@isTest(seeAllData=true)
private class CustomerTeamContactRoleTestClass {

	/*static void initialiseTestData()
	{
		YSRecordTypes__c r=new YSRecordTypes__c();
      	r.Name='YSRecordTypes';
      	r.YS_Contact_Record_Type__c='012D0000000BD3N';
      	insert r;
      	
      	Contact conObj=new Contact(Email='test@test.com');
      	conObj.RecordTypeId=r.YS_Contact_Record_Type__c;
      	insert conObj;
      	
      	Lookup_Contact_Roles__c lcrObj=new Lookup_Contact_Roles__c(Name='testRole');      	
      	insert lcrObj;
      	
		Account_Contact_Role__c acrObj=new Account_Contact_Role__c();
		acrObj.Role__r.Name='test';
		acrObj.Customer__r.Cable_Unit__r.Cable_Unit_No__c='05011647';
		acrObj.Contact__r.RecordTypeId=conObj.RecordTypeId;
		acrObj.Contact__r.Email=conObj.Email;
		insert acrObj;
		
		Lookup_Account_Team_Role__c atRoleObj=new Lookup_Account_Team_Role__c(Name='testATeamRoleName');
		insert atRoleObj;
		
		Account_Team__c atObj=new Account_Team__c();
		atObj.Customer_Team_Role__r.Name=atRoleObj.Name;
		atObj.Customer__r.Cable_Unit__r.Cable_Unit_No__c='05011647';
		atObj.Customer_Team_Member__r.Email__c='test@test.com';
		
		insert atObj;
	}*/
    static testMethod void accountTeamDetailsTest1() {
    	//initialiseTestData();  
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/customerteamcontactrole';
        RestContext.request.addParameter('rolename', 'Teknisk sagskontakt');   
        RestContext.request.addParameter('cableunitno','0000002147');
        RestContext.request.addParameter('type','external');
        RestContext.request.addParameter('action','emailid');                
        CustomerTeamContactRole.doGetAction();
      	CustomerTeamContactRole.getAccountTeamDetails();      	                     
    }
     static testMethod void accountTeamDetailsTest11() {
    	//initialiseTestData();  
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/customerteamcontactrole';
        RestContext.request.addParameter('rolename', 'Teknisk sagskontakt');   
       // RestContext.request.addParameter('cableunitno','0000002147');
        RestContext.request.addParameter('type','external');
        RestContext.request.addParameter('action','emailid');                
        CustomerTeamContactRole.doGetAction();
      	CustomerTeamContactRole.getAccountTeamDetails();      	                     
    }
     static testMethod void accountTeamDetailsTest111() {
    	//initialiseTestData();  
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/customerteamcontactrole';
        RestContext.request.addParameter('rolename', 'test');   
       // RestContext.request.addParameter('cableunitno','05011647');
        RestContext.request.addParameter('type','external');
        RestContext.request.addParameter('action','emailid');                
        CustomerTeamContactRole.doGetAction();
      	CustomerTeamContactRole.getAccountTeamDetails();      	                     
    }
    static testMethod void accountTeamDetailsTest2() {
    	//initialiseTestData();  
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/customerteamcontactrole';
        RestContext.request.addParameter('rolename', 'Salgsansvarlig');   
        RestContext.request.addParameter('cableunitno','0000006288');
        RestContext.request.addParameter('type','internal');
		RestContext.request.addParameter('action','');                
        CustomerTeamContactRole.doGetAction();
      	CustomerTeamContactRole.getAccountTeamDetails();     	                     
    }
     static testMethod void accountTeamDetailsTest22() {
    	//initialiseTestData();  
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/customerteamcontactrole';
        RestContext.request.addParameter('rolename', 'Salgsansvarlig');   
       // RestContext.request.addParameter('cableunitno','0000006288');
        RestContext.request.addParameter('type','internal');
		RestContext.request.addParameter('action','');                
        CustomerTeamContactRole.doGetAction();
      	CustomerTeamContactRole.getAccountTeamDetails();     	                     
    }
     static testMethod void accountTeamDetailsTest222() {
    	//initialiseTestData();  
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/customerteamcontactrole';
        RestContext.request.addParameter('rolename', 'Sagskontakt');   
        RestContext.request.addParameter('cableunitno','05454547');
        RestContext.request.addParameter('type','internal');
		RestContext.request.addParameter('action','test');                
        CustomerTeamContactRole.doGetAction();
      	CustomerTeamContactRole.getAccountTeamDetails();     	                     
    }
    static testMethod void accountTeamDetailsTest3() {
    	//initialiseTestData();  
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/customerteamcontactrole';
        RestContext.request.addParameter('rolename', 'Sagskontakt');   
       // RestContext.request.addParameter('cableunitno','');
        RestContext.request.addParameter('type','internal');
		//RestContext.request.addParameter('action','');                
        CustomerTeamContactRole.doGetAction();
      	CustomerTeamContactRole.getAccountTeamDetails();     	                     
    }
}