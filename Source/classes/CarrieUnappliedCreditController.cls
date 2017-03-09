/***********************************************************************************
************************************************************************************

* @class: CarrieUnappliedCreditController
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 10/06/2012
* @description: Class is used to display all the UnApplied Credits for a customer.

************************************************************************************ 
***********************************************************************************/
public class CarrieUnappliedCreditController {
    public Unapplied_Credit__c credits {get;set;}
    
    public CarrieUnappliedCreditController(ApexPages.StandardController controller){
        credits = (Unapplied_Credit__c)controller.getRecord();
    }
    
    /**
    * @description: This method is used to redirect to Carrie Home Page.
    * @return: PageReference
    */
    public PageReference redirectHomePage(){
       PageReference pageRef = new PageReference('/apex/CarrieBillingBatchPage?scontrolCaching=1&id='+credits.Aria_Account__c); 
        pageRef.setRedirect(true);
        return pageRef; 
    }
}