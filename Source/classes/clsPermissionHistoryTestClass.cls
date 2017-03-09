/**
	********************************************************************************
	********************************************************************************

	* @Test class: clsPermissionHistoryTestClass.
	* @author: Capgemini Consulting India Pvt. Ltd.
	* @Created Date = june 2013.
	* @description: this is used for the class clsPermissionHistory.

	**********************************************************************************
	**********************************************************************************
*/

@isTest
public class clsPermissionHistoryTestClass{
	 static String returnAccountId(){
	 	Address__c addr = new Address__c();                                     
        addr.Town__c = 'AH'; 
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301'; 
        addr.Side__c = 'A';
        addr.Floor__c ='Third';
        addr.House_No__c = 'test';
        addr.Street__c = 'AH';    
        addr.Entrance__c = 'A';
        insert addr; 
         
		RecordType rt = [select id,name from recordtype where sobjecttype='Account' limit 1];
        Account acc= new Account();
        acc.Name ='test2445';
        acc.Dealer_Number__c ='T7006';   
        acc.Street_YK__c = addr.Id;
        acc.Billing_Address__c = addr.Id;
        acc.Phone = '223225';
        acc.Email__c = 'abc@xyz.com';
        acc.Customer_No__c = '123459'; 
        acc.DealerProducts__c ='Bredbånd;Ekstrakanaler;Telefoni;YouBio';
        acc.DealerGroup__c = 'Fona';
        acc.PO_Box_alt__c ='2450';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment(); 
        acc.RecordTypeId = rt.Id;
        insert acc;
        return acc.id;
	 }
     static testMethod void myDataCreation(){
        String accId = returnAccountId();
        Permission__c per = new Permission__c();
        per.Nej_til_markedsforing__c = true;
        per.Driftsinfo_pa_email__c=true;
        per.E_kommunikation__c = false;
        per.Customer__c = accId;
        insert per;
        
     	ApexPages.CurrentPage().getParameters().put('Id',accId);
     	ApexPages.StandardController controller;
     	clsPermissionHistory clsPer = new clsPermissionHistory(controller);
     }
     static testMethod void callRedirect(){
     	String accId = returnAccountId();
     	
     	Permission__c per = new Permission__c();
        per.Nej_til_markedsforing__c = true;
        per.Driftsinfo_pa_email__c=true;
        per.E_kommunikation__c = false;
        per.Customer__c = accId;
        insert per;
        
     	ApexPages.CurrentPage().getParameters().put('Id',accId);
     	ApexPages.StandardController controller;
     	clsPermissionHistory clsPer = new clsPermissionHistory(controller);
        clsPer.Redirect();
     }
     static testMethod void permissionHistoryValues(){
     	String accId = returnAccountId();
        Permission__c per = new Permission__c();
        per.Nej_til_markedsforing__c = true;
        per.Driftsinfo_pa_email__c=false;
        per.E_kommunikation__c = false;
        per.Customer__c = accId;
        insert per;
        per = new Permission__c();
        per = [Select Nej_til_markedsforing__c,Driftsinfo_pa_email__c,Customer__c from Permission__c where Customer__c=:accId];
        per.Nej_til_markedsforing__c = true;
        per.Driftsinfo_pa_email__c = true;
        per.E_kommunikation__c = true;
        update per;
        
        Permission__History perHis = new Permission__History(ParentId = per.id, Field = 'Nej_til_markedsforing__c'); 
  		insert perhis; 
        
     	ApexPages.CurrentPage().getParameters().put('Id',per.Id);
     	ApexPages.StandardController controller;
     	clsPermissionHistory clsPer = new clsPermissionHistory(controller);
     	clsPer.getPerhis();
     }
     static testMethod void noSavedPermissions(){
     	String accId = returnAccountId();
     	ApexPages.CurrentPage().getParameters().put('Id',accId);
     	ApexPages.StandardController controller;
     	clsPermissionHistory clsPer = new clsPermissionHistory(controller);
     	clsPer.Redirect();
     }
}