@IsTest

private class ExchangeInShopControllerTestClass {
public static User u; 
    static testMethod void testDealerExchangeInShopflow() {
    
 Address__c addr = new Address__c();                                     
        addr.Town__c = 'AH'; 
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        addr.Side__c = 'A';
        addr.Floor__c ='Third';
        addr.House_No__c = 'test';
        addr.Street__c = 'AH';    
        addr.Entrance__c = 'A';
        insert addr; 
        
        RecordType rt = [select id,name from recordtype where sobjecttype='Account' and name='Forhandlerweb'];
        Account acc = new Account();
        acc.Name ='test12';
        acc.Dealer_Number__c ='T7006';   
        acc.Street_YK__c = addr.Id;
        acc.Phone = '223223';
        acc.Email__c = 'abc@xyz.com';
        acc.DealerProducts__c ='YouSee Clear;YouSee Telefoni';
        acc.DealerGroup__c = 'Fona';
        acc.RecordTypeId = rt.Id;
        insert acc;     
        
        Address__c add = new Address__c();
        add.Active__c= true;
        add.District__c ='test';
        add.Door_No__c ='123';
        add.Entrance__c = 'ABC';
        add.Floor__c = '4';
        add.House_No__c ='34';
        add.Name = 'pooja Agicha';
        add.Town__c = 'ABS';
        add.Postcode__c = '4000076';
        
        insert add;
        
        Contact cont =[select id from Contact where accountId=:acc.Id];
		System.debug('cont @@ - '+ cont);
		u = [select id from User where contactId =: cont.Id];
		System.debug('user u @@ - '+u);
        
        System.runAs(u) {  
        Test.startTest();
        PageReference pageRef = Page.DealerExchangeInShopSearchPage;
     Test.setCurrentPage(pageRef);
        string ErrorMessage = 'Ifølge YouSees system er der ingen ombytningsordre på dette serienr. Det kan skyldes følgende årsager:';
                    ErrorMessage = ErrorMessage + ' Kunden har ikke fejlmeldt boksen hos YouSee Support. Det skal kunden selv gøre først. \n';
                    ErrorMessage = ErrorMessage +' Serienummeret er indtastet forkert – prøv igen. \n';
                    ErrorMessage = ErrorMessage + ' Kunden har flere bokse og har medbragt den forkerte. \n';
                    ErrorMessage = ErrorMessage + ' Har du spørgsmål, så kontakt venligst YouSee  Forhandlersupport på 70 13 37 00 ';
        DealerExchangeInShop controller = new DealerExchangeInShop();
        DealerExchangeInShop.FORCE_TEST_MODE = true;
        controller.testMode =  true; 
        controller.SerialNo = '838301228900';
        controller.error='';
        
               
        controller.response = '{"logistik":{"links":[{"rel":"ombytning","mediatype":"application/vnd.yousee.kasia2.logistik+json;version=1;charset=UTF-8","href":"http://preprod-kasia.yousee.dk/logistik/ombytning"}],"ombytning-godkendt":true,"varenavn":"YouSee Kort","varenummer":"1213007","type":3,"lokation":"600725844","status":"DISPONIBEL","serienummer":"317001281320"},"responsecode":"200","responsemessage":"OK","ETag":"2142747879"}';
        // controller.SearchSerialNO();
        controller.damageComment = 'Damaged commnets will go here';
        controller.newSerialNo = '009988776655';                
        controller.getCCustInstAdd();       
        controller.setAgentNumber('T7006');
        controller.getAgentNumber();
        controller.GettextAreaDetails();
        controller.getToptextArea1();
        controller.getToptextArea2();
        controller.getToptextArea3();
        controller.getToptextArea4();
        controller.getAddress1();
        controller.getAddress2();
        controller.getExchangeDate();
        controller.DisPBoxCondParam = true;
        controller.DisplayNewSerialNumber = true;
        controller.Nextresponse = '400';
        controller.ExchangeOrderFound = true;
        controller.rel = 'ombytning';                             
        controller.error='';
        controller.location ='T1234';       
        controller.response = '{"logistik":{"links":[{"rel":"ombytning","mediatype":"application/vnd.yousee.kasia2.logistik+json;version=1;charset=UTF-8","href":"http://preprod-kasia.yousee.dk/logistik/ombytning"}],"ombytning-godkendt":false,"varenavn":"YouSee Kort","varenummer":"1213007","type":3,"lokation":"T1234","status":"DISPONIBEL","serienummer":"317001281320"},"responsecode":"200","responsemessage":"OK","ETag":"2142747879"}';   
        controller.SearchSerialNumber();
      
        
            
       controller.location = '123456';
               
        controller.response = '{"logistik":{"links":[{"rel":"ombytning","mediatype":"application/vnd.yousee.kasia2.logistik+json;version=1;charset=UTF-8","href":"http://preprod-kasia.yousee.dk/logistik/ombytning"}],"ombytning-godkendt":false,"varenavn":"YouSee Kort","varenummer":"1213007","type":3,"lokation":"123456","status":"DISPONIBEL","serienummer":"317001281320"},"responsecode":"200","responsemessage":"OK","ETag":"2142747879"}';
        DealerExchangeInShop.cCustomerInstallationAddress caddr= new DealerExchangeInShop.cCustomerInstallationAddress();        
        caddr.addr = add;
        caddr.email ='poooja.agicha@capgemini.com';
        caddr.getAddr1();
        caddr.getAddr2();
        caddr.lastName ='Chawla';
        caddr.mobilePhone = '9004664447';
        caddr.Name = 'Pooja Chawla';        
        controller.response = '{"logistik":{"links":[{"rel":"ombytning","mediatype":"application/vnd.yousee.kasia2.logistik+json;version=1;charset=UTF-8","href":"http://preprod-kasia.yousee.dk/logistik/ombytning"}],"ombytning-godkendt":false,"varenavn":"YouSee Kort","varenummer":"1213007","type":3,"lokation":"T9755","status":"DISPONIBEL","serienummer":"317001281320"},"responsecode":"200","responsemessage":"OK","ETag":"2142747879"}';
        controller.renderCommentTextBox();        
        controller.fetchCustomerInformation();
        controller.body = Blob.ValueOf('test data');
        //
   //      u = [Select ISActive, u.Profile.Name, u.ProfileId, u.Name, u.Id From User u where Profile.Name ='YouSee Customer Portal User' and IsActive=true limit 1];          
     //   System.runAs(u){
            controller.Next();
        //}
        controller.Approve();
        controller.CreatePDFDoc(); // Test methods do not support getContent method call.
        controller.BacktoApprovalPage();
        controller.BacktoSearchResultPage();
        controller.BacktoSearchpage();
        
         controller.response = '';      
        controller.location = 'T7006';
        
            //controller.error='Error';
            //controller.Approved=true; 
            controller.rel='indlevering';
            controller.error='Box is with Distributor';
            controller.ExchangeOrderFound= true;
             controller.SearchSerialNO();
             
            //system.assertEquals('Kan ikke bytte hardware med status Transit. Husk at varemodtage',controller.error);
            
            controller.error='';
        controller.ReserveSRNumber();
        controller.redirectToCustomerReceiptPage();
      //    controller.forhandlerInformationWrapper wrap = new controller.forhandlerInformationWrapper ();
      //    wrap.Pageno='';
     //     system.assertEquals('Kan ikke bytte hardware med status Transit. Husk at varemodtage',controller.error);
            Test.stoptest();    
         
        }            
                                              
    }
}