public class clsCBSchedNewCustValsController {

    public clsCBSchedNewCustValsController(ApexPages.StandardController controller) {
        this();
    }

    //constructor
    public clsCBSchedNewCustValsController(){
         c = new Case();
         c.Department__c='YOT';
         c.Product_2__c='YOT Call Back';
    }

    //public Date day {get;set;}
    public String cbType {get;set;}
    
    //proxy object for datepicker
    public CB_Custom_Schedule__c proxyObject = new CB_Custom_Schedule__c();
    public CB_Custom_Schedule__c getProxyObject() { return proxyObject; }
    public Date getProxyDate() { return proxyObject.CB_date__c; }
    
    //proxy object for picklist
    Case c;
    public Case getCaseFields() { 
        return c; 
    }
    
    
    public PageReference next(){
        if (validateAll()){
            return new PageReference('/apex/CB_SchedCustVals?date='+ clsCallBackUtil.formatDate(getProxyDate()) +'&type=' + c.Type_Task__c +'&retURL=/apex/CallBackAdminPage'); 
        }
        return null;
    }
    
    public boolean validateAll(){
        Boolean valid = true;
        if (getProxyDate()==null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CB_Error_Date_required));
            valid=false;
        }
        else if(getProxyDate()<Date.today()){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CB_Error_Date_in_past));
            valid=false;
        }

        if (c.Type_Task__c==null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CB_Error_Type_required));
            valid=false;
        }
        return valid;
    }
    
}