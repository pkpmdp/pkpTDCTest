global class clsNpBatchSendConfirmationReminderEmails implements Database.batchable<Case> {
    // Sends out first ot second confirmation reminder email messages in batches (Total number of sendEmail methods allowed is 10)
    // Usage:
    // clsNpBatchSendConfirmationReminderEmails batch = new clsNpBatchSendConfirmationReminderEmails(casesToRmndrData);
    // Database.executeBatch(batch, 10);

    // A container to store data necessary for confirmation reminders
    global class RmndrData {
        RmndrData() {}
        public RmndrData(Id contactId, String template) {
            contId = contactId;
            tmpl = template;
        }
        public Id contId {get; set;}
        public String tmpl {get; set;}
    }

    Map<Id, RmndrData> casesToRmndrData {get; set;}

    // Custom Iterator on a list of Cases
    global class NpIterator implements Iterator<Case> {
        List<Case> cases {get; set;}
        Integer i {get; set;}

        public NpIterator(List<Case> cList) {
            cases = cList;
            i = 0;
        }

        global boolean hasNext() {
            return (i >= cases.size()) ? false : true;
        }

        global Case next() {
            if (hasNext()) {
                i = i+1;
                return cases[i-1];
            } else {
                return null;
            }
        }
    }

    // Custom Iterable on a list of Cases
    global class NpIterable implements Iterable<Case> {
        List<Case> cases {get; set;}
        public NPIterable(List<Case> cList) {
            cases = cList;
        }

        global Iterator<Case> Iterator() {
            return new NpIterator(cases);
        }
    }

    // Constructor
    global clsNpBatchSendConfirmationReminderEmails(Map<Id, RmndrData> aMap) {
        casesToRmndrData = aMap;
    }

    // START method
    global Iterable<Case> start(Database.batchableContext bc) {
        // Prepare the Iterable to be passed to the execute method
        List<Case> cases = new List<Case>();
        if (casesToRmndrData != null) {
            for (Id caseId : casesToRmndrData.keySet()) {
                RmndrData rd = casesToRmndrData.get(caseId);
                Case aCase = new Case();
                // unable to set the Id field directly -> let's use RecordTypeId field for this purpose
                aCase.RecordTypeId = caseId; // caseId
                aCase.AccountId = rd.contId; // contactId
                aCase.Alternate_Name__c = clsNPEmailSender.getTemplateIdByName(rd.tmpl); // template
                cases.add(aCase);
            }
        }
        return new NpIterable(cases);
    }

    // EXECUTE method
    global void execute(Database.batchableContext bc, List<Case> scope) {
        // Send email message for all NP Cases in the scope
        for (Case aCase : scope) {
            // aCase.AccountId         = Contact Id
            // aCase.RecordTypeId      = Case Id
            // aCase.Alternate_Name__c = Email template Id
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(aCase.AccountId);     // contact Id - who is going to receive the email
            mail.setWhatId(aCase.RecordTypeId);          // related case Id
            mail.setTemplateId(aCase.Alternate_Name__c); // email template Id
            clsNPEmailSender.setDefaultPropertiesToEmail(mail);

            clsNPEmailSender sender = new clsNPEmailSender(mail);
            sender.sendMessage();            
        }
    }

    // FINISH method
    global void finish(Database.batchableContext bc) {
        // Do nothing
    }

    public static testMethod void testExecuteBatch(){
        Test.startTest();
        // Prepare a Customer
        Account acc = new Account(name='John Doe');
        acc.Dummy_Account__c = true;
        insert acc;

        // Prepare a Contact
        String CustomerEmailNp= 'banana@banana.net';
        Contact cnt = new Contact(FirstName='John', LastName = 'Doe');
        cnt.Temporary_contact__c = true;
        cnt.AccountId = acc.Id;
        cnt.Email = CustomerEmailNp;
        cnt.HomePhone = '12345678';
        insert cnt;

        NP_Order__c order = new NP_Order__c();
        insert order;

        // Instantiate a Case
        Case aCase = new Case();
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NEW;
        aCase.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT;
        aCase.AccountId = acc.id;
        aCase.NP_Order__c = order.Id;
        insert aCase;

        Map<Id, RmndrData> aMap = new Map<Id, RmndrData>();
        aMap.put(aCase.Id, new RmndrData(cnt.id, clsNPEmailSender.TMPL_NOTIFICATION_0_3));
        clsNpBatchSendConfirmationReminderEmails batch = new clsNpBatchSendConfirmationReminderEmails(aMap);
        Database.executeBatch(batch, 10);
        Test.stopTest();
    }
}