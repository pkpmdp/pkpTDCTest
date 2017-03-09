public with sharing class CasesCloseOverrideController {
    private static final String EMAIL_MSG_STATUS_NEW = '0';
    private final Case caseRecord;
    private final Id caseId;
    public final String backLink {get; private set;}
    public final String closeCaseLink {get; private set;}

    public CasesCloseOverrideController(ApexPages.StandardController stdController) {
        this.caseRecord = (Case)stdController.getRecord();
        this.caseId = this.caseRecord.Id;
        this.backLink = '/' + this.caseId;
        this.closeCaseLink = '/' + this.caseId + '/s?retURL=/' + this.caseId;
    }

    public PageReference closeOverride() {
        List<EmailMessage> emails = [SELECT Id FROM EmailMessage WHERE ParentId = :this.caseId AND Status = :EMAIL_MSG_STATUS_NEW LIMIT 1];
        if(emails.size() > 0) {
            return null;
        }

        return new PageReference(this.closeCaseLink);
    }
}