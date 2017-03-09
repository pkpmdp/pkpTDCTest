public class customerExtenstion {
  public List<Account> accList { get; set; }
  public string basis_value { get; set;}
  public static ID accountId;
  public List<excelWrapperClass> listExcelData = new List<excelWrapperClass>();
  public boolean TESTMODE = false;
  
   public  List<excelWrapperClass> ExcelList {
             get {return listExcelData ;}
             set {listExcelData = value;}
          }
   
  public List<Account_Contact_Role__c> ViewACRList {get;set;}
  public  List<Contact> contactList = new List<Contact>();
  
  public customerExtenstion(ApexPages.StandardController controller) {
  
      if(ApexPages.CurrentPage().getParameters().get('DeleteFlag') == 'True'){
          
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'Dealer has been deleted');
        ApexPages.addMessage(myMsg);
        
      }

        accList =[select id, name,Anlaeg_No__c,Customer_No__c,phone,type,Dealer_Number__c,
                   Debitor_Number__c,DealerGroup__c, Category__c, sales_consultant__c,selectedProduct__c, IsPersonAccount,
                   Basis__c,POS__c, Afregnes__c, DealerProducts__c,Dealer_Products__r.name,basis_value__c,POS_value__c,
                  Street_YK__r.Name, address_value__c,
                  Street_YK__r.Postcode__c,
                  Street_YK__r.Town__c
                  from Account where RecordTypeName__c='Forhandlerweb' and Active__c != false];
                 excelData();

  }
  
   
  public PageReference newDealer(){
       return page.DealerCreationPage;  
  }
  
  public PageReference exportToExcel() {
       PageReference excelPage;  
      // excelPage= Page.ExportAccountToExcel; 
    //  excelPage = Page.exportaccounttoexcel;
    excelPage = Page.DealerCreationExcelPage;
       return excelPage;
    }
    
    
  public class excelWrapperClass{
      
      public Account excelAccount {get;set;}
      public Account_Contact_Role__c excelManager {get;set;}
      public Account_Contact_Role__c excelAmbassador1 {get;set;}
      public Account_Contact_Role__c excelAmbassador2 {get;set;}
      public Account_Contact_Role__c excelAmbassador3 {get;set;}
      public Account_Contact_Role__c excelAmbassador4 {get;set;}
      public Account_Contact_Role__c excelAmbassador5 {get;set;}
      public Account_Contact_Role__c excelAmbassador6 {get;set;}
      public Account_Contact_Role__c excelAmbassador7 {get;set;}
     
  }
  
  
private void excelData(){
Integer acrCount;
	for(Account account : accList){
    
      acrCount = 0;
      excelWrapperClass excelExportData = new excelWrapperClass();
      excelExportData.excelAccount = account;
       
      /* ViewACRList=  [select  a.Role__r.Name,a.Contact__r.Id, a.Contact__r.Name,a.Contact__r.Email,
        a.Contact__r.Phone, a.Contact__r.street_p__r.name,a.contact__r.house_address__c,a.contact__r.Post_Code_P__c,a.Contact__r.Town_P__c
       From Account_Contact_Role__c a where a.Customer__c =: account.Id order by a.CreatedDate ];
      */ 
         /*    
       for(Account_Contact_Role__c ACR : ViewACRList ){
       
        if (ACR.Role__r.Name == 'Dealer Manager' ){
              
              excelExportData.excelManager = ACR;
               
            }
            else if (ACR.Role__r.Name == 'Dealer Ambassador' ){
                acrCount = acrCount + 1;
                if(acrCount == 1){
                    excelExportData.excelAmbassador1 = ACR;
                }
                if(acrCount == 2){
                    excelExportData.excelAmbassador2 = ACR;
                }
                if(acrCount == 3){
                    excelExportData.excelAmbassador3 = ACR;
                }
                if(acrCount == 4){
                    excelExportData.excelAmbassador4 = ACR;
                }
                if(acrCount == 5){
                    excelExportData.excelAmbassador5 = ACR;
                }
                if(acrCount == 6){
                    excelExportData.excelAmbassador6 = ACR;
                }
                if(acrCount == 7){
                    excelExportData.excelAmbassador7 = ACR;
                }

            }
            
       }
       */
    listExcelData.add(excelExportData);   
  }
 }
    
    
     
  //reading account data  for record type forhandler
  public void  getAccountData(){
     
  
  }
  public PageReference deleteAccount(){
     
      accountId= ApexPages.CurrentPage().getParameters().get('accountId');
    
      List<Contact> listContact = new List<Contact> ();
      listContact  = [Select c.Id  From Contact c where c.accountId =: accountId]; 
      List<User> listUser = new List<User>();
   
      if(listContact.size() > 0){
          for(Contact userContact : listContact){
              User[] newuser = [Select u.Id  From User u where u.contactId =: userContact.Id];
          if(newuser.size()> 0){
                newuser[0].isActive = false;
               // newuser[0].IsPortalEnabled = false;
            listUser.add(newuser[0]);
          }
         if(listUser.size() > 0){
              //update listUser;   
                List<Database.saveResult> uResults = Database.update(listUser,false);
               integer i=0;

                for(Database.saveResult result : uResults ) {
                        if(result.isSuccess())
                            {
                                i=i+1;
                            }
                      }
                if(i >= 1 )
                    {
                        System.debug('updated user');
                        deleteACR(accountId);
                        deleteContact(accountId);
                        deleteAccount(accountId);
                    }             
             }
          }
          
         List<excelWrapperClass> cloneList = new List<excelWrapperClass>();
         for(excelWrapperClass obj : listExcelData)
         {
            if(string.valueof(obj.excelAccount.id)!=accountId)
             cloneList.add(obj);
         }
         listExcelData.clear();
         listExcelData.addall(cloneList);
     }

  
  PageReference pageRef = ApexPages.currentPage();
  pageRef.getParameters().put('DeleteFlag','True');
 // pageRef.setRedirect(true);
  return pageRef;
  }
  
  
  private static void deleteACR(ID currentAccID){
  	  
  	  List<Account_Contact_Role__c> acrDelList = [Select id, Contact__c, Customer__c from Account_Contact_Role__c acr where 
                         acr.Customer__c =: currentAccID];
      if(acrDelList.size() > 0 ){
         delete acrDelList;             
      }
      
  }
 
   
  @future
  private static void deleteContact(ID currentAccID){
    
    List<Contact> listContacts = new List<Contact>();
    listContacts  = [Select c.Id  From Contact c where c.accountId =: currentAccID]; 
    if(listContacts.size() > 0){
    //    delete listContacts;
    }
  }
   
  @future
  private static void deleteAccount(ID currentAccID){
    
     Account[] account = [Select a.Id  From Account a where a.Id =: currentAccID];
      if(account.size() > 0){
    //  delete account ;  
      } 
  }
  
}