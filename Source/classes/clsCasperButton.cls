global class clsCasperButton {
    
    //private User user;
    
    public clsCasperButton() {}
        
    webservice static Boolean sendToCasper(String accountId) {
        User user = [Select Id, MID__c From User Where Id = : UserInfo.getUserId()];
        if (accountId != '') {
            Account account = [Select Id, Customer_No__c, Net_Installation__c,Net_Installation__r.INSTALLATION_ID__c From Account Where Id = :accountId];
            if (account.Customer_No__c != null) {
                system.debug('====account.Customer_No__c====='+account.Customer_No__c+'========user.MID__c==========='+user.MID__c);
                String customerNumber = callout(clsConnectionUtils.END_POINT + clsConnectionUtils.UPDATE_CASPER_METHOD, account.Net_Installation__r.INSTALLATION_ID__c + ';' + account.Customer_No__c + ';' + user.MID__c + ';;');
            	system.debug('=======customerNumber======'+customerNumber);
            }
        }
        return true;                    
    } 
    
    webservice static Boolean sendToCasperNetworkNo(String accountId) {
        User user = [Select Id, MID__c From User Where Id = : UserInfo.getUserId()];
        String custNo = '';
        if (accountId!=null && accountId != '') {
            Account account = [Select Id, Customer_No__c,AddressId__c From Account Where Id = :accountId];
            if (account!=null && account.AddressId__c != null) {
                if (account.Customer_No__c != null) {
                    custNo=account.Customer_No__c;
                }
                Address__c address = [select Cableunit_number__c from Address__c where External_Id__c=:account.AddressId__c];
                if (address!=null && address.Cableunit_number__c!=null){
                    String customerNumber = callout(clsConnectionUtils.END_POINT + clsConnectionUtils.UPDATE_CASPER_METHOD, custNo + ';' + user.MID__c + ';1;'+address.Cableunit_number__c);
                    return true;
                }
            }
        }
        return false;
    }

    webservice static Boolean sendToCasperAddress(String addressId) {
        User user = [Select Id, MID__c From User Where Id = : UserInfo.getUserId()];
        if (addressId != null && addressId != '') {
            Address__c address = [Select Id, External_Id__c From Address__c Where Id = :addressId];
            if (address != null && address.External_Id__c != null) {
                String addressNumber = callout(clsConnectionUtils.END_POINT + clsConnectionUtils.UPDATE_CASPER_ADDRESS_METHOD, address.External_Id__c + ';' + user.MID__c + ';;');
                return true;
            }
        }
        return false;
    }
    
    webservice static Boolean sendToCasperAddressInstallationId(String addressId, String installationId, DateTime startDate) {
        User user = [Select Id, MID__c From User Where Id = : UserInfo.getUserId()];
        if (addressId != null && addressId != '') {
            Address__c address = [Select Id, External_Id__c From Address__c Where Id = :addressId];
            if (address != null && address.External_Id__c != null) {
                String strDate = null;
                if(startDate != null){
                    strDate = startDate.format('dd/MM/yyyy HH:mm:ss');
                }
                String addressNumber = null;
                if(installationId != null){ 
                    addressNumber = callout(clsConnectionUtils.END_POINT + clsConnectionUtils.UPDATE_CASPER_ADDRESS_METHOD, 'ExternalId=' + address.External_Id__c + ';' +  'UserMid=' + user.MID__c + ';' +  'StartDate=' +  strDate + ';' + 'InstallationId=' +  installationId + ';;');
                }else{
                    addressNumber = callout(clsConnectionUtils.END_POINT + clsConnectionUtils.UPDATE_CASPER_ADDRESS_METHOD, 'ExternalId=' + address.External_Id__c + ';' +  'UserMid=' + user.MID__c + ';;');
                }   
                return true;
            }
        }
        return false;
    }
    
    static String callout(String endpoint, String body) {
        // Make the callout and check the response        
        Http http = new Http();
        HttpRequest req = new HttpRequest();        
        req.setMethod('GET');
        req.setEndpoint(endpoint);
        req.setBody((body == null ? '' : body));        
        HttpResponse res;
        try {
            res = http.send(req);
            System.debug('res = ' + res);
        } catch (Exception e) {}
        if (res != null) {
            if (res.getStatusCode() == 200) {
                return res.getBody();  // Good response
            }
        }
        return null;    
    }
    
    static testMethod void testDisplayCustomer() {
        RecordType recordType = [Select Id From RecordType Where Name = 'Queue Owned Case'];
        
        List<Lookup_Customer_Satisfaction__c> lcss = [Select Id, Name from Lookup_Customer_Satisfaction__c where Name = 'Ikke relevant' Limit 1];
        Lookup_Customer_Satisfaction__c lcs;
           
        if(lcss.size() > 0)
            lcs = lcss[0];
        
        // Create address record
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        // add.House_No__c = 1;
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        add.Cableunit_number__c = '1234';
        add.External_Id__c = '00010';
        insert add;
        
        // Create account record
        Account acc = new Account();
        acc.Name = 'Test Account 1';
        acc.Street_YK__c = add.Id;
        acc.Customer_No__c = '12345678910';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        //acc.Anlaeg_No__c='0005024065';
         if(lcs != null)
            acc.Customer_Satisfaction_Lookup__c = lcs.Id;
        insert acc;
            
        Case c = new Case();
        c.AccountId = acc.Id;
        c.Status = 'Open';
        c.Subject = 'Complaint Letter';
        c.Description = 'Product: TV\r\nType: Support\r\n';
        c.RecordTypeId = recordType.Id;
        insert c;
        
        // Invoke the method to send the web service request              
        Boolean result = sendToCasper(acc.Id);
    
        System.assertEquals(true, result);
        
        // Invoke the method to send the web service request   
        Boolean result2 = sendToCasperNetworkNo(acc.Id);
    
        System.assertEquals(true, result2);
        
        // Invoke the method to send the web service request   
        Boolean result3 = sendToCasperAddress(add.Id);
        System.assertEquals(true, result3);
        result3 = sendToCasperAddress(null);
        System.assertNotEquals(true, result3);
        
        clsCasperButton cls = new clsCasperButton();
        clsCasperButton.sendToCasperNetworkNo('');
        
         Cable_Unit__c cableUnitNew = new Cable_Unit__c();
        cableUnitNew.Name = 'cu_New'; 
        cableUnitNew.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitNew.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitNew.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitNew.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership1();
        cableUnitNew.Housing_Type__c = clsTestDataForYS.createLookupHousingType1();
        cableUnitNew.Building_Type__c = clsTestDataForYS.createLookupBuildingType1();
        insert cableUnitNew;
        
        Net_Installations__c netInstallold = new Net_Installations__c();
        netInstallold.Name = '123456';
        netInstallold.Installation_Status__c = 'Plug Outlet';
        netInstallold.Installation_Status_Code__c = '1';
        netInstallold.INSTALLATION_ID__c = '45678';
        netInstallold.Cable_Unit__c = cableUnitNew.Id;
        netInstallold.Address__c=add.id;
        netInstallold.Installation_Status_Code__c='1'; 
        insert netInstallold;
        
        clsCasperButton.sendToCasperAddressInstallationId(add.Id, netInstallold.Id, Datetime.now());
        clsCasperButton.sendToCasperAddressInstallationId('', netInstallold.Id, Datetime.now());
        clsCasperButton.sendToCasperAddressInstallationId(add.Id, null, Datetime.now());
    }
}