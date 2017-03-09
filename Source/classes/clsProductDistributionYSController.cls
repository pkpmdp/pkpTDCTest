public class clsProductDistributionYSController {
    
    // following lines are added by Navneet for populating record ids from custom settings 
     YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');
 	 String customerRecordType1 = ysRecords.YS_CUSTOMER_ACCOUNT_RECORD_TYPE_ID1__c;//012200000000nf3
    //private static String YS_CUSTOMER_ACCOUNT_RECORD_TYPE_ID = '012200000000nf3';
    private String YS_CUSTOMER_ACCOUNT_RECORD_TYPE_ID = customerRecordType1;
        
    
    // Member variables accessed via getters and setters in Visualforce page
    private Account account {get; set;}
    private List<Account> customerAccounts = new List<Account>();    
    
    private List<cProductDistributionSummary> productDistributionSummaries;
    // Constructor method retrieves account and related product distribution data
    public clsProductDistributionYSController(ApexPages.StandardController controller) {        
        this.account = [Select Id, Name, RecordTypeId, Cable_Unit_Name__c, Cable_Unit_No__c, Existing_Phase__c, Existing_Sales_Concept__c, Existing_Sales_Type__c, Latest_Phase__c, Latest_Sales_Concept__c, Latest_Sales_Type__c, (Select Id, Name, Customer__c, Product__c, Business__c, Amount__c From Product_Distributions__r) From Account Where Id = :controller.getId()]; 
        productDistributionSummaries = new List<cProductDistributionSummary>();   
    }

    public List<Account> getCustomerAccounts() {
        return customerAccounts;
    }
    
    // Method retrieves a list of product distribution records (wrapper class that summarises product distributions)
    public List<cProductDistributionSummary> getProductDistributionSummaries() {
        // Get the list of product distributions belonging to descendents of this account
        List<Product_Distribution__c> productDistributions = getProductDistributions();
        // Create the list of product distribution summary records  
        for (Product_Distribution__c productDistribution : productDistributions) { 
            cProductDistributionSummary productDistributionSummary = new cProductDistributionSummary(productDistribution);
            updateProductDistributionSummaryList(productDistributionSummary);        	      	
        } 
        return productDistributionSummaries;
    } 
    
    
    // Method retrieves all of the product distribution records linked to descendents of the top level account
    //public List<Product_Distribution__c> getProductDistributions() {
    private List<Product_Distribution__c> getProductDistributions() {    	
        List<Product_Distribution__c> productDistributions = new List<Product_Distribution__c>();
        // This shouldn't be needed - reports will be run from top level
        if (this.account.RecordTypeId == YS_CUSTOMER_ACCOUNT_RECORD_TYPE_ID) {
            customerAccounts.add(this.account);
            for (Product_Distribution__c productDistribution : this.account.Product_Distributions__r) {            	
                productDistributions.add(productDistribution);
            }
        }
        
        // Start with the top level account
        List<Id> accountIds = new List<Id> {this.account.Id};        
        // Until we run out of descendents for the top level account        
        boolean hasMore = true;
        while (hasMore) {
            // Store the ids of the child accounts for the next iteration
            List<Id> childAccountIds = new List<Id>();
            // Select the child accounts and their product distributions
            for (Account childAccount : [Select Id, Name, RecordTypeId, Cable_Unit_Name__c, Cable_Unit_No__c, Existing_Phase__c, Existing_Sales_Concept__c, Existing_Sales_Type__c, Latest_Phase__c, Latest_Sales_Concept__c, Latest_Sales_Type__c, (Select Id, Name, Customer__c, Product__c, Business__c, Amount__c From Product_Distributions__r) From Account Where ParentId In :accountIds Order by Name]) {               
                childAccountIds.add(childAccount.Id);
                if (childAccount.RecordTypeId == YS_CUSTOMER_ACCOUNT_RECORD_TYPE_ID) {
                    customerAccounts.add(childAccount);
                    // Add the product distribution records to a list for summarising
                    for (Product_Distribution__c productDistribution : childAccount.Product_Distributions__r) {
                        productDistributions.add(productDistribution);
                    }
                }
            }
            // Clear the list of ids that is used to query for more descendents
            accountIds.clear();
            // If no more child records were found...
            if (childAccountIds.size() == 0) {
                // Processing can complete
                hasMore = false;                
            } else{
                // Otherwise update the list of ids used to query for the next level of descendents
                accountIds.addAll(childAccountIds);
                // And set the flag so the loop will iterate again
                hasMore = true;
            }
        }
        
        return productDistributions;
    }
    
    private void updateProductDistributionSummaryList(cProductDistributionSummary newProductDistributionSummary) {
        boolean matchfound = false;
        for (cProductDistributionSummary existingProductDistributionSummary : productDistributionSummaries) {
            if (existingProductDistributionSummary.summaryRecord.Business__c == newProductDistributionSummary.summaryRecord.Business__c &&
            	existingProductDistributionSummary.summaryRecord.Product__c == newProductDistributionSummary.summaryRecord.Product__c) {
                                
                existingProductDistributionSummary.summaryRecord.Amount__c +=  + newProductDistributionSummary.summaryRecord.Amount__c;
                 
                matchfound = true;
                break;                
            }           
        }
        if  (!matchfound)
    		productDistributionSummaries.add(newProductDistributionSummary);
    
        /*
        // It isn't the first and couldn't be matched - therefore this must be a new summary record that must be inserted into the sorted list
        Integer position = -1;
        String lastCompare = '';
        // Loop through the existing records to find the right position
        for (Integer i = 0; i < productDistributionSummaries.size(); i++) {
            cProductDistributionSummary existingProductDistributionSummary = productDistributionSummaries[i];       
            // Compare the new summary record text fields to the existing records                   
            String newRecordCompare = newProductDistributionSummary.summaryRecord.Business__c + newProductDistributionSummary.summaryRecord.Product__c;
            String existingRecordCompare = existingProductDistributionSummary.summaryRecord.Business__c + existingProductDistributionSummary.summaryRecord.Product__c;
            // If the new record preceeds an existing one 
            if (existingRecordCompare.compareTo(newRecordCompare) > 0)  {
                // First occurence so mark the position
                if (position == -1) {
                    position = i;       
                    lastCompare = existingRecordCompare;
                } else {
                    // We need to compare to the last occurence
                    if (lastCompare.compareTo(existingRecordCompare) > 0) {
                        position = i;
                        lastCompare = existingRecordCompare;
                    }                      
                }
            }                   
        }
        if ( position == -1) {
            // The new record did not preceed an existing record so position it at the end of the list
            productDistributionSummaries.add(newProductDistributionSummary);
        } else {
            // The new record preceeded an existing record so insert it into the list at the marked position
            productDistributionSummaries.add(position, newProductDistributionSummary);
        }
        // Return the sorted list including the new record        
        */      
    }    
    
    
    /*
    // Update productionDistributionSummaries list to incorporate an additional product distribution summary record
    private List<cProductDistributionSummary> updateProductDistributionSummaryList(cProductDistributionSummary newProductDistributionSummary, List<cProductDistributionSummary> existingProductDistributionSummaries) {
        //  If this is the first record in the list then add it
        if (existingProductDistributionSummaries.size() == 0) {
            existingProductDistributionSummaries.add(newProductDistributionSummary);
            return existingProductDistributionSummaries;
        }
        // If we can match to an existing record in the list then update the amount 
        for (cProductDistributionSummary existingProductDistributionSummary : existingProductDistributionSummaries) {
            if (existingProductDistributionSummary.summaryRecord.Business__c == newProductDistributionSummary.summaryRecord.Business__c) {
                if (existingProductDistributionSummary.summaryRecord.Product__c == newProductDistributionSummary.summaryRecord.Product__c) {
                    existingProductDistributionSummary.summaryRecord.Amount__c += newProductDistributionSummary.summaryRecord.Amount__c;
                    return existingProductDistributionSummaries;
                }
            }           
        }
        
        // It isn't the first and couldn't be matched - therefore this must be a new summary record that must be inserted into the sorted list
        Integer position = -1;
        String lastCompare = '';
        // Loop through the existing records to find the right position
        for (Integer i = 0; i < existingProductDistributionSummaries.size(); i++) {
            cProductDistributionSummary existingProductDistributionSummary = existingProductDistributionSummaries[i];       
            // Compare the new summary record text fields to the existing records                   
            String newRecordCompare = newProductDistributionSummary.summaryRecord.Business__c + newProductDistributionSummary.summaryRecord.Product__c;
            String existingRecordCompare = existingProductDistributionSummary.summaryRecord.Business__c + existingProductDistributionSummary.summaryRecord.Product__c;
            // If the new record preceeds an existing one 
            if (existingRecordCompare.compareTo(newRecordCompare) > 0)  {
                // First occurence so mark the position
                if (position == -1) {
                    position = i;       
                    lastCompare = existingRecordCompare;
                } else {
                    // We need to compare to the last occurence
                    if (lastCompare.compareTo(existingRecordCompare) > 0) {
                        position = i;
                        lastCompare = existingRecordCompare;
                    }                      
                }
            }                   
        }
        if ( position == -1) {
            // The new record did not preceed an existing record so position it at the end of the list
            existingProductDistributionSummaries.add(newProductDistributionSummary);
        } else {
            // The new record preceeded an existing record so insert it into the list at the marked position
            existingProductDistributionSummaries.add(position, newProductDistributionSummary);
        }
        // Return the sorted list including the new record
        
        return existingProductDistributionSummaries;        
    }
    */
    
    // Wrapper class for product distribution - there will be one instance for each summary row               
    public class cProductDistributionSummary {
        private Product_Distribution__c summaryRecord;
        public cProductDistributionSummary(Product_Distribution__c productDistribution) {
            summaryRecord = new Product_Distribution__c();
            this.summaryRecord.Product__c = productDistribution.Product__c;
            this.summaryRecord.Business__c = productDistribution.Business__c;
            if (productDistribution.Amount__c == null) {
                this.summaryRecord.Amount__c = 0;               
            } else {
                this.summaryRecord.Amount__c = productDistribution.Amount__c;
            }                        
        }
        public Product_Distribution__c getSummaryRecord() {
            return this.summaryRecord;
        }
    }
}