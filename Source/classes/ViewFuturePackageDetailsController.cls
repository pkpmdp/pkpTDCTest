public class ViewFuturePackageDetailsController{

   String futureSubsId;
   String amsId;
   String selectedInstID;
   public String portalUser {get; set;}
   public String startDateCheck { get; set;}
   public String endDateCheck { get; set;}
   public String strMidCRD{get; set;}
   public String strMidUPD{get; set;}
   public List<User> userList{get; set;}
   public List<cInstallation> futureSubscriptionList = new List<cInstallation>();
   public Integer countFlag {get; set;}
   date mydate = date.today();
   public String siteCoreUrl{get; set;}
   public List<Subscription__c> futureSubscrList = new List<Subscription__c>();
   public boolean orderByPortalUser{get;set;}
   
   
   public ViewFuturePackageDetailsController(){
    // futureSubsId = Apexpages.currentpage().getparameters().get('futureSubsId');
     //strMidCRD = new Set<String>();
     //strMidUPD = NEW Set<String>();
     userList = new List<User>();
     amsId = Apexpages.currentpage().getparameters().get('futureSubsId');
     orderByPortalUser=false;
     siteCoreUrl = ServiceCenter_CustomSettings__c.getInstance('Service_Center_SiteCoreURL').Value__c;
     System.debug('------Inside ViewFuturePackageDetailsController-------------amsId-->'+amsId);
     startDateCheck = 'false';
     futureSubscrList = new List<Subscription__c>();
     try {
       if(amsId != null){
         System.debug('-------------fetchFuturePackageDetails---------------');
         //futureSubscrList = [select subs.Id,subs.Product__r.Name, subs.Future_Subscription__c, subs.Net_Installation__r.Id,subs.Requested_Start_Date__c,subs.Requested_End_Date__c from Subscription__c subs where subs.Id =: futureSubsId];
         //futureSubscrList = [select subs.Id,subs.Product__r.Name, subs.Future_Subscription__c, subs.Net_Installation__r.Id,subs.Requested_Start_Date__c,subs.Requested_End_Date__c,subs.Formatted_Start_Date__c from Subscription__c subs where subs.Address__c  =: amsId AND subs.Formatted_Start_Date__c = null];
         futureSubscrList = [select subs.Id,subs.Product__r.Name, subs.Future_Subscription__c, subs.Net_Installation__r.Id,subs.Requested_Start_Date__c,subs.Requested_End_Date__c,CreatedByMID__c,UpdatedByMID__c, Start_Date__c from Subscription__c subs where subs.Address__c  =: amsId Order by LastModifiedDate DESC];
         System.debug('-----futureSubscrList-------'+futureSubscrList);
         countFlag = futureSubscrList.size();
         System.debug('-----countFlag size-------'+countFlag);
       }
     //Contact loggedinContact = [Select Street_P__r.Name, accountId, Name, HierarchyAccount__c From Contact  where id in(select contactid from User where id =:UserInfo.getUserId()) LIMIT 1];
     /* if(loggedinContact != null){
      portalUser = loggedinContact.Name;
     }else{
     	portalUser = '';
     }*/
     
     /*List<Order__c> lst_orders=[SELECT Id,Address_Id__c FROM Order__c where Address_Id__c =: amsId];
     if(lst_orders.size()>0){
     	orderByPortalUser = true;
     }
     if(orderByPortalUser == true){
      	portalUser = 'YouSee';
     }else{
     	portalUser = '';
     }*/
     
     DateTime d = datetime.now();
    //string strFormat='yyyy-MM-dd';
     string strFormat='dd-MM-yyyy';
     if(futureSubscrList.size() > 0){
	    for(Subscription__c futureSubscription : futureSubscrList){
	      if(futureSubscription.Future_Subscription__c == null){
	      //if(futureSubscription.Future_Subscription__c == null && futureSubscription.Requested_Start_Date__c >= Date.today()){
	        cInstallation subscription = new cInstallation(futureSubscription);
	        subscription.futureSubsPackage = futureSubscription.Product__r.Name;
	        if(futureSubscription.CreatedByMID__c != null){
	        	strMidCRD = futureSubscription.CreatedByMID__c;
	        	//strMidCRD.add(futureSubscription.CreatedByMID__c);
	        }
	        if(futureSubscription.UpdatedByMID__c != null){
	        	strMidUPD = futureSubscription.UpdatedByMID__c;
	        	//strMidUPD.add(futureSubscription.UpdatedByMID__c);
	        }
	        	/*portalUser = 'YouSee';
	        }else{
	        	portalUser = loggedinContact.Name;
	        }*/
	        system.debug('#Future Subs Package#'+subscription.futureSubsPackage+'###strMidCRD'+strMidCRD+'$$$$$strMidUPD'+strMidUPD);
	        String formattedReqStartDate,formattedReqEndDate;
	        //if(futureSubscription.Requested_Start_Date__c != null && futureSubscription.Requested_Start_Date__c >= mydate){
	        if(futureSubscription.Requested_Start_Date__c != null){
		        formattedReqStartDate = convertDateFormat(futureSubscription.Requested_Start_Date__c);
	        }
	        if(formattedReqStartDate != null){
		        if(formattedReqStartDate != '01-01-2100' && formattedReqStartDate != '01-01-1900'){
		        	subscription.effectiveDate = formattedReqStartDate;
		        }else{
				   subscription.effectiveDate = '';
		        }
	        }
	        
	      //  if(futureSubscription.Requested_End_Date__c != null && futureSubscription.Requested_End_Date__c >= mydate){
	        if(futureSubscription.Requested_End_Date__c != null){
		      formattedReqEndDate = convertDateFormat(futureSubscription.Requested_End_Date__c);
	        }
	         if(formattedReqEndDate != null){
			   if(formattedReqEndDate != '01-01-2100' && formattedReqEndDate != '01-01-1900'){
			   	   subscription.effectiveEndDate = formattedReqEndDate;
			       endDateCheck = 'true';
			   }else{
			       subscription.effectiveEndDate = '';
				   endDateCheck = 'false';
			   }
	        }
	        if(subscription.effectiveDate != null || subscription.effectiveDate != ''){
	          if(subscription.effectiveEndDate == null || subscription.effectiveEndDate == ''){
	             startDateCheck = 'true'; 
	          }
	        }
	        System.debug('before adding startDateCheck---'+startDateCheck);
	        System.debug('before adding subscription---'+subscription);
	        System.debug('before adding futureSubscList.futureSubsPackage---'+subscription.futureSubsPackage);
	        System.debug('before adding futureSubscList.effectiveDate---'+subscription.effectiveDate);
	        if(subscription != null){
	          futureSubscriptionList.add(subscription);
	          system.debug('#futureSubscriptionList#'+futureSubscriptionList+'####Updated Count'+futureSubscriptionList.size());
	        }
	    }
	    }
     }  
     System.debug('$$$Before Portal User'+portalUser); 
     if(strMidUPD != null){
     	
     	System.debug('%%Inside Create');
     	userList = [Select Id,MID__c from User where MID__c =: strMidUPD and MID__c != null];
     	if(userList != null && userList.size() > 0){
     		portalUser = 'YouSee';
     	}else{
     		/*userList = [Select ID,Name From User where Name IN :strMidUPD];
     		if(userList.size() > 0){
     			portalUser = userList[0].Name;
     		}*/
     		portalUser = strMidUPD;
     	}
     	System.debug('$$$Inside Update'+portalUser);
     }else if(strMidCRD != null){
     	System.debug('%%Inside update'+strMidCRD);
     	userList = [Select Id,MID__c from User where MID__c =: strMidCRD and MID__c != null];
     	if(userList != null && userList.size() > 0){
     		portalUser = 'YouSee';
     	}else{
     		/*userList = [Select ID,Name From User where Name IN :strMidCRD];
     		if(userList.size() > 0){
     			portalUser = userList[0].Name;
     		}*/
     		portalUser = strMidCRD;
     	}
     	System.debug('$$$Inside Create'+portalUser);
     } 
     System.debug('$$$Final Inside Create/Update'+portalUser);
     }catch(Exception e){
        System.debug('--------EXCEPTION----------'+e.getMessage());
     } 
   }
   
   public List<cInstallation> getFutureSubscriptionList(){
   	System.debug('futureSubscriptionList size----'+futureSubscriptionList.size());
   	System.debug('futureSubscriptionList----'+futureSubscriptionList);
   	return futureSubscriptionList;
   }
    private String convertDateFormat(Date inputDate){
      String strDtFormat='dd-MM-yyyy';
      String formattedDate;
      DateTime dt = inputDate;
      if(dt != null){
         formattedDate = dt.format(strDtFormat);
      }
      return formattedDate;
   }
   
}