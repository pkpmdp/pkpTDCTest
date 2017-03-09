public class DealerCreationController {
    
 private final Account acc;
 public integer ambassadorCount = 0;
 public integer Acount {get;set;}
 public List<Account_Contact_Role__C> ACRList;
 public List<Contact> contactList;
 public ID accID;
 public List<Lookup_Contact_Roles__c> roleId;
 public List<Lookup_Contact_Roles__c> AmbRoleId;
 public Contact contact {get;set;}
 public List<Contact> contactFinalList {
      get {return contactList;}
      set {contactList= value;}
  }

public Contact managercontact;      
    public Contact getManagercontact()
    {
      return managercontact ;
    }
    public void setManagercontact(Contact c)
    {
      managercontact = c; 
    }
  
   
    public DealerCreationController (ApexPages.StandardController controller) {
        this.acc = (Account)controller.getRecord();
        ACRList = new List<Account_Contact_Role__C>();
        contactList = new List<Contact>();
    }
    
   public PageReference addAmbassador() {
      
      if(contactList ==null){
          contactList= new List<Contact>();
       }
       
      
      ambassadorCount++;
      Acount = ambassadorCount;
      Contact obj = new Contact();
      contactList.add(obj);
      return null;
    }
    
    public PageReference addManager() {
      
      managercontact = new Contact();
      return null;
    }
        
     public List<SelectOption> getDealerProductsItems() { 
        List<SelectOption> items = new List<SelectOption>(); 
        for(LookupMaster__c rt: [select id,name from LookupMaster__c where RecordType__C= 'Dealer Products' order by Order_sequence__c]) {      
            items.add(new SelectOption(rt.name,rt.name));  
        } 
      
        return items;
    }

    public List<SelectOption> getDealerGroupItems() { 
        List<SelectOption> items = new List<SelectOption>(); 
        items.add(new SelectOption('none','--Select--    '));  
        for(LookupMaster__c rt: [select id,name from LookupMaster__c where RecordType__C= 'Dealer Group' order by Order_sequence__c]) {      
           items.add(new SelectOption(rt.name,rt.name));
              
        } 
        return items;
    }

    public List<SelectOption> getDealerCategoryItems() { 
        List<SelectOption> items = new List<SelectOption>(); 
        items.add(new SelectOption('none','--Select--    '));  

        for(LookupMaster__c rt: [select id,name from LookupMaster__c where RecordType__C= 'Dealer Kategori' order by Order_sequence__c] ) {      
            items.add(new SelectOption(rt.name,rt.Name));  
        } 
        return items;
    }  

    public List<SelectOption> getSalesConsultantItems() { 
        List<SelectOption> items = new List<SelectOption>(); 
        items.add(new SelectOption('none','--Select--    '));  
        for(LookupMaster__c rt: [select id,name from LookupMaster__c where RecordType__C= 'Sales Consultants' order by Order_sequence__c]) {      
            items.add(new SelectOption(rt.name,rt.name));  
        } 
        return items;
    }
 
   
  public PageReference cancel(){
        return page.ForhandlerCustomer;  
  }

    
 public PageReference save(){
 	
 	System.debug(' ----------- Inside the save method ------------- ');
    ID contactID;
    String strProducts =this.acc.DealerProducts__c;
    string result=   strProducts.substring(1, strProducts.length()-1);
    this.acc.DealerProducts__c = result;
    if(isValid()){
    
    System.debug(' ----------- Before the try method ------------- ');
    
    try{
        
    	RecordType rt = [select id,name from recordtype where sobjecttype='Account' and name='Forhandlerweb'];

		System.debug(' ----------- Before the RecordType method ------------- ');
		
        this.acc.recordTypeId = rt.Id;
        this.acc.selectedProduct__c = this.acc.DealerProducts__c;
    
    	
        Database.SaveResult sr = Database.insert(acc,false);
        if(sr.isSuccess())
        {
            accID= sr.getId();
        }
     
     	//manager contact insertion
        if(managerContact != null){
        
        ID managerId = ContactInsert(managerContact);
        
        System.debug(' ----------- Before the Lookup_Contact_Roles__c method ------------- ');
        
        if(managerId != null){
            roleId =[select id from Lookup_Contact_Roles__c where name= 'Dealer Manager'];
            Account_Contact_Role__C managerACRole = new Account_Contact_Role__C();
            managerACRole.Customer__c = accID;
            managerACRole.Contact__c = managerId;
            managerACRole.Role__c = roleId[0].id;
            insert  managerACRole ;
        }
      	
      	
        
     }
     
     System.debug(' ----------- Before the Lookup_Contact_Roles__c 1 method ------------- ');
        
  //ambassador contact insertion
  if(contactList.size() > 0){
    System.debug('contactFinalList-->'+contactList.size());
    AmbRoleId =[select id from Lookup_Contact_Roles__c where name= 'Dealer Ambassador']; 
    
    System.debug(' ----------- Before the Lookup_Contact_Roles__c 2 method ------------- ');
    
    for(integer cntCount =0; cntCount < contactList.size() ; cntCount++){
       contactList[cntCount].accountId = accID; 
    }
    
    System.debug(' ----------- Before the Lookup_Contact_Roles__c 3 method ------------- ');
    
    List<Database.Saveresult> sACRResults = Database.insert(contactList,false);
    Set <id> ids = new Set <id>();

System.debug(' ----------- Before the Lookup_Contact_Roles__c 4 method ------------- ');
System.debug(' ----------- Before the Lookup_Contact_Roles__c 14 method ------------- '+ AmbRoleId.size());


    for(Database.Saveresult ACRresult : sACRResults ) {
         ids.add(ACRresult.getId());
      } 
     
     for(ID newId : ids){
        Account_Contact_Role__C ACRole = new Account_Contact_Role__C();
        ACRole.Customer__c = accID;
        ACRole.Contact__c = newId;
        ACRole.Role__c = AmbRoleId[0].id;
        ACRList.add(ACRole);
    }
    System.debug(' ----------- Before the Lookup_Contact_Roles__c 5 method ------------- ');
     insert ACRList;
  }
  

     
}catch (System.DmlException   e) {
    system.debug(e.getMessage()); 
    
 }
return page.ForhandlerCustomer;  
}
 else{
        return null;
    }
 } 

 public ID ContactInsert(Contact CData){
    CData.accountId = accID; 
  
   Database.SaveResult srContact = Database.insert(CData,false);
  
    if(srContact.isSuccess())
      {
        System.debug('srContact.getId()--->'+ srContact.getId());
      }
       return srContact.getId();
   

 }
 
 
private Boolean isValid()
 {
    Boolean flag=true;
    ApexPages.Message myMsg;
    integer j;
    
    //For dealer product and group
     if(this.acc.DealerGroup__c.length() == 0 || this.acc.DealerGroup__c == 'none'){
         myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Select Dealer Group');
            ApexPages.addMessage(myMsg);
            flag= false;
    }
    
    if(this.acc.DealerProducts__c.length() == 0 || this.acc.DealerProducts__c == null){
         myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Select Dealer Product');
            ApexPages.addMessage(myMsg);
            flag= false;
    }
    //for manager contact
    if(managerContact != null){
        
     if( managerContact.LastName.trim().length() == 0){
            myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Enter Manager Name');
            ApexPages.addMessage(myMsg);
            flag= false;
        }
     if( managerContact.Email.trim().length() == 0){
            myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Enter Manager Email');
            ApexPages.addMessage(myMsg);
            flag= false;

        }
     if( managerContact.Phone.trim().length() == 0){
            myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Enter Manager Phone');
            ApexPages.addMessage(myMsg);
            flag= false;
            
        }
        
        /*
        if( managerContact.LastName.length() == 0 && ( managerContact.Email.length() != 0 || managerContact.Phone.length() != 0)){
            myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Enter Manager Name');
            ApexPages.addMessage(myMsg);
            flag= false;
        }
     if( managerContact.Email.length() == 0 && ( managerContact.LastName.length() != 0 || managerContact.Phone.length() != 0)){
               myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Enter Manager Email');
            ApexPages.addMessage(myMsg);
            flag= false;

        }
     if( managerContact.Phone.length() == 0 && ( managerContact.LastName.length() != 0 || managerContact.Email.length() != 0)){
            myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Enter Manager Phone');
            ApexPages.addMessage(myMsg);
            flag= false;
            
        }*/

    }

  //for ambassador contact
  if(contactList.size()>0){
    /*
    for(integer i =0 ; i < contactList.size() ; i++){
        j = i+ 1;
            if(contactList[i].LastName.length() == 0 && ( contactList[i].Email.length() != 0 || contactList[i].Phone.length() != 0)){
              string str = 'Enter Ambassador ' + j +' Name';
            myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,str);
            ApexPages.addMessage(myMsg);
            flag= false;
        }
     if( contactList[i].Email.length() == 0 && ( contactList[i].LastName.length() != 0 || contactList[i].Phone.length() != 0)){
            string strEmail = 'Enter Ambassador ' + j +' Email';
               myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,strEmail);
            ApexPages.addMessage(myMsg);
            flag= false;

        }
     if( contactList[i].Phone.length() == 0 && ( contactList[i].LastName.length() != 0 || contactList[i].Email.length() != 0)){
            string strPhone = 'Enter Ambassador ' + j +' Phone';
            myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,strPhone);
            ApexPages.addMessage(myMsg);
            flag= false;
            
        }   
    }*/
    
    for(integer i =0 ; i < contactList.size() ; i++){
        j = i+ 1;
            if(contactList[i].LastName.trim().length()==0){
              string str = 'Enter Ambassador ' + j +' Name';
            myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,str);
            ApexPages.addMessage(myMsg);
            flag= false;
        }
     if( contactList[i].Email.trim().length()==0){
            string strEmail = 'Enter Ambassador ' + j +' Email';
               myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,strEmail);
            ApexPages.addMessage(myMsg);
            flag= false;

        }
     if( contactList[i].Phone.trim().length()==0){
            string strPhone = 'Enter Ambassador ' + j +' Phone';
            myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,strPhone);
            ApexPages.addMessage(myMsg);
            flag= false;
            
        }   
    }
  
  }

return flag;
}   
    
}