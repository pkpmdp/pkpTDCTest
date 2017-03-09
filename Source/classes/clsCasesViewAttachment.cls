public with sharing class clsCasesViewAttachment {
    
    private Attachment attachment;
    private Boolean render;
    private Boolean renderLink;
    private Boolean renderMoreThanOneF;
    private Id caseId;
    
    public clsCasesViewAttachment(ApexPages.StandardController controller) {

        caseId = controller.getId();

        render = false;
        renderMoreThanOneF = false;

        // Try attachments linked to email messages - these are not directly linked to the case
        for (EmailMessage message : [Select Id, Incoming, HasAttachment, (Select Id, CreatedDate, ContentType, BodyLength From Attachments) From EmailMessage Where Incoming = true And HasAttachment = true And ParentId = :controller.getId() Order By CreatedDate DESC Limit 1]) {
            if (message.Attachments.size() > 0) {
                attachment = message.Attachments.get(0);
                render = true;
            }
        }

        // Now get the attachments that are linked directly to the case
        List<Attachment> attachList = [Select Id, CreatedDate, ContentType, BodyLength From Attachment Where ParentId = :controller.getId() Order By BodyLength DESC Limit 2];         
        if (attachList.size() > 1) {
            renderMoreThanOneF = true;
        }

        Attachment attach;

        if (attachList.size() > 0) {
            attach=attachList.get(0);
        }

        // Now get the attachments that are linked directly to the case
        if (attachment == null) {
            attachment = attach;
            render = true;  
        } else {
            if (attachment.CreatedDate < attach.CreatedDate) {
                attachment = attach;
            }
        }

        //Attachment selected, is format supported to display?
        if (attachment != null ) {
            if (attachment.contentType !='image/gif' && attachment.contentType !='text/plain' &&
                attachment.contentType !='image/png' && attachment.contentType !='image/jpeg' &&
                attachment.contentType !='image/jpg' && attachment.contentType !='application/pdf' &&
                attachment.contentType != 'image/bmp' && attachment.contentType != 'application/octet-stream' &&
                attachment.contentType !='text/xml') {
                render=false;
                renderLink=true;
            } else {
                renderLink=false;
            }
        }

        /*
        // Try attachments linked to email messages - these are not directly linked to the case
        List<EmailMessage> messages = [Select Id, Incoming, HasAttachment, (Select Id From Attachments) From EmailMessage Where Incoming = true And HasAttachment = true And ParentId = :controller.getId() Order By CreatedDate DESC Limit 1];
        Map<Id, Attachment> messageAttachments = new Map<Id, Attachment>([Select Id, CreatedDate, OwnerId, Name, IsPrivate, ContentType, Body From Attachment  where parentId = :messages[0].Id]);
        Attachment messageAttachment;
        if(messages.size() > 0)
            if(messages[0].Attachments.size() > 0 )
                messageAttachment = messages[0].Attachments[0];
        
        List<Attachment> caseAttachments = [Select Id, CreatedDate From Attachment Where ParentId = :controller.getId() Order By CreatedDate DESC Limit 1];
        Attachment caseAttachment;
        if(caseAttachments.size() > 0)
            caseAttachment = caseAttachments[0];
            
        if (messageAttachment == null) {
            
            if(caseAttachment != null){
                attachment = caseAttachment;
                render = true;  
            }
        
        } else if(caseAttachment == null){
                
            Attachment newAttachment = new Attachment();
            newAttachment.ParentId = caseId;
            newAttachment.OwnerId = messageAttachments.get(messageAttachment.Id).OwnerId ;
            newAttachment.Name = messageAttachments.get(messageAttachment.Id).Name ; 
            newAttachment.IsPrivate = messageAttachments.get(messageAttachment.Id).IsPrivate ;
            newAttachment.ContentType = messageAttachments.get(messageAttachment.Id).ContentType ;
            newAttachment.Body = messageAttachments.get(messageAttachment.Id).Body;
            insert newAttachment;
            
            attachment = newAttachment;
            render = true;  
            
        }
        else{
            
            if (messageAttachment.CreatedDate < caseAttachment.CreatedDate) {
                attachment = caseAttachment;
            }
            else{
                
                Attachment newAttachment = new Attachment();
                newAttachment.ParentId = caseId;
                newAttachment.OwnerId = messageAttachments.get(messageAttachment.Id).OwnerId ;
                newAttachment.Name = messageAttachments.get(messageAttachment.Id).Name ; 
                newAttachment.IsPrivate = messageAttachments.get(messageAttachment.Id).IsPrivate ;
                newAttachment.ContentType = messageAttachments.get(messageAttachment.Id).ContentType ;
                newAttachment.Body = messageAttachments.get(messageAttachment.Id).Body;
                insert newAttachment;
                
                attachment = newAttachment;
                render = true;  
                
                
            }
        }
        */
               
    }
     
    public Attachment getAttachment() {
        return attachment;
    }

    public Boolean getRender() {
        return render;
    }

    public Boolean getRenderLink() {
        return renderLink;
    }

    public Boolean getRenderMoreThanOneF() {
        return renderMoreThanOneF;    
    }
}