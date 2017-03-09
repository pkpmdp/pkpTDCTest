public with sharing class BBGiftCodeResultController {
    Gift_Code_Send__c gfSend;
    List<Gift_Code__c> gifts;
    List<BB_GiftCodeController.Coder> codes;
    //List<BB_GiftCodeController.SmsCoder> smsCodes;
    //List<BB_GiftCodeController.Coder> emailCodes;
    Account customer;
    Boolean smsCrash;
    Boolean emailCrash;
    HttpCaller emailHttpCaller;
    HttpCaller smsHttpCaller;
    public static String SMS_SUBTYPE = 'sms';
    public static String EMAIL_SUBTYPE = 'email';
    public String AccId{get;set;}
    public List<String> calloutParameter = new List<String>();
    public List<String> calloutvalue = new List<String>();
    
    public abstract class HttpCaller {
        Gift_Code_Send__c gfSend;
        public boolean crashed { get; set;}
        String endpoint;
        String createdBy;
        String codes;
        
        public HttpCaller(String endpoint, Gift_Code_Send__c gfSend, String createdBy, String codes){
            this.gfSend = gfSend;
            crashed = false;
            this.endpoint = endpoint;
            this.createdBy = createdBy;
            this.codes = codes;
            
        }
        
        public abstract String getSubtype();
        
        public Dom.Document getDocument(){
            
        /**
        public Dom.Document getDocument(String amsId, String afsender, String message, 
            String mobilNr){
            
            <?xml version="1.0" encoding="UTF-8"?>
            <SMSMockup>
                <SMS>
                    <amsId>amsId</amsId>
                    <afsender>afsender</afsender>
                    <message>message</message>
                    <mobilNr>mobilNr</mobilNr>
                </SMS>
            </SMSMockup>
            */
            /*
            <?xml version="1.0" encoding="UTF-8"?>
            <spoc440 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="spoc440New.xsd">
              <GaveGoder>
                <customerNo>customerNo</customerNo>
                <firstName>firstName</firstName>
                <lastName>lastName</lastName>
                <email>email</email>
                <phone>phone</phone>
                <subtype>subtype</subtype>
                <sfid>sfid</sfid>
                <createdBy>createdBy</createdBy>
                <codes>codes</codes>
              </GaveGoder>
            </spoc440>
            */
            DOM.Document doc = new DOM.Document();
            dom.XmlNode spoc440 = doc.createRootElement('spoc440', null, null);
            Dom.XmlNode GaveGoder = spoc440.addChildElement('GaveGoder',  null, null);
            GaveGoder.addChildElement('customerNo',null, null).addTextNode(gfSend.Customer__r.Customer_No__c);
            GaveGoder.addChildElement('firstName',null, null).addTextNode(
                gfSend.Customer__r.firstName==null? '' : gfSend.Customer__r.firstName);
            GaveGoder.addChildElement('lastName',null, null).addTextNode(gfSend.Customer__r.lastName);
            GaveGoder.addChildElement('email',null, null).addTextNode(gfSend.email__c==null ? '': gfSend.email__c);
            GaveGoder.addChildElement('phone',null, null).addTextNode(gfSend.Sms__c == null ? '': gfSend.Sms__c);
            GaveGoder.addChildElement('subtype',null,null).addTextNode(getSubtype());       
            GaveGoder.addChildElement('sfid',null, null).addTextNode(gfSend.Customer__c);
            GaveGoder.addChildElement('createdBy',null, null).addTextNode(createdBy);
            System.debug('CODES => ############'+codes);
            GaveGoder.addChildElement('codes',null, null).addTextNode(codes);
            System.debug('xml'+doc.toXmlString());
            return doc;       
        }
                
        public String callout() {
            // Make the callout and check the response
            ApexPages.Message m ;
            String method= INTEGRATION__c.getInstance('SPOC440SMSMockup').HttpMethod__c;
            System.debug('method--------'+ method);
            
            String response = null;
                
                          
                Http http = new Http();
                HttpRequest req = new HttpRequest(); 
                req.setMethod(method); //GET
                req.setEndpoint(endpoint);
                req.setHeader('Content-Type', 'text/xml');        
                req.setBodyDocument(getDocument());        
                //req.setBody((body == null ? '' : body));
                req.setTimeout(15000);   
                System.debug('body'+ req.getBodyDocument());     
                HttpResponse res;
                try {
                    res = http.send(req);
                    System.debug('endpoint: ' + endpoint);
                    System.debug('res: ' + res); 
                    System.debug('resBody: ' + res.getBody());                  
                } catch (Exception e) {
                    m = new ApexPages.Message(ApexPages.severity.Error, 
                        e.getMessage(), e.getMessage());
                    ApexPages.addMessage(m); 
                    crashed = true;                                      
                }
                if (res != null) {
                    if (res.getStatusCode() == 200) {
                        // Good response 
                        response = res.getBody();
                        System.debug('response' + response);
                    }else {
                        String error = gfSend.Email__c != null? 
                            System.Label.GIFT_Email_crashed: ' ';  
                        error += gfSend.Sms__c != null ? ' '+ System.Label.GIFT_Sms_crashed:'';
                        m = new ApexPages.Message(ApexPages.severity.Error, error , error);
                        ApexPages.addMessage(m);
                        crashed = true;             
                    }
                }   
            return response;    
        }  
    }
    
    public class EmailHttpCaller extends HttpCaller{
        public EmailHttpCaller(String endpoint, Gift_Code_Send__c gfSend, String createdBy, String codes){
            super(endpoint,gfSend,createdBy,codes);
            
        }
        
        public EmailHttpCaller(Gift_Code_Send__c gfSend){
            super(null,gfSend,null,null);
        }
            
        public override String getSubtype(){
            return EMAIL_SUBTYPE;
        }

    }
    
 
//    public String giftsend{get;set;}
    public BBGiftCodeResultController(ApexPages.StandardController controller) {
        String Id = ApexPages.currentPage().getParameters().get('id');
        system.debug('check===='+Id);
        gfSend = [SELECT Id, Customer__c, Customer__r.Name,
            Customer__r.FirstName , Customer__r.LastName,  Customer__r.Customer_No__c,  
            Email__c, Sms__c, Readed__c , Count__c
            FROM Gift_Code_Send__c WHERE Id =: Id ];
        gifts =  [SELECT ID, Code__c, Gift_Code_Send__c, Valid_To__c FROM Gift_Code__c 
            WHERE Gift_Code_Send__c =: Id ORDER BY ID];
        customer = [SELECT Id, Name, AddressId__c,recordtypeid,recordtype.developername FROM Account WHERE Id =: gfSend.Customer__c];
        AccId = gfSend.Customer__c;
        //giftsend = gfSend.id;
        smsCrash=false;
        emailCrash=false;
        //smsHttpCaller = new SmsHttpCaller(gfSend); 
        emailHttpCaller = new EmailHttpCaller(gfSend);
        setCodes();     
    } 
    
    public void init(){
        // Check if there are any Gift Code records related to the given Gift Code Send record
        if (gifts == null || gifts.isEmpty()) {
            // Unexpected error: No gift codes available
            ApexPages.addMessages(
                new BB_GiftCodeController.ValidationException(BB_GiftCodeController.NOCODES)
            );
            return;
        }

        //Not possiblle do http callout without commit DML!     
        //if (gfSend.Sms__c!=null || gfSend.Email__c!=null) {  
        if (gfSend.Email__c!=null){         
            sendServices();
            
        }       
      
    }
       
    public void updateLog(){
        //Gift codes have not been sent at all except email     
        
            if (emailCrash = true){
              gfSend.Email__c=null;
            }
            
       // }       
    }
       
    public void setCodes(){
        
        codes = new List<BB_GiftCodeController.Coder>();
        for ( Gift_Code__c gift : gifts ){
            codes.add(new BB_GiftCodeController.Coder(gift.Code__c, gift.Valid_To__c));                
        }       
    }
    
        
    public List<BB_GiftCodeController.Coder> getCodes(){
        return codes;
    }
    
    public Gift_Code__c getSmallest(){
        Gift_Code__c smallGift = gifts.get(0);      
        for (Gift_Code__c gift : gifts){
            if (smallGift.Valid_To__c > gift.Valid_To__c){
                smallGift = gift;
            }
        }
        return smallGift;        
    }
    
    public void sendServices(){
        //setCodes();
        User user = [Select MID__c From User Where Id = : UserInfo.getUserId()];
        //String codeAsStr = new StringJoiner(codes,';').getStringWithSeparator();
        String endpoint = clsConnectionUtils_Admin.getEndPoint('SPOC440SMSMockup');
        //String params = gfSend.Customer__r.Customer_No__c + ' ' + 
        //  gfSend.Customer__r.FirstName + ' ' + gfSend.Customer__r.LastName + ' ' 
        //  + gfSend.Email__c + ' '+ gfSend.Sms__c + ' ' + gfSend.Customer__c + ' '
        //  + user.MID__c +' '+ ' '+ codeAsStr;
        //System.debug('params: ' + params);
                     
      
        if (gfSend.Email__c!=null){
            //setEmailCodes();
            BB_GiftCodeController.Templater etemp = new BB_GiftCodeController.EmailTemplater(gfSend,
                customer,codes,getSmallest());
                String codesString = etemp.getMarkup();
                codesString=codesString.substring(codesString.indexOf('<messaging:plainTextEmailBody')).replaceAll('\\<.*?>','');
                System.debug('codesString =>'+codesString);
            emailHttpCaller = new EmailHttpCaller(endpoint, gfSend, user.MID__c,
                codesString);   
            emailHttpCaller.callout();
            
        }               
    }
    
    public PageReference backToAccount(){
        String isConsole = ApexPages.currentPage().getParameters().get('isdtp');
        if(isConsole != null && 'vw'.equals(isConsole)){
            PageReference pageRef = new PageReference('/apex/ConsoleSendTab?id=' + customer.id);
            return pageRef;
        }               
        PageReference parentPage = new PageReference('/'+ customer.id);
        parentPage.setRedirect(true);
        return parentPage;
     }
     
    public PageReference cancel() {                      
        return backToAccount();      
    }
    
    public List<Gift_Code__c> getGifts() {
        return gifts;
    }
    
    public Gift_Code_Send__c getGiftSend() {
        return gfSend;
    }
    
    public boolean getWasSent(){        
        return gfSend.Email__c == null && gfSend.Sms__c == null?  false:true;
    } 
    
    public String getCustomerText(){
        return System.Label.GIFT_Status_Gift_Tags + ' ' + customer.Name;
    }
    
    public String getTitle(){
        return System.Label.GIFT_SendGiftCode + ' ' + customer.Name;        
    } 
    
    public Boolean getWasSentEmail(){
        return gfSend.Email__c == null ? false : true;
    }
    
    public String getCountEmailText(){  
        return  gifts.size() + ' ' +  System.Label.GIFT_Code_Text + 
            (gifts.size() > 1 ? System.Label.GIFT_Plural_Text : '') + ' ' +
            System.Label.GIFT_SentTo_Text + ' ' +
            System.Label.GIFT_Send_Email +': ' + gfSend.Email__c;
    }
    
    
      
    /*
    static testMethod void testStringJoiner(){      
        List<String> code = new List<String>();
        code.add('1');
        code.add('2');
        code.add('3');
        StringJoiner str = new StringJoiner(code,';');
        system.assert('1;2;3'== str.getStringWithSeparator());

        List<String> code2 = new List<String>();
        StringJoiner str2 = new StringJoiner(code2,',');
        code2.add('A');
        system.assert('A'== str2.getStringWithSeparator());             
    }
    */
    

       static testMethod void testRresultOfSend(){ 
        Address__c add = new Address__c(Street__c = 'Main Street', 
            Town__c = 'Leeds', Postcode__c = 'LS1');
        insert add;
        CustomerNumberSeq__c cust = new CustomerNumberSeq__c();
        cust.lastNumber__c = 64444444;
        insert cust;
        Account acc = new Account(FirstName = 'Robert', LastName = 'John', Street_YK__c = add.Id, 
            Customer_No__c = '4444',
            PersonEmail = 'jozef.huba@bitlayer.com',
            PersonMobilePhone = '+451904808868');           
        insert acc;
        
        Gift_Code_Send__c gfSend = new  Gift_Code_Send__c();
        gfSend.Count__c = '2';
        gfSend.Customer__c = acc.Id;
        gfSend.Email__c = acc.PersonEmail;
        gfSend.Readed__c = true;
        gfSend.Sms__c = acc.PersonMobilePhone;
        insert gfSend;
        
        Gift_Code__c gift = new Gift_Code__c();
        gift.Batch_Number__c= '0000'; 
        gift.Customer__c = acc.id;
        gift.Gift_Code_Send__c = gfSend.id;
        gift.Code__c = '0004'; 
        gift.Valid_From__c = System.today();
        gift.Valid_To__c =  System.today().addDays(10);     
        gift.Status__c = BB_GiftCodeController.ORDERED;
        gift.Ordered_Date__c = System.today();      
        insert gift;
        
        INTEGRATION__c ig =new INTEGRATION__c();
        ig.HttpMethod__c='PUT';
        ig.Name='SPOC440SMSMockup';
        //ig.Service__c='https://TDC.jitterbit.eu/prodapi/SPOC44';
        ig.IsBodyAppended__c=true;
        insert ig;
           
  
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('id',gfSend.id);    
        BBGiftCodeResultController ctr = new BBGiftCodeResultController(new ApexPages.StandardController(gfSend));
        ctr.cancel();
        //ctr = new BBGiftCodeResultController(new ApexPages.StandardController(gfSend));
        ctr.init();
        //system.assert(System.today().addDays(5)==ctr.getSmallest().Valid_To__c);
        //system.assert(ctr.getTitle() == System.Label.GIFT_SendGiftCode + ' ' + 'Robert John');      
        //system.assert(ctr.getWasSent());
        //system.assert(ctr.getGifts().size()==2);
        
    }

    /*
    static testMethod void testRresultOfSendCrash(){    
        Address__c add = new Address__c(Street__c = 'Main Street', 
            Town__c = 'Leeds', Postcode__c = 'LS1');
        insert add;
        CustomerNumberSeq__c cust = new CustomerNumberSeq__c();
        cust.lastNumber__c = 64444444;
        insert cust;
        Account acc = new Account(FirstName = 'Robert', LastName = 'John', Street_YK__c = add.Id, 
            Customer_No__c = '4444',
            PersonEmail = 'jozef.huba@bitlayer.com',
            PersonMobilePhone = '+451904808868');           
        insert acc;
        
        BB_Gift_Code_Send__c gfSend = new  BB_Gift_Code_Send__c();
        gfSend.Count__c = '2';
        gfSend.Customer__c = acc.Id;
        //gfSend.Email__c = acc.PersonEmail;
        //gfSend.Readed__c = true;
        gfSend.Sms__c = acc.PersonMobilePhone;
        insert gfSend;
        
        BB_Gift_Code__c gift = new BB_Gift_Code__c();
        gift.Batch_Number__c= '0000'; 
        gift.Customer__c = acc.id;
        gift.BB_Gift_Code_Send__c = gfSend.id;
        gift.Code__c = '0004'; 
        gift.Valid_From__c = System.today();
        gift.Valid_To__c =  System.today().addDays(5);     
        gift.Status__c = BB_GiftCodeController.ORDERED;
        gift.Ordered_Date__c = System.today();      
        insert gift;
        
        gift = new BB_Gift_Code__c();
        gift.Batch_Number__c= '0001'; 
        gift.Customer__c = acc.id;
        gift.BB_Gift_Code_Send__c = gfSend.id;
        gift.Code__c = '0005'; 
        gift.Valid_From__c = System.today();
        gift.Valid_To__c =  System.today().addDays(5);     
        gift.Status__c = BB_GiftCodeController.ORDERED;
        gift.Ordered_Date__c = System.today();  
        insert gift;        

        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('id',gfSend.id);    
        BBGiftCodeResultController ctr = new BBGiftCodeResultController(new ApexPages.StandardController(gfSend));
        ctr.smsHttpCaller = new BBGiftCodeResultController.smsHttpCaller( null, gfSend, null, null);
        ctr.smsHttpCaller.crashed = true;
        ctr.smsCrash = true;
        ctr.updateLog();
    }   */

    static testMethod void testResultOfMissingGiftCodes() {
        /*
        To avoid the following error:
        GiftCodeResultController : List index out of bounds: 0
        caused by: System.ListException: List index out of bounds: 0
        Class.GiftCodeResultController.getSmallest: line ...
        */
        Address__c add = new Address__c(
            Street__c='Main Street', Town__c='Leeds', Postcode__c='LS1'
        );
        insert add;
        CustomerNumberSeq__c cust = new CustomerNumberSeq__c();
        cust.lastNumber__c = 64444444;
        insert cust;
        Account acc = new Account(
            FirstName='Robert', LastName='John', Street_YK__c=add.Id, Customer_No__c='4444',
            PersonEmail='jozef.huba@bitlayer.com', PersonMobilePhone='+451904808868'
        );
        insert acc;

        Gift_Code_Send__c gfSend = new Gift_Code_Send__c(
            Count__c='2', Customer__c=acc.Id, Email__c=acc.PersonEmail,
            Readed__c=true, Sms__c=acc.PersonMobilePhone
        );
        insert gfSend;

        // Create a test Gift Code record with no relation to the above Gift Code Send record
        Date dt = System.today();
        Gift_Code__c gift = new Gift_Code__c(
            Batch_Number__c='0000', Customer__c=acc.id, //BB_Gift_Code_Send__c=gfSend.id
            Code__c='0004', Valid_From__c=dt, Valid_To__c=dt.addDays(10),
            Status__c=BB_GiftCodeController.ORDERED, Ordered_Date__c=dt
        );
        insert gift;

        PageReference pageRef = Page.BBGiftCodeResult;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', gfSend.id);
        BBGiftCodeResultController ctr = new BBGiftCodeResultController(
            new ApexPages.StandardController(gfSend)
        );
        ctr.init();
        ctr.getCountEmailText();
        ctr.getCustomerText();
        ctr.getTitle();
        ctr.getCodes();
        ctr.setCodes();
        ctr.getGiftSend();
        ctr.backToAccount(); 
        // Check if the error was handled OK
        Boolean wasMsg = false;
        for (ApexPages.Message msg : ApexPages.getMessages()) {
            wasMsg = msg.getSummary() == BB_GiftCodeController.NOCODES;
            if (wasMsg) {
                break;
            }
        }
        System.assert(wasMsg);
    }
}