public class GiftCodesSchedulerImpl {

    public static String STATUS_ACTIVE   = 'Active';
    public static String STATUS_INACTIVE = 'Inactive';
    public static String STATUS_ORDERED  = 'Ordered';
    public static String STATUS_USED     = 'Used';
    public static final String EMAIL_FROM = 'Kundeservice';

    public void runJob() {
        updateCodeStatus();
        sendMail();
    }

    private void sendTextEmail(String email) {
        String[] toaddress = new String[]{};
        toaddress.add(email);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        setOrgEmailAddress(mail);
        mail.setToAddresses(toaddress);
        mail.setsubject('Gift Codes');
        mail.setPlainTextBody('New Gift Codes needed.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

    private void sendMail() {
        List<Gift_Code__c> giftCodes = [SELECT id, Status__c FROM Gift_Code__c WHERE Status__c=:STATUS_ACTIVE];
        Gift_Codes_Config__c config = Gift_Codes_Config__c.getInstance('GiftCodes');
        if (config != null && giftCodes.size() < config.Limit_Value__c) {
            String email = config.Email__c;
            if (email != null) {
                User user = [SELECT id, email FROM User WHERE email=:email];
                if (user != null) {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    setOrgEmailAddress(mail);
                    mail.setTargetObjectId(user.Id);
                    mail.setTemplateId([SELECT id FROM EmailTemplate WHERE developerName = 'Low_State_Alert'].id);
                    mail.setSaveAsActivity(false);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                } else {
                    sendTextEmail(email);
                }
            }
        }
    }

    private void updateCodeStatus() {
        List<Gift_Code__c> giftCodes = [
            SELECT id, Valid_From__c, Valid_To__c, Status__c FROM Gift_Code__c
            WHERE (Valid_From__c <= today AND Valid_To__c >= today AND Status__c NOT IN (:STATUS_ACTIVE, :STATUS_ORDERED, :STATUS_USED)) OR
                ((Valid_From__c > today OR Valid_To__c < today) AND (Status__c = :STATUS_ACTIVE or Status__c = null)) FOR UPDATE
        ];

        Integer activeUpdateCount = 0;
        Integer inactiveUpdateCount = 0;
        for (Gift_Code__c giftCode : giftCodes) {
            if (giftCode.Valid_From__c <= date.today() && giftCode.Valid_To__c >= date.today() &&
                giftCode.Status__c != STATUS_ACTIVE &&
                giftCode.Status__c != STATUS_ORDERED &&
                giftCode.Status__c != STATUS_USED
            ){
                giftCode.Status__c = STATUS_ACTIVE;
                activeUpdateCount++;
            }

            if ((giftCode.Valid_From__c > date.today() || giftCode.Valid_To__c < date.today()) &&
                (giftCode.Status__c == STATUS_ACTIVE || giftCode.Status__c == null)
             ){
                giftCode.Status__c = STATUS_INACTIVE;
                inactiveUpdateCount++;
             }
        }
        System.debug('activeUpdateCount: ' + activeUpdateCount + ' inactiveUpdateCount: ' + inactiveUpdateCount);
        update giftCodes;
    }

    private void setOrgEmailAddress(Messaging.SingleEmailMessage mail){ 
        for (OrgWideEmailAddress owa : [SELECT id, Address, DisplayName FROM OrgWideEmailAddress]) {
            if (owa.DisplayName  == EMAIL_FROM)
                mail.setOrgWideEmailAddressId(owa.id);
        }
    }

    public static testMethod void testScheduler() {
        Test.startTest();

        List<Gift_Codes_Config__c> items = [SELECT Name FROM Gift_Codes_Config__c];
        if (items == null || items.size() == 0) {
            Gift_Codes_Config__c configTmp = new Gift_Codes_Config__c();
            configTmp.Name = 'GiftCodes';
            configTmp.Email__c = 'mimac@yousee.dk';
            configTmp.Limit_Value__c = 1000;
            insert configTmp;
        }

        Gift_Code__c code = new Gift_Code__c();
        code.Valid_From__c = date.today();
        code.Valid_To__c = date.today();
        code.Status__c = STATUS_INACTIVE;
        code.Batch_Number__c = '1';
        code.Code__c = '1';
        insert code;

        code = new Gift_Code__c();
        code.Valid_From__c = date.today().addDays(2);
        code.Valid_To__c = date.today();
        code.Status__c = STATUS_ACTIVE;
        code.Batch_Number__c = '1';
        code.Code__c = '2';
        insert code;

        GiftCodesSchedulerImpl job = new GiftCodesSchedulerImpl();
        job.runJob();

        Gift_Codes_Config__c config = Gift_Codes_Config__c.getInstance('GiftCodes');
        String email = config.Email__c;
        job.sendTextEmail(email);

        List<Gift_Code__c> giftCodesInactive = [
            SELECT id, Valid_From__c, Valid_To__c, Status__c FROM Gift_Code__c
            WHERE Valid_From__c < today AND Valid_To__c > today AND Status__c =:STATUS_INACTIVE
        ];
        System.assertEquals(0, giftCodesInactive.size());    

        List<Gift_Code__c> giftCodesActive = [
            SELECT id, Valid_From__c, Valid_To__c, Status__c FROM Gift_Code__c
            WHERE (Valid_From__c > today OR Valid_To__c < today) AND Status__c =:STATUS_ACTIVE
        ];
        System.assertEquals(0, giftCodesActive.size());    

        Test.stopTest();
    }
}