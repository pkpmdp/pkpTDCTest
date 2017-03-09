public class clsOpenCaseInfoYKController {

    private Boolean showWarning;

    public clsOpenCaseInfoYKController(ApexPages.StandardController controller) {
        Account account = (Account) controller.getRecord();
        List<Case> cases = [SELECT Id FROM Case
            WHERE AccountId = :account.Id
            AND IsClosed = false
            AND isQueueCase__c = 'True'
            //AND Department__c IN ('YK', 'YKFS', 'YKRB', 'YKRL', 'YKRS')
            LIMIT 1
        ];
        showWarning = cases.size() > 0;
    }

    public Boolean getShowWarning() {
        return showWarning;
    }

    public String getInfo() {
        return getShowWarning() ? System.Label.Yes : System.Label.No;
    }

    static testMethod void testAll() {
    	
    	YouSeeCustomSettings__c setting = new YouSeeCustomSettings__c();
		setting.Name = 'No_case_assignment_customerinformation';
		setting.Setting_Value__c = '00e20000001UQ6D,00e20000000vfam';
		insert setting;
		
        Decimal TESTNUM = 68999998;
        CustomerNumberSeq__c custSeq = new  CustomerNumberSeq__c();
        custSeq.lastNumber__c = TESTNUM;
        insert custSeq;
        // No cases
        Account acc = new Account(FirstName='John', LastName='Doe');
        acc.PersonEmail = null;
        acc.PersonMobilePhone = null;
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YK Customer Account'].Id;
        insert acc;
        clsOpenCaseInfoYKController ctrl =
            new clsOpenCaseInfoYKController(new ApexPages.standardController(acc))
        ;
        System.assert(!ctrl.getShowWarning());
        System.assertEquals(ctrl.getInfo(), System.Label.No);

        // An open case not owned by a queue
        Case aCase = new Case();
        aCase.Department__c = 'YOT';
        aCase.AccountId = acc.id;
        insert aCase;
        ctrl = new clsOpenCaseInfoYKController(new ApexPages.standardController(acc));
        System.assert(!ctrl.getShowWarning());
        System.assertEquals(ctrl.getInfo(), System.Label.No);

        // Select an existing queue
        QueueSobject q = [Select QueueId FROM QueueSobject WHERE SobjectType = 'Case' LIMIT 1];

        // An open case from YK owned by a queue
        Case ykCase = new Case();
        ykCase.Department__c = 'YK';
        ykCase.AccountId = acc.id;
        ykCase.OwnerId = q.QueueId;
        insert ykCase;
        ctrl = new clsOpenCaseInfoYKController(new ApexPages.standardController(acc));
        System.assert(ctrl.getShowWarning());
        System.assertEquals(ctrl.getInfo(), System.Label.Yes);
    }
}