/*Test method for Manual Form and manual ordering doc*/

@isTest

private class ManualFormsAndOrdersTestClass {
    
    public static ManualOrderingDocument__c[] listOrderingDocument; 
    static ManualFormsController manualFormsController = new ManualFormsController();
    
    public static testmethod void test() {
        Test.startTest();
        manualFormsController.getDocList();
        manualFormsController.redirectToPreviewURL();
        manualFormsController.redirectURL();
        manualOrderingDoc();
        Test.stopTest();
    }

    static testMethod void testManualDocController(){
        ManualOrderingDocController docObject = new ManualOrderingDocController();
        docObject.isApexTest = true;
        String name = docObject.dealerName;
        String dnumber = docObject.dealerNumber;
        docObject.setDocumentURL('testUrl');        
    }
     
    public static void manualOrderingDoc(){
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
        
        String accountId = null;
        PageReference pageRef = Page.ManualOrdersPage;
        Test.setCurrentPage(pageRef);
        //setTelefoniData();
        RecordType rt = [select id,name from recordtype where sobjecttype='Account' and name='Forhandlerweb'];
        Account acc = new Account(name='T000',phone='80000',Dealer_Number__c='T000',Debitor_Number__c='T000',Email__c='testmethod@sfdc.com',
        DealerGroup__c='Blaa Gruppe',Category__c='C',sales_consultant__c='CUL',POS__c=true,
        Afregnes__c='Forhandler',DealerProducts__c='Digitalt kabel-tv;YouSee Clear (kabel-tv)',recordTypeId=rt.id, Street_YK__c=addr.id);
        acc.recordTypeId = rt.Id;
        accountId = acc.id;//acc.recordTypeId;
        insert acc;
        system.debug('+++++++++++++++----' +accountId);
        
        Contact contact = new Contact(firstname='Ram', MobilePhone='323232', LastName='Chokkam',Street_P__c=addr.id);
        contact.AccountId=accountId;
        insert contact;
        
        setDigitalData();
        updateDigitalData();
        deleteDigitalData();
        //setEkstrakanalerData();
        //setlejeboksData();
        //setTelefoniData();
        //setPlusData();
        setOfferData('YouSee Ekstrakanaler');
        setOfferData('YouSee lejeboks');
        setOfferData('YouSee Telefoni');
        setOfferData('YouSee Plus');
        setOfferData('YouSee Bredbånd');

        LookupMaster__c manualDoc = new LookupMaster__c();
        manualDoc = [Select m.Name,m.Id From LookupMaster__c m where m.recordType__c=: 'Manual Order Document' and m.Name ='YouSee Clear']; 
        
        ManualOrderingDocument__c orderData = new ManualOrderingDocument__c(
        Description__c ='Test Class',
        FieldType__c ='CheckBox',
        FieldValue__c = '',
        Required__c = false,
        Font__c = 'Times New Roman',
        Font_Color__c ='Green',
        FontStyle__c = 'Bold',
        Font_Size__c = '14',
        //   Name ='A0012',
        SequenceNumber__c =3.0,
        ManualOrderDocument__c = manualDoc.Id );
        insert orderData;
        
        ManualOrderingDocController manualOrderingDocController = new ManualOrderingDocController();
        manualOrderingDocController.isApexTest = true;
        manualOrderingDocController.getCustomOrderingList();
        commonclass objCommon = new commonclass();
        objCommon.userContact = contact;
        objCommon.dealerAccount = acc;
        manualOrderingDocController.objCommon = objCommon;
        
        manualOrderingDocController.getDocumentURL();
        manualOrderingDocController.getManualDocument();
        manualOrderingDocController.savePdf();
        manualOrderingDocController.print();
        manualOrderingDocController.back();
        manualOrderingDocController.getLongDate();
        manualOrderingDocController.sendMail();
        manualOrderingDocController.sendUserMailAttachPdf();
        
        
      }

        //digital kabel tv data
        private static void setDigitalData(){
        LookupMaster__c manualDoc = new LookupMaster__c();
        manualDoc = [Select m.Name,m.Id From LookupMaster__c m where m.recordType__c=: 'Manual Order Document' and m.Name ='YouSee Clear']; 
                
        ManualOrderingDocument__c orderData = new ManualOrderingDocument__c(
        Description__c ='Test Class',
        FieldType__c ='Text',
        Required__c = false,
        Font__c = 'Times New Roman',
        Font_Color__c ='Green',
        FontStyle__c = 'Bold',
        Font_Size__c = '14',
        //   Name ='A0012',
        SequenceNumber__c =3.0,
        ManualOrderDocument__c = manualDoc.Id );
        insert orderData;
        
        ManualOrderingDocument__c orderData1 = new ManualOrderingDocument__c(
        Description__c ='Test Class',
        FieldType__c ='RadioButton',
        Required__c = false,
        Font__c = 'Times New Roman',
        Font_Color__c ='Green',
        FontStyle__c = 'Bold',
        Font_Size__c = '14',
        //   Name ='A0013',
        SequenceNumber__c =4.0,
        ManualOrderDocument__c = manualDoc.Id );
        
        insert orderData1;
        commonClass.isRecursiveTrigger = false;
        update orderData1;
        Apexpages.currentpage().getparameters().put('docType', manualDoc.Id);
        Apexpages.currentpage().getparameters().put('docTypeText' , 'YouSee Clear');
        ManualOrderingDocController controller = new ManualOrderingDocController();
    }

        private static void updateDigitalData(){
        LookupMaster__c manualDoc = new LookupMaster__c();
        manualDoc = [Select m.Name,m.Id From LookupMaster__c m where m.recordType__c=: 'Manual Order Document' and m.Name ='YouSee Clear']; 
        
        ManualOrderingDocument__c orderData = new ManualOrderingDocument__c(
        Description__c ='Test Class',
        FieldType__c ='Text',
        Required__c = false,
        Font__c = 'Times New Roman',
        Font_Color__c ='Green',
        FontStyle__c = 'Bold',
        Font_Size__c = '14',
        //   Name ='A0012',
        SequenceNumber__c =3.0,
        ManualOrderDocument__c = manualDoc.Id );
        insert orderData;
        
        ManualOrderingDocument__c orderData1 = new ManualOrderingDocument__c(
        Description__c ='Test Class',
        FieldType__c ='RadioButton',
        Required__c = false,
        Font__c = 'Times New Roman',
        Font_Color__c ='Green',
        FontStyle__c = 'Bold',
        Font_Size__c = '14',
        //   Name ='A0013',
        SequenceNumber__c =4.0,
        ManualOrderDocument__c = manualDoc.Id );
        
        insert orderData1;
        commonClass.isRecursiveTrigger = false;
        orderData1.Font_Size__c = '18';
        update orderData1;
        Apexpages.currentpage().getparameters().put('docType', manualDoc.Id);
        Apexpages.currentpage().getparameters().put('docTypeText' , 'YouSee Clear');
    }

        private static void deleteDigitalData(){
        LookupMaster__c manualDoc = new LookupMaster__c();
        manualDoc = [Select m.Name,m.Id From LookupMaster__c m where m.recordType__c=: 'Manual Order Document' and m.Name ='YouSee Clear']; 
        
        ManualOrderingDocument__c orderData = new ManualOrderingDocument__c(
        Description__c ='Test Class',
        FieldType__c ='Text',
        Required__c = false,
        Font__c = 'Times New Roman',
        Font_Color__c ='Green',
        FontStyle__c = 'Bold',
        Font_Size__c = '14',
        //   Name ='A0012',
        SequenceNumber__c =3.0,
        ManualOrderDocument__c = manualDoc.Id );
        insert orderData;
        
        ManualOrderingDocument__c orderData1 = new ManualOrderingDocument__c(
        Description__c ='Test Class',
        FieldType__c ='RadioButton',
        Required__c = false,
        Font__c = 'Times New Roman',
        Font_Color__c ='Green',
        FontStyle__c = 'Bold',
        Font_Size__c = '14',
        //   Name ='A0013',
        SequenceNumber__c =4.0,
        ManualOrderDocument__c = manualDoc.Id );
        
        insert orderData1;
        commonClass.isRecursiveTrigger = false;
        delete orderData1;
        Apexpages.currentpage().getparameters().put('docType', manualDoc.Id);
        Apexpages.currentpage().getparameters().put('docTypeText' , 'YouSee Clear');
    }
    
        // Generic method started
        private static void setOfferData(String offer){        
        LookupMaster__c manualDoc = new LookupMaster__c();
        System.Debug('Error in inputOffer--->'+ offer);
        //String inputOffer = String.valueOf(offer);
        String inputOffer = (String) offer;
        System.Debug('Error in inputOffer--->'+ inputOffer);
        manualDoc = [Select m.Name,m.Id From LookupMaster__c m where m.recordType__c=: 'Manual Order Document' and m.Name = : inputOffer];
        System.Debug('Error in inputOffer--->'+ inputOffer);
        
        ManualOrderingDocument__c orderData = new ManualOrderingDocument__c(
        Description__c ='Test Class',
        FieldType__c ='Text',
        Required__c = false,
        Font__c = 'Times New Roman',
        Font_Color__c ='Green',
        FontStyle__c = 'Bold',
        Font_Size__c = '14',
        //   Name ='A0012',
        SequenceNumber__c =3.0,
        ManualOrderDocument__c = manualDoc.Id );
        insert orderData;
        
        ManualOrderingDocument__c orderData1 = new ManualOrderingDocument__c(
        Description__c ='Test Class',
        FieldType__c ='RadioButton',
        Required__c = false,
        Font__c = 'Times New Roman',
        Font_Color__c ='Green',
        FontStyle__c = 'Bold',
        Font_Size__c = '14',
        //   Name ='A0013',
        SequenceNumber__c =4.0,
        ManualOrderDocument__c = manualDoc.Id );
        
        insert orderData1;
        commonClass.isRecursiveTrigger = false;
        update orderData1;
        Apexpages.currentpage().getparameters().put('docType', manualDoc.Id);
        Apexpages.currentpage().getparameters().put('docTypeText' , inputOffer );
        ManualOrderingDocController controller1 = new ManualOrderingDocController();
    }
    
 }