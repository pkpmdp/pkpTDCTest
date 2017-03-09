@isTest(seeAllData=true)
public class CustomerTeamRoleDetailsTestClass{

 static testMethod void singleCustomerTeamRoleDetailsTest() {    
     
     	
        CustomerTeamRoleDetails.CustomerTeamRoleWrapper cWrapObj=new CustomerTeamRoleDetails.CustomerTeamRoleWrapper();
        cWrapObj.roleCode='Salgsansvarlig';
        cWrapObj.roleName='Salgsansvarlig';
        cWrapObj.roleId='a0wD00000017IrhIAE';
        cWrapObj.endDate=Date.valueOf('2100-01-01');
        cWrapObj.startDate=Date.valueOf('1900-01-01');
        
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/customerteamrole';
         RestContext.request.addParameter('action', 'getroleId');   
         RestContext.request.addParameter('roleid', 'a0wD00000017IrhIAE');  
        CustomerTeamRoleDetails.getAction();
        List<CustomerTeamRoleDetails.CustomerTeamRoleWrapper> customerTeamRoleWrpList=CustomerTeamRoleDetails.getSingleCustomerTeamRoleDetails();
        List<Lookup_Account_Team_Role__c> customerTeamRoleList = [SELECT Active__c,Code__c,Name,Id,Start_Date__c,End_Date__c FROM Lookup_Account_Team_Role__c limit 1]; 
        List<CustomerTeamRoleDetails.CustomerTeamRoleWrapper> cWrapObj2=CustomerTeamRoleDetails.getMapTocustomerTeamRoleList(customerTeamRoleList);
    }
    //test role id null
    static testMethod void singleCustomerTeamRoleDetailsTest2() { 
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/customerteamrole';
         RestContext.request.addParameter('action', 'getroleId');   
        // RestContext.request.addParameter('roleid', 'a0wD00000017IrhIAE');  
        CustomerTeamRoleDetails.getAction();    
        List<CustomerTeamRoleDetails.CustomerTeamRoleWrapper> customerTeamRoleWrpList=CustomerTeamRoleDetails.getSingleCustomerTeamRoleDetails();
        CustomerTeamRoleDetails.getSingleCustomerTeamRoleDetails();
    }
    
    static testMethod void allCustomerTeamRoleDetailsTest() {    
        
        ContactWrapper cWrapObj=new ContactWrapper();
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/contact';
        RestContext.request.addParameter('action', 'all');  
         CustomerTeamRoleDetails.getAction();
        CustomerTeamRoleDetails.getAllCustomerTeamRoleDetails();
    }
    //test action null
    static testMethod void allCustomerTeamRoleDetailsTest2() {    
        
        ContactWrapper cWrapObj=new ContactWrapper();
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/contact';
      //  RestContext.request.addParameter('action', 'all');  
         CustomerTeamRoleDetails.getAction();
       
    }
    //test other action
    static testMethod void allCustomerTeamRoleDetailsTest3() {    
        
        ContactWrapper cWrapObj=new ContactWrapper();
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/contact';
        RestContext.request.addParameter('action', 'elseTest');  
         CustomerTeamRoleDetails.getAction();
       
    }
    
    static testMethod void activeCustomerTeamRoleDetailsTest() {   
        ContactWrapper cWrapObj=new ContactWrapper();
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/contact';
        RestContext.request.addParameter('action', 'active');  
        CustomerTeamRoleDetails.getAction();
        CustomerTeamRoleDetails.getActiveCustomerTeamRoleDetails();      
    }

}