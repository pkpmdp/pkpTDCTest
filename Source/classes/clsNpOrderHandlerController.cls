public class clsNpOrderHandlerController {

    private ApexPages.standardController controller;
    private NP_Order__c npOrder;
    private ID caseId;
    
    public clsNpOrderHandlerController(ApexPages.StandardController stdController) {
        controller = stdController;
        npOrder = [
            SELECT Id, Cancellation_Reason__c FROM NP_Order__c
            WHERE Id = :((NP_Order__c) controller.getRecord()).Id
        ];
        caseId = null;
        Map<String, String> mapParams = ApexPages.currentPage().getParameters();
        if (mapParams.containsKey(clsCasesNpHandlerController.PARAM_CASE_ID)) {
            caseId = mapParams.get(clsCasesNpHandlerController.PARAM_CASE_ID);
        }
    }

    public PageReference save() {
        PageReference pageRef = controller.save();
        return caseId != null ? new PageReference('/' + caseId) : pageRef;
    }

    public PageReference cancel() {
        PageReference pageRef = controller.cancel();
        return caseId != null ? new PageReference('/' + caseId) : pageRef;
    }

    static testMethod void testSave() {
        // Use the PageReference Apex class to instantiate a page
        PageReference pageRef = Page.NpOrderCancellationReason;
        Test.setCurrentPage(pageRef);

        String aReason = 'Kunden annullerer ordren';

        // Instantiate a Case record
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Cancellation_Reason__c = null;
        npOrder.Telephone_Number__c = '911';
        npOrder.Customer_Number__c = '666';
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCREATED;
        insert npOrder;

        // Instantiate and construct the controller class.
        clsNpOrderHandlerController ctrl =
            new clsNpOrderHandlerController(new ApexPages.standardController(npOrder))
        ;

        // fill the Cancelation Reason value to NP Order record of the controller
        npOrder.Cancellation_Reason__c = aReason;

        // Save:
        pageRef = ctrl.save();
        // Check that the save() method doesn't return NULL (indicating a validation error)
        System.assertNotEquals(null, pageRef);

        // Get from DB and compare:
        NP_Order__c dbOrder = [SELECT Cancellation_Reason__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Cancellation_Reason__c, aReason);
    }

    static testMethod void testCancel() {
        // Use the PageReference Apex class to instantiate a page
        PageReference pageRef = Page.NpOrderCancellationReason;
        Test.setCurrentPage(pageRef);

        String aReason = 'Kunden annullerer ordren';

        // Instantiate a Case record
        NP_Order__c npOrder = new NP_Order__c();
        npOrder.Cancellation_Reason__c = null;
        npOrder.Telephone_Number__c = '911';
        npOrder.Customer_Number__c = '666';
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCREATED;
        insert npOrder;

        // Instantiate and construct the controller class.
        clsNpOrderHandlerController ctrl =
            new clsNpOrderHandlerController(new ApexPages.standardController(npOrder))
        ;

        // fill the Cancelation Reason value to NP Order record of the controller
        npOrder.Cancellation_Reason__c = aReason;

        // Cancel:
        pageRef = ctrl.cancel();
        // Check that the cancel() method doesn't return NULL (indicating a validation error)
        System.assertNotEquals(null, pageRef);

        // Get from DB and compare:
        NP_Order__c dbOrder = [SELECT Cancellation_Reason__c FROM NP_Order__c WHERE Id = :npOrder.Id];
        System.assertEquals(dbOrder.Cancellation_Reason__c, null);
    }
}