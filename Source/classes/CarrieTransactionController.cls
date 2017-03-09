/***********************************************************************************
************************************************************************************

* @class: CarrieTransactionController
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 18/01/2013
* @description: This class is used to show all tranasctions for a customer.
* @jira CARRIE-752

************************************************************************************ 
***********************************************************************************/
public class CarrieTransactionController {
    private Aria_API_Configuration__c config { get; private set; }
    Aria_Account__c customer = new Aria_Account__c();
    public Decimal ariaAccountNo;
    public HttpResponse response;
    public PageReference pageRef = null;
    public Aria_Account__c ariaAcc { get; set; }  
    public List<Transaction__c> transList { get; set; }
    public integer counter=0;  //keeps track of the offset
    public integer list_size=100; //sets the page size or number of rows 
    public integer total_size; //used to show user the total size of the list
     
          
    public CarrieTransactionController (ApexPages.StandardController controller){
        customer = (Aria_Account__c)controller.getRecord(); 
        config = CarrieCommonUtil.validateAPIConfiguration(config);
        ariaAccountNo = customer.Aria_Account_No__c;  
        ariaAcc = [select Id,Aria_Plan_Name__c from Aria_Account__c where Id = :controller.getRecord().Id];
        system.debug('ariaAcc***'+ariaAcc);
        total_size = [select count() from Transaction__c s 
                     where s.Aria_Account__c =: ariaAcc.Id];
        system.debug('total_size***'+total_size);
    }
    
    /**
    * @description: Use to redirect back to carrie home page.
    * @return: PageReference.
    */
    public PageReference redirectCustomerBillingPage() {
        pageRef = new PageReference('/apex/CarrieCustomerBillingPage?scontrolCaching=1&id='+customer.Id); 
        pageRef.setRedirect(true); 
        return pageRef;
    }
    
    /**
    * @description: This method is used to fetch Transactions and populate Start balance
    */    
    public List<Transaction__c>  getTransactionList()  {
        List<Transaction__c>  transactionList = new List<Transaction__c> ();
        try{ 
         transactionList = [ Select s.Name, s.posting_date__c, s.description__c, s.start_balance__c, s.charge_amt__c, s.credit_amt__c,  s.end_balance__c  
                     From Transaction__c s
                     where s.Aria_Account__c =: ariaAcc.Id 
                      order by s.Name asc
                      limit :list_size 
                      offset :counter 
                      ]; 
            system.debug('counter***'+counter);            
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
         } 
        return transactionList;
    } 
    
    
    /**
    * @description: This method makes Call from Client
    */
   public PageReference getTransactionDetails(){
        try{
           system.debug('getTransList***'+getTransactionList());
           if(counter >=2000){
             counter =2000; // Added due to OFFSET Governance Limit
           }
           transList = getTransactionList();
        }catch(Exception e){       
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
            CarrieLog.LogException(e);
        }
        return null; 
    } 
    
    /**
    * @description: This method does pagination of transaction
    */ 
    
    public PageReference Beginning() { //user clicked beginning
      counter = 0;
      getTransactionDetails();
      return null;
    }

    public PageReference Previous() { //user clicked previous button
      counter -= list_size;
      getTransactionDetails();
      return null;
    }

    public PageReference Next() { //user clicked next button
      counter += list_size;
      getTransactionDetails();
    return null;
    }

    public PageReference End() { //user clicked end
      counter = total_size - math.mod(total_size, list_size);
      getTransactionDetails();
    return null;
    }

    public Boolean getDisablePrevious() { //this will disable the previous and beginning buttons
      if (counter>0) return false; else return true;
    }

    public Boolean getDisableNext() { //this will disable the next and end buttons
     if (counter + list_size < total_size) return false; 
      else return true;
    }
    
    public Integer getTotal_size() {
      return total_size;
    }
    
    public Integer getPageNumber() {
      return counter/list_size + 1;
    }

    public Integer getTotalPages() {
      if (math.mod(total_size, list_size) > 0) {
         return total_size/list_size + 1;
      } else {
         return (total_size/list_size);
        }
   }
    
     
}