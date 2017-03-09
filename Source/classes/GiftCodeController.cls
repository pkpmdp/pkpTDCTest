public with sharing class GiftCodeController {    
    public Gift_Code_Send__c giftCodeSend {get; set;}
    public Account customer{get;set;}
    public boolean show_sms{get;set;}
    public boolean show_Reason{get;set;}
    public String title {
        get {
            return System.Label.GIFT_SendGiftCode + ' ' + customer.Name;
        } 
        set;
    } 
    public static final String EMAIL = 'EMAIL'; 
    public static final String SMS = 'SMS'; 
    public static final String READ = 'READ'; 
    
    public static final String EMAILERRORMSG = System.Label.GIFT_Err_Email;
    public static final String SMSERRORMSG =  System.Label.GIFT_Err_Sms;
    public static final String SENDBYERRORMSG =  System.Label.GIFT_Err_SendBy;
    public static final String COUNTERROR = System.Label.GIFT_Err_Count;
    public static final String NOCODES = System.Label.GIFT_Err_NoCodes;
    public static final String EXPIRATION = System.Label.GIFT_Expiration + ' ';
    public static final String ORDERED = 'Ordered';
    public static final String ACTIVE = 'Active';
    public static final String EMAIL_FROM_YK = '0D2200000004CKG';//Kundeservice
    public static final String EMAIL_FROM_BB = '0D2M0000000012r';
    public static final String DANISHPHONEPREF = '45';
    public static final String SMSFORMATERROR = System.Label.GIFT_Sms_Format;
    public static final String TESTEMAIL = 'uoh@yousee.dk'; 
        
    public class IntegrateException extends Exception {}    
    public class ValidationException extends Exception {}
    public class SmsFormatException extends Exception {}
        
    public SendBy sendby;
    List<Coder> codes;
    String defaultVal;
    
    public class SmsNumber{
        /*
        NOT(REGEX(Home_Phone__c, '^[+]?[0-9]{0,19}')),
        NOT(REGEX(PersonMobilePhone ,'^[+]?[0-9]{0,19}')),
        NOT(REGEX(Phone ,'^[+]?[0-9]{0,19}'))
        */
        private String sNumber;     
    
        public SmsNumber(String sNumber){
            this.sNumber = sNumber;         
        }
        public Boolean validate(){
            Pattern myPattern = pattern.compile('^([+]45[0-9]{8})|(45[0-9]{8})|([0-9]{8})');
            Matcher myMatcher = myPattern.matcher(sNumber);
            if (!MyMatcher.matches()) {
                ApexPages.addMessages(new SmsFormatException(SMSFORMATERROR));
                return false;
            }
            return true;
        }
        
        public String trim(){
            if (sNumber.length()== 8) {
                sNumber = DANISHPHONEPREF + sNumber;
            } else if (sNumber.length() == 11) {
                    return sNumber.substring(1, sNumber.length());              
            }
            return sNumber;
        }       
    }
    
    
    public virtual class Coder { 
        public String value {get; set;}
        public Date validTo {get; set;}
        
        public Coder(String value, Date validTo){
            this.value = value;
            this.validTo = validTo; 
        }
        public Coder(String value){
            this.value = value; 
        }
        public virtual String getString(){
            return value + EXPIRATION + validTo.format();
        }
        public virtual String getOnlyCode(){
            return value;
        }
                
    }
    public class SmsCoder extends Coder{
        public SmsCoder(String value){
            super(value, null);
        }
        public override String getString(){
            return value;
        }
                
    }
    
    
    
    public virtual class EmailTemplater extends Templater {             
        public EmailTemplater(Gift_Code_Send__c gfSend, Account customer, List<Coder> codes,Gift_Code__c gift){           
            super( gfSend, customer, codes,gift);
        }
        
        public override String getTemplateName(){
            if(customer.RecordType.Developername == 'Blockbuster_Customer_Account')
                return 'BB_Gift_Code_Send';
            else if(customer.RecordType.Developername == 'YK_Customer_Account')
                return 'Send_Gift_Codes_Email';
            return null;
        }
        
        public override void substBody(){
            /*
            '{!Account.Name}'
            '{!Gift_Code__c.Code__c}'
            '{!Today}'
            */
            setGiftWords();   
            emailTemplate.body = emailTemplate.body.replace('{!Account.Name}',
                customer.Name).
                 replace('{!GIFTWORD}',giftword).
                replace('{!Gift_Code__c.Code__c}',getCodesFormated()).
                replace('{!GIFTWORD2}',giftword2); 
        }
        
    }
    /*
    public virtual class SmsTemplater extends Templater{
        public SmsTemplater(Gift_Code_Send__c gfSend, Account customer, List<Coder> codes){
            super( gfSend, customer, codes);
        }
        
        public virtual override String getTemplateName(){
            return 'Send_Gift_Codes_Sms';
        }
        
        public override void substBody(){
            setGiftWords(); 
            emailTemplate.body = emailTemplate.body.replace('{!Gift_Code__c.Code__c}',
                getCodesFormated()).                
                replace('{!Gift_Code_Send__c.Count__c}',gfSend.Count__c).
                replace('{!Today}',System.today().format()).
                replace('{!GIFTWORD}',giftword).
                replace('{!GIFTWORD2}',giftword2);
        }
        
    }
    */
    
    
    public virtual class SmsTemplaterOne extends Templater{
        public SmsTemplaterOne(Gift_Code_Send__c gfSend, Account customer, List<Coder> codes, Gift_Code__c gift){
            super( gfSend, customer, codes,gift);
        }
        
        public virtual override String getTemplateName(){
            return 'Send_Gift_Codes_Sms_One';
        }
        
        public override void substBody(){
                emailTemplate.body = emailTemplate.body.replace('{!Gift_Code__c.Code__c}',
                    //getCodesFormated()).replace('{!Today}',System.today().format())
                    getCodesFormated()).replace('{!Today}',gift.Valid_To__c.format());
        }
        
    }
    
    public virtual class SmsTemplaterMore extends SmsTemplaterOne {
        public SmsTemplaterMore(Gift_Code_Send__c gfSend, Account customer, List<Coder> codes , Gift_Code__c gift){
            super( gfSend, customer, codes, gift);
        }
        
        public override String getTemplateName(){
            return 'Send_Gift_Codes_Sms_More';
        }
    }
    
    public interface ITemplater {
        String getTemplateName();
        void substBody();
    }

    public abstract class Templater implements  ITemplater {
        Gift_Code_Send__c gfSend;
        EmailTemplate emailTemplate;
        Account customer;
        List<Coder> codes;
        Gift_Code__c gift;
        String giftword,giftword2;
            
        public Templater(Gift_Code_Send__c gfSend, Account customer, List<Coder> codes,Gift_Code__c gift){
            this.gfSend = gfSend;
            this.customer = customer;
            this.codes= codes;
            this.gift = gift;
            emailTemplate = [select id, body, subject from EmailTemplate 
             where developerName =: getTemplateName()];
            substBody();                        
        }
        
        protected void setGiftWords(){
            //giftword = codes.size()>1 ? 'gavekoder': 'gavekode';
            //giftword2 = codes.size()>1 ? 'Gavekoderne' : 'Gavekoden';
            giftword = codes.size()>1 ? 'dine filmkoder': 'din filmkode';
            giftword2 = codes.size()>1 ? 'Koderne' : 'Koden';
        }
        
        public abstract String getTemplateName();
        
        public String getSubject(){
            return emailTemplate.subject;
        }
        
        public String getBody(){
            return emailTemplate.body;  
        } 
        
        
        
        public String getCodesFormated(){
            String codeFormated = '';
            for ( Coder code :  codes ){
                if(customer.RecordType.developername == 'YK_Customer_Account') 
                    codeFormated = codeFormated + code.getString();
                 else if(customer.RecordType.developername == 'Blockbuster_Customer_Account') 
                    codeFormated = codeFormated + code.getOnlyCode();
                
            }
            return codeFormated;
        }
                
        public abstract void substBody();
        
    }
        
    public GiftCodeController(ApexPages.StandardController controller) {
        // to get default value of picklist
        
         Schema.DescribeFieldResult F = Gift_Code_Send__c.Count__c.getDescribe();
         List <Schema.PicklistEntry> pickVals = F.getPicklistValues();
         for (Schema.PicklistEntry av: pickVals) {
            if (av.isDefaultValue()) {
                defaultVal = av.getValue();
        }
        }
            system.debug('Default value is' + defaultVal);
        codes = new List<Coder>();
        giftCodeSend = new Gift_Code_Send__c();     
        customer = [SELECT Id, Name, PersonEmail, PersonMobilePhone,Recordtypeid,Recordtype.developerName FROM Account 
            WHERE Id =: ApexPages.currentPage().getParameters().get('accid')];
        giftCodeSend.Customer__c = customer.Id;
        //For testing purposes:     
        giftCodeSend.Email__c = customer.PersonEmail;
        //Production:
        //giftCodeSend.Email__c = customer.PersonEmail;         
        giftCodeSend.Sms__c = customer.PersonMobilePhone;  
         giftCodeSend.Count__c = defaultVal;
        if(customer.Recordtype.developerName == 'Blockbuster_Customer_Account')
        {
            show_Reason = true;
            show_sms = false;
        }
        else
        {
            show_sms = true;
            show_Reason = false;
        } 
        String recType = customer.Recordtype.developerName;
        sendby = new SendBy(recType);
    }
    public class SendBy {
        
        public boolean byEmail = false;
        public boolean bySms = false;
        public boolean byRead = false;
        String[] methods = new String[]{};
        String custType;
        public SendBy(String custType)
        {
            this.custType = custType;
            
        }
        public List<SelectOption> getItems() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption(EMAIL,System.Label.GIFT_Send_Email));
            if(custType != 'Blockbuster_Customer_Account')
            {options.add(new SelectOption(SMS,System.Label.GIFT_Send_Sms));}
            options.add(new SelectOption(READ,System.Label.GIFT_Read_Code));
            return options;
        }
            
        public String[] getMethods() {
            return methods;
        }
            
        public void setMethods(String[] methods) {
            this.methods = methods;
        }
    }
    
    public void validate(){
        try {
            Integer co = integer.valueOf(defaultVal);
        } catch (System.Exception e) {
            throw new ValidationException(COUNTERROR);
        }
        if (sendby.getMethods().size()==0){
            ApexPages.addMessages(new ValidationException(SENDBYERRORMSG));
        }
        else {
            for (String method : sendby.getMethods()){
                if (method == EMAIL ){ 
                    sendby.byEmail = true;
                    if ( giftCodeSend.Email__c==null){
                        ApexPages.addMessages(new ValidationException(EMAILERRORMSG));
                    }
                } else if( method == SMS ) { 
                    sendby.bySms = true;
                    if (giftCodeSend.Sms__c==null){
                        ApexPages.addMessages(new ValidationException(SMSERRORMSG));
                    }else {
                        SmsNumber smsNumber = new SmsNumber(giftCodeSend.Sms__c);
                        smsNumber.validate();
                        giftCodeSend.Sms__c = smsNumber.trim();                     
                    }
                } else if( method == READ ) { 
                    sendby.byRead = true;
                    giftCodeSend.Readed__c = sendby.byRead;                                     
                }                   
            }           
        }
    }    
    
    public PageReference save() {
        String smsResponse = null;
        validate();
        if (ApexPages.getMessages().size()>0) return null;
        Integer expectedCount = Integer.valueOf(defaultVal);
                        
        Savepoint sp = Database.setSavepoint();         
        System.debug('IN SAVE CHK recttype = *** '+customer.Recordtype.developerName);
        Gift_Code_Send__c gfSend = new  Gift_Code_Send__c();
        gfSend.Count__c = defaultVal;
        gfSend.Email__c = sendby.byEmail==true ? giftCodeSend.Email__c : null;
            gfSend.Readed__c = giftCodeSend.Readed__c;
            gfSend.Sms__c = sendby.bySms == true ? giftCodeSend.Sms__c: null;
        gfSend.Customer__c = giftCodeSend.Customer__c;
        //Adding customer recordtype check
        if(customer.Recordtype.developerName == 'YK_Customer_Account')
        {
            gfSend.RecordTypeId = [select id from recordtype where DeveloperName = 'YK_Gift_Code_Send' limit 1].id;
        }
        else if(customer.Recordtype.developerName    == 'Blockbuster_Customer_Account')
        {
            gfSend.Reason__c = giftCodeSend.Reason__c;
            gfSend.RecordTypeId = [select id from recordtype where DeveloperName = 'BB_Gift_Code_Send' limit 1].id;
        }
        insert gfSend; 
        Gift_Code__c gift;              
        for (sObject oneObject : Database.query('SELECT Id, Code__c, Customer__c, ' + 
        ' Gift_Code_Send__c, Ordered_by__c, Ordered_Date__c, Status__c, Gift_Code__c.Valid_To__c '+
        ' FROM Gift_Code__c WHERE Status__c = \''+ String.escapeSingleQuotes(ACTIVE) + '\'' + 
        ' limit '+defaultVal+'FOR UPDATE')) {
            gift = (Gift_Code__c)oneObject;
            
            if(customer.Recordtype.developerName == 'YK_Customer_Account')
                codes.add(new Coder(gift.Code__c , gift.Valid_To__c));
            else if(customer.Recordtype.developerName    == 'Blockbuster_Customer_Account')
                codes.add(new Coder(gift.Code__c));
            gift.Customer__c = giftCodeSend.Customer__c;
            gift.Gift_Code_Send__c = gfSend.Id;
            gift.Ordered_by__c = UserInfo.getUserId();
            gift.Ordered_Date__c =System.today();
            gift.Status__c = ORDERED;
            update gift;            
        }
        if (codes.size()!=expectedCount){           
            Database.rollback(sp);      
            ApexPages.addMessages(new ValidationException(NOCODES));
            return null;    
        }               
        if (sendby.byEmail){
            sendEmail(gfSend,gift);
        }
        if (sendby.bySms || sendby.byEmail){
            //Not possiblle do http callout without commit DML!
            return getResultPage(gfSend);
        }       
        return getResultPage(gfSend);            
    }
       
    private void sendEmail(Gift_Code_Send__c gfSend, Gift_Code__c gift){
        String[] toaddress = new String[]{};
        toaddress.add(giftCodeSend.Email__c);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //mail.setReplyTo(EMAIL_FROM);
        setOrgEmailAddress(mail);
        mail.setToAddresses(toaddress);
        EmailTemplater emailTemp = new EmailTemplater(gfSend,customer,codes,gift); 
        mail.setsubject(emailTemp.getSubject());
        mail.setPlainTextBody(emailTemp.getBody());
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });       
    }
    
    private void setOrgEmailAddress(Messaging.SingleEmailMessage mail){ 
        //for(OrgWideEmailAddress owa : [select id, Address, DisplayName  
          //  from OrgWideEmailAddress]) {
                if(customer.RecordType.developername == 'YK_Customer_Account')
                    mail.setOrgWideEmailAddressId([select id,Address,DisplayName from OrgWideEmailAddress where id =: EMAIL_FROM_YK limit 1].id);
                else if(customer.RecordType.developername == 'Blockbuster_Customer_Account')
                    mail.setOrgWideEmailAddressId([select id,Address,DisplayName from OrgWideEmailAddress where id =: EMAIL_FROM_BB limit 1].id);            
        // if(owa.id  == EMAIL_FROM_YK) 
           //     mail.setOrgWideEmailAddressId(owa.id); 
            
        
    }    
    
    private PageReference getResultPage(Gift_Code_Send__c gfSend){
        PageReference parentPage = new PageReference('/apex/GiftCodeResult?id='+gfSend.id);
        parentPage.setRedirect(true);
        return parentPage;
    }
    
    private PageReference backToAccount(){
        String isConsole = ApexPages.currentPage().getParameters().get('isdtp');
        if(isConsole != null && 'vw'.equals(isConsole)){
            //PageReference pageRef = new PageReference('/apex/ConsoleSendTab?id=' + giftCodeSend.Customer__c);
            PageReference pageRef = new PageReference('/' + giftCodeSend.Customer__c+'?isdtp=vw');
            return pageRef;
        }        
        PageReference parentPage = new PageReference('/'+giftCodeSend.Customer__c);
        parentPage.setRedirect(true);
        return parentPage;
     }
     
    public PageReference cancel() {                      
        return backToAccount();      
    }
    
    public SendBy getSendBy(){
        return sendby;
    }
    
    static testMethod void testSendGifts(){ 
        Address__c add = new Address__c(Street__c = 'Main Street', 
            Town__c = 'Leeds', Postcode__c = 'LS1');
        insert add;
        
        Account acc = new Account(FirstName = 'Robert', LastName = 'John', Street_YK__c = add.Id, 
            Customer_No__c = '4444',
            PersonEmail = 'jozef.huba@bitlayer.com',
            PersonMobilePhone = '+4521730891');     
        insert acc;
        
        Gift_Code__c gift = new Gift_Code__c();
        gift.Batch_Number__c= '0000'; 
        gift.Code__c = '0004'; 
        gift.Valid_From__c = System.today();
        gift.Valid_To__c =  System.today().addDays(5);     
        gift.Status__c = ACTIVE;        
        insert gift;
        
        gift = new Gift_Code__c();
        gift.Batch_Number__c= '0001'; 
        gift.Code__c = '0005'; 
        gift.Valid_From__c = System.today();
        gift.Valid_To__c =  System.today().addDays(5);     
        gift.Status__c = ACTIVE;
        insert gift;
        
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('accid',acc.id);    
        GiftCodeController ctr = new GiftCodeController(new ApexPages.StandardController(acc));
        ctr.cancel();
        ctr = new GiftCodeController(new ApexPages.StandardController(acc));
        ctr.giftCodeSend.Count__c = '1';
        ctr.sendby.setMethods(new String[]{EMAIL, SMS, READ});  
        system.assert(ctr.title == System.Label.GIFT_SendGiftCode + ' Robert John');
        ctr.save();
        system.assert(ApexPages.getMessages().size()==0);   
    }
    
    static testMethod void testValidation(){    
        Address__c add = new Address__c(Street__c = 'Main Street', 
            Town__c = 'Leeds', Postcode__c = 'LS1');
        insert add;
        
        Account acc = new Account(FirstName = 'Robert', LastName = 'John', Street_YK__c = add.Id, 
            Customer_No__c = '4444');           
        insert acc;
        
        Gift_Code__c gift = new Gift_Code__c();
        gift.Batch_Number__c= '0000'; 
        gift.Code__c = '0004'; 
        gift.Valid_From__c = System.today();
        gift.Valid_To__c =  System.today().addDays(5);     
        gift.Status__c = ACTIVE;        
        insert gift;
        
        gift = new Gift_Code__c();
        gift.Batch_Number__c= '0001'; 
        gift.Code__c = '0005'; 
        gift.Valid_From__c = System.today();
        gift.Valid_To__c =  System.today().addDays(5);     
        gift.Status__c = ACTIVE;
        insert gift;
        
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('accid',acc.id);    
        GiftCodeController ctr = new GiftCodeController(new ApexPages.StandardController(acc));
        ctr.cancel();
        ctr = new GiftCodeController(new ApexPages.StandardController(acc));
        ctr.giftCodeSend.Count__c = '1';                   
        ctr.save();
        system.assert(ApexPages.getMessages().size()==1);       
        ctr.sendby.setMethods(new String[]{EMAIL, SMS, READ});
        ctr.giftCodeSend.Email__c = null;   
        ctr.save();     
        system.assert(ApexPages.getMessages().size()==3);       
    }
    
    static testMethod void testSmsNumber(){     
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
    }    
}