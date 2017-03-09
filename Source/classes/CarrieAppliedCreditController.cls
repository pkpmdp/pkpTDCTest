/***********************************************************************************
************************************************************************************

* @class: CarrieAppliedCreditController
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 10/06/2012
* @description: Class is used to display all the Applied Credits for a customer.

************************************************************************************ 
***********************************************************************************/
public class CarrieAppliedCreditController {
    public Applied_Credit__c serviceCredit {get;set;}
    public List<Applied_Credit__c> serviceCreditList{get;set;}
    public String showForbrug{get;set;}
   
    public CarrieAppliedCreditController(ApexPages.StandardController controller){
        serviceCredit = (Applied_Credit__c)controller.getRecord();
        if(serviceCredit.Aria_Account__r.Aria_Plan_Name__c=='YouBio'){
        	showForbrug='false';
        }else{
        	showForbrug ='true';
        }
        serviceCreditList = [Select s.Faktura__c,s.Faktura__r.Name,s.Faktura__r.Momspligtigt_bel_b__c, s.Faktura__r.Datoforudskrift__c, s.Amount__c From Applied_Credit__c s where s.Faktura__r.Name!='00000' and s.Name like :serviceCredit.Name]; //carrie-1010
    }
    
    /**
    * @description: This method is used to  redirect to Carrie Home Page.
    * @return: PageReference.
    */    
    public PageReference redirectHomePage(){
    	//Modified for Carrie-1331
        PageReference pageRef = new PageReference('/apex/CarrieBillingBatchPage?scontrolCaching=1&id='+serviceCredit.Aria_Account__c); 
        pageRef.setRedirect(true);
        return pageRef;
    }
}