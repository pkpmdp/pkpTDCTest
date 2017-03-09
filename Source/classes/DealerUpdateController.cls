public class DealerUpdateController{
   
    public Account acc= new Account();
    public List<Lookup_Contact_Roles__c> AmbRoleId;
    public List<Account_Contact_Role__c> ViewACRList {get;set;}
    
    public List<Account_Contact_Role__C> ACRList;
    public Contact ViewManager {
             get {return ViewManagerList ;}
             set {ViewManagerList = value;}
          }
    public Contact ViewManagerList;
    public Contact ViewAmbassador = new Contact ();
    public List<Contact> ViewAmbList = new List<Contact>();
    
    public  List<Contact> ViewAmbassadorList {
             get {return ViewAmbList ;}
             set {ViewAmbList = value;}
          }
 
    public PageReference addManager() {
      ViewManagerList = new Contact ();
      ViewManager = new Contact();
      return null;
    }
          
    public List<Contact> contactList= new List<Contact>();
    public Contact contact {get;set;}
  
    public List<Contact> contactFinalList {
      get {return contactList;}
      set {contactList= value;}
    }
    public Set <id> contactAmbassadorID;
    
    public Account ViewAccount {
             get {return ViewAcc ;}
             set {ViewAcc = value;}
          }
    public Account ViewAcc = new Account ();
    
    public string Street {get;set;}
    public string houseNumber {get;set;}
    public string postcode {get;set;}
    public string town {get;set;}
  
   public void addAmbassador() {
      Contact obj = new Contact();
      ViewAmbList.add(obj);
    
    }
 
 
 public ID accountId ;
 
  public DealerUpdateController(ApexPages.StandardController controller) {
   ACRList = new List<Account_Contact_Role__C>();
   contactAmbassadorID = new Set <id>();
   ViewAccount = new Account();
   accountId = ApexPages.CurrentPage().getParameters().get('accountId');
 
       /* ViewACRList =[Select a.Id,a.Role__r.Name,a.Customer__r.Id, a.Customer__r.Name, a.Customer__r.Anlaeg_No__c,a.Customer__r.Customer_No__c,a.Customer__r.phone,
                      a.Customer__r.type,a.Customer__r.Dealer_Number__c,a.Customer__r.isPersonAccount,a.Customer__r.Debitor_Number__c,a.Customer__r.DealerGroup__c,
                      a.Customer__r.Category__c, a.Customer__r.sales_consultant__c,a.Customer__r.Basis__c,a.Customer__r.POS__c,a.Customer__r.Afregnes__c, 
                      a.Customer__r.DealerProducts__c,a.customer__r.selectedProduct__c,a.Customer__r.Email__c ,
                      a.Customer__r.Fax,
                      a.Customer__r.Street_YK__r.name,
                      a.Customer__r.address_value__c,
                      a.Customer__r.Street_YK__r.Postcode__c,
                      a.Customer__r.Street_YK__r.Town__c,
                      a.Contact__r.Id, 
                      a.Contact__r.Name,
                      a.Contact__r.Email, 
                      a.Contact__r.Phone,
                      a.Contact__r.street_p__c,
                      a.Contact__r.street_p__r.name,
                      a.Contact__r.house_address__c, 
                      a.Contact__r.Street_P__r.Postcode__c ,
                      a.Contact__r.Street_P__r.Town__c 
                      From Account_Contact_Role__c a 
                      where a.Customer__c =: accountId order by a.CreatedDate ];
    	*/
  
        ViewAccount= [Select a.Id, a.Name, a.Anlaeg_No__c,a.Customer_No__c,a.phone,
                      a.type,a.Dealer_Number__c,a.isPersonAccount,a.Debitor_Number__c,a.DealerGroup__c,
                      a.Category__c, a.sales_consultant__c,a.Basis__c,a.POS__c,a.Afregnes__c, 
                      a.DealerProducts__c,a.selectedProduct__c,a.Email__c ,
                      a.Fax,
                      a.Street_YK__r.name,
                      a.address_value__c,
                      a.Street_YK__r.Postcode__c,
                      a.Street_YK__r.Town__c 
                      From Account a 
                      where a.Id =: accountId order by a.CreatedDate];
   
       this.acc = (Account)controller.getRecord(); 
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
        items.add(new SelectOption('none','--None--    '));  
        for(LookupMaster__c rt: [select id,name from LookupMaster__c where RecordType__C= 'Dealer Group' order by Order_sequence__c]) {      
                            items.add(new SelectOption(rt.name,rt.name));
              
        } 
        return items;
    }

    public List<SelectOption> getDealerCategoryItems() { 
        List<SelectOption> items = new List<SelectOption>(); 
        items.add(new SelectOption('none','--None--    '));  

        for(LookupMaster__c rt: [select id,name from LookupMaster__c where RecordType__C= 'Dealer Kategori' order by Order_sequence__c] ) {      
            items.add(new SelectOption(rt.name,rt.name));  
        } 
        return items;
    }  

    public List<SelectOption> getSalesConsultantItems() { 
        List<SelectOption> items = new List<SelectOption>(); 
        items.add(new SelectOption('none','--None--    '));  
        for(LookupMaster__c rt: [select id,name from LookupMaster__c where RecordType__C= 'Sales Consultants' order by Order_sequence__c]) {      
            items.add(new SelectOption(rt.name,rt.name));  
        } 
        return items;
    }
 
   
  public PageReference cancel(){
        return page.ForhandlerCustomer;  
  }
  
  //reading account data  for record type forhandler
  public PageReference save(){
    
    String strProducts = ViewAccount.DealerProducts__c;
    string result=   strProducts.substring(1, strProducts.length()-1);
    ViewAccount.DealerProducts__c = result;
    if(isValid()){
        try{
            updateAccount();
           /* if(ViewManager != null){
                 upsert ViewManager;
            }
            updateAmbassador();
            */
        }catch (System.DmlException   e) {
            system.debug(e.getMessage()); 
         }
         return page.ForhandlerCustomer;
    }
    else{
        return null;
    }
  }
/*
private void updateAmbassador(){
if(ViewAmbassadorList.size() > 0){
        for(integer cntCount =0; cntCount < ViewAmbassadorList.size() ; cntCount++){
            ViewAmbassadorList[cntCount].accountId = accountId; 
        }
    
     AmbRoleId =[select id from Lookup_Contact_Roles__c where name= 'Dealer Ambassador']; 
     List<Database.upsertResult> uResults = Database.upsert(ViewAmbassadorList,false);
     Set <id> ids = new Set <id>();

    for(Database.upsertResult result : uResults ) {
         System.assert(result.isSuccess());
         ids.add(result.getId());
      }
    
   Set <id> ContactSet = new Set<id>() ;
   Set <id> ContactNotSet = new Set<id>() ;
   for(ID acr : contactAmbassadorID){
       if (ids.contains(acr)){
            Contactset.add(acr)  ;   
        }    
        else{
            ContactNotSet.add(acr) ; 
         }
               
    } 
    ids.removeAll(Contactset);
   
    for(ID newId : ids){
        Account_Contact_Role__C ACRole = new Account_Contact_Role__C();
        ACRole.Customer__c = accountId;
        ACRole.Contact__c = newId;
        ACRole.Role__c = AmbRoleId[0].id;
        ACRList.add(ACRole);
    }
    insert ACRList;
   }
}
*/
private void updateAccount(){
   
     this.acc = [select id from account where id =: accountId ];
     this.acc.name = ViewAccount.name;
     this.acc.Anlaeg_No__c =  ViewAccount.Anlaeg_No__c;
     this.acc.Customer_No__c = ViewAccount.Customer_No__c;
     this.acc.phone = ViewAccount.phone;
     this.acc.Dealer_Number__c= ViewAccount.Dealer_Number__c;
     this.acc.Debitor_Number__c= ViewAccount.Debitor_Number__c;
     this.acc.DealerGroup__c =  ViewAccount.DealerGroup__c;
     this.acc.Category__c = ViewAccount.Category__c;
     this.acc.sales_consultant__c = ViewAccount.sales_consultant__c ;
     this.acc.Basis__c = ViewAccount.Basis__c ;
     this.acc.POS__c = ViewAccount.POS__c ;
     this.acc.Afregnes__c = ViewAccount.Afregnes__c; 
     this.acc.DealerProducts__c = ViewAccount.DealerProducts__c;
     this.acc.selectedProduct__c = ViewAccount.DealerProducts__c;
     this.acc.Email__c = ViewAccount.Email__c;
     this.acc.Fax = ViewAccount.Fax ;
     this.acc.Street_YK__c = ViewAccount.Street_YK__c;
     update this.acc ;
     
}
 
 private Boolean isValid()
 {
    Boolean flag=true;
    ApexPages.Message myMsg;
    integer j;
    
    //For dealer product and group
     if(ViewAccount.DealerGroup__c.length() == 0 || ViewAccount.DealerGroup__c == 'none'){
         myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Select Dealer Group');
            ApexPages.addMessage(myMsg);
            flag= false;
    }
    
    if(ViewAccount.DealerProducts__c.length() == 0 || ViewAccount.DealerProducts__c == null){
         myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Select Dealer Product');
            ApexPages.addMessage(myMsg);
            flag= false;
    }
    /*
    //for manager contact
    if(ViewManager != null){
        
        
        if( ViewManager.LastName.length() == 0 ){
            myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Enter Manager Name');
            ApexPages.addMessage(myMsg);
            flag= false;
        }
     if( ViewManager.Email.length() == 0 ){
               myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Enter Manager Email');
            ApexPages.addMessage(myMsg);
            flag= false;

        }
     if( ViewManager.Phone.length() == 0 ){
            myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Enter Manager Phone');
            ApexPages.addMessage(myMsg);
            flag= false;
            
        }

    }

  //for ambassador contact
  if(ViewAmbassadorList.size()>0){
    for(integer i =0 ; i < ViewAmbassadorList.size() ; i++){
        j = i+ 1;
            if(ViewAmbassadorList[i].LastName.length() == 0 ){
              string str = 'Enter Ambassador ' + j +' Name';
            myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,str);
            ApexPages.addMessage(myMsg);
            flag= false;
        }
     if( ViewAmbassadorList[i].Email.length() == 0 ){
            string strEmail = 'Enter Ambassador ' + j +' Email';
               myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,strEmail);
            ApexPages.addMessage(myMsg);
            flag= false;

        }
     if( ViewAmbassadorList[i].Phone.length() == 0 ){
            string strPhone = 'Enter Ambassador ' + j +' Phone';
            myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,strPhone);
            ApexPages.addMessage(myMsg);
            flag= false;
            
        }   
    }
  
  }
  */

return flag;
}   
   
}