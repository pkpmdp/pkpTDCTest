public with sharing class BB_GiftCodeController {
    /*
     * Changes done for SPOC-2213: Using original objects
    */    
    public Gift_Code_Send__c giftCodeSend {get; set;}
    public Account customer{get;set;}
    public Contact customerCont{get;set;}
    public String title {
        get {
            return System.Label.BB_GIFT_SendGiftCode + ' ' + customer.Name;
        } 
        set;
    } 
    public static final String EMAIL = 'EMAIL'; 
    public static final String READ = 'READ'; 
    
    public static final String EMAILERRORMSG = System.Label.GIFT_Err_Email;
    public static final String SMSERRORMSG =  System.Label.GIFT_Err_Sms;
    public static final String SENDBYERRORMSG =  System.Label.GIFT_Err_SendBy;
    public static final String COUNTERROR = System.Label.GIFT_Err_Count;
    public static final String NOCODES = System.Label.GIFT_Err_NoCodes;
    public static final String EXPIRATION = System.Label.GIFT_Expiration + ' ';
    public static final String ORDERED = System.Label.ORDERED;
    public static final String ACTIVE = System.Label.BB_Active;
   // public static final String EMAIL_FROM = '0D2M0000000013p';//Block Buster service Test with vijay.sonawane@capgemini.com
   public static final String EMAIL_FROM = System.Label.Blockbuster_Support;//Block Buster service
    
    public static final String DANISHPHONEPREF = '45';
    public static final String SMSFORMATERROR = System.Label.GIFT_Sms_Format;
    public static final String TESTEMAIL = 'uoh@yousee.dk'; 
        
    public class IntegrateException extends Exception {}    
    public class ValidationException extends Exception {}
    public class SmsFormatException extends Exception {}
        
    public SendBy sendby;
    List<Coder> codes;
    
    public String defaultVal;
    
    public virtual class Coder { 
        public String value {get; set;}
        public Date validTo {get; set;}
        
        public Coder(String value, Date validTo){
            this.value = value;
            this.validTo = validTo; 
        }     
        public virtual String getString(){
            return value +  EXPIRATION + validTo.format();
        } 
    }
    
    public class SendBy {
        public boolean byEmail = false;
        public boolean bySms = false;
        public boolean byRead = false;
        String[] methods = new String[]{};
                    
        public List<SelectOption> getItems() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption(EMAIL,System.Label.GIFT_Send_Email));
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
    
    public virtual class EmailTemplater extends Templater {
        public EmailTemplater(Gift_Code_Send__c gfSend, Account customer, List<Coder> codes,Gift_Code__c gift){           
            super( gfSend, customer, codes,gift);
        }
        
        public override String getTemplateName(){
            return System.Label.BB_Template;
        }
        
        public override void substBody(){
            /*
            '{!Account.Name}'
            '{!BB_Gift_Code__c.Code__c}'
            '{!Today}'
            */
            setGiftWords();
            if(emailTemplate.markup!=null){
              emailTemplate.markup = emailTemplate.markup.replace('{!recipient.Name}',
                customer.Name).
                replace('{!relatedTo.Code_Formatted__c}',getCodesValueFormated()).
                replace('<apex:outputText value="{0, date, dd-MM-yyyy}"><apex:Param value="{!relatedTo.Valid_To__c}" /></apex:OutputText>',gift.Valid_To__c.format());
               // System.debug('markup=> '+emailTemplate.markup);
            } 
            
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
            emailTemplate = [select id, body, htmlvalue, subject, markup from EmailTemplate 
             where developerName =: getTemplateName()];
            // System.debug('emailTemplate => @@@@@@@'+ emailTemplate);
            substBody();                        
        }
        
        protected void setGiftWords(){
            //giftword = codes.size()>1 ? 'gavekoder': 'gavekode';
            //giftword2 = codes.size()>1 ? 'Gavekoderne' : 'Gavekoden';
            giftword = codes.size()>1 ? 'dine filmkoder': 'din filmkode';
            giftword2 = codes.size()>1 ? 'Koderne' : 'Koden';
        }
        
        public abstract String getTemplateName();
        
        public String getTemplateId(){
            return emailTemplate.id;
        }
        public String getMarkup(){
            return emailTemplate.markup;
        }
        public String getCodesValueFormated(){
            String codeFormated = '';
            for ( Coder code :  codes ){
                codeFormated = codeFormated + '\n' + code.value;
            }
            System.debug('codeFormated value=> '+codeFormated);
            return codeFormated;
        } 
        
        
        public abstract void substBody();
        
    }
        
    public BB_GiftCodeController (ApexPages.StandardController controller) {
        // to get default value of picklist
        
         Schema.DescribeFieldResult F = Gift_Code_Send__c.Count__c.getDescribe();
         List <Schema.PicklistEntry> pickVals = F.getPicklistValues();
         for (Schema.PicklistEntry av: pickVals) {
            if (av.isDefaultValue()) {
                defaultVal = av.getValue();
                system.debug('Default value is' + defaultVal);
        }
        }
            
 
 
        sendby = new SendBy();
        codes = new List<Coder>();
        giftCodeSend = new Gift_Code_Send__c ();     
        customer = [SELECT Id, Name, PersonEmail, PersonMobilePhone  FROM Account 
            WHERE Id =: ApexPages.currentPage().getParameters().get('accid')];
        customerCont = [SELECT Id,Email FROM Contact WHERE AccountId =:customer.Id];
        giftCodeSend.Customer__c = customer.Id;
        //For testing purposes:     
        giftCodeSend.Email__c = customer.PersonEmail;
        system.debug('Default value is' + giftCodeSend.Email__c);
        //Production:
        giftCodeSend.Count__c = defaultVal;  
        
        
    }
    
    public String getCodesValueFormated(){
        String codeFormated = '';
        for ( Coder code :  codes ){
            codeFormated = codeFormated + ',' + code.value;
        }
        codeFormated = codeFormated.substring(codeFormated.indexOf(',')+1);
        System.debug('codeFormated value 1=> '+codeFormated);
        return codeFormated;
    }
    
    public void validate(){ 
        //SPOC-2213: As default is 1.
          Integer co=0;      
        try {
          
          co = integer.valueOf(defaultVal);
            System.debug('check'+co);
        } catch (System.Exception e) { 
            throw new ValidationException(COUNTERROR);
        } 
        if (sendby.getMethods().size()==0){
            System.debug('check for default value'+co);
            ApexPages.addMessages(new ValidationException(SENDBYERRORMSG));
        }
        else {
            for (String method : sendby.getMethods()){
                if (method == EMAIL ){ 
                    sendby.byEmail = true;
                    if ( giftCodeSend.Email__c==null){
                        ApexPages.addMessages(new ValidationException(EMAILERRORMSG));
                    }
                }else if( method == READ ) { 
                    sendby.byRead = true;
                    giftCodeSend.Readed__c = sendby.byRead;                                     
                }                   
            }           
        }
    }    
    
    public PageReference save() {
        //String smsResponse = null;
        validate();
       
        if (ApexPages.getMessages().size()>0) return null;
        //SPOC-2213: As default is 1
        Integer expectedCount = Integer.valueOf(defaultVal);
        Savepoint sp = Database.setSavepoint();         
        
        Gift_Code_Send__c gfSend = new  Gift_Code_Send__c();
        //Check for deauflt ***********
        //gfSend.Count__c = giftCodeSend.Count__c;
        gfSend.Count__c = defaultVal;
        System.debug('Count '+ giftCodeSend.Count__c);
        gfSend.Customer__c = giftCodeSend.Customer__c;
        gfSend.Email__c = sendby.byEmail==true ? giftCodeSend.Email__c : null;
        gfSend.Readed__c = giftCodeSend.Readed__c;
        gfSend.Reason__c = giftCodeSend.Reason__c;
        insert gfSend;
                
        Gift_Code__c gift; 
        System.debug('ACTIVE '+ACTIVE)   ; 
        //SPOC : Chagned query to limit 1
        for (sObject oneObject : Database.query('SELECT Id, Code__c, Customer__c, ' + 
        ' Gift_Code_Send__c, Ordered_by__c, Ordered_Date__c, Status__c,Valid_To__c '+
        ' FROM Gift_Code__c WHERE Status__c = \''+ String.escapeSingleQuotes(ACTIVE) + '\'' + 
        ' limit '+defaultVal+'FOR UPDATE' )) {
            gift = (Gift_Code__c)oneObject;
            codes.add(new Coder(gift.Code__c , gift.Valid_To__c));
            gift.Code_Formatted__c = getCodesValueFormated();
            gift.Customer__c = giftCodeSend.Customer__c;
            gift.Gift_Code_Send__c = gfSend.Id;
            gift.Ordered_by__c = UserInfo.getUserId();
            gift.Ordered_Date__c =System.today();
            gift.Status__c = ORDERED;
            
            update gift;            
        }
        System.debug('codes=> '+codes);
        //Check for deauflt ***********
        if (codes.size()!=expectedCount){           
            Database.rollback(sp);      
            ApexPages.addMessages(new ValidationException(NOCODES));
            return null;    
        }               
        if (sendby.byEmail){
            sendEmail(gfSend,gift);
        }
        /*if (sendby.bySms || sendby.byEmail){
            //Not possiblle do http callout without commit DML!
            return getResultPage(gfSend);
        }   */    
        return getResultPage(gfSend);            
    }
       
    private void sendEmail(Gift_Code_Send__c gfSend, Gift_Code__c gift){
        String[] toaddress = new String[]{};
        toaddress.add(giftCodeSend.Email__c);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //mail.setReplyTo(EMAIL_FROM);
        setOrgEmailAddress(mail);
        if(toaddress[0]!=customerCont.Email){
            mail.setToAddresses(toaddress);
        }
        EmailTemplater emailTemp = new EmailTemplater(gfSend,customer,codes,gift); 
        mail.setTemplateId(emailTemp.getTemplateId());
        mail.setTargetObjectId(customerCont.Id);
        mail.setWhatId(gift.Id);
        mail.setSaveAsActivity(false);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });       
    }
    
    private void setOrgEmailAddress(Messaging.SingleEmailMessage mail){ 
        OrgWideEmailAddress owa = [select id, Address, DisplayName  
            from OrgWideEmailAddress where id =: EMAIL_FROM];
        mail.setOrgWideEmailAddressId(owa.id);
        /*for(OrgWideEmailAddress owa : [select id, Address, DisplayName  
            from OrgWideEmailAddress]) {
            if(owa.id  == EMAIL_FROM) 
                mail.setOrgWideEmailAddressId(owa.id); 
        }*/
    }    
    
    private PageReference getResultPage(Gift_Code_Send__c gfSend){
        PageReference parentPage = new PageReference('/apex/BBGiftCodeResult?id='+gfSend.id);
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
    
   
    
}