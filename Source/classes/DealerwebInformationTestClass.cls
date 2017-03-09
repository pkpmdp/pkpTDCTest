/*Test method for page Front Page,Hjælp og support,Spærrede kunder,Nyttig info*/

@isTest
private class DealerwebInformationTestClass {
    
    public static User u;
    static Pagereference pr;
                
    static testMethod void testDealerwebInformation() {
    
    RecordType rt1 = [select id,name from recordtype where sobjecttype='Contact' and name='YS Contact layout'];
    YSRecordTypes__c ysRecordType = new YSRecordTypes__c();
    ysRecordType.name = 'YSRecordTypes';
    ysRecordType.YS_Contact_Record_Type__c = rt1.Id;
    insert ysRecordType;
    
    
 Address__c addr = new Address__c();                                     
        addr.Town__c = 'AH'; 
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        //Commented for DW-720: Side__c is going to be deleted from SFDC
        //addr.Side__c = 'A';
        addr.Floor__c ='Third';
        addr.House_No__c = 'test';
        addr.Street__c = 'AH';    
        addr.Entrance__c = 'A';
        insert addr; 
        
        RecordType rt = [select id,name from recordtype where sobjecttype='Account' and name='Forhandlerweb'];
        Account acc = new Account();
        acc.Name ='Tapanm4572';
        acc.Dealer_Number__c ='T9885'; 
        acc.Debitor_Number__c='1234567890';
        acc.DealerGroup__c='Telebutik';
        acc.Street_YK__c = addr.Id;
        acc.Phone = '2232231234';
        acc.Email__c = 'tapan4.mahapatra@test191.com';
        acc.DealerProducts__c ='Digitalt kabel-tv; YouSee Telefoni';
        acc.RecordTypeId = rt.id;
        insert acc;
        
        Address__c add = new Address__c();
        add.Active__c= true;
        add.District__c ='test';
        add.Door_No__c ='123';
        add.Entrance__c = 'ABC';
        add.Floor__c = '4';
        add.House_No__c ='34';
        add.Name = 'Ram Chokkam';
        add.Town__c = 'ABS';
        add.Postcode__c = '4000076';
        insert add;
        
        Folder fd = [select id,name from folder where name = 'ForhandlerWeb Documents'];
        Document dd= new Document();
        dd.Name='Attched file';
        dd.FolderId=fd.Id;
        dd.Description ='hi';
        dd.Type='jpg';
       // dd.CreatedById='12345';
        dd.ContentType='jpg';
        dd.DeveloperName ='sheetal';
        //dd.Id='01520000000aCiOAAU';
        insert dd;
        Id [] fixedSearchResults= new Id[] {dd.id}; 

     Test.setFixedSearchResults(fixedSearchResults); 
        
        Contact cont =[select id from Contact where accountId=:acc.Id];
        System.debug('cont @@ - '+ cont);
        u = [select id from User where contactId =: cont.Id];
        System.debug('user u @@ - '+u);
        
        Test.startTest();
        System.runAs(u) {         
        //PageReference pageRef = Page.DealerwebInformationController;
        //Test.setCurrentPage(pageRef);
        nyttigInfoPage();
        BlacklistedCustomersPage();
        HelpSupportPage();
        FrontPage();
                                                            
          DealerwebInformationController infoController1 = new DealerwebInformationController();
          infoController1.loggedInUser = u;
          infoController1.newpwd ='6yy17';
          infoController1.changePassword();
          infoController1.pwdChangeAction();
          infoController1.backToHomePage();
          //Added for CR DW-481 SearchReceipt functionality
          infoController1.fromdate = '01.08.2011';
          infoController1.toDate = '01.12.2011';
          infoController1.searchAllReciepts();
          infoController1.SearchDocumentText = 'abcd';
          infoController1.searchAllReciepts();
          infoController1.fromdate = '';
          infoController1.toDate = '';
          infoController1.SearchDocumentText = 'abcd';
          infoController1.searchAllReciepts();
          infoController1.redirectTOVaremodtagelsePage();
          infoController1.getProductDescription();
          Test.stoptest();  
      }            
    
                                           
    }
         public static void nyttigInfoPage(){
         PageReference pageRef = Page.NyttigInfoPage;
         Test.setCurrentPage(pageRef);
         Apexpages.currentpage().getparameters().put('pageType','NyttigInfo');
         DealerwebInformationController controller = new DealerwebInformationController();

    } 
         public static void BlacklistedCustomersPage(){
         PageReference pageRef = Page.BlacklistedCustomersPage;
         Test.setCurrentPage(pageRef);
         Apexpages.currentpage().getparameters().put('pageType','BlacklistedCustomers');
         DealerwebInformationController controller = new DealerwebInformationController();
                  
    } 
         public static void HelpSupportPage(){
         PageReference pageRef = Page.HelpSupportPage;
         Test.setCurrentPage(pageRef);
         Apexpages.currentpage().getparameters().put('pageType','HelpSupport');
         Apexpages.currentpage().getparameters().put('groupInfo','Kvitteringsarkiv');
         DealerwebInformationController controller1 = new DealerwebInformationController();
                                       
    } 
         public static void FrontPage(){
         PageReference pageRef = Page.forhandlerHomePage;
         Test.setCurrentPage(pageRef);
         DealerwebInformationController controller1 = new DealerwebInformationController();                  
    }
                  
       
       }