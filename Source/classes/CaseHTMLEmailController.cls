public with sharing class CaseHTMLEmailController {
    /*private Case caseObj;

    public CaseHTMLEmailController(ApexPages.StandardController stdController) {
        this.caseObj = (Case)stdController.getRecord();
        this.caseObj = [SELECT Origin, Description From Case where id = : caseObj.id];
    }

    public String lastHTMLEmail { get
        {return getLastHTMLEmail(); }
    }
    
    public String getLastHTMLEmail() {
        if(caseObj.Origin != 'Email') {
            return caseObj.Description;
        } else {
            EmailMessage lastEmail = [SELECT TextBody, HtmlBody FROM EmailMessage WHERE ParentId=:caseObj.Id AND Incoming = true ORDER BY LastModifiedDate DESC LIMIT 1];
            if (lastEmail != null) {
    
                String emailBody;
                if(lastEmail.HtmlBody != null) {
                    emailBody = lastEmail.HtmlBody;
                } else if(lastEmail.TextBody != null) {
                    emailBody = lastEmail.TextBody;
                } else {
                    emailBody = '';
                }
    
                return emailBody;
            }
            
            return '';
        }
    }*/
}