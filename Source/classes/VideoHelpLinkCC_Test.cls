/**
    * @description: This is the test class for VideoHelpLinkCC
    */
    
    @isTest
    private class VideoHelpLinkCC_Test{
    
        public static Account insertCustomer(){
            Account account = new Account(); 
            RecordType recordType = [Select r.Name, r.Id From RecordType r where r.Name = 'YK Customer Account'];  
            account = new Account();                     
            account.RecordTypeId =recordType.Id;
            account.Status_YK__c = 'Active';
            account.FirstName = 'Test'; 
            account.LastName = 'Test';
            account.Invoice_Test__c = true;
            account.Customer_response__c = 'Neutral omkring ændring';
            account.Customer_No__c='981929'; 
            account.PersonMobilePhone = '4569871235';
            account.PersonEmail= 'test@etst.com';
            insert account;
            return account;
        }
        public static Video_Message__c insertVidMessage(){
            Video_Message__c vm = new Video_Message__c();
            vm.Headline_on_video__c = 'test Headline_on_video__c';
            vm.Help_Tips__c = 'help tip';
            vm.Message_Id__c = '23633';
            vm.Sales_Events__c = 'After';
            insert vm;
            return vm;
            
        }
        //test method videoHelpLinkTest
         static testmethod void videoHelpLinkTest(){
         
             insert new CustomerNumberSeq__c(lastNumber__c = 64999998);
             insert new Actimo_CS__c(Value__c='https://actimo.com/api/v1/integrations/iframe/send-message', Name ='Actimo_Base_URL');
             // insert account record
             Account acc = insertCustomer();
             //insert videomessage record
             Video_Message__c vm = insertVidMessage();
             
             //initialize page
             PageReference pageRef = Page.VideoHelpLinks;
             Test.setCurrentPage(pageRef);
             ApexPages.currentPage().getParameters().put('accId', acc.id);
             
             //initialize constructor
             VideoHelpLinkCC construc = new VideoHelpLinkCC();
             construc.getMessageOptions();
             
             construc.salesSelection = 'After';
             list <Video_Message__c > vmList = construc.getVMList();
             system.assertEquals(vmList[0].Help_Tips__c  , vm.Help_Tips__c);
             construc.generateURL();
             construc.resetShowFrame();
        }
}