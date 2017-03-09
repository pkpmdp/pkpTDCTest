public class clsCasesNpAuthorizationCreateController {

    private ApexPages.standardController controller {get; set;}
    private Case aCase;

    public NP_Order__c npOrder {get; set; }

    public clsCasesNpAuthorizationCreateController(ApexPages.StandardController stdController) {
        controller = stdController;
        aCase = (Case) stdController.getRecord();
        aCase.origin = clsCasesNpHandlerController.CASE_ORIGIN_WEB;
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
        aCase.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPEXPORT;
        aCase.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPEXPORT;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPEXPORT;

        npOrder = new NP_Order__c();
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPAUTHORIZATIONLETTER;
        npOrder.Authorization_Received__c = true;
    }

    /*
     * Override default save method
     */
    public PageReference save() {
        // Perform DB insert of the new NP Order and Case
        Savepoint savePt = Database.setSavepoint(); // store savepoint to make insert of npOrder and aCase atomic
        try {
            // Set default values and save
            npOrder.Authorization_Approved__c = false;
            npOrder.Disapproval_Reason__c = null;
            // Set more customer data by customer number
            if (npOrder.Customer_Number__c != null) {
                Account[] accs = [SELECT Name FROM Account WHERE Customer_No__c = :npOrder.Customer_Number__c];
                if (accs.size() > 0) {
                    npOrder.Customer_Name__c = accs[0].Name;
                }
            }
            insert npOrder;    // store NP Order

            aCase.Customer_Number__c = npOrder.Customer_Number__c;
            aCase.RecordTypeId = clsCasesNpHandlerController.getRecordTypeId(clsCasesNpHandlerController.RT_NPQUEUE);
            aCase.NP_Order__c = npOrder.id; // attach NP Order to case
            insert aCase; // store the Case record
            
        } catch (System.DmlException e) {
            ApexPages.addMessages(e);
            Database.rollback(savePt);
            return null;
        }
        return new PageReference('/apex/CasesTab');
    }
}