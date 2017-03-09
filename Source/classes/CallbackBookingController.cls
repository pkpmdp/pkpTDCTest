public class CallbackBookingController {
  public integer StartHour {get; set;}
  public integer EndHour {get; set;}
  public integer NumberOfDays {get; set;}
  public string UrlCBCase {get; set;}
  public string Debug {get; set;}
  public string Error {get; set;}
  public CaseComment caseComment {get; set;}
  
  private Map<String, CallbackBookingSlot> slots;
  private Date baseDate;
  private String idCustomer = null;
  private String idCase = null;
  private String idCancel = null;
  private String idInsert = null;
  private String idUpdate = null;
  private boolean reschedule = false;
  private Case updateCase = null;  
  private CB_Case__c updateCBCase = null;  
  public Case xCase = new Case();
  private String retUrl = null;
  
  private static RecordType xCBCaseRecordType; 
  
  public static final String PRODUCT_CALLBACK='YOT Call Back';
  public static final String PRODUCT_OUTBOUND_GREENLAMP='Green Lamp';
  public static final String TYPE_TASK_OUTBOUND_CALL='Call';
  public static final String TYPE_TASK_OUTBOUND_CALLBACK_GREENLAMP='Outbound Green Lamp - Call back bookings';
  public static final String TYPE_TASK_OUTBOUND_ARRANGE_CALLBACK='Outbound - book to arrange call back time';
  
  static{
    xCBCaseRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Call_Back_Open_Case'];
  }
  
  // constructor
  public CallbackBookingController(Date baseDate, string caseType){
    this.xCase.Department__c = 'YOT';
    this.xCase.Product_2__c = PRODUCT_CALLBACK;
    this.xCase.Status = 'New';
    this.xCase.Origin = 'Phone';
    this.xCase.RecordTypeId = xCBCaseRecordType.Id;
    
    this.baseDate = baseDate;
    this.xCase.Type_Task__c = caseType;
    
    this.StartHour = 9;
    this.EndHour = 17;
    this.NumberOfDays = 7;
    
    Initialize();
  }
  
  // constructor
  public CallbackBookingController(){
    this(Date.today(), 'Broadband');
  }
  
  private void Initialize(){    
    Map<String, String> mapParams = ApexPages.currentPage().getParameters();
    
    if (mapParams.containsKey('action')){
      String action = mapParams.get('action');
      if (action=='reschedule'){
      	this.reschedule=true;
      }
    }

       
    if (mapParams.containsKey('CustomerId')){
      this.idCustomer = mapParams.get('CustomerId');
    }
    
    if (mapParams.containsKey('CaseId')){
      this.idCase = mapParams.get('CaseId');

      try {
        this.updateCase = [SELECT Id, Call_Back__c,Product_2__c, Type_Task__c, RecordTypeId FROM Case WHERE Id = :this.idCase];

        this.xCase.RecordTypeId = this.updateCase.RecordTypeId;

        this.xCase.Type_Task__c = this.updateCase.Type_Task__c;
		if (updateCase.Type_Task__c==TYPE_TASK_OUTBOUND_CALL || (!reschedule && updateCase.Type_Task__c==TYPE_TASK_OUTBOUND_ARRANGE_CALLBACK)){
			//set initial value for green lamp product
			if (updateCase.Product_2__c==PRODUCT_OUTBOUND_GREENLAMP){
				this.xCase.Type_Task__c = TYPE_TASK_OUTBOUND_CALLBACK_GREENLAMP;
			}
			//else if ... another outbound campaign will go here 
			else {
				this.xCase.Type_Task__c = null;
			}
		}

        List<CB_Case__c> cbCaseLst= [SELECT Id, CB_time_from__c, CB_time_to__c FROM CB_Case__c WHERE Id = :this.updateCase.Call_Back__c];
        if (cbCaseLst.size()>0){
	      	this.updateCBCase = cbCaseLst[0]; 
	    }
      } catch (Exception ex){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.CB_Case_Doesnt_exist));
      }
      
      
    }

    if (mapParams.containsKey('CancelId')){
      this.idCancel = mapParams.get('CancelId');
    }

    if (mapParams.containsKey('UpdateId')){
      this.idUpdate = mapParams.get('UpdateId');
    }
    
    if (mapParams.containsKey('InsertId')){
      this.idInsert = mapParams.get('InsertId');
    }
    
    if (mapParams.containsKey('Type')){
      this.xCase.Type_Task__c = mapParams.get('Type');
    }
    
    if (mapParams.containsKey('retUrl')){
      this.retUrl = mapParams.get('retUrl');
    }

    CreateSlotCollection();
    caseComment = new CaseComment();
  }
  
  // returns true if there is Case provided for update
  public Boolean getIsCaseUpdate(){
  	//if (this.updateCase!=null && this.updateCBCase!=null){
  	if (reschedule){
  		return true;
  	}
  	return false;
    //return this.strCaseType != null ? true : false;
  }
  
  // returns false if there is Case provided for update
  public Boolean getIsNotCaseUpdate(){
    return ! this.getIsCaseUpdate();
  }
  
  // returns formatted string with case type (we need this in page heading)
  public String getCaseTypeString(){
  	if (getIsCaseUpdate()){
  		return '- ' + this.updateCase.Type_Task__c;
  	}
  	return '';
    //return this.strCaseType == null ? '' : '- ' + this.strCaseType;
  }
  
  // get number of scheduled slot for specific date and time interval
  private static Integer GetAvailableSlotsCBCase(CB_Case__c cbAka){
  	return GetAvailableSlotsImpl(cbAka.CB_time_from__c.date(), cbAka.CB_time_from__c.hour(), cbAka.CB_time_to__c.hour(), cbAka.CB_type__c);
  }
  
  // get number of scheduled slot for specific date and time interval
  private static Integer GetAvailableSlotsImpl(Date dt, Integer iFrm, Integer iTil, String caseType){
    DateTime dtFrm = DateTime.newInstance(dt, Time.newInstance(iFrm, 0, 0, 0));
    DateTime dtTil = DateTime.newInstance(dt, Time.newInstance(iTil, 0, 0, 0));

    // check custom schedule
    List <CB_Custom_Schedule__c> lstCustom = [
      SELECT Max_slots__c         
      FROM CB_Custom_Schedule__c c WHERE CB_type__c = : caseType AND CB_time_from__c = : dtFrm AND CB_time_to__c = : dtTil
      LIMIT 1
    ];
    
    if (lstCustom != null && lstCustom.size() > 0){
      return lstCustom[0].Max_slots__c.intValue();
    } else {
      List <CB_Schedule_Template__c> lstCur = [
        SELECT  
          (SELECT Time_from__c, Time_to__c, Friday__c, Monday__c, Saturday__c, Sunday__c, Thursday__c, Tuesday__c, Wednesday__c
            FROM CB_Default_Schedules__r WHERE Time_from__c = :iFrm AND Time_to__c = :iTil
          )
        FROM CB_Schedule_Template__c c WHERE CB_type__c = : caseType AND Valid_from__c <= :dt
        ORDER BY Valid_from__c DESC
        LIMIT 1
      ];
      if (lstCur != null && lstCur.size() > 0 && lstCur[0].CB_Default_Schedules__r != null){
        return GetMaxSlotsForDay(lstCur[0].CB_Default_Schedules__r, GetDayOfWeek(dt), false, dt);
      }
    }
      
    return 0;
  }
  
  // create new slot collection 
  private void CreateSlotCollection(){
    this.slots = new Map<String, CallbackBookingSlot>();
    
    if (this.idCancel!=null||(this.idCustomer == null && this.xCase.Type_Task__c == null)){
      return;
    }
    
    // find last valid schedule template (in the past) -> it's the date that is currently valid
    List <CB_Schedule_Template__c> lstCur = [
      SELECT Period__c, Working_hours_from__c, Working_hours_to__c, Valid_from__c, 
       (SELECT Time_from__c, Time_to__c, Friday__c, Monday__c, Saturday__c, Sunday__c, Thursday__c, Tuesday__c, Wednesday__c
        FROM CB_Default_Schedules__r
       )
      FROM CB_Schedule_Template__c c WHERE CB_type__c = : this.xCase.Type_Task__c AND Valid_from__c <= : this.baseDate
      ORDER BY Valid_from__c DESC
      LIMIT 1
    ];
    
    if (lstCur != null && lstCur.size() > 0 && lstCur[0] != null){
      // get initial valid values for period and working hours
      this.NumberOfDays = lstCur[0].Period__c.intValue();
      this.StartHour = lstCur[0].Working_hours_from__c.intValue();
      this.EndHour = lstCur[0].Working_hours_to__c.intValue();
    
      // SELECT future valid scheduled templated that are within the period interval
      List <CB_Schedule_Template__c> lstFuture = [
        SELECT Period__c, Working_hours_from__c, Working_hours_to__c, Valid_from__c, 
         (SELECT Time_from__c, Time_to__c, Friday__c, Monday__c, Saturday__c, Sunday__c, Thursday__c, Tuesday__c, Wednesday__c
          FROM CB_Default_Schedules__r
         )
        FROM CB_Schedule_Template__c c WHERE CB_type__c = : this.xCase.Type_Task__c AND Valid_from__c > : this.baseDate AND Valid_from__c < : this.baseDate + this.NumberOfDays
        ORDER BY Valid_from__c ASC
      ];
        
      // SELECT custom scheduled slots that are within the period interval
      List <CB_Custom_Schedule__c> lstCustom = [
        SELECT Max_slots__c, CB_time_to__c, CB_time_from__c         
        FROM CB_Custom_Schedule__c c WHERE CB_type__c = : this.xCase.Type_Task__c AND CB_time_from__c > : this.baseDate AND CB_time_to__c < : this.baseDate + (this.NumberOfDays + 1)
        ORDER BY CB_time_from__c ASC
      ];
        
      // merge (append them in the end)
      if (lstFuture != null && lstFuture.size() > 0){
        lstCur.addAll(lstFuture);
      }
      // loop through all dates
      Iterator<CB_Schedule_Template__c> it = lstCur.iterator();
      CB_Schedule_Template__c objSchedTempl = it.hasNext() ? it.next() : null;
      while(objSchedTempl != null){
        CB_Schedule_Template__c objSchedTemplNext = it.hasNext() ? it.next() : null;
        
        // get the longest interval for working hours
        Integer startHour = objSchedTempl.Working_hours_from__c.intValue();
        if (this.StartHour > startHour){
          this.StartHour = startHour;
        }
        
        Integer endHour = objSchedTempl.Working_hours_to__c.intValue();
        if (this.EndHour < endHour){
          this.EndHour = endHour;
        }
        
        DateTime nowMs = DateTime.now();
        
        if (objSchedTempl != null){                     
          for (Integer i=0; i<this.NumberOfDays; ++i){
            Date dateCur = this.baseDate + i;
            // check current interval validity
            if (objSchedTempl != lstCur[0] && dateCur < objSchedTempl.Valid_from__c){
              continue;
            }
            // check the next (future) interval; future interval is more recent/accurate/prioritized 
            if (objSchedTemplNext != null && dateCur >= objSchedTemplNext.Valid_from__c){
              break;
            }
            
            // Process data from CB_Default_Schedule__c object
            for (CB_Default_Schedule__c objIntervals: objSchedTempl.CB_Default_Schedules__r) {
              // current time slot as integers
              Integer iFrom = objIntervals.Time_from__c.intValue();
              Integer iTo = objIntervals.Time_to__c.intValue();
              Integer iSlots = -1;
              
              // search in custom scheduled slots
              for (CB_Custom_Schedule__c objCustom : lstCustom){
                if (objCustom.CB_time_from__c.date() == dateCur && objCustom.CB_time_to__c.date() == dateCur && objCustom.CB_time_from__c.hour() == iFrom && objCustom.CB_time_to__c.hour() == iTo){
                  iSlots = objCustom.Max_slots__c.intValue();
                }
              }
              
              // if no custom schedule, take default schedule
              if (iSlots == - 1){
                iSlots = GetMaxSlotsForDay(objIntervals, i, true, this.BaseDate);
              }
              
              if (iSlots > 0){
                // check if the end of intentional interval is less than one hour in the future
                Long l = DateTime.newInstance(dateCur, Time.newInstance(iTo, 0, 0, 0)).getTime() - nowMs.getTime();
                if (l < (1 * 1000 * 60 * 60)){ // one hour in miliseconds
                  iSlots = 0;
                }
                              
                CallbackBookingSlot cbs = new CallbackBookingSlot(dateCur, iFrom, iTo, iSlots, this.xCase.Type_Task__c);
                
                Blob md5 = Crypto.generateDigest('MD5', Blob.valueof(string.format('{0} {1}-{2}', new String[]{dateCur.format() + string.valueOf(iFrom) + string.valueOf(iTo)})));
                this.slots.put(cbs.getMD5(), cbs);
              }
            }
          }
        }
        objSchedTempl = objSchedTemplNext;
      }
      
      // SELECT CB_Case that lies within the interval
      List <CB_Case__c> lstCases = [
        SELECT CB_time_from__c, CB_time_to__c 
        FROM CB_Case__c c WHERE CB_type__c = : this.xCase.Type_Task__c AND CB_time_from__c > : this.baseDate AND CB_time_to__c < : this.baseDate + (this.NumberOfDays + 1)
        ORDER BY CB_time_from__c ASC
      ];
      
      // loop through all cases and lower number of available slots
      for(CB_Case__c objCBCase : lstCases){
        for (CallbackBookingSlot objSlot : this.slots.values()){
          DateTime dtSlotFrom = DateTime.newInstance(objSlot.DateOn, Time.newInstance(objSlot.HourFrom, 0, 0, 0));
          DateTime dtSlotTo = DateTime.newInstance(objSlot.DateOn, Time.newInstance(objSlot.HourTill, 0, 0, 0));
            
          if (objCBCase.CB_time_from__c == dtSlotFrom && objCBCase.CB_time_to__c == dtSlotTo && objSlot.Available > 0){
            // lower number of free slots accor
            objSlot.Available -= 1;
          }
        }
      }
    }
  }
  
  // get slot collection
  public List<CallbackBookingSlot> getCallbackSlots(){
    return this.slots.values();
  }
  
  private static Integer GetDayOfWeek(Date dt){
    Date bg = dt.toStartofWeek();
    return bg.daysBetween(dt) + CalendarController.getWeekOffset();
  }  
  
  // Week Day to Integer mapping
  private static Integer GetMaxSlotsForDay(CB_Default_Schedule__c objIntervals, Integer offset, Boolean offsetDayOfWeek, Date bd){
    if (offsetDayOfWeek){
      offset = offset + GetDayOfWeek(bd);
    }
    offset = Math.Mod(offset, 7);
    
    if (offset == 0){
      return objIntervals.Monday__c == null ? 0 : objIntervals.Monday__c.intValue();
    } else if (offset == 1) {
      return objIntervals.Tuesday__c == null ? 0 : objIntervals.Tuesday__c.intValue();
    } else if (offset == 2) {
      return objIntervals.Wednesday__c == null ? 0 : objIntervals.Wednesday__c.intValue();
    } else if (offset == 3) {
      return objIntervals.Thursday__c == null ? 0 : objIntervals.Thursday__c.intValue();
    } else if (offset == 4) {
      return objIntervals.Friday__c == null ? 0 : objIntervals.Friday__c.intValue();
    } else if (offset == 5) {
      return objIntervals.Saturday__c == null ? 0 : objIntervals.Saturday__c.intValue();
    } else {
      return objIntervals.Sunday__c == null ? 0 : objIntervals.Sunday__c.intValue();
    }    
  }
  
  private static string FormatDate(DateTime dt){
    return dt.format('dd-MM-yyyy');
  }
  
  private static string FormatCaseDateTime(DateTime dtFrom, DateTime dtTill){
    return CalendarController.GetDayLabelString(GetDayOfWeek(dtFrom.date())) + ', ' + dtFrom.format('dd-MM-yyyy') + ' ' + dtFrom.format('HH:mm') + ' - ' + dtTill.format('HH:mm');
  }
  
  public Date getDateFrom(){
    return this.baseDate;
  }
  
  public Date getDateTill(){
    return this.baseDate + (this.NumberOfDays - 1);
  }
  
  public string getDateFromFormatted(){
    return FormatDate(DateTime.newInstance(this.getDateFrom(), Time.newInstance(0, 0, 0, 0)));
  }
  
  public string getDateTillFormatted(){
    return FormatDate(DateTime.newInstance(this.getDateTill(), Time.newInstance(0, 0, 0, 0)));
  }
  
  /*
  public PageReference next(){
    this.baseDate = this.baseDate + 1;
    CreateSlotCollection();
    return null;
  }
  
  public PageReference prev(){
    this.baseDate = this.baseDate - 1;
    CreateSlotCollection();
    return null;
  }
  */
  
  public PageReference refresh(){
    CreateSlotCollection();
    return null;
  }  
  
  public Case getTempCase(){
    return xCase;
  }
  
  private Boolean CheckCBCaseConflict(String idCase){
  	List<Case> css = [SELECT Id, Call_Back__c FROM Case c WHERE c.Id = :idCase LIMIT 1];
  	if (css != null && css.size() == 1){
  		Case cs = css[0];
	  	List<CB_Case__c> cbs = [SELECT c.Id, c.CB_type__c, c.CB_time_from__c, c.CB_time_to__c FROM CB_Case__c c WHERE c.Id = : cs.Call_Back__c LIMIT 1];
	  	if (cbs != null && cbs.size() == 1){
	  		CB_Case__c myself = cbs[0];
	  		if (myself != null){
	  			Integer maxSlots = GetAvailableSlotsCBCase(myself);
	  			
	  			List<CB_Case__c> cbsOthers = [SELECT Id, CB_type__c, CB_time_from__c, CB_time_to__c, CreatedDate FROM CB_Case__c c WHERE CB_type__c = :myself.CB_type__c AND CB_time_from__c = :myself.CB_time_from__c AND CB_time_to__c = :myself.CB_time_to__c ORDER BY CreatedDate, Id];
	  			if (cbsOthers != null && cbsOthers.size() > maxSlots){
	  				// conflict, we have to check if we have to delete CB_Case__c 'myself'
	  				Boolean shouldDelete = true;
	  				for(Integer i=0; i<maxSlots; ++i){
	  					if (cbsOthers[i].Id == myself.Id){
	  						shouldDelete = false;
	  						break;
	  					}
	  				}
	  				
	  				if (shouldDelete){
	  					Database.DeleteResult[] res;
	  					if (this.idInsert != null) {
	  						res = Database.Delete(new ID[]{idCase, myself.Id});
	  					}else{
	  						res = Database.Delete(new ID[]{myself.Id});
	  					} 
	  					for(Database.DeleteResult dr : res){
	  						if (dr.getErrors() != null){
	  							for(Database.Error err : dr.getErrors()){
	  								ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, err.getMessage())); 
	  							}
	  						}
	  					}
	  					
	  					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.CB_Case_Slot_booked));
	  					return true;  					  					  					
	  				}
	  			}
	  		}
	  	}
  	}
  	return false;
  }
  
  public PageReference redirectAction(){
  	if (this.idInsert != null && this.idCustomer != null) {
    	if (!CheckCBCaseConflict(this.idInsert)){
    	  return new PageReference(Page.CallbackCase.getUrl() + '?Id=' + this.idInsert);
    	}
    } else if (this.idUpdate != null){
    	if (!CheckCBCaseConflict(this.idUpdate)){
    		if (this.retUrl != null){
    			return new PageReference(this.retUrl);
    		} else {
          return new PageReference('/' + this.idUpdate);
    		}
    	}
    }    
    return null;
  }
  
  // 
  public PageReference createCBCase(){
    if (this.UrlCBCase != null && this.UrlCBCase.length() > 0){
      CallbackBookingSlot cbs = this.slots.get(this.UrlCBCase);
      if (cbs != null){
        Date dt = cbs.DateOn;
        Integer iFrm = cbs.HourFrom;
        DateTime dtFrm = DateTime.newInstance(dt, Time.newInstance(iFrm, 0, 0, 0));
        Integer iTil = cbs.HourTill;
        DateTime dtTil = DateTime.newInstance(dt, Time.newInstance(iTil, 0, 0, 0));
            
        // check if the end of intentional interval is less than one hour in the future
        Long l = dtTil.getTime() - DateTime.now().getTime();
        if (l < (1 * 1000 * 60 * 60)){ // one hour in miliseconds
          // error, the end of interval is less than one hour
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.CB_Case_Slot_booked));
          return null;
        }

				// check if the customer has already created CB case with the same type
				if (this.updateCBCase == null && this.idCustomer != null && this.idCustomer.length() > 0){ 
				  Integer countCBCases = [SELECT COUNT() FROM Case WHERE Call_Back__c != NULL AND AccountId = :this.idCustomer AND Type_Task__c = :cbs.CaseType];
					//system.debug('countCBCases:' + countCBCases + ':' + idCustomer);
					if (countCBCases > 0) {
					  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.CB_Case_Already_Exists));
			      return null;
					}
				}				
		    
        // get number of scheduled slots for specific date and time interval 
        Integer cntSlots = GetAvailableSlotsImpl(dt, iFrm, iTil, cbs.CaseType);
            
        // check if we're still able to create CB Case; check current DB status if there are already booked slots with CB Cases
        Integer cntDbCurrent = [SELECT COUNT() FROM CB_Case__c c WHERE c.CB_time_from__c = :dtFrm AND c.CB_time_to__c = :dtTil AND CB_type__c = : cbs.CaseType];
        if (cntSlots > cntDbCurrent){
        	Savepoint sp = Database.setSavepoint();
          try{
          	//reschedule
            if (reschedule){            
              this.updateCBCase.CB_time_from__c = dtFrm;
              this.updateCBCase.CB_time_to__c = dtTil;
              this.updateCBCase.CB_time__c = FormatCaseDateTime(dtFrm, dtTil);

              update this.updateCBCase;
              
              this.idUpdate = this.idCase;
              
              PageReference pr = Page.CallbackBooking;
              pr.getParameters().clear();
              pr.getParameters().put('UpdateId', this.idUpdate);
              pr.getParameters().put('Type', cbs.CaseType);
              if (this.retUrl != null){
              	pr.getParameters().put('retUrl', this.retUrl);
              }
              pr.setRedirect(true);
              return pr;
            }
            //create new CB case 
            else if (this.idCustomer != null && this.idCustomer.length() > 0){                
              CB_Case__c newCbCase = new CB_Case__c(CB_time_from__c = dtFrm, CB_time_to__c = dtTil, CB_type__c = cbs.CaseType, CB_time__c = FormatCaseDateTime(dtFrm, dtTil));
              insert newCbCase;
              
              Case newCase = new Case(Department__c = xCase.Department__c, Product_2__c = xCase.Product_2__c, Type_Task__c = cbs.CaseType, RecordTypeId = xCBCaseRecordType.Id, Status = xCase.Status, Origin = xCase.Origin, AccountId = this.idCustomer, Call_Back__c = newCbCase.Id);
              insert newCase;
              
              this.idInsert = newCase.Id;
  
              PageReference pr = Page.CallbackBooking;
              pr.getParameters().clear();
              pr.getParameters().put('InsertId', this.idInsert);
              pr.getParameters().put('CustomerId', this.idCustomer);
              pr.getParameters().put('Type', cbs.CaseType);
              pr.setRedirect(true);
              return pr;
            }
            //schedule outbound case
            else if (updateCase != null){
            	//outbound without CB case
            	if (this.updateCBCase == null){
	              CB_Case__c newCbCase = new CB_Case__c(CB_time_from__c = dtFrm, CB_time_to__c = dtTil, CB_type__c = cbs.CaseType, CB_time__c = FormatCaseDateTime(dtFrm, dtTil));
	              insert newCbCase;
	              updateCase.Call_Back__c = newCbCase.Id;
            	}
            	//outbound with existing CB case
            	else{
            		this.updateCBCase.CB_time_from__c = dtFrm;
              		this.updateCBCase.CB_time_to__c = dtTil;
              		this.updateCBCase.CB_time__c = FormatCaseDateTime(dtFrm, dtTil);
            		this.updateCBCase.CB_type__c=cbs.CaseType;
            		update updateCBCase;
            	}
              
              updateCase.Type_Task__c = cbs.CaseType;
             
              update updateCase;
             	
              this.idUpdate = this.idCase;
              
              PageReference pr = Page.CallbackBooking;
              pr.getParameters().clear();
              pr.getParameters().put('UpdateId', this.idUpdate);
              pr.getParameters().put('Type', cbs.CaseType);
              if (this.retUrl != null){
              	pr.getParameters().put('retUrl', this.retUrl);
              }
              pr.setRedirect(true);
              return pr;
            }
          }
          catch(DmlException ex){
            Database.rollback(sp);
            ApexPages.addMessages(ex);
          }
        } else {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.CB_Case_Slot_booked));
        }
      }
      CreateSlotCollection();
    }
    return null;
  }
  
	public PageReference cancelCBCase() {
		PageReference pageReference = new PageReference('/500/o');
		Case cancelCase;
		try {
			caseComment.ParentId = this.idCancel;
			insert caseComment;
    		cancelCase = [SELECT AccountId, Status, Product_2__c FROM Case WHERE Id = :this.idCancel for update];
        	cancelCase.Status = 'Cancelled';
        	update cancelCase;
        	
        	if (cancelCase.Product_2__c == PRODUCT_CALLBACK){
	        	// on submit return to customer for call back cases
	        	pageReference = new PageReference('/' + cancelCase.AccountId);
        	}
        	else {
	        	// on submit return to case for Outbound cases
	        	pageReference = new PageReference('/' + idCancel);
        	}
		} catch (Exception ex) {
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.CB_Case_Doesnt_exist));
    	}
  		return pageReference;
	}
  
	public PageReference returnToCBCase() {
		// on cancel return to case
		return new PageReference('/' + idCancel);
  	}
}