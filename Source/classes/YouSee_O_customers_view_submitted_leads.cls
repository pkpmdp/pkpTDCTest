public class YouSee_O_customers_view_submitted_leads {

    public String siteCoreUrl {get;set;}
    public string cableUnitName{get; set;}
    public String portalBrugerRole {get; set;}
    public String cableUnitNumber {get; set;}
    public String successmsg {get; set;}
    public boolean showmsg{get;set;}
    public boolean displayStatus {get;set;}
    public boolean isButtonShow{get; set;}
    public list<Cable_Unit__c> cableUnit = new list<Cable_Unit__c>();
    
    public boolean send{get; set;}
    public Integer cnt=0;
    public Integer eCnt = 0;
    String leadownerId = UserInfo.getUserId(); 
   Transient public List<RegisteredLead> submittedLeads;
    Transient Static Map<ID, Lead> leadMap = new Map<ID, Lead>();
    public Boolean renderSection{get;set;}
   // public Static List<String> msg = new List<String>();
         
    public YouSee_O_customers_view_submitted_leads()
    {
      System.debug('Constructor submitted leads called');
      cableUnitName='';
      String accountID = ApexPages.currentPage().getParameters().get('accountId');
       cableUnitNumber = ApexPages.CurrentPage().getParameters().get('cableunitnumber');
       // Support-5377 --------START
        Boolean cableUnitMatch = true;  // Support-5377 
        renderSection = true; // Support-5377
         list<Account> accList = new list<Account>();
            if(String.isNotBlank(accountID)){
                
                accList = [SELECT Id, Cable_Unit__r.Cable_Unit_No__c FROM Account where id =:accountID ];
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
        
        siteCoreUrl = ServiceCenter_CustomSettings__c.getInstance('Service_Center_SiteCoreURL').Value__c;
        portalBrugerRole = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
       
        System.debug('***-->'+cableUnitNumber);
        cableUnit = [Select c.Id , c.name from Cable_Unit__c c where c.Cable_Unit_No__c = :cableUnitNumber limit 1];
        System.debug('***-->'+cableUnit);
        
        if(!cableUnit.isEmpty())
            cableunitName = cableUnit[0].name;
        
        successmsg = '';      
        showmsg = false;
        displayStatus = false;
        isButtonShow = true;
    }
    
    public List<RegisteredLead> getSubmittedLeads(){
        submittedLeads = new List<RegisteredLead>();
        if(!cableUnit.isEmpty()){
            for(Lead lead : [Select Id, resendFlag__c, Address_External_Id__c, Name , Email, Status, Unsubscribed__c, CreatedDate from Lead 
        where Cable_Unit_1__c = :cableUnit[0].Id and LeadSource = 'Service Center - Member registration' and OwnerId = :leadownerId order by CreatedDate Desc])
        {
            RegisteredLead objr =new RegisteredLead();
            objr.id = lead.Id;
            objr.name= lead.Name;
            objr.email= lead.Email;            
            objr.status=lead.Status;
            //objr.amsId = lead.Address_External_Id__c;
            System.debug('External Id--------*****--'+lead.Address_External_Id__c);
            objr.address = getAddress(lead.Address_External_Id__c);
            
            DateTime createdDate = lead.createdDate;
            String dateOutput = createdDate.format('dd-MM-yyyy');
            objr.createdDate= dateOutput;
            objr.unsubscribed = lead.Unsubscribed__c;
            objr.resend= lead.resendFlag__c;
            leadMap.put(lead.Id, lead);            
            submittedLeads.add(objr);            
        }  
            
        }
            
       return submittedLeads;
    } 
    
    public String getAddress(String addressExternalId)
    {
        String returnAddress;
        if(addressExternalId!=null)
        {
           System.debug('Inside if+++++++++'+addressExternalId);
          Transient List<Address__c> addressList = new List<Address__c>();
            addressList = [SELECT Full_Address__c FROM Address__c WHERE External_Id__c=:addressExternalId ] ;
            if(!addressList.isEmpty())
            {
                System.debug('AddresList---'+addressList);
              String fullAddress = addressList.get(0).Full_Address__c;             
              returnAddress =  fullAddress.substringBefore('<img');
            }   
        }
        System.debug('return------'+returnAddress);
        return returnAddress;
    }
    
    public void resendEmail(){
              
      String emailStr = '';    
      Integer count = 0;   
      Boolean checked = false;   
      showmsg = true;  
        send = false;
        cnt=0;
        List<Lead> ldList = new List<Lead>();
       for(RegisteredLead lead : submittedLeads){             
              if (lead.resend == true){
                     Lead updatedLead = leadMap.get(lead.id) ;
                 
                     updatedLead.resendFlag__c = true;
                     ldList.add(updatedLead);
                  
                     count ++;
                     if(count <= 1){emailStr = lead.email; }
                     else { emailStr = emailStr + ' , ' + lead.email ; }   
                     checked = true;                  
              }
       }
        update ldList;
       if (checked == true){
            emailStr.replaceAll(', $','');       
            successmsg = 'Email sendt til medlem: '+emailStr; }
       else {
            successmsg = 'Du skal vælge mindst én post';
       }
        cnt=0;
       displayStatus = false;
       isButtonShow = true;
    }
    
    
  public void checkStatus()
  {
      String emailStr = '';  
       for(RegisteredLead lead : submittedLeads){             
              if (lead.resend == true && lead.unsubscribed == true){
                 cnt ++; 
                   if(cnt <= 1)
                   {
                       emailStr = lead.email; 
                   }
                   else 
                   { 
                         emailStr = emailStr + ' , ' + lead.email ; 
                   }   
              }
       }
      if(cnt > 0)
      {
          send = true;
          displayStatus = true;
          isButtonShow = false;
          showmsg = true;
          successmsg = 'Medlem '+ emailStr +' er allerede registreret og har afvist medlemsregistrering. Vil du gensende?';
          System.debug('****displayStatus if ***'+displayStatus);
      }
      else
      {
          send = false;
          //resendEmail();
          System.debug('****displayStatus else *****'+displayStatus);
      }

      
  }
    
   public void cancelEmail()
   {
       send = false;
       cnt=0;
       showmsg = false; 
       displayStatus = false;
       isButtonShow = true;
   }
    
    
    public class RegisteredLead {
        public String name{get; set;}
        public String email{get; set;}
        public String status{get; set;}
        public String createdDate{get; set;}
        public Boolean unsubscribed {get; set;}
        public Boolean resend {get; set;}  
        public String id{get;set;}     
        //public String amsId{get;set;}   
        public String address{get; set;}
    }
       
}