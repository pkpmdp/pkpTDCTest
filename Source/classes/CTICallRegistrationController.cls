public class CTICallRegistrationController {
    
    private String contextId;
    public CTI_CallRegistration__c CTI {get; private set;}
    public Boolean requiredParams {get; private set;}
    public Integer DbSaveSucceeded {get; private set;}
    
    public static final String DEFAULT_JOB_TYPE = 'Default';
    //public static final String CALL_OBJECT = 'CallObject';
    public static final String CONTEXT_ID = 'ContextId';
    public static final String CALL_START_TIME = 'CallStartTime';
    public static final String CALL_DURATION = 'CallDuration';
    public static final String PHONE_NUMBER = 'PhoneNo';
    public static final String CDN = 'CDN';
    public static final String CUSTOMER_NUMBER = 'CustNo';
    public static final String CONTACT_ID = 'ContactID';
    public static final String ACCOUNT_ID = 'AccountID';
    
    public CTICallRegistrationController() {
        this.DbSaveSucceeded = 0;
        requiredParams = true;
    
        Map<String, String> mapParams = ApexPages.currentPage().getParameters();
        CTI = new CTI_CallRegistration__c();
        if (mapParams.containsKey(CONTEXT_ID)){
            contextId = mapParams.get(CONTEXT_ID);
            CTI.ContextId__c = this.contextId;          
        }
        
        Boolean foundRecord = false;
        
        if (this.contextId != null && this.contextId.length() > 0){  
	        List<CTI_CallRegistration__c> actualCalls = [SELECT Id, TaksonomySet__c, Henvendelsetype__c, Udstyr__c, Kundeforhold__c, Henvendelse__c, Losning__c, Comment__c, Account__c FROM CTI_CallRegistration__c WHERE ContextId__c = :this.contextId AND CreatedById =:UserInfo.getUserId()];
	        if (actualCalls != null && actualCalls.size() > 0){
	        	foundRecord = true;
	        	
	          CTI.Account__c = actualCalls[0].Account__c;
	          CTI.Comment__c = actualCalls[0].Comment__c;
	          CTI.TaksonomySet__c = actualCalls[0].TaksonomySet__c;
	          if (CTI.TaksonomySet__c != null){
		          CTI.Henvendelsetype__c = actualCalls[0].Henvendelsetype__c;
		          CTI.Udstyr__c = actualCalls[0].Udstyr__c;
		          CTI.Kundeforhold__c = actualCalls[0].Kundeforhold__c;
		          CTI.Henvendelse__c = actualCalls[0].Henvendelse__c;
		          CTI.Losning__c = actualCalls[0].Losning__c;
	          }	          
	        }
	      } 
	      if (!foundRecord){	      
	        if (mapParams.containsKey(PHONE_NUMBER)){
	            CTI.Phone_number__c = mapParams.get(PHONE_NUMBER);
	        }
	        if (mapParams.containsKey(CDN)){
	            CTI.CDN__c = mapParams.get(CDN);
	        }
	
	        String callStartTimeString = mapParams.get(CALL_START_TIME);
	        if (callStartTimeString != null && callStartTimeString != ''){
	            CTI.Call_Start_Time__c = Datetime.newInstance((Decimal.valueOf(callStartTimeString)).longValue());
	        }
	
	        String callDurationString = mapParams.get(CALL_DURATION);
	        if (callDurationString != null){
	            CTI.Call_Duration_In_Seconds__c = Decimal.valueOf(callDurationString);
	        }
	        // CustNo is not mandatory parameter
	        if (mapParams.containsKey(CONTACT_ID)) {
	            List<Contact> contacts = [SELECT Id, AccountId FROM Contact WHERE Id = :mapParams.get(CONTACT_ID)];
	            if (contacts.size() > 0)
	                CTI.Account__c = contacts[0].AccountId;
	        } else if (mapParams.containsKey(ACCOUNT_ID)) {
	            List<Account> customers = [SELECT Id FROM Account WHERE Id = :mapParams.get(ACCOUNT_ID)];
	            if (customers.size() > 0)
	                CTI.Account__c = customers[0].Id;
	        } else if (mapParams.containsKey(CUSTOMER_NUMBER)) {
	            List<Account> customers = [SELECT Id FROM Account WHERE Customer_No__c = :mapParams.get(CUSTOMER_NUMBER)];
	            if (customers.size() > 0)
	                CTI.Account__c = customers[0].Id;
	        }	        
        }  
        
        if (CTI.TaksonomySet__c == null){
          CTI.TaksonomySet__c = getTaxonomySet();
        }    
    }
    
    public PageReference createEmptyCallReg(){
        //create empty cti record if it doesn't exist
        List<CTI_CallRegistration__c> existingCTIList = null;
        if (this.contextId!=null){
            existingCTIList = [SELECT Id, Account__c FROM CTI_CallRegistration__c WHERE ContextId__c =: contextId AND CreatedById =:UserInfo.getUserId() ];
            if(existingCTIList==null || existingCTIList.size()==0){
                CTI_CallRegistration__c tmpCTI = new CTI_CallRegistration__c(ContextId__c=contextId);
                insert tmpCTI;
            } else if (existingCTIList!=null && existingCTIList.size()==1){
            	CTI.Account__c = existingCTIList[0].Account__c;
            }
        } 
        return null;
    }
    
    
    private String getTaxonomySet() {
        List<Call_Registration_Job__c> callRegJobs = getUserJobs(UserInfo.getUserId());
        if (callRegJobs != null && callRegJobs.size() > 0){
            return callRegJobs[0].Taksonomy_Set__c;
        } 

        callRegJobs = getDefaultJob(UserInfo.getUserId());    
        if (callRegJobs != null && callRegJobs.size() > 0){
            return callRegJobs[0].Taksonomy_Set__c;
        } else {
            requiredParams = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.CR_Job_Missing));
        }
        return null;
    }
    
    public static List<Call_Registration_Job__c> getUserJobs(Id userId) {
        List<Call_Registration_Job__c> callRegJobs = new List<Call_Registration_Job__c>();
        Date now = Date.today();
        // first try select Jobs_Users__c by logged userId
        List<Jobs_Users__c> userJobs = [SELECT Call_Registration_Job__c FROM Jobs_Users__c WHERE User__c = :userId ORDER BY CreatedDate DESC];
        if (userJobs != null && userJobs.size() > 0)
            callRegJobs = [SELECT Id, Job_Type__c, Coverage__c, Valid_From__c, Valid_To__c, CDN__c, Taksonomy_Set__c, Time_From__c, Time_To__c FROM Call_Registration_Job__c 
                WHERE Id = :userJobs[0].Call_Registration_Job__c AND Valid_From__c <= :now AND (Valid_To__c >= :now OR Valid_To__c = null) AND Job_Type__c != :DEFAULT_JOB_TYPE ORDER BY CreatedDate DESC];
        if (callRegJobs.size() == 0) {
            // select all groups for the user's role
            Set<Id> userOrGroupsIDs = new Set<Id>();
            if(UserInfo.getUserRoleId()!=null){
                List<Group> groups = [SELECT Id FROM Group WHERE RelatedId = :UserInfo.getUserRoleId()];
                for (Group thisGroup : groups) {
                    userOrGroupsIDs.add(thisGroup.Id);
                }
            }
            //select group with current user
            userOrGroupsIDs.add(UserInfo.getUserId());
                        
            // select group members
            Set<Id> groupsIDs = new Set<Id>();
            List<GroupMember> groupMembers = [SELECT GroupId FROM GroupMember WHERE UserOrGroupId IN :userOrGroupsIDs];
            for (GroupMember grMember : groupMembers) {
                if (grMember.GroupId != null) {
                    groupsIDs.add(grMember.GroupId);
                }
            }
            List<Jobs_Groups__c> userGroups = [SELECT Call_Registration_Job__c FROM Jobs_Groups__c WHERE Group_ID__c IN :groupsIDs ORDER BY CreatedDate DESC];
            if (userGroups.size() > 0) {
                callRegJobs = [SELECT Id, Job_Type__c, Coverage__c, Valid_From__c, Valid_To__c, CDN__c, Taksonomy_Set__c FROM Call_Registration_Job__c 
                    WHERE Id = :userGroups[0].Call_Registration_Job__c AND Valid_From__c <= :now AND (Valid_To__c >= :now OR Valid_To__c = null) ORDER BY CreatedDate DESC];
            }
        } 
        return callRegJobs;
    }
    
    public static List<Call_Registration_Job__c> getDefaultJob(Id userId) {
        List<Call_Registration_Job__c> callRegJobs = new List<Call_Registration_Job__c>();
        callRegJobs = [SELECT Taksonomy_Set__c,Job_Type__c  FROM Call_Registration_Job__c WHERE Job_Type__c = :DEFAULT_JOB_TYPE ORDER BY CreatedDate DESC];
        return callRegJobs;
    }
    
    public PageReference saveCallRegistration() {
      try
      {
        this.DbSaveSucceeded = 1;
        system.debug('saveCallRegistration1 : ' + this.DbSaveSucceeded);
        
        List<CTI_CallRegistration__c> existingCTIList = null;
        if (contextId!=null){
            existingCTIList = [SELECT Id, Call_Duration_In_Seconds__c, Udstyr__c, Kundeforhold__c, Henvendelsetype__c, Henvendelse__c, Losning__c, Comment__c FROM CTI_CallRegistration__c WHERE ContextId__c =: contextId AND CreatedById =:UserInfo.getUserId() ];
        } 
        if(existingCTIList!=null && existingCTIList.size()>0){
            CTI_CallRegistration__c existingCTI = existingCTIList[0];
            
            //update all parameters from form 
            existingCTI.Udstyr__c = CTI.Udstyr__c;
            existingCTI.Kundeforhold__c = CTI.Kundeforhold__c;
            existingCTI.Henvendelsetype__c = CTI.Henvendelsetype__c;
            existingCTI.Henvendelse__c = CTI.Henvendelse__c;
            existingCTI.Losning__c = CTI.Losning__c;
            existingCTI.Comment__c = CTI.Comment__c;
            
            existingCTI.Account__c = CTI.Account__c;
            existingCTI.TaksonomySet__c = CTI.TaksonomySet__c;
            
            //update all parameters from URL
            //if (callDuration != null){
            //    existingCTI.Call_Duration_In_Seconds__c = callDuration;
            //}            
            //existingCTI.Phone_number__c = CTI.Phone_number__c;
            //existingCTI.CDN__c = CTI.CDN__c;
            //existingCTI.Call_Start_Time__c = CTI.Call_Start_Time__c;
            
            update existingCTI;
        }
        else{
            insert CTI;
        }
      }
      catch(DmlException ex){
        this.DbSaveSucceeded = 0;
        // Database.rollback(sp);
        ApexPages.addMessages(ex);
      }
      catch (Exception ex)
      {
        this.DbSaveSucceeded = 0;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error when inserting CTI record. '+ex));
      }

      return null;
    }
    
    public PageReference cancelCallRegistration() {
        this.DbSaveSucceeded = 1;
        if (this.contextId!=null){
            try{
                List<CTI_CallRegistration__c> existingCTIList = null;
                
                existingCTIList = [SELECT Id,TaksonomySet__c FROM CTI_CallRegistration__c WHERE ContextId__c =: contextId AND CreatedById =:UserInfo.getUserId() AND TaksonomySet__c = null];
                if(existingCTIList!=null && existingCTIList.size()>0){
                    
                    delete existingCTIList;
                }
            }
            catch(DmlException ex){
                this.DbSaveSucceeded = 0;
                ApexPages.addMessages(ex);
            }
            catch (Exception ex)
            {
                this.DbSaveSucceeded = 0;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error when cancelling CTI record. '+ex));
            }
        }
        return null;
    }
    
}