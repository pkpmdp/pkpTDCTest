public class UpdateYKCustomerAddressesController {

    public String customerNo{get; set;}
    public String firstName{get; set;}
    public String InstallationAddressId{get; set;}
    public String billingAddressId{get; set;}
    public String legalAddressId{get; set;}
    
    public UpdateYKCustomerAddressesController(){
        
    }
    
    public PageReference updateCustomer(){
        System.debug('****customerNo***'+customerNo);
        System.debug('****firstName***'+firstName);
        System.debug('****lastName***'+InstallationAddressId);
        System.debug('****billingAddressId***'+billingAddressId);
       Account acc = new Account();
        Address__c billingAddr = new Address__c ();
        Address__c legalAddr  = new Address__c();
        Address__c InstallationAddress  = new Address__c();
        if(customerNo != null){
            acc = [SELECT Id, FirstName, LastName, Billing_Address__c, Street_YK__c FROM Account WHERE Customer_No__c =: customerNo];  
            System.debug('*****acc****'+acc);
            if(billingAddressId != null && billingAddressId != ''){
                billingAddr = [SELECT Id, External_Id__c, Full_Address__c FROM Address__c WHERE External_Id__c=: billingAddressId];
            }
            if(legalAddressId != null && legalAddressId !='')
            	legalAddr = [SELECT Id, External_Id__c, Full_Address__c FROM Address__c WHERE External_Id__c=: legalAddressId];
            if(InstallationAddressId != null && InstallationAddressId !='')
            	InstallationAddress = [SELECT Id, External_Id__c, Full_Address__c FROM Address__c WHERE External_Id__c=: InstallationAddressId];
        }
        if(acc != null){
            if(billingAddr != null)
                acc.Billing_Address__c = billingAddr.Id;
            if(legalAddr != null)
                acc.Street_YK__c = legalAddr.Id;
            /*if(firstName != null && firstName != '')
                acc.FirstName = firstName;
            if(lastName != null && lastName != '')
                acc.LastName = lastName;*/
             update acc;
        }
        
        try{
        Customer_Related_Address__c cRCust = new Customer_Related_Address__c();
        cRCust = [SELECT Customer__c,Id,InstallationAddress__c,Installation_Address__c,JuridicalAddress__c,Juridical_Address__c,Name FROM Customer_Related_Address__c WHERE Customer__c =: acc.Id Order By LastModifiedDate DESC LIMIT 1];
        if(cRCust != null){
            
        
        if(InstallationAddress != null){
            cRCust.Installation_Address__c = InstallationAddress.Id;
            cRCust.InstallationAddress__c = InstallationAddress.Full_Address__c;
        }
        if(InstallationAddress != null){
            cRCust.Juridical_Address__c = legalAddr.Id;
            cRCust.JuridicalAddress__c = legalAddr.Full_Address__c;
        }
          update cRCust;
          customerNo = '';
            firstName = '';
            InstallationAddressId = '';
            billingAddressId = '';
            legalAddressId = '';
        }
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Customer related address not updated.'));
        	return null;
        }
        
        return null;
    }
}