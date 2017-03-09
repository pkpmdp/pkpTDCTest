/*
    Author) mkha@yousee.dk
    Date: 15-11-2012
    Ressource-link for filter function: http://blog.jeffdouglas.com/2010/07/13/building-a-dynamic-search-page-in-visualforce/
*/
public class clsRelatedOCustomerRelationsController {
    public Account account;
    public List<BillingRelation> billingRelations;
    public String accountId {set;get;} 
    @TestVisible
    public String filterValue;   
    
    //Constructor
    public clsRelatedOCustomerRelationsController(ApexPages.StandardController controller) {
        this.account = (Account) controller.getRecord();
        this.account = [Select Id, Name, Customer_No__c, Street_YK__c from Account where Id = : account.Id];
        this.accountId = account.Id;
        this.billingRelations = new List<BillingRelation>();
        filterValue = '';
    }
    
    public List<BillingRelation> getBillingRelations(){             
        if(account.Street_YK__c != null) {
            System.debug('***** In IF');
        	//String recordType = System.label.PYS+' O-Customer';     
        	String recordType = 'YF O-Customer';     
            List<Account> billingAccounts = [Select Id, Name, Street_YK__c, Customer_No__c from Account where Street_YK__c = :account.Street_YK__c and RecordTypeName__c=:recordType];
            system.debug('billingAccounts: ' + billingAccounts);
            system.debug('Filtervalue: ' + filterValue);
            if(filtervalue == null || filterValue == ''){               
                return populateBillingRelations(billingAccounts);               
                
            }
            else{               
                //billingRelations = populateBillingRelations(billingAccounts);               
                List<BillingRelation> filterList = new List<BillingRelation>();
                for(BillingRelation item: billingRelations){
                    if(item.cableUnitNo.containsIgnoreCase(filterValue) ||                  
                        item.relationType.containsIgnoreCase(filterValue) ||
                        item.billingAccount.Customer_No__c.containsIgnoreCase(filterValue) ||
                        item.billingAccount.Name.containsIgnoreCase(filterValue)){
                        filterList.add(item);   
                    }
                }               
                filterList.sort();
                return filterList;                  
            }
        }
        return null;
    }    
    
    public PageReference runFilter(){       
        filterValue = Apexpages.currentPage().getParameters().get('searchfilter');      
        return null;
    }
    
    public List<BillingRelation> populateBillingRelations(List<Account> billingAccounts){
        billingRelations.clear();
        //Muligvis en fejl i denne. Lad os debugge.
        List<Cable_Unit__c> allCableUnits = [Select Id from Cable_Unit__c where (Legal_Account_No__c IN : billingAccounts OR  Payment_Account_No__c IN :billingAccounts)];
        
        Set<Id> uniqueCableUnitIds = new Set<Id>();
        for(Cable_Unit__c tmp: allCableUnits){
            if(!uniqueCableUnitIds.contains(tmp.Id))
                uniqueCableUnitIds.add(tmp.Id);     
        }        
        
        for(Account cableUnitCustomer: [Select Id, Cable_Unit__c, Cable_Unit__r.Cable_Unit_No__c, Cable_Unit__r.Payment_Account_No__c, Cable_Unit__r.Legal_Account_No__c from Account where Cable_Unit__c IN : uniqueCableUnitIds] ){
            for(Account billingAccount: billingAccounts){
                if(billingAccount.Id == cableUnitCustomer.Cable_Unit__r.Payment_Account_No__c)
                    billingRelations.add(new BillingRelation(cableUnitCustomer, billingAccount, cableUnitCustomer.Cable_Unit__r.Cable_Unit_No__c, 'Betaler', billingAccount.Id)); 
                if(billingAccount.Id == cableUnitCustomer.Cable_Unit__r.Legal_Account_No__c)
                    billingRelations.add(new BillingRelation(cableUnitCustomer, billingAccount, cableUnitCustomer.Cable_Unit__r.Cable_Unit_No__c, 'Juridisk', billingAccount.Id));
            }               
        }
        billingRelations.sort();
        return billingRelations;
    }
    
    public class BillingRelation implements Comparable {
        public BillingRelation(){}

        public BillingRelation(Account cableUnit, Account billingAccount, String cableUnitNo, String relationType, Id accountId){
            this.cableUnit = cableUnit;
            this.billingAccount = billingAccount;
            this.cableUnitNo = cableUnitNo;
            this.relationType = relationType;
            this.accountId = accountId;
        }
        
        public Integer compareTo(Object compareTo) {
            BillingRelation compareToEmp = (BillingRelation)compareTo;
            Integer thisCuNo = Integer.valueOf(cableUnitNo);
            Integer compareCuNo = Integer.valueOf(compareToEmp.cableUnitNo);
            if (thisCuNo == compareCuNo) return 0;
            if (thisCuNo > compareCuNo) return 1;
            return -1;        
        }
        
        public String accountName {
            get{return billingAccount.Name;}
        } 
        
        public Account cableUnit {get;set;}                
        public Account billingAccount {get;set;}
        public String cableUnitNo{get;set;}
        public String relationType{get;set;}
        public Id accountId {get;set;} 
              
    }
}

/* Back-up af adresse-visning
    <apex:pageBlockSection>
        <apex:outputLink value="/apex/AccountEditAddresses?id={!accountId}" target="_parent">{!$Label.Edit_Addresses}</apex:outputLink>
    </apex:pageBlockSection>      
*/

/*
public class clsRelatedOCustomerRelationsController {
    private Account account;
    private List<BillingRelation> billingRelations;
    public String accountId {set;get;}
    
    //Constructor
    public clsRelatedOCustomerRelationsController(ApexPages.StandardController controller) {
        this.account = (Account) controller.getRecord();
        this.account = [Select Id, Name, Customer_No__c, Street_YK__c from Account where Id = : account.Id];
        this.accountId = account.Id;
        this.billingRelations = new List<BillingRelation>();
    }
    
    public List<BillingRelation> getBillingRelations(){
        if(account.Street_YK__c != null){
            List<Account> billingAccounts = [Select Id, Name, Street_YK__c, Customer_No__c from Account where Street_YK__c = :account.Street_YK__c and RecordTypeId='012M0000000CqcL'];
            return populateBillingRelations(billingAccounts);
        }
        return null;
    }
    
    private List<BillingRelation> populateBillingRelations(List<Account> billingAccounts){      
        //Muligvis en fejl i denne. Lad os debugge.
        List<Cable_Unit__c> allCableUnits = [Select Id from Cable_Unit__c where (Legal_Account_No__c IN : billingAccounts OR  Payment_Account_No__c IN :billingAccounts)];
        
        Set<Id> uniqueCableUnitIds = new Set<Id>();
        for(Cable_Unit__c tmp: allCableUnits){
            if(!uniqueCableUnitIds.contains(tmp.Id))
                uniqueCableUnitIds.add(tmp.Id);     
        }
        
        for(Cable_Unit__c cableUnit: [Select Id, Cable_Unit_No__c, Payment_Account_No__c, Legal_Account_No__c from Cable_Unit__c where Id IN : uniqueCableUnitIds] ){
            for(Account billingAccount: billingAccounts){
                if(billingAccount.Id == cableUnit.Payment_Account_No__c)
                    billingRelations.add(new BillingRelation(cableUnit, billingAccount, cableUnit.Cable_Unit_No__c, 'Betaler')); 
                if(billingAccount.Id == cableUnit.Legal_Account_No__c)
                    billingRelations.add(new BillingRelation(cableUnit, billingAccount, cableUnit.Cable_Unit_No__c, 'Juridisk'));
            }               
        }
        billingRelations.sort();
        return billingRelations;
    }
    
    public class BillingRelation implements Comparable {
        public BillingRelation(){}

        public BillingRelation(Cable_Unit__c cableUnit, Account billingAccount, String cableUnitNo, String relationType){
            this.cableUnit = cableUnit;
            this.billingAccount = billingAccount;
            this.cableUnitNo = cableUnitNo;
            this.relationType = relationType;
        }
        
        public Integer compareTo(Object compareTo) {
            BillingRelation compareToEmp = (BillingRelation)compareTo;
            Integer thisCuNo = Integer.valueOf(cableUnitNo);
            Integer compareCuNo = Integer.valueOf(compareToEmp.cableUnitNo);
            if (thisCuNo == compareCuNo) return 0;
            if (thisCuNo > compareCuNo) return 1;
            return -1;        
        }
        
        public Cable_Unit__c cableUnit {get;set;}        
        public Account billingAccount {get;set;}
        public String cableUnitNo{get;set;}
        public String relationType{get;set;}
    }

}
*/