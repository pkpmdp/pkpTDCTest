public global class CommonExceptionHandlerCls {
	
	private String  className {get;set;}
	private String  ModuleName {get;set;}
	private String  functionName {get;set;}
	
	public errorLogDetails errlog = new errorLogDetails();
	//public ServiceCenter_ErrorLogs__c log;
	
	
	public CommonExceptionHandlerCls (String className1,String moduleName1){
		this.className = className1;
		this.ModuleName = moduleName1;
	}

	public CommonExceptionHandlerCls(){
		
	}
	public void logErrorMessage (String errorLog, Boolean debugLogs, String sevLevel) {
	
		Blob pdfLog = Blob.valueOf(errorLog);
		//sendLogMail(pdfLog);
		storedErrorLogsInObject(errorLog, sevLevel);	
	}
	
	public string prepareMessage(Exception excep,String modulename1, String functionname1) {
		return 'From : ' + classname + '  Method: ' + functionname1 + ' Module Name : '+modulename1
			 + ' ErrorMessage: ' + excep.getMessage();
	}
	
	public void handleException(Exception excep,string functionname1,
								boolean showindebuglog,boolean putonerrorstack,String cableUnitNumber, String severityLevel) {
									
		string message = prepareMessage(excep, modulename, functionname1);
		//if (showindebuglog) {
		logErrorMessage(message, showindebuglog, severityLevel);
		  //return errorLog;
		//}	
		//redirectToCommonErrorPage();
		//if (!putonerrorstack) throw new serviceCenterException(message);	 
	}
	
	public pageReference redirectToCommonErrorPage () {
        return Page.exception;
	}
	
	class errorLogDetails {
		
		/*public String organizationName {get;set;}
		public String userName {get;set;}
		public String moduleName {get;set;}
		public String errorDescription {get;set;}
		public String resolution {get;set;}
		*/
	}  

	private void storedErrorLogsInObject(String errorLogs, String sevLevel1){
		
		try {
			    system.debug('inside storedErrorLogsInObject-----------');
			    
				DateTime errorDateTime = DateTime.Now();  
				ServiceCenter_ErrorLogs__c log = new ServiceCenter_ErrorLogs__c();
				
				if (errorLogs!=null && errorLogs!=''){
					log.Error_Description__c = errorLogs;
				} 
				log.Date_Time__c = errorDateTime;
				log.Organization_Id__c = UserInfo.getOrganizationId();
				log.Organization_Name__c = UserInfo.getOrganizationName();
				log.User_Id__c = UserInfo.getUserId();
				log.User_Name__c = UserInfo.getName();
				log.Use_Case__c = this.ModuleName;
				log.Severity__c = sevLevel1;
				if (log !=null){
					system.debug('$Error validation$'+log);
					//update log;
					insert log;
					system.debug('$ Log inserted Error validation$'+log);
				}
		} catch (Exception e){
			 system.debug('Erro :'+e.getMessage());
			 ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
             ApexPages.addMessage(errorMsg);
    	}		
		 
	}

     public void sendLogMail(Blob ErrorLog){ 	
	 //private void sendLogMail(Blob ErrorLog) {
  
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        String userName = UserInfo.getUserName();
        system.debug('sendLogMail-----userName---------'+userName);
        User activeUser = [Select Email From User where Username = : userName limit 1];
        String userEmail = activeUser.Email;
        String[] toAddresses = new String[] {userEmail};
        system.debug('toAddress------------'+toAddresses[0]);  
        mail.setToAddresses(toAddresses);
        
        mail.setReplyTo('navneet.rajput@capgemini.com');

        mail.setSenderDisplayName(userEmail);
        
        mail.setSubject('Exception Found in service center');

        mail.setBccSender(false);

        mail.setUseSignature(false);

        mail.setHtmlBody('<div style="font-family:Verdana, Geneva, sans-serif; font-size:12px"> <br/><br/><b>Organization:</b> '
        					+ UserInfo.getOrganizationName() +' ('+ UserInfo.getOrganizationId() +')<br/><b>User:</b> ' + UserInfo.getName()
        					+ ' ('+ UserInfo.getUserId() +')<br/><br/>some text.<br/>');
        
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
		
        attachment.setBody(ErrorLog);
        
		attachment.setContentType('text/html; charset=UTF-8');
        
		attachment.setFileName('errorLog.html');
        
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attachment});

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
		 
}