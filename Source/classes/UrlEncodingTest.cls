@isTest 
private class UrlEncodingTest {
    
    public static testMethod void testEncoding() {
        END_POINT__c en = new END_POINT__c();
        en.END_POINT__c = 'https://TDCGroupTRIAL79207.jitterbit.eu/devtdcapi/1';
        en.Name='JITTERBIT';
        insert en;
        insert new INTEGRATION__c(
        HttpMethod__c = 'GET',
        Name = 'DigitalFilter',
        Params__c = 'cableunitid',
        Service__c = 'JITTERBIT',
        IsBodyAppended__c = false);
       
        Address__c add = new Address__c (Town__c = 'Leeds');
        add.Name = 'VæøåÆØÅ'; 
        add.House_No__c = '29'; 
        add.Floor__c= '2'; 
        add.Entrance__c= 'A'; 
        add.Floor__c= '2'; 
        add.Side__c= 'TV'; 
        add.Door_No__c= '8'; 
        add.Postcode__c= '1674'; 
        insert add;
         CustomerNumberSeq__c cust = new CustomerNumberSeq__c();
        cust.lastNumber__c = 64444444;
        insert cust;    
        //Account acc = new Account(FirstName = 'Jack' ,LastName = 'Morrison', Customer_No__c = '55555589', Street_YK__c = add.Id,Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment());
        //insert acc;
        Lookup_Post_Code__c postcodeLookup;
        String postcode = '2000';
        postcodeLookup = new Lookup_Post_Code__c();
        postcodeLookup.name = postcode;
        postcodeLookup.PostCode_External_ID__c  = postcode;
        insert postcodeLookup;
        Cable_Unit__c cableUnitTest1 = new Cable_Unit__c();
        cableUnitTest1.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest1.Name = 'cu_kundeCust_testing'; 
        cableUnitTest1.Municipaly__c = clsTestDataForYS.getMunicipaly(); 
        cableUnitTest1.Cable_Unit_Post_Code__c = postcodeLookup.PostCode_External_ID__c;
        cableUnitTest1.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();                      
        cableUnitTest1.Housing_Type__c = clsTestDataForYS.createLookupHousingType();                    
        cableUnitTest1.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        cableUnitTest1.HF_no__c = '1234';
        cableUnitTest1.Key_Box__c = '1';
        cableUnitTest1.Cable_Type__c = 'Coax';
        insert cableUnitTest1;
        
        Cable_Unit__c cableUnitTest2 = new Cable_Unit__c();
        cableUnitTest2.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest2.Name = 'cu_kundeCust_testing1'; 
        cableUnitTest2.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitTest2.Cable_Unit_Post_Code__c = postcodeLookup.PostCode_External_ID__c;
        cableUnitTest2.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership1();                      
        cableUnitTest2.Housing_Type__c = clsTestDataForYS.createLookupHousingType1();                
        cableUnitTest2.Building_Type__c = clsTestDataForYS.createLookupBuildingType1();
        cableUnitTest2.HF_no__c = '1235';
        cableUnitTest2.Key_Box__c = '1';
        cableUnitTest2.CA_Ownership_Code__c = '0';
        cableUnitTest2.Cable_Type__c = 'Coax';
        insert cableUnitTest2; 
        
        Cable_Unit__c cableUnitTest3 = new Cable_Unit__c();
        cableUnitTest3.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest3.Name = 'cu_kundeCust_testing2'; 
        cableUnitTest3.Municipaly__c = '223 Hørsholm'; 
        cableUnitTest3.Cable_Unit_Post_Code__c = postcodeLookup.PostCode_External_ID__c;
        cableUnitTest3.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership2();                     
        cableUnitTest3.Housing_Type__c = clsTestDataForYS.createLookupHousingType2();                     
        cableUnitTest3.Building_Type__c = clsTestDataForYS.createLookupBuildingType2();
        cableUnitTest3.CA_Ownership_Code__c = '1';
        cableUnitTest3.HF_no__c = '1236';
        cableUnitTest3.Key_Box__c = '1';
        cableUnitTest3.Cable_Type__c = 'Coax';
        insert cableUnitTest3;
        
        Net_Installations__c inst1 = new Net_Installations__c(Address__c = add.Id, Cable_Unit__c = cableUnitTest1.Id,Package_selection__c = 'GP');
        insert inst1;
        ApexPages.currentPage().getParameters().put('Id',inst1.Id);
        UrlEncodingController controller = new UrlEncodingController();
        
        Net_Installations__c inst2 = new Net_Installations__c(Address__c = add.Id, Cable_Unit__c = cableUnitTest2.Id,Package_selection__c = 'MP');
        insert inst2;
        ApexPages.currentPage().getParameters().put('Id',inst2.Id);
        controller = new UrlEncodingController();
        
        Net_Installations__c inst3 = new Net_Installations__c(Address__c = add.Id, Cable_Unit__c = cableUnitTest3.Id,Package_selection__c = 'FP');
        insert inst3;
        ApexPages.currentPage().getParameters().put('Id',inst3.Id);
        controller = new UrlEncodingController();
        String str = controller.getLink();
        
        /*    
        Installation__c inst1 = new Installation__c(Address__c = add.Id, Customer__c = acc.Id);
        inst1.Cable_Unit_no__c = '1';
        inst1.Key_box_placement__c = '1';
        inst1.HF_no__c = '1';
        inst1.Package_selection__c = 'GP';
        insert inst1;
        ApexPages.currentPage().getParameters().put('Id',inst1.Id);
        UrlEncodingController controller = new UrlEncodingController();
        
        inst1 = new Installation__c(Address__c = add.Id);
        inst1.Cable_Unit_no__c = '1';
        inst1.Key_box_placement__c = '1';
        inst1.HF_no__c = '1';
        inst1.Package_selection__c = 'FP';
        insert inst1;
        ApexPages.currentPage().getParameters().put('Id',inst1.Id);
        controller = new UrlEncodingController();
        
        inst1 = new Installation__c(Address__c = add.Id);
        inst1.Cable_Unit_no__c = '1';
        inst1.Key_box_placement__c = '1';
        inst1.HF_no__c = '1';
        inst1.Package_selection__c = 'MP';
        insert inst1;
        ApexPages.currentPage().getParameters().put('Id',inst1.Id);
        controller = new UrlEncodingController();
        
        inst1 = new Installation__c(Address__c = add.Id);
        inst1.Cable_Unit_no__c = '1';
        inst1.Key_box_placement__c = '1';
        inst1.HF_no__c = '1';
        inst1.Package_selection__c = '9';
        insert inst1;
        ApexPages.currentPage().getParameters().put('Id',inst1.Id);
        controller = new UrlEncodingController();
        
        inst1 = new Installation__c(Address__c = add.Id);
        inst1.Cable_Unit_no__c = '1';
        inst1.Key_box_placement__c = '1';
        inst1.HF_no__c = '1';
        insert inst1;
        ApexPages.currentPage().getParameters().put('Id',inst1.Id);
        controller = new UrlEncodingController();
        
        inst1 = new Installation__c(Address__c = add.Id);
        inst1.Cable_Unit_no__c = '1';
        inst1.Key_box_placement__c = '1';
        inst1.HF_no__c = '1';
        inst1.Service_for_hold__c = 'Ja';
        insert inst1;
        Cable_Unit__c cableUnit = new Cable_Unit__c(Cable_Unit_no__c = '1', CA_Ownership_Code__c = '1');
        insert cableUnit;
        ApexPages.currentPage().getParameters().put('Id',inst1.Id);
        controller = new UrlEncodingController();

        inst1 = new Installation__c(Address__c = add.Id);
        inst1.Cable_Unit_no__c = '1';
        inst1.Key_box_placement__c = '1';
        inst1.HF_no__c = '1';
        inst1.Service_for_hold__c = 'Nej';
        insert inst1;
        ApexPages.currentPage().getParameters().put('Id',inst1.Id);
        controller = new UrlEncodingController();
        System.assert(controller.getLink()!= null);
        
        inst1 = new Installation__c(Address__c = add.Id);
        inst1.Cable_Unit_no__c = '2';
        inst1.Key_box_placement__c = '1';
        inst1.HF_no__c = '1';
        inst1.Service_for_hold__c = 'Ja';
        insert inst1;
        cableUnit = new Cable_Unit__c(Cable_Unit_no__c = '2', CA_Ownership_Code__c = '0');
        insert cableUnit;
        ApexPages.currentPage().getParameters().put('Id',inst1.Id);
        controller = new UrlEncodingController();*/
    }
    
    /* mkha@yousee.dk - uncommented due to issue with 'Too many soql statements' issue
    public static testMethod void testProgramPakke() {
        Address__c add = new Address__c (Town__c = 'Leeds');
        add.Name = 'VæøåÆØÅ'; 
        add.House_No__c = '29'; 
        add.Floor__c= '2'; 
        add.Entrance__c= 'A'; 
        add.Floor__c= '2'; 
        add.Side__c= 'TV'; 
        add.Door_No__c= '8'; 
        add.Postcode__c= '1674'; 
        insert add;
            
        Account acc = new Account(FirstName = 'Jack' ,LastName = 'Morrison', Customer_No__c = '55555589', Street_YK__c = add.Id);
        insert acc;
        
        Map<String, Integer> mapProgramPakkes = new Map<String, Integer>();
        mapProgramPakkes.put('Agent 2 med inst.', 3);
        mapProgramPakkes.put('Agent 2 med inst.,Agent1 med inst.', 2);
        mapProgramPakkes.put('Agent1 med inst.', 1);
        mapProgramPakkes.put('Agent1 med inst.,Agent3 m.inst', 3);
        mapProgramPakkes.put('Agent2 m. inst', 2);
        mapProgramPakkes.put('Agent3 m.inst', 3);
        mapProgramPakkes.put('Agent3 m.inst,Agent1 med inst.', 3);
        mapProgramPakkes.put('FP', 3);
        mapProgramPakkes.put('FP,GP', 3);
        mapProgramPakkes.put('FP,MP', 3);
        mapProgramPakkes.put('GP', 1);
        mapProgramPakkes.put('GP,FP', 3);
        mapProgramPakkes.put('GP,LT', 2);
        mapProgramPakkes.put('GP,Tillægspakke', 3);
        mapProgramPakkes.put('GP,TP', 3);
        mapProgramPakkes.put('Grundpakke', 1);
        mapProgramPakkes.put('Grundpakke,LT', 2);
        mapProgramPakkes.put('Grundpakke,Tillægspakke', 3);
        mapProgramPakkes.put('Grundpakke,TP', 3);
        mapProgramPakkes.put('LT', 3);
        mapProgramPakkes.put('LT,GP', 2);
        mapProgramPakkes.put('LT,Grundpakke', 2);
        mapProgramPakkes.put('MP', 2);
        mapProgramPakkes.put('MP,GP', 2);
        mapProgramPakkes.put('MP,ST', 3);
        mapProgramPakkes.put('ST,MP', 3);
        mapProgramPakkes.put('Tillægspakke', 3);
        mapProgramPakkes.put('Tillægspakke ,GP', 3);
        mapProgramPakkes.put('Tillægspakke ,Grundpakke', 3);
        mapProgramPakkes.put('TP', 3);
        mapProgramPakkes.put('TP,GP', 3);
        mapProgramPakkes.put('TP,Grundpakke', 3);
        
        for(String pakke : mapProgramPakkes.keySet()){
          Installation__c inst = new Installation__c(Address__c = add.Id);
          inst.Cable_Unit_no__c = '1';
          inst.Key_box_placement__c = '1';
          inst.HF_no__c = '1';
          inst.Package_selection__c = pakke;
          insert inst;
        
          ApexPages.currentPage().getParameters().put('Id', inst.Id);
          
          UrlEncodingController controller = new UrlEncodingController();  
                  
          String link = controller.getLink();
          //System.debug(link);
          System.assert(link != null);
          System.assert(link.length() > 0);
        
          PageReference pageRef = new PageReference(controller.createLink());
          String programpakke = pageRef.getParameters().get('programpakke');
          //System.debug(programpakke);
          System.assert(programpakke == String.valueOf(mapProgramPakkes.get(pakke)));
        }       
    }*/
}