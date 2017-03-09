@isTest(seeAllData=true)
private class CustomerTeamDetailsTestClass {

   static testMethod void singleCustomerTeamRoleDetailsTest() {    
     
     	
       CustomerTeamDetails.CustomerTeamWrapper cWrapObj=new CustomerTeamDetails.CustomerTeamWrapper();
       cWrapObj.roleCode='Salgsansvarlig';
       cWrapObj.roleName='Salgsansvarlig';
       cWrapObj.staffActorId='a0ND0000003xgliMAA';
       cWrapObj.staffId='PCRM-US-----3224116';
       
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/customerteam';
         RestContext.request.addParameter('action', 'getaccountteam');   
        RestContext.request.addParameter('cableunitno','000006277');
        CustomerTeamDetails.doGetAction();
      	CustomerTeamDetails.getCustomerTeamDetails();
      	List<Account_Team__c> customerTeamList = [SELECT Id,Cable_Unit__c,Customer_Team_Member_Kiss_Id__c,Customer_Team_Role__r.Code__c,Customer_Team_Role__r.Name,Customer__r.Cable_Unit_No__c FROM Account_Team__c limit 5];
      	CustomerTeamDetails.mapToCustomerTeamList(customerTeamList);
                     
    }
    //null action test
    static testMethod void singleCustomerTeamRoleDetailsTest2() {    
     
     	
       CustomerTeamDetails.CustomerTeamWrapper cWrapObj=new CustomerTeamDetails.CustomerTeamWrapper();
       cWrapObj.roleCode='Salgsansvarlig';
       cWrapObj.roleName='Salgsansvarlig';
       cWrapObj.staffActorId='a0ND0000003xgliMAA';
       cWrapObj.staffId='PCRM-US-----3224116';
       
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/customerteam';         
        RestContext.request.addParameter('cableunitno','000006277');
        CustomerTeamDetails.doGetAction();
      	CustomerTeamDetails.getCustomerTeamDetails();
      	List<Account_Team__c> customerTeamList = [SELECT Id,Cable_Unit__c,Customer_Team_Member_Kiss_Id__c,Customer_Team_Role__r.Code__c,Customer_Team_Role__r.Name,Customer__r.Cable_Unit_No__c FROM Account_Team__c limit 5];
      	CustomerTeamDetails.mapToCustomerTeamList(customerTeamList);
                     
    }
    //other action test and cableUnit null
    static testMethod void singleCustomerTeamRoleDetailsTest3() {    
     
     	
       CustomerTeamDetails.CustomerTeamWrapper cWrapObj=new CustomerTeamDetails.CustomerTeamWrapper();
       cWrapObj.roleCode='Salgsansvarlig';
       cWrapObj.roleName='Salgsansvarlig';
       cWrapObj.staffActorId='a0ND0000003xgliMAA';
       cWrapObj.staffId='PCRM-US-----3224116';
       
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/customerteam';
         RestContext.request.addParameter('action', 'elseTest'); //else action  
       // RestContext.request.addParameter('cableunitno','000006277');
        CustomerTeamDetails.doGetAction();
      	CustomerTeamDetails.getCustomerTeamDetails();
      	List<Account_Team__c> customerTeamList = [SELECT Id,Cable_Unit__c,Customer_Team_Member_Kiss_Id__c,Customer_Team_Role__r.Code__c,Customer_Team_Role__r.Name,Customer__r.Cable_Unit_No__c FROM Account_Team__c limit 5];
      	CustomerTeamDetails.mapToCustomerTeamList(customerTeamList);
                     
    }
    
    static testMethod void staffMemberDetailsTest() {   
       
        CustomerTeamDetails.StaffMemberWrapper sWrapObj=new CustomerTeamDetails.StaffMemberWrapper();
        //sWrapObj.customerId='p.xc------159361081';
        sWrapObj.fullName='Søren Freddy Olsen';
        sWrapObj.role='Salgsansvarlig';
        sWrapObj.userId='A65594';
        sWrapObj.cableUnitNumber = '0000000005';
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/customerteam';
        RestContext.request.addParameter('action', 'postaccountteam');   
        RestContext.request.addParameter('cableunitno','000006277');
         
        List<String> ids=new List<String>();
        ids.add('0000000005');
        ids.add('0000000006');
        
        String jsonString=JSON.serialize(ids);
        RestContext.request.requestBody=Blob.valueOf(jsonString);        
        CustomerTeamDetails.doPostAction();
      	CustomerTeamDetails.getStaffMemberDetails();
      	List<Account_Team__c> staffMemberList = [SELECT Id,Customer_Kiss_Id__c ,Customer_Team_Member_Lookup_Code__c ,Customer_Team_Member_Name__c,Customer_Team_Role_Lookup_Code__c,Customer__r.Cable_Unit_No__c FROM Account_Team__c limit 5];
      	CustomerTeamDetails.getMapToStaffList(staffMemberList);
                     
    }
    //do post null action and json null test
    static testMethod void staffMemberDetailsTest2() {  
       
        CustomerTeamDetails.StaffMemberWrapper sWrapObj=new CustomerTeamDetails.StaffMemberWrapper();
        //sWrapObj.customerId='p.xc------159361081';
        sWrapObj.fullName='Søren Freddy Olsen';
        sWrapObj.role='Salgsansvarlig';
        sWrapObj.userId='A65594';
        sWrapObj.cableUnitNumber = '0000000005';
        
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/customerteam';
        //RestContext.request.addParameter('action', 'postaccountteam');   
        RestContext.request.addParameter('cableunitno','000006277');
         
        List<String> ids=new List<String>();      
        
        String jsonString=JSON.serialize(ids);
        RestContext.request.requestBody=Blob.valueOf(jsonString);       
        CustomerTeamDetails.doPostAction();
      	CustomerTeamDetails.getStaffMemberDetails();
                     
    }
}