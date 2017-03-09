/**********************************************************************************
************************************************************************************

* @class: DealerWebConferenceRegisterController
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 05/12/2012
* @description: Class is controller for the youSee 13 Conference Registration Form

************************************************************************************ 
***********************************************************************************/
public with sharing class DealerWebConferenceRegisterController { 
	
	public Boolean myFlag {get;set;}{myFlag=false;}
    public String dayProgram	{get;set;}
	public String transportInfo	{get;set;}
	public String registerText {get ;set ;}
    public Integer rowNo     {get;set;}
    public Boolean isEditMode	{get;set;}
    public List<Contact> lstInsertedContacts	{get;set;}
    public List<Contact> lstFailedContacts	{get;set;}
    public String errors {get; set;} 
    public String youseeConferenceInfo{get;set;}
    public String pickupVal {get; set;}
    public String pickupRoute {get; set;}
    public List<WrapContacts> wrapList {get ; set ;}
    public String rowsId {get ; set ; }
    public WrapContacts wrapCons {get ; set;}
    
    List<User> currentDealerUser = new List<User>();
    List<Contact> currentDealerContact = new List<Contact>();
    Map<String,String> pickTime = new Map<String,String>();
    Map<String,String> dropTime = new Map<String,String>();    
    Map<String,WrapContacts> mapWrap = new Map<String,WrapContacts>();
    Contact	currentContact;
    
    /**
    * @description: Constructor : Initializes the page variables
    */    
    public DealerWebConferenceRegisterController(ApexPages.StandardController controller) {
    	errors = '';
        wrapCons = new WrapContacts();
        wrapList = new List<WrapContacts>();
        rowNo = 0;
        rowsId = '';
        registerText = '';
        isEditMode = false; 
    	pickupRoute = '';
    	pickupVal = '';
    	getForhandlerData();
    	currentDealerUser = [Select Contact.AccountId, Contact.Street_P__c, Contact.Post_Code_P__c From User Where Id = :UserInfo.getUserId() limit 1];
    	if(currentDealerUser[0].ContactId != null)
    		getCurrentDealerDetails();    	
        setPickupTime();
        setDropTime();
        currentContact = new Contact(Onskes_programplanen__c = true);        
		//system.debug('currentDealerUser[0].ContactId in getCurrentDealerDetails'+currentDealerUser[0].ContactId);		
        system.debug('myFlag in constructor ' +myFlag);
        system.debug('wrapCons in constructor ' +wrapCons);
        system.debug('wrapList in constructor ' +wrapList);
    }
       
    /**  
    * @description: action method for page which fetches the forhandlerInfo to be displayed on page
    */     
     public void getForhandlerData(){
     	ApexPages.Standardcontroller std = new ApexPages.Standardcontroller(new Contact(Onskes_programplanen__c = true));
    	DealerWebConferenceTicketController forhandlerData = new DealerWebConferenceTicketController(std);
    	dayProgram = forhandlerData.dayProgram;
    	transportInfo = forhandlerData.transportInfo;
    	youseeConferenceInfo = forhandlerData.youseeConferenceInfo; 
    	registerText = forhandlerData.registerText; 
    }  
    
    /**
    * @description: Adds one more attendee in the table
    */       
    public void AddMoreAttendees(){
    	String mobileMsg = '';
    	String emailMsg = '';
    	if(errors == ''){
	    	mobileMsg = checkMobileNumber('add', null);
	    	emailMsg = emailValidation(wrapCons.contact.email);
    	}
   		if(errors == '' && mobileMsg == '' &&  emailMsg == ''){
			try{		
				if(pickupVal != null && pickupVal != '' && pickupRoute != null && pickupRoute != ''
				&& wrapCons.contact.Transportation_Required__c == 'Ja'){
					wrapCons.contact.Pickup_Time__c = pickTime.get(pickupVal);
					wrapCons.contact.Drop_Time__c = dropTime.get(pickupVal);
					wrapCons.contact.Valg_opsamlingsby__c = pickupVal;
					wrapCons.contact.Valg_rute__c = pickupRoute;
				}else if(wrapCons.contact.Transportation_Required__c != 'Ja'){
					wrapCons.contact.Pickup_Time__c = '';
					wrapCons.contact.Drop_Time__c = '';
					wrapCons.contact.Valg_opsamlingsby__c = '';
					wrapCons.contact.Valg_rute__c = '';
					wrapCons.contact.Transportation_Required__c = 'Nej';
				}		
				WrapContacts wrap = new WrapContacts();
				wrap.contact = wrapCons.contact;
				wrap.rowCount = rowNo;
				wrapList.add(wrap);
				mapWrap.put(String.valueOf(wrap.rowCount),wrap);
				system.debug('wrapList in AddMoreAttendees' +wrapList);
				system.debug('mapWrap in AddMoreAttendees' +mapWrap);
				rowNo++;
				rowsId = '';
				wrapCons = new WrapContacts();
			} 
			catch(Exception e){
				system.debug('EXCEPTION THROWN in AddMoreAttendees: ' +e.getMessage());
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Der er opstået en fejl da du forsøgte at oprette. Prøv igen.'));
			}
		} 
		else {
			String errorMessage = '';
			if(mobileMsg != '')	
				errorMessage += '<li>-' +mobileMsg+ '</li>';
			if(emailMsg != '')	
				errorMessage += '<li>-' +emailMsg+ '</li>';
			if(errorMessage != ''){
	            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'<ul>' + errorMessage + '</ul>'));	           
			}                                   	
		}
		errors =  pickupVal = pickupRoute ='' ;
    } 
    
    /**
    * @description: deletes the specified attendee from the table  
    */  
    public void deleteRow(){
    	try{
    		mapWrap.remove(rowsId);
    		sortList();
    		system.debug('mapWrap in delete ' +mapWrap); 
    		system.debug('wrapList in delete ' +wrapList);    		
	    	wrapCons = new WrapContacts();
	    	isEditMode = false;
    	} 
    	catch(Exception e){
    		system.debug('EXCEPTION THROWN in deleteRow: ' +e.getMessage());
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Der er opstået en fejl da du forsøgte at slette. Prøv igen.'));
    	}
    }
     
    /**
    * @description: edits the specified attendee in the table
    */   
    public void editRow(){   
    	try{ 
    		currentContact = mapWrap.get(rowsId).contact;
    		wrapCons.contact = currentContact.clone();
	    	isEditMode = true;
	    	system.debug('wrapCons in editRow' +wrapCons);
	    	system.debug('wrapList in editRow' +wrapList);	    	
    	}
    	catch(Exception e){
    		system.debug('EXCEPTION THROWN in editRow: ' +e.getMessage());
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Der er opstået en fejl da information skulle hentes. Prøv igen.'));
    	}    	
    }
      
    /**
    * @description: refreshes the top section and saves the edited employee in the table
    */ 
    public void editAndSave(){
    	system.debug('wrapCons.rowCount in editAndSave' +rowsId);  
    	system.debug('wrapCons in editAndSave' + wrapCons);   
		system.debug('wrapMap in editAndSave' + mapWrap); 
		WrapContacts wrap = new WrapContacts();
		wrap.contact = wrapCons.contact;
		wrap.rowCount = Integer.valueOf(rowsId);
    	String mobileMsg = '';
    	String  emailMsg = '';
    	if(errors == ''){ 
	    	mobileMsg = checkMobileNumber('edit', Integer.valueOf(rowsId)); 
	    	emailMsg = emailValidation(wrap.contact.email);
    	}
   		if(errors == '' && mobileMsg == '' &&  emailMsg == ''){
    		try{    
    			system.debug('pickupVal in editAndSave' +pickupVal);  
		    	system.debug('pickupRoute in editAndSave' + pickupRoute);   
				system.debug('wrap.contact.Transportation_Required__c in editAndSave' + wrap.contact.Transportation_Required__c);		    			    		
				if(pickupVal != null && pickupVal != '' && pickupRoute != null && pickupRoute != ''
				&& wrap.contact.Transportation_Required__c == 'Ja'){
					wrap.contact.Pickup_Time__c = pickTime.get(pickupVal);
					wrap.contact.Drop_Time__c = dropTime.get(pickupVal);
					wrap.contact.Valg_opsamlingsby__c = pickupVal;
					wrap.contact.Valg_rute__c = pickupRoute;
				}else if(wrap.contact.Transportation_Required__c != 'Ja'){
					wrap.contact.Pickup_Time__c = '';
					wrap.contact.Drop_Time__c = '';
					wrap.contact.Valg_opsamlingsby__c = '';
					wrap.contact.Valg_rute__c = '';
					wrap.contact.Transportation_Required__c = 'Nej';
				}	
				mapWrap.put(rowsId,wrap);
				sortList();
				system.debug('wrapList in editAndSave' +wrapList);
				system.debug('wrapMap in editAndSave' + mapWrap); 
				isEditMode = false;
				rowsId = '';
				wrapCons = new wrapContacts();
	    	}
	    	catch(Exception e){
	    		system.debug('EXCEPTION THROWN in editAndSave: ' +e.getMessage());
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Der er opstået en fejl da du forsøgte at gemme. Prøv igen.'));
	    	}
    	}
		else {
			String errorMessage = '';
			if(mobileMsg != '')	
				errorMessage += '<li>-' +mobileMsg+ '</li>';
			if(emailMsg != '')	
				errorMessage += '<li>-' +emailMsg+ '</li>';
			if(errorMessage != ''){
	            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'<ul>' + errorMessage + '</ul>'));	           
			}                                   	
		}
    	errors =  pickupVal = pickupRoute ='' ;
    }
    
    /**
    * @description: cancels the changes made to contact on the form page
    */ 
    public PageReference cancelEdit(){
    	system.debug('in cancel ' +wrapList);
    	wrapCons = new WrapContacts();
    	isEditMode = false;
      	return null; 
    }
           
    /**
    * @description: inserts the attendees as Contacts under the logged-in dealer and sends email to each of the attendees
    * @return: DealerWebConferenceReceipt
    */ 
    public PageReference RegisterAttendees(){
    	try{
	    	List<User> currentDealer = new List<User>();
	    	Set<Id> insertedContactIds = new Set<Id>();
	    	lstInsertedContacts = new List<Contact>();
	    	lstFailedContacts = new List<Contact>();
	    	Integer count = 0;
	    	Set<Integer> failedContactIndexes = new Set<Integer>();
	    	currentDealer = [Select Contact.AccountId, Contact.Street_P__c From User Where Id = :UserInfo.getUserId()];
	        RecordType contactRecType = [Select r.Id From RecordType r where r.DeveloperName = 'Conference_Contact_Layout'];
	        system.debug('wrapList in RegisterAttendees ' + wrapList);
	        List<Contact> contacts = new List<Contact>();
	        if(currentDealer.size() > 0){
        		for(WrapContacts wrap : wrapList){
        			wrap.contact.AccountId = currentDealer[0].Contact.AccountId;
        			wrap.contact.MobilePhone = wrap.contact.Conference_Mobile_Phone__c;
        			wrap.contact.Street_P__c = currentDealer[0].Contact.Street_P__c;
        			wrap.contact.RecordTypeId = contactRecType.Id;
        			wrap.contact.IsConferenceContact__c = true;	     
        			contacts.add(wrap.contact);   			
        		}
        		system.debug('contacts in RegisterAttendees ' +contacts);
        		List<Database.Saveresult> sr = database.insert(contacts, false);	        		
        		for(Database.Saveresult result : sr){
        			if(result.isSuccess()){
        				insertedContactIds.add(result.getId());
        			}
        			else{
        				failedContactIndexes.add(count);         				
        				system.debug('Error Message for failed contacts ' + result.getErrors());
        			}
        			count++;
        		}
        		lstInsertedContacts = [Select Id, Email,Stillingsbetegnelse__c,FirstName,LastName,Conference_Mobile_Phone__c,Transportation_Required__c
        					    ,Valg_rute__c, Valg_opsamlingsby__c,Account.Dealer_Number__c From Contact Where Id IN : insertedContactIds];
        		
        		for(Integer i =0; i <= contacts.size(); i++){
        			if(failedContactIndexes.contains(i)){
        				lstFailedContacts.add(contacts[i]);
        			}
        		}
	        }
	        wrapCons = new WrapContacts();
	        wrapList = new List<WrapContacts>();
	        PageReference pageRef = new PageReference('/apex/DealerWebConferenceReceipt');
	        pageRef.setRedirect(false);
	        return pageRef; 
    	}
    	catch(Exception e){
    		system.debug('EXCEPTION THROWN in registerAttendees: ' +e.getMessage());
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Der er opstået en fejl ved registrering af kontakt. Prøv igen'));
    		return null;
    	}
    }  
    
    /**
    * @description: Sends email to each of the attendees registered from the form
    * @return: String
    */ 
    public String sendEmailToAttendees(String cId, String cEmail){
    	try{
	    	String templateId = [Select Id From EmailTemplate Where DeveloperName = 'YouSee_Live_13' Limit 1].Id;
			String fromEmailId = [Select Id From OrgWideEmailAddress Where DisplayName = 'YouSee Forhandler Support' Limit 1].Id;
			List<String> toAddresses = new List<String>{cEmail};
			
			// Define the email 
			Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
			
			// Reference the attachment page and pass in the Contact ID
			PageReference pdf =  Page.DealerWebConferenceTicket;
			pdf.getParameters().put('id',(String)cId); 
			pdf.setRedirect(true);
			// Take the PDF content
			Blob b = pdf.getContent();
			
			// Create the email attachment
			Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
			efa.setFileName('YouSee LIVE 13.pdf');
			efa.setBody(b);
			
			// Sets the paramaters of the email   
			email.setSaveAsActivity(false);
			email.setOrgWideEmailAddressId(fromEmailId);
			
			email.setTemplateId(templateId);
			email.setTargetObjectId(cId);
			
			email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa}); // Sends the email 
			
			Messaging.SendEmailResult [] r = 
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
			
			return 'Mail Sent successfully'; 
    	}
    	catch(Exception e){
    		system.debug('EXCEPTION THROWN in sendEmailToAttendees: ' +e.getMessage());
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Send email fejlede.'));
			return null;
    	}
    	return '';
    }                                 
    
    /**
    * @description: Redirects user to forhandler home page
    * @return: forhandlerHomePage
    */  
    public PageReference redirectToHome(){
    	PageReference pageRef = new PageReference('/apex/forhandlerHomePage');
    	return pageRef;
    }   
    
    /**
    * @description: Sends email to registered contacts
    */  
    public void sendEmail(){
    	for(Contact c : lstInsertedContacts){
    		String result = sendEmailToAttendees(c.Id, c.Email);
    	}
    }
    
    /**
    * @description: Get logged in dealer's postal code information to display transport option on form page
    */  
    public void getCurrentDealerDetails(){
    	
		currentDealerContact = [Select c.Post_Code_P__c, c.Id From Contact c where c.Id=:currentDealerUser[0].ContactId]; 
		system.debug('currentDealerContact[0].Post_Code_P__c in getCurrentDealerDetails'+currentDealerContact[0].Post_Code_P__c);
   	    if(currentDealerContact[0].Post_Code_P__c > String.valueOf(4999))
            myFlag= true;   	    
        else
            myFlag = false;        
    }
    
    /**
    * @description: Checks if the mobile number is unique
    * @return: boolean
    */      
    private String checkMobileNumber(String editOrAdd, Integer recordNumber){
    	Set<String> mobile = new Set<String>();
    	String mobileMsg = '';
    	Integer count = 0;
    	system.debug('contact.Conference_Mobile_Phone__c in checkMobileNumber' +wrapCons.contact.Conference_Mobile_Phone__c);
    	if(wrapCons.contact.Conference_Mobile_Phone__c.length() < 8 || !Pattern.matches('[0-9]{8,8}',wrapCons.contact.Conference_Mobile_Phone__c)){
    		mobileMsg = 'Mobil nummer skal være 8 karakterer langt.';
    	}
    	else{    		
	    	for(WrapContacts wrap : wrapList){
	    		if(editOrAdd == 'edit' && wrap.rowCount != recordNumber)
	    			mobile.add(wrap.contact.Conference_Mobile_Phone__c);
	    		else if(editOrAdd != 'edit')
	    			mobile.add(wrap.contact.Conference_Mobile_Phone__c);	
	    	}
	    	system.debug('mobile added previously ' +mobile);
	    	List<Contact> conList = new List<Contact>();
	    	conList = [Select Id,Conference_Mobile_Phone__c from Contact where Conference_Mobile_Phone__c =: wrapCons.contact.Conference_Mobile_Phone__c];
	    	if(conList.size()>0 || mobile.contains(wrapCons.contact.Conference_Mobile_Phone__c)){
	    		mobileMsg = 'Mobil nummeret er allerede brugt til en tilmelding. Indtast venligst et andet mobil nummer.';
	    	}
    	}    	
    	return mobileMsg;
    }
    
    /**
    * @description: Set pickup Time map
    */   
    private void setPickupTime(){
		pickTime.put('Frederikshavn Banegård' , 'Kl. 05.15');
		pickTime.put('Ålborg Hallens P-Plads','Kl. 06.15');
		pickTime.put('Randers Hallens P-Plads – Skyline Arena','Kl. 07.30');
		pickTime.put('Struer Banegård','Kl. 06.30');
		pickTime.put('Holstebro Banegård','Kl. 07.00');
		pickTime.put('Herning Banegård','Kl. 07.30' );
		pickTime.put('Vejle Banegård','Kl. 08.30');
		pickTime.put('Skive Banegård','Kl. 06.00');
		pickTime.put('Viborg Banegård','Kl. 06.30');
		pickTime.put('Silkeborg Banegård','Kl. 07.00');
		pickTime.put('Skjern Banegård','Kl. 06.00');
		pickTime.put('Varde Banegård','Kl. 06.35');
		pickTime.put('Esbjerg Banegård','Kl. 07.00');
		pickTime.put('Fredericia Banegård','Kl. 08.15');
		pickTime.put('Aabenraa Afkørsel ved Mc Donalds','Kl. 06.45');
		pickTime.put('Haderslev busstation','Kl. 07.15');
		pickTime.put('Kolding Banegård','Kl. 07.45');
		pickTime.put('Nyborg Banegård','Kl. 09.00');
		pickTime.put('Aarhus ved Musikhuset','Kl. 06.30');
		pickTime.put('Horsens ved afkørsel 56 - den ved Burger King','Kl. 08.00');
		pickTime.put('Odense Banegård ved posthuset','Kl. 09.00');		
	} 
    
    /**
    * @description: Set drop Time map
    */  
    private void setDropTime(){ 
		dropTime.put('Frederikshavn Banegård' , 'Kl. 23.45');
		dropTime.put('Ålborg Hallens P-Plads','Kl. 22.15');
		dropTime.put('Randers Hallens P-Plads – Skyline Arena','Kl. 21.00');		
		dropTime.put('Struer Banegård','Kl. 23.00');
		dropTime.put('Holstebro Banegård','Kl. 22.30');
		dropTime.put('Herning Banegård','Kl. 22.00' );
		dropTime.put('Vejle Banegård','Kl. 21.00');		
		dropTime.put('Skive Banegård','Kl. 22.15');
		dropTime.put('Viborg Banegård','Kl. 21.45');
		dropTime.put('Silkeborg Banegård','Kl. 21.15 ');		
		dropTime.put('Skjern Banegård','KI. 22.00');
		dropTime.put('Varde Banegård','Kl. 21.30');
		dropTime.put('Esbjerg Banegård','Kl. 21.10');
		dropTime.put('Fredericia Banegård','Kl. 20.00');		
		dropTime.put('Aabenraa Afkørsel ved Mc Donalds','Kl. 21.15');
		dropTime.put('Haderslev busstation','Kl. 20.45');
		dropTime.put('Kolding Banegård','Kl. 20.15');
		dropTime.put('Nyborg Banegård','Kl. 19.00');		
		dropTime.put('Aarhus ved Musikhuset','Kl. 21.30');
		dropTime.put('Horsens ved afkørsel 56 - den ved Burger King','Kl. 20.30');
		dropTime.put('Odense Banegård ved posthuset','Kl. 19.30');		
	}  
	
	/**
    * @description: sorts the contact list
    */ 
    private void sortList(){
    	wrapList = new List<WrapContacts>();		      
      	List<String> sortCount = new List<String>();
      	sortCount.addAll(mapWrap.keySet());
      	sortCount.sort();
      	for(String i : sortCount){
      		wrapList.add(mapWrap.get(i)); 
      	}
    }       
	
	/**
    *@description: this method is used to validate email 
    *This method will return false only when client side alert boxes are disabled.
    */ 
	private String emailValidation(String email){
		String emailMsg = '';
		if(Pattern.matches('[_a-z0-9-]+(.[_a-z0-9-]+)*@[a-z0-9-]+(.[a-z0-9-]+)*(.[a-z]{2,4})',email)){
        	system.debug('Valid Email Address ');
        	emailMsg = '';
        }else{
			system.debug('Invalid Email Address in emailValidation');
			emailMsg = 'Ugyldig e-mail-adresse';
		}
		return emailMsg;
	}
	
    /**
    * @description: Wrapper Class for holding contacts
    */ 
	public class WrapContacts{
		public Contact contact{get ; set;}
		public Integer rowCount {get ; set;}
			
		public WrapContacts(){
			contact = new Contact(Onskes_programplanen__c = true);
			rowCount = 0;				
		}
	}	
}