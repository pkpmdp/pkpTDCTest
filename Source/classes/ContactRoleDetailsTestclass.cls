@isTest
private class ContactRoleDetailsTestclass {

    static testMethod void customerContactRoleDetailsTest() {
    	
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/contactrole';
        RestContext.request.addParameter('cableunitno','000002147');
        RestContext.request.addParameter('action','all');
        
        Lookup_Contact_Roles__c lcrObj=new Lookup_Contact_Roles__c();
        insert lcrObj;
        String lcrId=lcrObj.Id;
               
        
        
        List<String> ids=new List<String>();
        ids.add(lcrId);             
        String jsonString=JSON.serialize(ids);
        RestContext.request.requestBody=Blob.valueOf(jsonString);         
        Blob body = RestContext.request.requestBody;
        String bodyString = body.toString();
      	String[] jsonwrap =(String[])JSON.deserialize(bodyString,String[].class);
        List<Id> idList = new List<Id>();
        for(String id1 : jsonwrap){
            idList.add(id1);
        }       
        ContactRoleDetails.doPostAction(); 
        ContactRoleDetails.getContactRoleDetail();
        
        ContactRoleDetails.ContactRoleWrapper conWrapper=new ContactRoleDetails.ContactRoleWrapper();      
        conWrapper.visKontrakt=true;
        conWrapper.roleCode='teest';
        conWrapper.roleId='32423';
        conWrapper.roleName='test';
       
        conWrapper.aktiv=true;
        conWrapper.portalDescription='test';
        conWrapper.startDate=Date.today();
        conWrapper.endDate=Date.valueOf('2013-12-12');
        conWrapper.showInPortal=true;
        
        
        List<Lookup_Contact_Roles__c> roleList = [SELECT Code__c,Id,Name,Vis_i_kontrakt__c,Active__c,Start_Date__c,End_Date__c,Visible_in_Service_Centre__c,Portal_Description__c FROM Lookup_Contact_Roles__c WHERE ID IN :idList];
       ContactRoleDetails.getMapToContactRoleList(roleList);
    }
    static testMethod void customerContactRoleDetailsTest2() {
    	
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/contactrole';
        RestContext.request.addParameter('cableunitno','000002147');
        //RestContext.request.addParameter('action','all');        
        Lookup_Contact_Roles__c lcrObj=new Lookup_Contact_Roles__c();
        insert lcrObj;
        String lcrId=lcrObj.Id;      
        
        List<String> ids=new List<String>();
        ids.add(lcrId);             
        String jsonString=JSON.serialize(ids);
        RestContext.request.requestBody=Blob.valueOf(jsonString);         
        Blob body = RestContext.request.requestBody;
        String bodyString = body.toString();
      	String[] jsonwrap =(String[])JSON.deserialize(bodyString,String[].class);
        List<Id> idList = new List<Id>();
        for(String id1 : jsonwrap){
            idList.add(id1);
        }       
        ContactRoleDetails.doPostAction(); 
        ContactRoleDetails.getContactRoleDetail();
        
        List<Lookup_Contact_Roles__c> roleList = [SELECT Code__c,Id,Name,Vis_i_kontrakt__c,Active__c,Start_Date__c,End_Date__c,Visible_in_Service_Centre__c,Portal_Description__c FROM Lookup_Contact_Roles__c WHERE ID IN :idList];
       ContactRoleDetails.getMapToContactRoleList(roleList);
    }
    
    static testMethod void singleContactRoleDetailsTest() {
    	
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/contactrole';
        RestContext.request.addParameter('cableunitno','000002147');
        RestContext.request.addParameter('action','getroleId');
        Lookup_Contact_Roles__c lcrObj=new Lookup_Contact_Roles__c();
        insert lcrObj;
        String lcrId=lcrObj.Id;
        RestContext.request.addParameter('roleid',lcrId);
       
        ContactRoleDetails.getAction();
        ContactRoleDetails.getSingleContactRoleDetails();
    }
    
    static testMethod void singleContactRoleDetailsTest2() {
    	
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/contactrole';
        RestContext.request.addParameter('cableunitno','000002147');
        RestContext.request.addParameter('action','elseTest');
        ContactRoleDetails.getAction();
        ContactRoleDetails.getSingleContactRoleDetails();
    }
    
    static testMethod void allContactRoleDetailsTest() {
    	
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/contactrole';
        RestContext.request.addParameter('cableunitno','000002147');
        RestContext.request.addParameter('action','all');
        Lookup_Contact_Roles__c lcrObj=new Lookup_Contact_Roles__c();
        lcrObj.Start_Date__c=Date.today();
        lcrObj.End_Date__c=Date.valueOf('2100-12-12');        
        insert lcrObj;       
        ContactRoleDetails.getAction();
        ContactRoleDetails.getAllContactRoleDetails();
    }
     static testMethod void allContactRoleDetailsTest2() {
    	
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/contactrole';
        RestContext.request.addParameter('cableunitno','000002147');
        ContactRoleDetails.getAction();
        ContactRoleDetails.getAllContactRoleDetails();
    }
     static testMethod void activeContactRoleDetailsTest() {
    	
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/contactrole';
        RestContext.request.addParameter('cableunitno','000002147');
        RestContext.request.addParameter('action','active');
        Lookup_Contact_Roles__c lcrObj=new Lookup_Contact_Roles__c();
        lcrObj.Start_Date__c=Date.today();
        lcrObj.End_Date__c=Date.valueOf('2100-12-12');        
        insert lcrObj;       
       
        ContactRoleDetails.getAction();
        ContactRoleDetails.getActiveContactRoleDetails();
    }
    static testMethod void activeContactRoleDetailsTest2() {
    	
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/contactrole';
        RestContext.request.addParameter('cableunitno','000002147');
        //RestContext.request.addParameter('action','active');
        Lookup_Contact_Roles__c lcrObj=new Lookup_Contact_Roles__c();
        lcrObj.Start_Date__c=Date.today();
        lcrObj.End_Date__c=Date.valueOf('2100-12-12');        
        insert lcrObj;       
       
        ContactRoleDetails.getAction();
        ContactRoleDetails.getActiveContactRoleDetails();
    }
}