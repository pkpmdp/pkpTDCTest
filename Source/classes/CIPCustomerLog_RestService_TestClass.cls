@isTest 
public with sharing class CIPCustomerLog_RestService_TestClass {
	
	  //getCustomerLog
	  public static Customer_Log__c clObj{get;set;}
	  public static Account testAccount{get;set;}
	  public static Cable_Unit__c testCableUnit{get;set;}
	  
	  
	  static void setupData(){
	  	
	  	Lookup_Building_Type__c buildingType;
		Lookup_Housing_Type__c housingType;
		Lookup_Housing_Ownership__c housingOwnerShip;
		
		Lookup_Customer_Segment__c customerSegment = new Lookup_Customer_Segment__c(); 
		customerSegment.Name = 'ParceInt_Test'; 
		customerSegment.Code__c = 'pnetTest'; 
		customerSegment.SourceId__c = 'PCRM-seg---98777511';
		insert customerSegment;
		
		buildingType = new Lookup_Building_Type__c();               
		buildingType.name ='Private bunglow';
		buildingType.Code__c='12121';
		buildingType.End_Date__c = date.today().addMonths(1);
		buildingType.Start_Date__c= date.today();
		buildingType.SourceId__c='Private bunglow34';
		insert buildingType;
		
		housingType = new Lookup_Housing_Type__c(); 
		housingType.name = 'Private andelstype';
		housingType.Code__c = '12121';
		housingType.End_Date__c = date.today().addMonths(1);
		housingType.Start_Date__c = date.today();
		housingType.SourceId__c = 'Private bunglow545';
		insert housingType;
		
		housingOwnerShip = new Lookup_Housing_Ownership__c();
		housingOwnerShip.name = 'Andel';
		housingOwnerShip.Code__c = '12121';
		housingOwnerShip.End_Date__c = date.today().addMonths(1);
		housingOwnerShip.Start_Date__c = date.today();
		housingOwnerShip.SourceId__c = 'Private bunglow876';
		insert housingOwnerShip;
		        
        // Cable Unit
        testCableUnit = new Cable_Unit__c();
        testCableUnit.Name = 'test CU';
        testCableUnit.Cable_Unit_No__c = '123456987';
        testCableUnit.Potential_Installations__c = 68.0;
        testCableUnit.Municipaly__c = '223 Hørsholm'; 
        testCableUnit.Cable_Unit_Post_Code__c = '7400';
        testCableUnit.Housing_Ownership__c = housingOwnerShip.Id;                      
        testCableUnit.Housing_Type__c = housingType.Id;                     
        testCableUnit.Building_Type__c = buildingType.Id;
        insert testCableUnit;
        
        // Cable Unit
     
        // setup a customer account   
          
        testAccount = new Account(name='Test Account' + '0', 
                                  Cable_Unit__c = testCableUnit.Id, 
                                  ShippingStreet='1 Main St.', 
                                  ShippingState='VA', 
                                  ShippingPostalCode='12345', 
                                  ShippingCountry='USA', 
                                  ShippingCity='Anytown', 
                                  Description='This is a test account', 
                                  BillingStreet='1 Main St.', 
                                  BillingState='VA', 
                                  BillingPostalCode='12345', 
                                  BillingCountry='USA', 
                                  BillingCity='Anytown', 
                                  AnnualRevenue=10000,
                                  Customer_No__c='123456',
                                  Customer_Segment_Lookup__c=customerSegment.Id,
                                  Type = 'Kunde');
        insert testAccount;         
	    
	    clObj=new Customer_Log__c();
	  	clobj.Customer__c=testAccount.Id;		  
	    insert clObj;
	    
	    clObj=[Select Customer__r.Customer_No__c from Customer_Log__c where ID=:clObj.Id];
	    
	  }
	
	 //action null
	  static testMethod void CIPCustomerLog_RestService_TestMethod1() {	
	  	
	  	setupData();
	  	
	  	System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/customerlog';
        RestContext.request.addParameter('action','');
        
        CIPCustomerLog_RestService.doAction();  
        
	  }  	
	  
	  //with action 'getNotesForCustomer', log id and customer id
	  static testMethod void CIPCustomerLog_RestService_TestMethod2() {
	  	
	  	setupData();
	  	
	  	CIPCustomerLog_RestService.GetResponseWrapper grwObj=new CIPCustomerLog_RestService.GetResponseWrapper();
	  	CIPCustomerLog_RestService.StatusWrapper crswObj=new CIPCustomerLog_RestService.StatusWrapper();
	  	CIPCustomerLog_RestService.PostResponseWrapper crpwObj=new CIPCustomerLog_RestService.PostResponseWrapper();
	  	
	  	System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/customerlog';
        RestContext.request.addParameter('action', 'getNotesForCustomer');  
        
        CIPCustomerLog_RestService.ResponseWrapper rwObj=new CIPCustomerLog_RestService.ResponseWrapper();
        rwObj.logId=clObj.Id;
        rwObj.customerNumber=testAccount.Customer_No__c;
        
        String jsonString=JSON.serialize(rwObj);
        RestContext.request.requestBody=Blob.valueOf(jsonString); 
        
     
        CIPCustomerLog_RestService.getCustomerLog(System.RestContext.request);       
        
        Blob body = RestContext.request.requestBody;
        String bodyString = body.toString();
        CIPCustomerLog_RestService.GetResponseWrapper jsonwrap =(CIPCustomerLog_RestService.GetResponseWrapper)JSON.deserialize(bodyString,CIPCustomerLog_RestService.GetResponseWrapper.class);
       
        
	  }  
	  //with customerno
	  static testMethod void CIPCustomerLog_RestService_TestMethod3() {
	  	
	  	setupData();
	  	CIPCustomerLog_RestService.GetResponseWrapper grwObj=new CIPCustomerLog_RestService.GetResponseWrapper();
	  	CIPCustomerLog_RestService.StatusWrapper crswObj=new CIPCustomerLog_RestService.StatusWrapper();
	  	CIPCustomerLog_RestService.PostResponseWrapper crpwObj=new CIPCustomerLog_RestService.PostResponseWrapper();
	  	
	  	System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/customerlog';
        RestContext.request.addParameter('action', 'getNotesForCustomer');
        RestContext.request.addParameter('customerno', '123456');
        
        CIPCustomerLog_RestService.ResponseWrapper rwObj=new CIPCustomerLog_RestService.ResponseWrapper();
        rwObj.logId=clObj.Id;
        rwObj.customerNumber=testAccount.Customer_No__c;
        
        String jsonString=JSON.serialize(rwObj);
        RestContext.request.requestBody=Blob.valueOf(jsonString);       
     
        CIPCustomerLog_RestService.getCustomerLog(System.RestContext.request);         
             
	  }  
	  
	  //saveCustomerLog1  // without log id and customer no
	  static testMethod void CIPCustomerLog_RestService_TestMethod4() {
	  	
	  	setupData();
	  	
	  	System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/customerlog';
             
        CIPCustomerLog_RestService.ResponseWrapper rwObj=new CIPCustomerLog_RestService.ResponseWrapper();
        rwObj.logId=clObj.Id;
        rwObj.customerNumber=testAccount.Customer_No__c;
        rwObj.area='abc';
        rwObj.contactType='testContactType';
        rwObj.customerNumber='123';
        rwObj.description='testDesc';
        rwObj.guide='testGuide';
        rwObj.userMID='1234';
        
        String jsonString=JSON.serialize(rwObj);
        RestContext.request.requestBody=Blob.valueOf(jsonString); 
        CIPCustomerLog_RestService.saveCustomerLog(rwObj);      
        
        Blob body = RestContext.request.requestBody;
        String bodyString = body.toString();
        CIPCustomerLog_RestService.PostResponseWrapper jsonwrap =(CIPCustomerLog_RestService.PostResponseWrapper)JSON.deserialize(bodyString,CIPCustomerLog_RestService.PostResponseWrapper.class);
       
	  } 
	   
	  //saveCustomerLog2   //with log id and customer id
	  static testMethod void CIPCustomerLog_RestService_TestMethod5() {
	  	
	  	setupData();
	  	
	  	System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/customerlog';
              
        CIPCustomerLog_RestService.ResponseWrapper rwObj=new CIPCustomerLog_RestService.ResponseWrapper();       
        rwObj.logId=clobj.Id;
        rwObj.customerNumber=testAccount.Customer_No__c;        
        
        String jsonString=JSON.serialize(rwObj);
        RestContext.request.requestBody=Blob.valueOf(jsonString); 
        CIPCustomerLog_RestService.saveCustomerLog(rwObj);      
        
	  }  
	  
	    //saveCustomerLog2  //without log id
	  static testMethod void CIPCustomerLog_RestService_TestMethod6() {
	  	
	  	setupData();
	  	
	  	System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/customerlog';
        
        CIPCustomerLog_RestService.ResponseWrapper rwObj=new CIPCustomerLog_RestService.ResponseWrapper();     
        rwObj.customerNumber=testAccount.Customer_No__c;
        
        String jsonString=JSON.serialize(rwObj);
        RestContext.request.requestBody=Blob.valueOf(jsonString); 
        CIPCustomerLog_RestService.saveCustomerLog(rwObj);    
        
          
        
	  } 
	  	  
}