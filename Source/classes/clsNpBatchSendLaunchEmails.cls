public class clsNpBatchSendLaunchEmails { // just an empty class
/* MADE OBSOLETE BY NP-162
global class clsNpBatchSendLaunchEmails implements Database.batchable<Case> {
    // Sends out launch email messages in batches (Total number of sendEmail methods allowed is 10)
    // Usage:
    // clsNpBatchSendLaunchEmails batch = new clsNpBatchSendLaunchEmails(caseToContactMap);
    // Database.executeBatch(batch, 10);

    String templateId {get; set;}
    Map<Id, Id> caseToContactMap {get; set;}

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
    global clsNpBatchSendLaunchEmails(Map<Id, Id> aMap) {
        templateId = clsNPEmailSender.getTemplateIdByName(clsNPEmailSender.TMPL_INPORT_LAUNCHED);
        caseToContactMap = aMap;
    }

    // START method
    global Iterable<Case> start(Database.batchableContext bc) {
        // Prepare the Iterable to be passed to the execute method
        List<Case> cases = new List<Case>();
        if (caseToContactMap != null) {
            for (Id caseId : caseToContactMap.keySet()) {
                Case aCase = new Case();
                // unable to set the Id field directly -> let's use RecordTypeId field for this purpose
                aCase.RecordTypeId = caseId; // caseId
                aCase.AccountId = caseToContactMap.get(caseId); // contactId
                cases.add(aCase);
            }
        }
        return new NpIterable(cases);
    }

    // EXECUTE method
    global void execute(Database.batchableContext bc, List<Case> scope) {
        // Send email message for all NP Cases in the scope
        for (Case aCase : scope) {
            // aCase.AccountId    = Contact Id
            // aCase.RecordTypeId = Case Id
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(aCase.AccountId); // contact Id - who is going to receive the email
            mail.setWhatId(aCase.RecordTypeId);      // related case Id
            mail.setTemplateId(templateId);          // email template Id
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

        Map<Id, Id> aMap = new Map<Id, Id>();
        aMap.put(aCase.Id, cnt.Id);
        clsNpBatchSendLaunchEmails batch = new clsNpBatchSendLaunchEmails(aMap);
        Database.executeBatch(batch, 10);
        Test.stopTest();
    }
MADE OBSOLETE BY NP-162 */
}