@isTest
private class OperativeTroubleshootingControllerTest {

    static testMethod void testOperativeTroubleshootingController() {
        // create testing data
        Address__c add = new Address__c(
            Street__c='Main Street', Town__c='Leeds', Postcode__c='0000'
        );
        insert add;

        Account acc = new Account(
            Name='Test Account 1', Customer_No__c='123456789', Street_YK__c=add.Id, 
        							Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment());
        insert acc;

		Cable_Unit__c cableUnitTest1 = new Cable_Unit__c();
        cableUnitTest1.Name = 'cu_kundeCust_testing'; 
        cableUnitTest1.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest1.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitTest1.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest1.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnitTest1.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnitTest1.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        cableUnitTest1.HF_no__c = '1234';
        cableUnitTest1.Key_Box__c = '1';
        insert cableUnitTest1;
        
        
        Net_Installations__c inst = new Net_Installations__c(Address__c = add.Id, Cable_Unit__c = cableUnitTest1.Id,Package_selection__c = 'GP');
        insert inst;
        
        /*Installation__c inst = new Installation__c(Address__c=add.Id, Customer__c=acc.Id);
        insert inst;*/

        Operative_Troubleshooting__c ot1 = new Operative_Troubleshooting__c(
            Area__c='0900 Teglholmsgade',
            Updated_date__c=DateTime.newInstance(2011, 6, 1),
            Start_date__c=Datetime.now().addDays(-1) // yesterday
        );
        insert ot1;

        Operative_Troubleshooting__c ot2 = new Operative_Troubleshooting__c(
            Area__c='D01-Danmark',
            Updated_date__c=DateTime.newInstance(2011, 5, 1),
            Start_date__c=Datetime.now() // today
        );
        insert ot2;

        Operative_Troubleshooting__c ot3 = new Operative_Troubleshooting__c(
            Area__c='D01-Danmark',
            Updated_date__c=DateTime.newInstance(2011, 4, 1),
            Start_date__c=Datetime.now().addDays(1) // tomorrow
        );
        insert ot3;

        Operative_Troubleshooting__c ot4 = new Operative_Troubleshooting__c(
            Area__c='0900 Teglholmsgade',
            Updated_date__c=DateTime.newInstance(2011, 3, 1),
            Start_date__c=Datetime.now() // today
        );
        insert ot4; 

        OperativeTroubleshootingPostcodes__c op11 = new OperativeTroubleshootingPostcodes__c(
            Operative_Troubleshooting__c=ot1.Id, PostCode__c='0000'
        );
        OperativeTroubleshootingPostcodes__c op12 = new OperativeTroubleshootingPostcodes__c(
            Operative_Troubleshooting__c=ot1.Id, PostCode__c='0001'
        );
        insert new OperativeTroubleshootingPostcodes__c[]{op11, op12};

        OperativeTroubleshootingPostcodes__c op21 = new OperativeTroubleshootingPostcodes__c(
            Operative_Troubleshooting__c=ot2.Id, PostCode__c='0000'
        );
        OperativeTroubleshootingPostcodes__c op22 = new OperativeTroubleshootingPostcodes__c(
            Operative_Troubleshooting__c=ot2.Id, PostCode__c='1234'
        );
        insert new OperativeTroubleshootingPostcodes__c[]{op21, op22};

        Bier_Reg2Post__c reg2post1 = new Bier_Reg2Post__c(Region__c='10', Postcode__c='0000');
        insert reg2post1;
        Bier_Region__c region1 = new Bier_Region__c(Bier_ID__c='10', Name='D01-Danmark');
        insert region1;

        // create controller
        OperativeTroubleshootingController ctrl = new OperativeTroubleshootingController(
            new ApexPages.StandardController(acc)
        );

        // getOperativesUrl
        System.assertEquals(ctrl.getOperativesUrl(), OperativeTroubleshootingController.BIER_URL_FN);

        // check getOperatives method
        List<Operative_Troubleshooting__c> lst = ctrl.getOperatives();
        // Only 3 should be in the resulting list:
        // ot1 -> Operative Troubleshooting ot1 is related to OperativeTroubleshootingPostcodes op11
        // and op11's PostCode '0000' is the same as the PostCode of the Address related to
        // the Installation which is related to the given Account
        // ot2 -> Operative Troubleshooting ot2 is related to OperativeTroubleshootingPostcodes op21
        // and op21's PostCode '0000' is the same as the PostCode of the Address related to
        // the Installation which is related to the given Account
        // ot3 -> Operative Troubleshooting ot3's Area 'D01-Danmark' is the same as the Name of
        // the Bier Region and it's Bier ID '10' is the same as the Region of the Bier Reg2Post
        // and it's Postcode '0000' is the same as the PostCode of the Address related to
        // the Installation which is related to the given Account
        Boolean gotOt1 = false;
        Boolean gotOt2 = false;
        Boolean gotOt3 = false;
        System.assert(lst != null && lst.size() >= 3);
        System.assertEquals(ctrl.NumberOfRecords, lst.size());
        // Check if there are all 3 expected records in the resulting list
        for (Integer i=0; i<lst.size(); ++i) {
            if (lst[i].Id == ot1.Id) {
                gotOt1 = true;
            } else if (lst[i].Id == ot2.Id) {
                gotOt2 = true;
            } else if (lst[i].Id == ot3.Id) {
                gotOt3 = true;
            }
        }
        System.assert(gotOt1 && gotOt2 && gotOt3);

        // Current records
        lst = ctrl.getCurrent();
        System.assert(lst != null && lst.size() >= 2);
        // Coming records
        lst = ctrl.getComing();
        System.assert(lst != null && lst.size() >= 1);

        // ActiveActivitiesCount
        System.assertEquals(ctrl.ActiveActivitiesCount, 0);
        // ActiveActivitiesUrl
        System.assertEquals(ctrl.ActiveActivitiesUrl, '/apex/ActiveActivitiesPage?CustomerId='+acc.Id);
        // ActiveActivitiesCount
        System.assertEquals(ctrl.ActiveErrorsCount, 0);
        // ActiveActivitiesUrl
        System.assertEquals(ctrl.ActiveErrorsUrl, '/apex/ActiveErrorsPage?CustomerId='+acc.Id);

        ActiveActivities__c aa1 = new ActiveActivities__c(
            Customer__c=acc.Id, Name='1', ActiveActivityID__c=1
        );
        ActiveActivities__c aa2 = new ActiveActivities__c(
            Customer__c=null, Name='2', ActiveActivityID__c=2
        );
        insert new ActiveActivities__c[]{aa1, aa2};

        ActiveErrors__c ae = new ActiveErrors__c(Customer__c=acc.Id, Name='1',ActiveErrorId__c=1);
        insert ae;

        // create controller
        OperativeTroubleshootingController ctrl2 = new OperativeTroubleshootingController(
            new ApexPages.StandardController(acc)
        );

        // ActiveActivitiesCount
        System.assertEquals(ctrl2.ActiveActivitiesCount, 1);
        // ActiveActivitiesUrl
        System.assertEquals(ctrl2.ActiveActivitiesUrl, (OperativeTroubleshootingController.BIER_URL_AA+'1'));
        // ActiveActivitiesCount
        System.assertEquals(ctrl2.ActiveErrorsCount, 1);
        // ActiveActivitiesUrl
        System.assertEquals(ctrl2.ActiveErrorsUrl, (OperativeTroubleshootingController.BIER_URL_AE+'1'));

        ActiveActivities__c aa3 = new ActiveActivities__c(Customer__c=acc.Id, Name='3');
        insert aa3;

        ActiveErrors__c ae2 = new ActiveErrors__c(Customer__c=acc.Id, Name='2');
        insert ae2;

        // create controller
        OperativeTroubleshootingController ctrl3 = new OperativeTroubleshootingController(
            new ApexPages.StandardController(acc)
        );

        // ActiveActivitiesCount
        System.assertEquals(ctrl3.ActiveActivitiesCount, 2);
        // ActiveActivitiesUrl
        System.assertEquals(ctrl3.ActiveActivitiesUrl, '/apex/ActiveActivitiesPage?CustomerId='+acc.Id);
        // ActiveActivitiesCount
        System.assertEquals(ctrl3.ActiveErrorsCount, 2);
        // ActiveActivitiesUrl
        System.assertEquals(ctrl3.ActiveErrorsUrl, '/apex/ActiveErrorsPage?CustomerId='+acc.Id);
    }

    static testMethod void testTransferredToBier() {
        Address__c add = new Address__c(
            Street__c='Main Street', Town__c= 'Leeds', Postcode__c='0000');
        insert add;

        Account acc = new Account(
            Name='Test Account 1', Customer_No__c='123456789', Street_YK__c=add.Id, Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment());
        insert acc;

        ActiveActivities__c aa1 = new ActiveActivities__c(
            Customer__c=acc.Id, Name='1', ActiveActivityID__c=1, Transferred_to_Bier__c=False);
        insert aa1;

        OperativeTroubleshootingController ctr = new OperativeTroubleshootingController(
            new ApexPages.StandardController(acc)
        );
        System.assertEquals(ctr.ActiveActivitiesCount, 1);
        System.assertEquals(ctr.ActiveActivitiesUrl, '#');
    }
}