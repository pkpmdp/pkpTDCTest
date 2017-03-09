public class Yousee_View_o_customers {
    
    public String siteCoreUrl {get;set;}
    public string cableUnitName{get; set;}
    public String portalBrugerRole {get; set;}
    public String cableUnitNumber {get; set;}
   Transient List<OCustomer> customers = new List<OCustomer> ();
    
    public Cable_Unit__c cableUnit = new Cable_Unit__c();
    Transient List<String> addresses = new List<String>();
   Transient List<Account> accounts = new List<Account>();
    List<Net_Installations__c> installations = new List<Net_Installations__c>();
    
    public Yousee_View_o_customers(){
        
        siteCoreUrl = ServiceCenter_CustomSettings__c.getInstance('Service_Center_SiteCoreURL').Value__c;
        portalBrugerRole = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
        cableUnitNumber = ApexPages.CurrentPage().getParameters().get('cableunitnumber');
        cableUnit = [Select c.Id , c.name from Cable_Unit__c c where c.Cable_Unit_No__c = :cableUnitNumber limit 1];
        cableUnitName = cableUnit.name;
    }
    public List<OCustomer> getOCustomers(){     
        for(Net_Installations__c installation : [select inst.Address__c From Net_Installations__c inst where inst.Cable_Unit__r.Cable_Unit_No__c = :cableUnitNumber])//
        {
            addresses.add(installation.Address__c);
        }
        System.debug('addresses.size() ' +addresses.size());
            
        accounts = [select Name, FirstName, LastName, Home_Phone__c, PersonEmail, Billing_Address__c, Full_Addresses__c from Account where Billing_Address__c = :addresses]; 
        System.debug('accounts.size() ' +accounts.size());   
       
        for(Account acct : accounts) {
         
            OCustomer customer = new OCustomer();  
            String addr = acct.Full_Addresses__c.substringBefore('<img'); 
            customer.address = addr;
            customer.firstName = acct.Name;
            customer.phone = acct.Home_Phone__c;
            customer.email = acct.PersonEmail;
            customer.lastName = acct.LastName;
            customers.add(customer);
        }
        System.debug('customers.size() ' +customers.size());
               
        return customers;
    }
    
    public class OCustomer{
     public String lastName{get; set;}
     public String address{get;set;}
     public String firstName{get; set;}
     public String phone{get; set;}
     public String email{get; set;}
    }
    

}