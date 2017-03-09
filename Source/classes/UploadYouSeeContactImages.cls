public class UploadYouSeeContactImages{
    public String mainImage;
    
    // added for unknown comment
    public Id ysId;
    public String YouSeeContactName = '';
    public String YouSeeContactEmail = '';
    public String YouSeeContactTelephone = '';
    public String telephoneExt = '+45';
    public String YouSeeContactMCode = '';
    Private String ImageId = '';
    public ID accId{get;set;}
    public string cableunitnumber = '';
    public String siteCoreUrl{get; set;}
    public String accountId{get;set;}//support-5377
     public Boolean renderSection{get;set;}//support-5377
    public String portalBrugerRole {get; set;}
    
    public CommonExceptionHandlerCls exceptionHandler = new CommonExceptionHandlerCls('UploadYouSeeContactImages','Update personal information');
    
    public String  GetYouSeeContactName () {
        return YouSeeContactName;       
    }
    public String  GetYouSeeContactEmail () {
        return YouSeeContactEmail;      
    }
    
    public String  GetYsId () {
        return ysId;      
    }
    
     public String  GetYouSeeContactTelephone () {
        return YouSeeContactTelephone;      
    }
     
    public String GetDocumentId (String UserMCode ){
      try {
            String Result = '';
            for(Document docu : [Select d.Id From Document d where d.Name =: UserMCode]){
              Result = '/servlet/servlet.FileDownload?file=' + docu.Id;
            }
            
            return Result;
      } catch (Exception e) {
        ApexPages.Message myMsg;
            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,Label.SC_commonError);
            ApexPages.addMessage(myMsg);
            return null;
      }         
    }
  
    public String getMainImage(){
        return mainImage;
    }
    
    public void setMainImage(Id imageId){
        this.mainImage = imageId;
    }
    public string cableUnitName {get;set;}
    
    
    public UploadYouSeeContactImages(){
      try{
        cableUnitName = '';
        portalBrugerRole = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
        siteCoreUrl = ServiceCenter_CustomSettings__c.getInstance('Service_Center_SiteCoreURL').Value__c;
        accId = ApexPages.currentPage().getParameters().get('accountId');
        cableunitnumber = ApexPages.currentPage().getParameters().get('cableunitnumber');
        System.debug('$AcccID$'+accId);
        
        // Support-5377 -------- START
        Boolean cableUnitMatch = true;  //Support-5377  
        renderSection = true; //Support-5377

        list<Account> accList = new list<Account>();
            if(String.isNotBlank(accId)){
                
                accList = [SELECT Id, Cable_Unit__r.Cable_Unit_No__c FROM Account where id =:accId ];
            }
            
            if(!accList.isEmpty()){
                if(cableUnitNumber != null && accList[0].Cable_Unit__r.Cable_Unit_No__c != cableUnitNumber){
                    renderSection = false;
                    cableUnitMatch = false;
                    /* ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Cable Unit Not matched with Account');
                    ApexPages.addMessage(errorMsg); */ 
                }
            }
            else
            {
                renderSection = false;
                cableUnitMatch = false;
                
                 system.debug('***cableUnitMatch****renderSection****'+cableUnitMatch + '    ' + renderSection);
            }
        
        if(cableUnitMatch){
            cableUnitName = ServiceCenterSingleton.getInstance().getCableUnitName(ApexPages.CurrentPage().getParameters().get('cableunitnumber'));
        
        String relManagerRoleName = ServiceCenter_CustomSettings__c.getInstance('Service Center RelationShip Manager').Value__c;
        //String relManagerRoleName = 'Kundeansvarlig';      
        List<Lookup_Account_Team_Role__c> roleList1 = [select Id from Lookup_Account_Team_Role__c where Name =: relManagerRoleName];
        Id relManagerRoleId;
            
            
        if(roleList1.Size() > 0){
          relManagerRoleId = roleList1.get(0).Id;
        }
        
        //for ( Account_Team__c at : [Select a.Id,a.Customer_Team_Member__c,a.Customer_Team_Member__r.Name,a.Customer_Team_Member__r.Code__c,a.Customer_Team_Member__r.Telephone__c,a.Customer_Team_Member__r.Email__c From Account_Team__c a where a.Customer_Team_Role__r.Id  =: relManagerRoleId]){
        for ( Account_Team__c at : [Select a.Id,a.Customer_Team_Member__c,a.Customer_Team_Member__r.Name,a.Customer_Team_Member__r.Code__c,a.Customer_Team_Member__r.Telephone__c,a.Customer_Team_Member__r.Email__c From Account_Team__c a where a.Customer_Team_Role__r.Id  =: relManagerRoleId and a.customer__C =: accId]){
            if(at.Customer_Team_Member__r.Name != null && at.Customer_Team_Member__r.Name != '' && at.Customer_Team_Member__r.Name.length() > 0 ){
                  YouSeeContactName = at.Customer_Team_Member__r.Name;
                }else{
                  YouSeeContactName = '';
                }
                if(at.Customer_Team_Member__r.Email__c != null && at.Customer_Team_Member__r.Email__c != '' && at.Customer_Team_Member__r.Email__c.length() > 0 ){
                  YouSeeContactEmail = at.Customer_Team_Member__r.Email__c;
                }else{
                    YouSeeContactEmail = '';
                }
                
                if(YouSeeContactEmail != null){ 
                  ysId = at.Customer_Team_Member__r.Id;
                } 
                //YouSeeContactTelephone = at.Customer_Team_Member__r.Telephone__c;
                if(at.Customer_Team_Member__r.Telephone__c != null && at.Customer_Team_Member__r.Telephone__c != '' && at.Customer_Team_Member__r.Telephone__c.length() > 0 ){
                  YouSeeContactTelephone = telephoneExt + at.Customer_Team_Member__r.Telephone__c;
                }else{
                  YouSeeContactTelephone = '';
                  //YouSeeContactTelephone = at.Customer_Team_Member__r.Telephone__c;
                  //YouSeeContactTelephone = telephoneExt + '45869'; 
                }
                //YouSeeContactMCode = at.Customer_Team_Member__r.Code__c;
                if(at.Customer_Team_Member__r.Code__c != null){
                  YouSeeContactMCode = at.Customer_Team_Member__r.Code__c;
                  system.debug('#MCODe#'+YouSeeContactMCode);
                }else{
                  YouSeeContactMCode = '';
                } 
                
                /*if(at.Customer_Team_Member__r.Code__c != null && at.Customer_Team_Member__r.Code__c != '' && at.Customer_Team_Member__r.Code__c.length() > 0 ){
                  YouSeeContactMCode = at.Customer_Team_Member__r.Code__c;
                  System.debug('$YouSeeContactMCode$'+YouSeeContactMCode);
                }else{
                  YouSeeContactMCode = '';
                }*/
            }
            ImageId = GetDocumentId(YouSeeContactMCode);
              mainImage = ImageId;
                  
              
    
            
        }
        
       
        
             
        }catch (Exception e) {
        ApexPages.Message myMsg;
            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,Label.SC_commonError);
            ApexPages.addMessage(myMsg);
      }
    }
  
    Public String GetOrgId() {
        String Result = '';
        Result = '&oid=' + UserInfo.getOrganizationId() ;
        
        Return Result;      
    }
   
  
   public PageReference cancel()
    { 
       try {
            PageReference newPage = new PageReference(contactConstClass.CABLEUNITDETAILURL);
            if (cableunitnumber!= null){
                newPage.getParameters().put(contactConstClass.CABLEUNITNUMBER, cableunitnumber);
            }else{
                Account account = [Select a.Anlaeg_No__c From Account a where a.id =: accId];
                newPage.getParameters().put(contactConstClass.CABLEUNITNUMBER, account.Anlaeg_No__c);
            }
            newPage.getParameters().put(contactConstClass.ACCOUNTID,accId);

            newPage.setRedirect(true);
            
            return newPage;
       } catch (Exception e) {
        ApexPages.Message myMsg;
            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,Label.SC_commonError);
            ApexPages.addMessage(myMsg);
            exceptionHandler.handleException(e,'cancel()',false,false,cableunitnumber,'Medium');
            return null;
      }     
            
    }
        
    public PageReference writeToConsultant()
    {
      try {
          PageReference writeToConsultantPage;
          writeToConsultantPage= Page.writeToYourConsultant;
          writeToConsultantPage.getParameters().putAll(ApexPages.CurrentPage().getParameters());
          writeToConsultantPage.getParameters().put('previousPage','/apex/viewYouseeContactPersonPage');
          writeToConsultantPage.getParameters().put('YouSeeContactEmail',GetYouSeeContactEmail());
          writeToConsultantPage.getParameters().put('ysId',GetYsId());
          return writeToConsultantPage;
      }  catch (Exception e) {
        ApexPages.Message myMsg;
            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,Label.SC_commonError);
            ApexPages.addMessage(myMsg);
            exceptionHandler.handleException(e,'writeToConsultant()',false,false,cableunitnumber,'Medium');
            return null;
      }            
    }
    
       
}