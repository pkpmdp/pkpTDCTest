global class CTICallRegistrationWebServices {
    webservice static Boolean isCallRegVisible() {
        List<Call_Registration_Job__c> callRegJobs = CTICallRegistrationController.getUserJobs(UserInfo.getUserId());
        if (callRegJobs != null && callRegJobs.size() > 0){
            return true;
        }
        return false;
    }
    
    webservice static void cancelCallReg(String contextId){
      List<CTI_CallRegistration__c> actualCalls = [SELECT Id, TaksonomySet__c FROM CTI_CallRegistration__c WHERE ContextId__c = :contextId AND CreatedById =:UserInfo.getUserId() AND TaksonomySet__c = null];
      if (actualCalls != null && actualCalls.size() > 0){
        delete actualCalls;
      }
    }

    private static void UpdateCTIObject(CTI_CallRegistration__c CTI, String contextId, String CDN, Long callDuration, String phoneNo, String callStartTimeString, String contactID, String accountID, String CustNo) {
      if (CTI != null){
	      CTI.Call_Duration_In_Seconds__c = callDuration;
	              
	      if (phoneNo != null && phoneNo.length() > 0){
	        CTI.Phone_number__c = phoneNo;
	      }
	      
	      if (CDN != null && CDN.length() > 0){
	        CTI.CDN__c = CDN;
	      }
	      
	      if (callStartTimeString != null && callStartTimeString.length() > 0){
	        CTI.Call_Start_Time__c = Datetime.newInstance((Decimal.valueOf(callStartTimeString)).longValue() * 1000);
	      }
	      
	      if (CTI.Account__c == null){
	          if (contactID!= null && contactID.length() > 0){
	            List<Contact> contacts = [SELECT Id, AccountId FROM Contact WHERE Id = :contactID];
	            if (contacts.size() > 0) {
	              CTI.Account__c = contacts[0].AccountId;
	            }
	          } else if (accountID!= null && accountID.length() > 0) {
	            List<Account> customers = [SELECT Id FROM Account WHERE Id = :accountID];
	            if (customers.size() > 0) {
	              CTI.Account__c = customers[0].Id;
	            }
	          } else if (CustNo!= null && CustNo.length() > 0) {
	            List<Account> customers = [SELECT Id FROM Account WHERE Customer_No__c = :CustNo];
	            if (customers.size() > 0){
	              CTI.Account__c = customers[0].Id;
	            }
	          }
	        }
	    }
    }
    
    private static Boolean InternalIsCallRegRequired(String CDN){
        List<Call_Registration_Job__c> callRegJobs = CTICallRegistrationController.getUserJobs(UserInfo.getUserId());
        Boolean callRegRequired = false;
        if (callRegJobs != null && callRegJobs.size() > 0) {
            if (callRegJobs[0].Job_Type__c == CTIAdministrationController.JOB_TYPE_REQUIRED) {
                callRegRequired = true;
            } else if (callRegJobs[0].Job_Type__c == CTIAdministrationController.JOB_TYPE_TIME) {
                DateTime compareDateTime = DateTime.newInstance(CTIAdministrationController.DEFAULT_DATE, DateTime.now().time());
                if (compareDateTime > callRegJobs[0].Time_From__c && compareDateTime < callRegJobs[0].Time_To__c)
                    callRegRequired = true;
            } else if (callRegJobs[0].Job_Type__c == CTIAdministrationController.JOB_TYPE_CDN) {
                if (CDN == callRegJobs[0].CDN__c) {
                    // user must be selected
                    Integer userCount = [SELECT COUNT() FROM Jobs_Users__c WHERE Call_Registration_Job__c = :callRegJobs[0].Id];
                    if (userCount > 0)
                        callRegRequired = true;
                }
            } else if (callRegJobs[0].Job_Type__c == CTIAdministrationController.JOB_TYPE_COVERAGE) {
                Date now = Date.today();
                Integer agentCallRegistrations = [SELECT COUNT() FROM CTI_CallRegistration__c WHERE CreatedById = :UserInfo.getUserId() AND CreatedDate >= :now AND CreatedDate <= :now + 1];
                Integer agentCalls = [SELECT COUNT() FROM Task WHERE CreatedById = :UserInfo.getUserId() AND CreatedDate >= :now AND CreatedDate <= :now + 1];
                System.debug('agentCallRegistrations: ' + agentCallRegistrations);
                System.debug('agentCalls: ' + agentCalls);
                if (agentCalls > 0) {
                    // calculate current coverage
                    Decimal coverage = (Decimal.valueOf(agentCallRegistrations) / Decimal.valueOf(agentCalls)) * 100;
                    if (coverage < callRegJobs[0].Coverage__c) {
                        callRegRequired = true;
                    }
                }
            } else {
              // unknown Job Type
            }        
        }
        return callRegRequired; 
    }
    
    webservice static Boolean IsCallRegMandatory(String CDN) {
        return InternalIsCallRegRequired(CDN);
    }
    
    webservice static Boolean IsCallRegFinished(String contextId){
    	List<CTI_CallRegistration__c> actualCalls = [SELECT Id, TaksonomySet__c FROM CTI_CallRegistration__c WHERE ContextId__c = :contextId AND CreatedById =:UserInfo.getUserId()];
      if (actualCalls != null && actualCalls.size() > 0 && actualCalls[0].TaksonomySet__c != null){
      	return true;
      }
      return false;
    }

    webservice static Boolean DoCallReg(String contextId, String CDN, Long callDuration, String phoneNo, String callStartTimeString, String contactID, String accountID, String CustNo) {
    
        // check if call registration was already created
        List<CTI_CallRegistration__c> actualCalls = [SELECT Id, TaksonomySet__c, Account__c FROM CTI_CallRegistration__c WHERE ContextId__c = :contextId AND CreatedById =:UserInfo.getUserId()];
                
        if (actualCalls != null && actualCalls.size() > 0){
            UpdateCTIObject(actualCalls[0], contextId, CDN, callDuration, phoneNo, callStartTimeString, contactID, accountID, CustNo);
            update(actualCalls[0]);
            if (actualCalls[0].TaksonomySet__c != null){
                return false;
            }
        }

        Boolean callRegRequired = InternalIsCallRegRequired(CDN);
        
        // insert Call Registration record to keep parameters contextID and call duration
        if (callRegRequired){
          if (actualCalls == null || actualCalls.size() == 0){
              CTI_CallRegistration__c CTI = new CTI_CallRegistration__c(
                ContextId__c = contextId                            
              );
              
              UpdateCTIObject(CTI, contextId, CDN, callDuration, phoneNo, callStartTimeString, contactID, accountID, CustNo);
              
              insert CTI;
          }
        }
        
        return callRegRequired;
    }
}