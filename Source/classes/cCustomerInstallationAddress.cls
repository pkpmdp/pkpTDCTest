public class cCustomerInstallationAddress {
       // public string customerName{get;set;}
        public String firstName{get;set;}
        public String lastName{get;set;}
        public String contactNumber{get;set;}
        public Address__c addr{get;set;}
        public String email{get;set;} 
        public String conformEmailID{get;set;}
        public String mobilePhone{get;set;}
        public String amsId{get;set;}
        public Boolean isNewCustomer{get;set;}
        public String customerNumber{get;set;}
        public string sfdcID {get;set;}
        public string installationID{get;set;}
        
        public String getAddr1(){
            String addressString = '';
            addressString = addressString+(addr.Street__c == null ?  '' : addr.Street__c+' ');
            addressString = addressString+ (addr.House_No__c == null ?  '' : addr.House_No__c+' ');
            addressString = addressString+(addr.Entrance__c == null ?  '' : addr.Entrance__c+' ');
            addressString = addressString+(addr.Floor__c == null ?  '' : addr.Floor__c+' ');
            //Commented for DW-720: Side__c field is going to be deleted from SFDC
            //addressString = addressString+(addr.Side__c == null ?  '' : addr.Side__c+' ');
            addressString = addressString+(addr.Door_No__c == null ?  '' : addr.Door_No__c+' ');
            return addressString;
        }
        public String getAddr2(){
            String addressString = '';
            addressString = addressString+(addr.Postcode__c == null ?  '' : addr.Postcode__c+' ');
            addressString = addressString+(addr.Town__c== null ?  '' : addr.Town__c+' ');
            return addressString;
        }
 }