@isTest
private class clsCustomerRelatedAddrControllerTest {
        public static final String STREET1 = 'TestStreet1';
        public static final String STREET2 = 'TestStreet2';
        public static final String CABLEUNITNO = '1';
        public static Cable_Unit__c cu;
         
        static testMethod void getAddressesTest() {
            Test.startTest();
            
            Account customer = new Account(FirstName = 'John', LastName = 'Doe');
            insert customer;
            
            Address__c address1 = new Address__c();
            address1.Name=STREET1;
            address1.Street__c=STREET1;
            address1.Cableunit_number__c = CABLEUNITNO;
            insert address1;

            Address__c address2 = new Address__c();
            address2.Name=STREET2;
            address2.Street__c=STREET2;
            insert address2;
            
            Customer_Related_Address__c cra = new Customer_Related_Address__c();
            cra.Customer__c=customer.id;
            cra.Installation_Address__c=address1.id;
            cra.Juridical_Address__c=address2.id;
            cra.Payer_Address__c=address1.id;
            //cra.Usage_Address__c=address2.id;
            
            PageReference pageRef1 = Page.CustomerRelatedAddressesYK;
            Test.setCurrentPage(pageRef1);
            
            ApexPages.currentPage().getParameters().clear();
            ApexPages.currentPage().getParameters().put('id', customer.id);
            
            ApexPages.StandardController sc1 = new ApexPages.StandardController(customer);
            clsCustomerRelatedAddressesYKController c1 = new clsCustomerRelatedAddressesYKController(sc1);        

            List<clsCustomerRelatedAddressesYKController.DisplayAddress> da1 = c1.getAddresses();
            
            insert cra;
             
            PageReference pageRef = Page.CustomerRelatedAddressesYK;
            Test.setCurrentPage(pageRef);
            
            ApexPages.currentPage().getParameters().clear();
            ApexPages.currentPage().getParameters().put('id', customer.id);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(customer);
            clsCustomerRelatedAddressesYKController c = new clsCustomerRelatedAddressesYKController(sc);        

            List<clsCustomerRelatedAddressesYKController.DisplayAddress> da = c.getAddresses();
            //System.assert(da!=null);
            //System.assert(da.size()>0);
            //System.assertEquals(2,da.size());
            //System.assertEquals(STREET2,da[0].address.Name);
            //System.assertEquals(STREET1,da[1].address.Name);
          //  System.assertEquals(STREET1,da[2].address.Name);
          //  System.assertEquals(CABLEUNITNO,da[0].cableUnitNo);
            //System.assertEquals(customer.id, c.getAccountId());
            Test.stopTest();
        }

        static testMethod void getAddressesFromCiaTest() {
            Test.startTest();
            
            Address__c address1 = new Address__c();
            address1.Name=STREET1;
            address1.Street__c=STREET1;
            address1.Cableunit_number__c = CABLEUNITNO;
            insert address1;

            Account customer = new Account(FirstName = 'John', LastName = 'Doe');
            customer.Street_YK__c = address1.Id;            
            insert customer;
            
            Customer_Related_Address__c cra = new Customer_Related_Address__c();
            cra.Customer__c=customer.id;
            cra.Payer_Address__c=address1.id;
            
            Customer_Installation_Address__c cia = new Customer_Installation_Address__c();
            cia.Address__c = address1.id;
            cia.Customer__c = customer.id;
            insert cia;

                        
            PageReference pageRef1 = Page.CustomerRelatedAddressesYK;
            Test.setCurrentPage(pageRef1);
            
            ApexPages.currentPage().getParameters().clear();
            ApexPages.currentPage().getParameters().put('id', customer.id);
            
            ApexPages.StandardController sc1 = new ApexPages.StandardController(customer);
            clsCustomerRelatedAddressesYKController c1 = new clsCustomerRelatedAddressesYKController(sc1);        

            List<clsCustomerRelatedAddressesYKController.DisplayAddress> da1 = c1.getAddresses();
            
            insert cra;
             
            PageReference pageRef = Page.CustomerRelatedAddressesYK;
            Test.setCurrentPage(pageRef);
            
            ApexPages.currentPage().getParameters().clear();
            ApexPages.currentPage().getParameters().put('id', customer.id);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(customer);
            clsCustomerRelatedAddressesYKController c = new clsCustomerRelatedAddressesYKController(sc);        

            List<clsCustomerRelatedAddressesYKController.DisplayAddress> da = c.getAddresses();
                        
            Test.stopTest();            
        }
        
        
        static testMethod void getActiveSubTrueInstallations() {
            Address__c address1 = new Address__c();
            address1.Name=STREET1;
            address1.Street__c=STREET1;
            address1.Cableunit_number__c = CABLEUNITNO;
            insert address1;
            
            Cable_Unit__c cableUnitTest1 = new Cable_Unit__c();
	        cableUnitTest1.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
	        cableUnitTest1.Name = 'cu_kundeCust_testing'; 
	        cableUnitTest1.Municipaly__c = clsTestDataForYS.getMunicipaly();
	        cableUnitTest1.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
	        cableUnitTest1.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();                      
	        cableUnitTest1.Housing_Type__c = clsTestDataForYS.createLookupHousingType();                    
	        cableUnitTest1.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
	        cableUnitTest1.HF_no__c = '1234';
	        cableUnitTest1.Key_Box__c = '1';
            cableUnitTest1.Cable_Type__c = 'Coax';
	        insert cableUnitTest1;
	        
	        Account customer = new Account(FirstName = 'John', LastName = 'Doe');
            customer.Street_YK__c = address1.Id;            
            insert customer;
            
            Customer_Related_Address__c cra = new Customer_Related_Address__c();
            cra.Customer__c=customer.id;
            cra.Payer_Address__c=address1.id;
            
            Net_Installations__c installation = new Net_Installations__c();
        	installation.Address_Id__c = 'add123a';
        	installation.Address__c = address1.id;
        	installation.Cable_Unit__c = cableUnitTest1.Id;
        	installation.AddressId_InstLbnr__c = '1';
        	insert installation;
        	
        	/*Installation__c inst1 = new Installation__c();
        	inst1.Address__c = address1.Id;
        	inst1.Cable_Unit_no__c = cu.Cable_Unit_No__c;
        	inst1.Customer__c = customer.Id;
        	inst1.HF_no__c = '1234';
        	inst1.Note_field__c = 'Note field';
        	inst1.Sales_concept__c = 'Sales concept';
        	insert inst1;
        	System.debug('$$inst1$$'+inst1);*/	
        
            
            Customer_Installation_Address__c cia = new Customer_Installation_Address__c();
            cia.Address__c = address1.id;
            cia.Customer__c = customer.id;
            cia.Active_Sub__c = true;
            insert cia;

                        
            PageReference pageRef1 = Page.CustomerRelatedAddressesYK;
            Test.setCurrentPage(pageRef1);
            
            ApexPages.currentPage().getParameters().clear();
            ApexPages.currentPage().getParameters().put('id', customer.id);
            
            ApexPages.StandardController sc1 = new ApexPages.StandardController(customer);
            clsCustomerRelatedAddressesYKController c1 = new clsCustomerRelatedAddressesYKController(sc1);        
			Test.startTest();
            List<clsCustomerRelatedAddressesYKController.DisplayAddress> da1 = c1.getAddresses();
            
            insert cra;
             
            PageReference pageRef = Page.CustomerRelatedAddressesYK;
            Test.setCurrentPage(pageRef);
            
            ApexPages.currentPage().getParameters().clear();
            ApexPages.currentPage().getParameters().put('id', customer.id);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(customer);
            clsCustomerRelatedAddressesYKController c = new clsCustomerRelatedAddressesYKController(sc);        
			c.getAccountId();
            List<clsCustomerRelatedAddressesYKController.DisplayAddress> da = c.getAddresses();
                        
            Test.stopTest();            
        }
        
        
        
        static testMethod void getInstallations() {
            Address__c address1 = new Address__c();
            address1.Name=STREET1;
            address1.Street__c=STREET1;
            address1.Cableunit_number__c = CABLEUNITNO;
            insert address1;
            
            /*cu = new Cable_Unit__c();
        	cu.Name = 'ViewAddressesForInstallationsCU';        
        	cu.Cable_Unit_No__c = '0000005566';
        	cu.Status__c = '0';
        	cu.distinctAddresses__c = 'Nerult(2-2),Vashi(1-10)';
        	insert cu;*/
	        
	        Cable_Unit__c cableUnitTest1 = new Cable_Unit__c();
	        cableUnitTest1.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
	        cableUnitTest1.Name = 'cu_kundeCust_testing'; 
	        cableUnitTest1.Municipaly__c = clsTestDataForYS.getMunicipaly();
	        cableUnitTest1.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
	        cableUnitTest1.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();                      
	        cableUnitTest1.Housing_Type__c = clsTestDataForYS.createLookupHousingType();                    
	        cableUnitTest1.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
	        cableUnitTest1.HF_no__c = '1234';
	        cableUnitTest1.Key_Box__c = '1';
            cableUnitTest1.Cable_Type__c = 'Coax';
	        insert cableUnitTest1;
	        
	        Net_Installations__c installation = new Net_Installations__c();
        	installation.Address_Id__c = 'add123a';
        	installation.Address__c = address1.id;
        	installation.Cable_Unit__c = cableUnitTest1.Id;
        	installation.AddressId_InstLbnr__c = '1';
        	insert installation;

            Account customer = new Account(FirstName = 'John', LastName = 'Doe');
            customer.Street_YK__c = address1.Id;            
            insert customer;
            
            Customer_Related_Address__c cra = new Customer_Related_Address__c();
            cra.Customer__c=customer.id;
            cra.Payer_Address__c=address1.id;
            
            /*Installation__c inst1 = new Installation__c();
        	inst1.Address__c = address1.Id;
        	inst1.Cable_Unit_no__c = cu.Cable_Unit_No__c;
        	inst1.Customer__c = customer.Id;
        	inst1.HF_no__c = '1234';
        	inst1.Note_field__c = 'Note field';
        	inst1.Sales_concept__c = 'Sales concept';
        	insert inst1;
        	System.debug('$$inst1$$'+inst1);*/	
        
            
            Customer_Installation_Address__c cia = new Customer_Installation_Address__c();
            cia.Address__c = address1.id;
            cia.Customer__c = customer.id;
            cia.Active_Sub__c = true;
            insert cia;

                        
            PageReference pageRef1 = Page.CustomerRelatedAddressesYK;
            Test.setCurrentPage(pageRef1);
            
            ApexPages.currentPage().getParameters().clear();
            ApexPages.currentPage().getParameters().put('id', customer.id);
            
            ApexPages.StandardController sc1 = new ApexPages.StandardController(customer);
            clsCustomerRelatedAddressesYKController c1 = new clsCustomerRelatedAddressesYKController(sc1);        
			Test.startTest();
            List<clsCustomerRelatedAddressesYKController.DisplayAddress> da1 = c1.getAddresses();
            
            insert cra;
             
            PageReference pageRef = Page.CustomerRelatedAddressesYK;
            Test.setCurrentPage(pageRef);
            
            ApexPages.currentPage().getParameters().clear();
            ApexPages.currentPage().getParameters().put('id', customer.id);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(customer);
            clsCustomerRelatedAddressesYKController c = new clsCustomerRelatedAddressesYKController(sc);        
			c.getAccountId();
			
            List<clsCustomerRelatedAddressesYKController.DisplayAddress> da = c.getAddresses();
            clsCustomerRelatedAddressesYKController.DisplayAddress dads = new clsCustomerRelatedAddressesYKController.DisplayAddress();
            dads.setCableUnitNo();
            Test.stopTest();            
        }
        
        
        static testMethod void getAllNetandInstallations() {
            List<Address__c> addList1 = new List<Address__c>();
            
            Address__c address1 = new Address__c();
            address1.Name=STREET1;
            address1.Street__c=STREET1;
            address1.Cableunit_number__c = '0000005566';
           
            insert address1;
            Address__c address2 = new Address__c();
            address2.Name=STREET1;
            address2.Street__c=STREET1;
            address2.Cableunit_number__c = '0000005566,0000005567';
           
            insert address2;
            
            addList1.add(address1);
            
            cu = new Cable_Unit__c();
        	cu.Name = 'ViewAddressesForInstallationsCU';        
        	cu.Cable_Unit_No__c = '0000005566';
        	cu.Status__c = '0';
        	cu.distinctAddresses__c = 'Nerult(2-2),Vashi(1-10)';
            cu.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();                     
        	cu.Housing_Type__c = clsTestDataForYS.createLookupHousingType();                   
        	cu.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
            cu.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
            cu.Municipaly__c = clsTestDataForYS.getMunicipaly(); 
            cu.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
            cu.Cable_Type__c = 'Coax';
        	insert cu;
            
            Account customer = new Account(FirstName = 'John', LastName = 'Doe');
            customer.Customer_Segment_Lookup__c= clsTestDataForYS.createLookupCustomerSegment();
            customer.Street_YK__c = address2.Id;            
            insert customer;
            
             Account customer1 = new Account(FirstName = 'John', LastName = 'Doe');
            customer1.Customer_Segment_Lookup__c= clsTestDataForYS.createLookupCustomerSegment2();
            customer1.Street_YK__c = address1.Id;            
            insert customer1;
            
            
            
            Customer_Related_Address__c cra = new Customer_Related_Address__c();
            cra.Customer__c=customer.id;
            cra.Payer_Address__c=address1.id;
            
            Net_Installations__c installation = new Net_Installations__c();
        	installation.Address_Id__c = 'add123a';
        	installation.Address__c = address1.id;
        	installation.Cable_Unit__c = cu.Id;
        	installation.AddressId_InstLbnr__c = '1';
        	insert installation;
            
             Customer_Related_Address__c cra1 = new Customer_Related_Address__c();
            cra1.Customer__c=customer1.id;
            cra1.Payer_Address__c=address1.id;
            
            Net_Installations__c installation1 = new Net_Installations__c();
        	installation1.Address_Id__c = 'add123a';
        	installation1.Address__c = address1.id;
        	installation1.Cable_Unit__c = cu.Id;
        	installation1.AddressId_InstLbnr__c = '1';
        	insert installation1;
            
            /*Installation__c inst1 = new Installation__c();
        	inst1.Address__c = address1.Id;
        	inst1.Cable_Unit_no__c = cu.Cable_Unit_No__c;
        	inst1.Customer__c = customer.Id;
        	inst1.HF_no__c = '1234';
        	inst1.Note_field__c = 'Note field';
        	inst1.Sales_concept__c = 'Sales concept';
        	insert inst1;
        	System.debug('$$inst1$$'+inst1);*/	
        
            
            Customer_Installation_Address__c cia = new Customer_Installation_Address__c();
            cia.Address__c = address1.id;
            cia.Customer__c = customer.id;
            cia.Active_Sub__c = true;
            insert cia;

                        
            PageReference pageRef1 = Page.CustomerRelatedAddressesYK;
            Test.setCurrentPage(pageRef1);
            
            ApexPages.currentPage().getParameters().clear();
            ApexPages.currentPage().getParameters().put('id', customer.id);
            
            ApexPages.StandardController sc1 = new ApexPages.StandardController(customer);
            clsCustomerRelatedAddressesYKController c1 = new clsCustomerRelatedAddressesYKController(sc1);        
			Test.startTest();
            List<clsCustomerRelatedAddressesYKController.DisplayAddress> da1 = c1.getAddresses();
            insert cra;
             
            PageReference pageRef = Page.CustomerRelatedAddressesYK;
            Test.setCurrentPage(pageRef);
            
            ApexPages.currentPage().getParameters().clear();
            ApexPages.currentPage().getParameters().put('id', customer.id);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(customer);
            clsCustomerRelatedAddressesYKController c = new clsCustomerRelatedAddressesYKController(sc);        
			List<clsCustomerRelatedAddressesYKController.DisplayAddress> da = c.getAddresses();
			clsCustomerRelatedAddressesYKController.DisplayAddress dads2 = new clsCustomerRelatedAddressesYKController.DisplayAddress();
			dads2.getAddressFromList(addList1,address1.Id);
            c.getPreInstalledModem();
            clsCustomerRelatedAddressesYKController ob = new clsCustomerRelatedAddressesYKController();
            
            ApexPages.currentPage().getParameters().clear();
            ApexPages.currentPage().getParameters().put('id', customer1.id);
            
            ApexPages.StandardController sc2 = new ApexPages.StandardController(customer1);
            clsCustomerRelatedAddressesYKController c2 = new clsCustomerRelatedAddressesYKController(sc2);
            c2.getPreInstalledModem();
            Test.stopTest();            
        }
}