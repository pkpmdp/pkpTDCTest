public class clsCasesNpImportCreateController {

    private ApexPages.standardController controller {get; set;}
    private Case aCase;

    public NP_Order__c npOrder {get; set; }

    public clsCasesNpImportCreateController(ApexPages.StandardController stdController) {
        controller = stdController;
        aCase = (Case) stdController.getRecord();
        aCase.Origin = clsCasesNpHandlerController.CASE_ORIGIN_WEB;
        aCase.Status = clsCasesNpHandlerController.CASE_STATUS_NPRESERVED;
        aCase.Department__c = clsCasesNpHandlerController.CASE_DEPARTMENT_NPIMPORT;
        aCase.Product_2__c = clsCasesNpHandlerController.CASE_PRODUCT_NPIMPORT;
        aCase.Type_Task__c = clsCasesNpHandlerController.CASE_TYPETASK_NPIMPORT;

        npOrder = new NP_Order__c();
        npOrder.Status__c = clsCasesNpHandlerController.NPO_STATUS_NPORDERARRIVED;
   }

    /*
     * Override default save method
     */
    public PageReference save() {
        // Perform DB insert of the new Case
        Savepoint savePt = Database.setSavepoint(); // store savepoint to make insert of npOrder and aCase atomic
        try {
            // Set more customer data by customer number
            if (npOrder.Customer_Number__c != null) {
                Account[] accs = [SELECT Name FROM Account WHERE Customer_No__c = :npOrder.Customer_Number__c];
                if (accs.size() > 0) {
                    npOrder.Customer_Name__c = accs[0].Name;
                }
            }
            insert npOrder; // store NP Order

            aCase.Customer_Number__c = npOrder.Customer_Number__c;
            aCase.NP_Order__c = npOrder.id; // attach NP Order to case
            aCase.RecordTypeId = clsCasesNpHandlerController.getRecordTypeId(clsCasesNpHandlerController.RT_NPQUEUE);
            insert aCase; // store the Case record
        } catch (System.DmlException e) {
            ApexPages.addMessages(e);
            Database.rollback(savePt);
            return null;
        }
        return new PageReference('/apex/CasesTab');
    }
}