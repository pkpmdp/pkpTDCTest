@isTest(SeeAllData = true)
private class cInstallationSCTestClass{

    static TestMethod void unitTest(){
        Test.startTest();
        Address__c tempAdd = new Address__c();
        tempAdd.Street__c = 'Amagerbrogade';
        tempAdd.Entrance__c = '';
        tempAdd.House_No__c = '40';
        tempAdd.Floor__c = '1';
        //tempAdd.Side__c ='';
        tempAdd.Postcode__c = '';
        tempAdd.Town__c = 'Orderse C'; 
        tempAdd.Door_No__c = '3';
        insert tempAdd;
        
        Net_Installations__c tempInstall = new Net_Installations__c();
        Subscription__c tempSubscription = new Subscription__c();
        
        cInstallation cInst1 = new cInstallation(tempInstall, tempSubscription);
        cInstallation cInst = new cInstallation();
        cInstallation cInstSub = new cInstallation(tempSubscription);
        cInstallation cInstInst = new cInstallation(tempInstall);
        Subscription__c tempSub = new Subscription__c();
        
        cInst1.getFullAddress();
        cInst1.getFormattedAddress();
        cInst1.getCurrentProductName();
        cInst1.tvpackage = '';
    	cInst1.packageChangedDate = ''; 
    	cInst1.selectedmyBeboer = false;
    	cInst1.myBebeorTxt = '';
    	cInst1.optionsPackages = new List<SelectOption>();
    	cInst1.futureSubsPackage= '';
    	cInst1.effectiveDate = '';
    	cInst1.effectiveEndDate = '';  
    	cInst1.productName = '';
    	cInst1.checkBlandSelv= false;
    	cInst1.blandSelvEmailID= '';
    	cInst1.installationLbnr = '';
    	cInst1.errorFlag = '';
    	cInst1.errorCode = '';
    	cInst1.errorMessage = '';
    	cInst1.amsId= '';
    	cInst1.formatAddress= '';
        cInst1.nybeboerHref = '';
    	cInst1.nybeboerMediaType = '';
		cInst1.nybeboerFlag = false;
    	cInst1.existingSortering = '';
    	cInst1.errorSubscFlag = false;
    	cInst1.countSubscFlag  = 0;
    	cInst1.testFlag  = 0;
    	cInst1.subsCount  = 0;
    	cInst1.checkValidate = false; 
        cInst1.isBadPayee = false;
        cInst1.productsList = new List<cInstallation.cProducts>();
    	cInst1.nybeborList = new List<String>();
        Test.stopTest();
        
    }
   /* static TestMethod void unitTest2(){
        Test.startTest();
        String tempName;
        String tempNo;
        String temphRef;
        String tempMediaType;
        String tempSort;
        Test.stopTest();
    
    }    */

}