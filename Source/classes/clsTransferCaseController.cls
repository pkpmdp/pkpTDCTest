public with sharing class clsTransferCaseController{
    public String to{get;set;}
    public String additionalTo{get;set;}
    public String cc{get;set;}
    public String bcc{get;set;}
    public String subject{get;set;}
    public String body{get;set;}
    public List<Attachment> attachments{get;set;}
    private String caseId;
    private String accountId;
    private String contactId;
    public static final String TEMP_EMAIL = 'no-reply@salesforce.com';
    public static final String TEMP_PHONE = '-';
    
    public class ApplicationException extends Exception {}
    
    //constructor
    public clsTransferCaseController() {
    }

    public PageReference initialise(){
        Savepoint sp = Database.setSavepoint();

        caseId=ApexPages.currentPage().getParameters().get('id');
        attachments = [select id,BodyLength,Name,ContentType from Attachment where ParentId=:caseId];
        
        //prefill bcc with current user email
        User currentUser = [select Email from User where id=:UserInfo.getUserId()];
        bcc=currentUser.Email;

        //try to send email to evaluate email template body and subject
        Messaging.SingleEmailMessage tmpEmail = new Messaging.SingleEmailMessage();
        try{
            Case currentCase = [select AccountId from Case where id=:caseId];
            accountId = currentCase.AccountId;
            Contact fakeCon = null;

            if (this.accountId!=null){
                Account acc = [select PersonContactId,Phone,Company_Email__c from Account where id=:currentCase.AccountId];
                
                if (acc.PersonContactId!=null){//person account
                    Contact con = [select Email from Contact where id=:acc.PersonContactId];
                    contactId=con.Id; //controller property - used for creating activity history record
                    if (con.Email==null||con.Email==''){
                        String phone = (acc.Phone==null?TEMP_PHONE:acc.Phone);
                        String email = TEMP_EMAIL;
                        fakeCon = new Contact(Temporary_contact__c = true, FirstName='FirstName', LastName='LastName ' + caseId, Email=email, Phone=phone);
                        insert fakeCon;
                        tmpEmail.setTargetObjectId(fakeCon.Id);
                    } else {
                        tmpEmail.setTargetObjectId(acc.PersonContactId);
                    }    
                }
                else{//business account
                    String bussinessPhone = (acc.Phone==null?TEMP_PHONE:acc.Phone);
                    String bussinessEmail = (acc.Company_Email__c==null?TEMP_EMAIL:acc.Company_Email__c);
                    
                    fakeCon = new Contact(Temporary_contact__c = true, FirstName='FirstName', LastName='LastName ' + caseId, Email=bussinessEmail, Phone=bussinessPhone);
                    insert fakeCon;
                    tmpEmail.setTargetObjectId(fakeCon.Id); 
                }
            }
            else{
                    fakeCon = new Contact(Temporary_contact__c = true, FirstName='FirstName', LastName='LastName ' + caseId, Email=TEMP_EMAIL, Phone=TEMP_PHONE);
                    insert fakeCon;
                    tmpEmail.setTargetObjectId(fakeCon.Id); 
            }
            
            tmpEmail.setUseSignature(false);
            tmpEmail.setSaveAsActivity(false);
            
            //tmpEmail.setTargetObjectId('003M0000001UIZoIAO');
            //tmpEmail.setToAddresses(new String[]{bcc});
            
            tmpEmail.setWhatId(caseId);
            tmpEmail.setTemplateId('00X20000001Utkl');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { tmpEmail });
            body=tmpEmail.getPlainTextBody();
            subject=tmpEmail.getSubject();
            
            if (fakeCon!=null){
                delete fakeCon;
            }
            
            //throw an exception to cancel email sending
            throw new ApplicationException('Expected exception');
        }
        catch(Exception e){
            System.debug(e);
            
        }
        finally{
            Database.rollback(sp);
        }

        return null;
    }
    
    public PageReference sendEmail() {

        String[]toAddrs=parseEmailAddresses(to);
        String[]additionalToAddrs=parseEmailAddresses(additionalTo);
        String[]ccAddrs=parseEmailAddresses(cc);
        String[]bccAddrs=parseEmailAddresses(bcc);
        List<String> allEmailAddrs = new List<String>();
        allEmailAddrs.addAll(toAddrs);
        allEmailAddrs.addAll(additionalToAddrs);
        allEmailAddrs.addAll(ccAddrs);
        allEmailAddrs.addAll(bccAddrs);
         
        if(validateEmailAddresses(allEmailAddrs)){
            
            Set<Id> attachmentIds = new Set<Id>();
            for (Attachment att:attachments){
                attachmentIds.add(att.id);
            }
            List<Attachment> fullAttachments = [select id,BodyLength,Name,ContentType,Body from Attachment where Id IN :attachmentIds];
            
            //create transfer case object to disable automatic attachment duplication in attachment trigger tgrAttachmentAfterInsertUpdate
            Transfer_Case__c transferCase = new Transfer_Case__c(Case__c=caseId);
            insert transferCase;
              
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setUseSignature(true);
            email.setSaveAsActivity(true);
            
            //email.setTargetObjectId('003M0000001UIZo');
            
            //toAddresses
            List<String> toEmailAddrs = new List<String>();
            toEmailAddrs.addAll(toAddrs);
            toEmailAddrs.addAll(additionalToAddrs);
            
            email.setToAddresses(toEmailAddrs);
            email.setCcAddresses(ccAddrs);
            email.setBccAddresses(bccAddrs);
            
            email.setWhatId(caseId);
            email.setSubject(subject);
            email.setPlainTextBody(body);
            email.setFileAttachments(caseAtts2EmailAtts(fullAttachments)); 
         
            // Send the email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });

            //create record in EmailMessage 
            EmailMessage emailMessage = new EmailMessage();
            emailMessage.ToAddress=printList(toEmailAddrs);
            emailMessage.CcAddress=printList(ccAddrs);
            emailMessage.BccAddress=printList(bccAddrs);
            emailMessage.Subject=email.getSubject();
            emailMessage.TextBody=email.getPlainTextBody();
            emailMessage.ParentId=caseId;
            emailMessage.MessageDate = Datetime.now();
            emailMessage.Status = '3';//Sent

            //create record in Activity History
            Task activity = new Task();
            activity.RecordTypeId='01220000000TyI8AAK';
            activity.Type='Andet';
            activity.ActivityDate = System.today();
            //activity will be related also to account from case
            activity.WhoId=contactId;
            activity.Status = 'Completed';
            activity.WhatId = caseId;
            activity.Subject = 'Email: '+ email.getSubject();
            if(email.getSubject()!=null && email.getSubject().length()>73){
                activity.Subject = 'Email: '+ email.getSubject().substring(0,70)+'...';
            }
            activity.Description = 'Additional To: '+emailMessage.ToAddress+'\nCC: '+emailMessage.CcAddress+'\nBCC: '+emailMessage.BccAddress+'\nAttachment: '+printAttachmentList(attachments)+'\n\nSubject: '+emailMessage.Subject+'\nBody:\n'+emailMessage.TextBody;
            insert activity;

            emailMessage.ActivityId = activity.id;
            insert emailMessage;

            //insert attachments;
            List<Attachment> clonedAttachments = new List<Attachment>(); 
            for(Attachment att:fullAttachments){
                Attachment clonedAtt = att.clone(false,false);
                clonedAtt.ParentId=emailMessage.Id;
                clonedAttachments.add(clonedAtt);
            }
            
            insert clonedAttachments; 

            delete transferCase;
            
            String retUrl = ApexPages.currentPage().getParameters().get('retUrl');
            return new PageReference(retUrl);
        }
        return null;
    }

    public PageReference delAtt() {
        String attId = ApexPages.currentPage().getParameters().get('attId'); 
        Integer attIndex = findAttIndex(attId);
        attachments.remove(attIndex);
        return null;
    }
    public PageReference cancel() {
        String retUrl = ApexPages.currentPage().getParameters().get('retUrl');
        return new PageReference(retUrl);
    }
 
    private boolean validateEmailAddresses(String[] emails){
        boolean result = true;
        if (emails.size()==0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Email_Error_Address_Required));
            result = false;
        }
        for(String email:emails ){
            if (!Pattern.matches('^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$',email)){
                String errorMessage = String.format(Label.Email_Error_Invalid_Address,new String[]{email});
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
                result = false;
            }
        }
        return result;
    }
    
    private String[] parseEmailAddresses(String input){
        String[] result = new List<String>();
        if(input!=null && input!=''){
            String replaced = input.replace(',',';');
            String[] splitted = replaced.split(';');
    
            for(String item:splitted ){
                String trimmed=item.trim();
                if (trimmed!=null && trimmed!=''){
                    result.add(trimmed);
                }
            }
        }
        return result;
    }

    private List<Messaging.EmailFileAttachment> caseAtts2EmailAtts(List<Attachment> atts){
        List<Messaging.EmailFileAttachment> emailAttachments = new List<Messaging.EmailFileAttachment>();
        for(Attachment att:atts){
            Messaging.EmailFileAttachment emailAttach = new Messaging.EmailFileAttachment();
            emailAttach.setContentType(att.ContentType);
            emailAttach.setFileName(att.Name);
            emailAttach.setInline(false);
            emailAttach.Body = att.Body;
            emailAttachments.add(emailAttach);
        }
        return emailAttachments;
    }
    
    private Integer findAttIndex(String id){
        Integer result=null;
        Integer index = 0;
        for (Attachment a:attachments){
            if (a.Id==id){
                result = index;
                break;
            }
            index++;
        }
        return result;
    }
    
    private String printList(String[] items){
        String result='';
        String separator=';';
        boolean isFirst=true;
        for (String item:items){
            if(isFirst){
                isFirst=false;
            }
            else{
                result+=separator;
            }
            result+=item;
        }
        return result;
    }
    
    private String printAttachmentList(Attachment[] atts){
        String result='';
        String separator=', ';
        boolean isFirst=true;
        for (Attachment att:atts){
            if(isFirst){
                isFirst=false;
            }
            else{
                result+=separator;
            }
            result+=att.Name;
        }
        return result;
    }
    
}