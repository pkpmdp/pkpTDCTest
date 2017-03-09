public with sharing class GiftCodeResultController {
    Gift_Code_Send__c gfSend;
    List<Gift_Code__c> gifts;
    List<GiftCodeController.Coder> codes;
    List<GiftCodeController.SmsCoder> smsCodes;
    //List<GiftCodeController.Coder> emailCodes;
    Account customer;
    Boolean smsCrash;
    Boolean emailCrash;
    HttpCaller emailHttpCaller;
    HttpCaller smsHttpCaller;
    public static String SMS_SUBTYPE = 'sms';
    public static String EMAIL_SUBTYPE = 'email';
    public String AccId{get;set;}
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
            GaveGoder.addChildElement('codes',null, null).addTextNode(codes);
            System.debug('xml'+doc.toXmlString());
            return doc;       
        }
                
        public String callout() {
            // Make the callout and check the response
            ApexPages.Message m ;
            /*
            = new ApexPages.Message(ApexPages.severity.Error, 
                    System.Label.GIFT_Sms_crashed, System.Label.GIFT_Sms_crashed);
            ApexPages.addMessage(m);
            crashed = true;
            */
            String method= INTEGRATION__c.getInstance('SPOC440SMSMockup').HttpMethod__c;
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
    
    public class SmsHttpCaller extends HttpCaller{
        public SmsHttpCaller(String endpoint, Gift_Code_Send__c gfSend, String createdBy, String codes){
            super(endpoint,gfSend,createdBy,codes);
        }
        
        public SmsHttpCaller(Gift_Code_Send__c gfSend){
            super(null,gfSend,null,null);
        }
    
        public override String getSubtype(){
            return SMS_SUBTYPE;
        }
    }
    /*  
    public class StringJoiner {
        List<String> codes;
        String separator;
        String result;
        Boolean created;
        
        public StringJoiner (List<String> codes, String separator){
            this.codes = codes; 
            this.separator = separator;
            this.result = '';
            this.created = false;
        }
                
        public String getStringWithSeparator(){
            if (!created) make();
            return result;
        }
        
        Boolean make(){         
            Integer i = 0;
            if ( codes.size()!=0 )
                do {
                    String code = (String)codes.get(i);             
                    result = result + code;
                    i += 1;
                } while (i < codes.size() && addSepartor());
            created = true;     
            return created;
        }
        
        
        Boolean addSepartor(){
            result += separator;
            return true;
        }
    }
    */
//    public String giftsend{get;set;}
    public GiftCodeResultController(ApexPages.StandardController controller) {
        String Id = ApexPages.currentPage().getParameters().get('id');
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
        smsHttpCaller = new SmsHttpCaller(gfSend); 
        emailHttpCaller = new EmailHttpCaller(gfSend);
        setCodes();     
    }
    
    public void init(){
        // Check if there are any Gift Code records related to the given Gift Code Send record
        if (gifts == null || gifts.isEmpty()) {
            // Unexpected error: No gift codes available
            ApexPages.addMessages(
                new GiftCodeController.ValidationException(GiftCodeController.NOCODES)
            );
            return;
        }

        //Not possiblle do http callout without commit DML!     
        if (gfSend.Sms__c!=null || gfSend.Email__c!=null) {         
            sendServices();
        }       
                
        if (smsHttpCaller.crashed) {
            smsCrash = smsHttpCaller.crashed;  //gfSend.Sms__c!=null ? true : false;
            //emailCrash = gfSend.Email__c!=null ? true : false;
            updateLog();
        }            
    }
       
    public void updateLog(){
        //Gift codes have not been sent at all except email     
        if (smsHttpCaller.crashed && gfSend.Readed__c==false && gfSend.Email__c==null ){
            //Release booked gift codes
            for ( Gift_Code__c gift : gifts ){
                gift.Customer__c = null;
                gift.Gift_Code_Send__c = null;
                gift.Ordered_by__c = null;
                gift.Ordered_Date__c = null;
                gift.Status__c = GiftCodeController.ACTIVE;
                update gift;
            }
            //Remove info about sending gift codes.
            delete gfSend;
        }
        // Gift codes have been sent by Email or Readed
        else{ 
            if (smsCrash = true) {
                gfSend.Sms__c=null;
                update gfSend;
            }
            //if (emailCrash = true){
            //  gfSend.Email__c=null;
            //}
            
        }       
    }
       
    public void setCodes(){
        /*
        codes = new List<String>();
        for ( Gift_Code__c gift : gifts ){
            codes.add(gift.Code__c+':'+gift.Valid_To__c.format());
        }*/
        codes = new List<GiftCodeController.Coder>();
        for ( Gift_Code__c gift : gifts ){
            codes.add(new GiftCodeController.Coder(gift.Code__c, gift.Valid_To__c));                
        }       
    }
    
    public void setSmsCodes(){
        smsCodes = new List<GiftCodeController.SmsCoder>();
        for ( Gift_Code__c gift : gifts ){
            smsCodes.add(new GiftCodeController.SmsCoder(gift.Code__c));                
        }       
    }
    /*
    public void setEmailCodes(){
        emailCodes = new List<GiftCodeController.Coder>();
        for ( Gift_Code__c gift : gifts ){
            emailCodes.add(new GiftCodeController.Coder(gift.Code__c, gift.Valid_To__c));               
        }       
    }   */ 
    
    public List<GiftCodeController.Coder> getCodes(){
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
                     
        if (gfSend.Sms__c!=null){
            setSmsCodes();
            //GiftCodeController.Templater temp = 
            //  new GiftCodeController.SmsTemplater(gfSend,customer,smsCodes);           
            
            GiftCodeController.Templater temp = (codes.size()==1)? 
                new GiftCodeController.SmsTemplaterOne(gfSend,customer,smsCodes, getSmallest()):
                new GiftCodeController.SmsTemplaterMore(gfSend,customer,smsCodes , getSmallest());             
            smsHttpCaller = new SmsHttpCaller(endpoint, gfSend, user.MID__c, temp.getBody());
            smsHttpCaller.callout();
        }
        
        if (gfSend.Email__c!=null){
            //setEmailCodes();
            GiftCodeController.Templater etemp = new GiftCodeController.EmailTemplater(gfSend,
                customer,codes,getSmallest());
            emailHttpCaller = new EmailHttpCaller(endpoint, gfSend, user.MID__c,
                etemp.getBody());   
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
    
    public Boolean getWasSentSms(){
        return (smsHttpCaller.crashed==false && gfSend.Sms__c != null) ? true : false;
    }
    
    public String getCountSmsText(){
        return  gifts.size() + ' ' +  System.Label.GIFT_Code_Text + 
            ( gifts.size() > 1 ? System.Label.GIFT_Plural_Text : '') +  ' ' +
            System.Label.GIFT_SentTo_Text + ' ' +
            System.Label.GIFT_Send_Sms +': ' + gfSend.Sms__c;
    }
    /*
    public String getCountText(){
        String sended = gfSend.Email__c!=null ? System.Label.GIFT_Send_Email + ' ' : '' ;
        sended += gfSend.Sms__c!=null && smsHttpCaller.crashed==false ? 
            (gfSend.Email__c!=null? '& ' + System.Label.GIFT_Send_Sms: System.Label.GIFT_Send_Sms) : 
                gfSend.Sms__c!=null && smsHttpCaller.crashed==true ? 
                + System.Label.GIFT_Sms_crashed: '' ;               
        return (smsHttpCaller.crashed==true && gfSend.Email__c == null)? sended :       
            gifts.size() + ' '+ System.Label.GIFT_tags_result + ' ' + sended ;              
    }
    */  
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
        gift.Status__c = GiftCodeController.ORDERED;
        gift.Ordered_Date__c = System.today();      
        insert gift;
        
        gift = new Gift_Code__c();
        gift.Batch_Number__c= '0001'; 
        gift.Customer__c = acc.id;
        gift.Gift_Code_Send__c = gfSend.id;
        gift.Code__c = '0005'; 
        gift.Valid_From__c = System.today();
        gift.Valid_To__c =  System.today().addDays(5);     
        gift.Status__c = GiftCodeController.ORDERED;
        gift.Ordered_Date__c = System.today();  
        insert gift;
        

        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('id',gfSend.id);    
        GiftCodeResultController ctr = new GiftCodeResultController(new ApexPages.StandardController(gfSend));
        ctr.cancel();
        ctr = new GiftCodeResultController(new ApexPages.StandardController(gfSend));
        ctr.init();
        system.assert(System.today().addDays(5)==ctr.getSmallest().Valid_To__c);
        system.assert(ctr.getTitle() == System.Label.GIFT_SendGiftCode + ' ' + 'Robert John');      
        system.assert(ctr.getWasSent());
        system.assert(ctr.getGifts().size()==2);
    }
    
    static testMethod void testRresultOfSendCrash(){    
        Address__c add = new Address__c(Street__c = 'Main Street', 
            Town__c = 'Leeds', Postcode__c = 'LS1');
        insert add;
        
        Account acc = new Account(FirstName = 'Robert', LastName = 'John', Street_YK__c = add.Id, 
            Customer_No__c = '4444',
            PersonEmail = 'jozef.huba@bitlayer.com',
            PersonMobilePhone = '+451904808868');           
        insert acc;
        
        Gift_Code_Send__c gfSend = new  Gift_Code_Send__c();
        gfSend.Count__c = '2';
        gfSend.Customer__c = acc.Id;
        //gfSend.Email__c = acc.PersonEmail;
        //gfSend.Readed__c = true;
        gfSend.Sms__c = acc.PersonMobilePhone;
        insert gfSend;
        
        Gift_Code__c gift = new Gift_Code__c();
        gift.Batch_Number__c= '0000'; 
        gift.Customer__c = acc.id;
        gift.Gift_Code_Send__c = gfSend.id;
        gift.Code__c = '0004'; 
        gift.Valid_From__c = System.today();
        gift.Valid_To__c =  System.today().addDays(5);     
        gift.Status__c = GiftCodeController.ORDERED;
        gift.Ordered_Date__c = System.today();      
        insert gift;
        
        gift = new Gift_Code__c();
        gift.Batch_Number__c= '0001'; 
        gift.Customer__c = acc.id;
        gift.Gift_Code_Send__c = gfSend.id;
        gift.Code__c = '0005'; 
        gift.Valid_From__c = System.today();
        gift.Valid_To__c =  System.today().addDays(5);     
        gift.Status__c = GiftCodeController.ORDERED;
        gift.Ordered_Date__c = System.today();  
        insert gift;        

        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('id',gfSend.id);    
        GiftCodeResultController ctr = new GiftCodeResultController(new ApexPages.StandardController(gfSend));
        ctr.smsHttpCaller = new GiftCodeResultController.SmsHttpCaller( null, gfSend, null, null);
        ctr.smsHttpCaller.crashed = true;
        ctr.smsCrash = true;
        ctr.updateLog();
    }       

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
            Batch_Number__c='0000', Customer__c=acc.id, //Gift_Code_Send__c=gfSend.id
            Code__c='0004', Valid_From__c=dt, Valid_To__c=dt.addDays(10),
            Status__c=GiftCodeController.ORDERED, Ordered_Date__c=dt
        );
        insert gift;

        PageReference pageRef = Page.GiftCodeResult;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', gfSend.id);
        GiftCodeResultController ctr = new GiftCodeResultController(
            new ApexPages.StandardController(gfSend)
        );
        ctr.init();
        // Check if the error was handled OK
        Boolean wasMsg = false;
        for (ApexPages.Message msg : ApexPages.getMessages()) {
            wasMsg = msg.getSummary() == GiftCodeController.NOCODES;
            if (wasMsg) {
                break;
            }
        }
        System.assert(wasMsg);
    }
}