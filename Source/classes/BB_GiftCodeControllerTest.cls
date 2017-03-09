@isTest
private class BB_GiftCodeControllerTest {

     static testMethod void testSendGifts(){ 
        Address__c add = new Address__c(Street__c = 'Main Street', 
            Town__c = 'Leeds', Postcode__c = 'LS1');
        insert add;
         CustomerNumberSeq__c cust = new CustomerNumberSeq__c();
        cust.lastNumber__c = 64444444;
        insert cust;
        Account acc = new Account(FirstName = 'Robert', LastName = 'John', Street_YK__c = add.Id, 
            Customer_No__c = '4444',
            PersonEmail = 'jozef.huba@bitlayer.com',
            PersonMobilePhone = '+4521730891');     
        insert acc;
       /* CustomerNumberSeq__c cust = new CustomerNumberSeq__c();
        cust.lastNumber__c = 4444;
        insert cust; */
        Gift_Code__c gift = new Gift_Code__c();
        gift.Batch_Number__c= '0000'; 
        gift.Code__c = '0004'; 
        gift.Valid_From__c = System.today();
        gift.Valid_To__c =  System.today().addDays(5);     
       // gift.Status__c = BB_GiftCodeController.ACTIVE;
        gift.Status__c = 'Active';
         gift.Code_Formatted__c = '0004';
        insert gift;
         
        GiftCodeList gift2 = new GiftCodeList();
         gift2.giftCodeId = gift.id;
         gift2.getCodes();
        gift = new Gift_Code__c();
        gift.Batch_Number__c= '0001'; 
        gift.Code__c = '0005'; 
        gift.Valid_From__c = System.today();
        gift.Valid_To__c =  System.today().addDays(5);     
        //gift.Status__c = BB_GiftCodeController.ACTIVE;
         gift.Status__c = 'Active';
        insert gift;
        
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('accid',acc.id);    
        BB_GiftCodeController ctr = new BB_GiftCodeController(new ApexPages.StandardController(acc));
        ctr.cancel();
        ctr = new BB_GiftCodeController(new ApexPages.StandardController(acc));
        ctr.giftCodeSend.Count__c = '1';
        //
        ctr.sendby.setMethods(new String[]{BB_GiftCodeController.EMAIL, BB_GiftCodeController.READ});  
        system.assert(ctr.title == System.Label.BB_GIFT_SendGiftCode + ' Robert John');
        ctr.save();
        ctr.SendBy.getItems();
  
         //system.assert(ApexPages.getMessages().size()==0);   
    }
    private class CoderMock extends BB_GiftCodeController.Coder
    {
        public CoderMock(string val,date dt)
        {
            super(val,dt);   
            
        }
        
    }
    static testmethod void testToString()
    {
        CoderMock cm = new CoderMock('5678',system.today());
        cm.getString();
    }
    static testMethod void testValidation(){    
        Address__c add = new Address__c(Street__c = 'Main Street', 
            Town__c = 'Leeds', Postcode__c = 'LS1');
        insert add;
         CustomerNumberSeq__c cust = new CustomerNumberSeq__c();
        cust.lastNumber__c = 64444444;
        insert cust;
        Account acc = new Account(FirstName = 'Robert', LastName = 'John', Street_YK__c = add.Id, 
            Customer_No__c = '4444');           
        insert acc;
        
        Gift_Code__c gift = new Gift_Code__c();
        gift.Batch_Number__c= '0000'; 
        gift.Code__c = '0004'; 
        gift.Valid_From__c = System.today();
        gift.Valid_To__c =  System.today().addDays(5);     
        //gift.Status__c = BB_GiftCodeController.ACTIVE;    
           gift.Status__c = 'Active';    
        insert gift;
        
        gift = new Gift_Code__c();
        gift.Batch_Number__c= '0001'; 
        gift.Code__c = '0005'; 
        gift.Valid_From__c = System.today();
        gift.Valid_To__c =  System.today().addDays(5);     
        gift.Status__c ='Active';
        insert gift;
        
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('accid',acc.id);    
        BB_GiftCodeController ctr = new BB_GiftCodeController(new ApexPages.StandardController(acc));
        ctr.cancel();
        ctr = new BB_GiftCodeController(new ApexPages.StandardController(acc));
        ctr.giftCodeSend.Count__c = '1';                   
        ctr.save();
        system.assert(ApexPages.getMessages().size()==1);  
        //    
        ctr.sendby.setMethods(new String[]{BB_GiftCodeController.EMAIL, BB_GiftCodeController.READ});
        ctr.giftCodeSend.Email__c = null;   
        ctr.save(); 
        System.debug('ApexPages.getMessages().size()=>'+ApexPages.getMessages().size());    
        system.assert(ApexPages.getMessages().size()==2);       
    }
    
    /*static testMethod void testSmsNumber(){     
        SmsNumber smsNumber = new SmsNumber('+4521730891');
        system.assert(smsNumber.validate());    
        
        smsNumber = new SmsNumber('4545217308');
        system.assert(smsNumber.validate());
        
        smsNumber = new SmsNumber('11217308');
        system.assert(smsNumber.validate());
        
        smsNumber = new SmsNumber('22');
        system.assert(!smsNumber.validate());
        
        smsNumber = new SmsNumber('4040217308');
        system.assert(!smsNumber.validate());
        
        smsNumber = new SmsNumber('4545217308');
        system.assert(smsNumber.validate());
        system.assert('4545217308'==smsNumber.trim());
        
        smsNumber = new SmsNumber('11217308');
        system.assert(smsNumber.validate());
        system.assert('4511217308'==smsNumber.trim());
                
        smsNumber = new SmsNumber('+4521730891');
        system.assert(smsNumber.validate());
        system.assert('4521730891'==smsNumber.trim());      
    }  */ 
}