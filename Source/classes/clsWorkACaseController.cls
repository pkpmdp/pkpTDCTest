public with sharing class clsWorkACaseController {
    
    Case case2;
    
    public String isConsole{get;set;}
    
    public clsWorkACaseController(ApexPages.StandardController standardController){
        
        String caseId = ApexPages.currentPage().getParameters().get('id');
        
        List<Case> cases = new List<Case>();
        if(caseId != null)
            cases = [select id, ownerId, Owner.Name from Case where id = :caseId];
        
        if(cases.size()> 0)
            case2 = cases[0];
    }
    
    public PageReference goToCase(){
        
        if(case2 != null){
            String caseOwnerId = case2.OwnerId; 
            if(!caseOwnerId.startsWith('005') || case2.Owner.Name == 'API User'){
                
                case2.ownerId = System.Userinfo.getUserId();
                case2.manual_assign__c = true;
                
                try {
                    
                    Database.SaveResult result = Database.update(case2);
                    
                    
                } catch (Exception e) {
                    ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'An error occured Updating the Case: ' + e.getMessage(), e.getMessage());
                    ApexPages.addMessage(m);
                    return null;
                }
                
                
                return new PageReference('/' + case2.Id + '?retURL=/' + case2.Id);
            }
            else{
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'This Case is already taken by another user. Please refresh the list and select another Case.'));
                return new PageReference('/' + case2.Id);
            }
        }
        else{
            
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'Invalid Case Id!!');
            ApexPages.addMessage(m);
            return null;
        }
        
    }
    public PageReference gotoCase2(){
        System.debug('****Wen gotocase2'+isConsole);
        if(case2 != null){
            String caseOwnerId = case2.OwnerId; 
            if(!caseOwnerId.startsWith('005') || case2.Owner.Name == 'API User'){
                
                case2.ownerId = System.Userinfo.getUserId();
                case2.manual_assign__c = true;
                
                try {
                    
                    Database.SaveResult result = Database.update(case2);
                    
                    
                } catch (Exception e) {
                    ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'An error occured Updating the Case: ' + e.getMessage(), e.getMessage());
                    ApexPages.addMessage(m);
                    return null;
                }
                
                if(isConsole == 'false'){
                    System.debug('****Wen I am out of console');
                    return new PageReference('/' + case2.Id + '?retURL=/' + case2.Id);                   
                }
                else 
                return new PageReference('/' + case2.Id + '?retURL=/' + case2.Id+'&isdtp=vw');
            }
            else{
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'This Case is already taken by another user. Please refresh the list and select another Case.'));
                return new PageReference('/' + case2.Id);
            }
        }
        else{
            
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'Invalid Case Id!!');
            ApexPages.addMessage(m);
            return null;
        }
        
    }
    static testmethod void testWorkACaseController(){
    	
    	YouSeeCustomSettings__c setting = new YouSeeCustomSettings__c();
		setting.Name = 'No_case_assignment_customerinformation';
		setting.Setting_Value__c = '00e20000001UQ6D,00e20000000vfam';
		insert setting;
        
        ApexPages.Standardcontroller standardController;
        clsWorkACaseController controller = new clsWorkACaseController(standardController);
        controller.goToCase();
        controller.gotoCase2();
        
        Address__c addr  = new Address__c();
        addr.Town__c = 'AH';
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        addr.Floor__c = 'Third';
        addr.House_No__c = 'testData';
        addr.Street__c = 'AH';
        addr.Entrance__c = 'A';
        insert addr;
        
        Account acc = new Account();
        acc.Name = 'TestHierarchy';
        acc.Type='Kunde';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
        acc.Street_YK__c = addr.Id;
        acc.Street_YK__r = addr;
        acc.Customer_No__c='1234';
        System.debug(' Address----- '+acc.Street_YK__r);
        insert acc;
        
        NP_ORDER__c np = new  NP_ORDER__c();
            np.Telephone_Number__c = '12345678';
            np.Customer_Number__c = '666';
            np.Status__c='NP Order Arrived';
            np.Customer_Name__c='namita P';
            np.Current_Customer_Id__c='1234';
            np.Customer_Email__c ='namita.patil@capegmini.com';
           
   /*  Case cases =new case();
     cases.Status = 'Cancelled';
     cases.Internal_Comments_Close_Reason__c = 'hi this is a test demo';
     cases.Save_in_Kundelog__c=true;
     cases.AccountId=acc.id;
     cases.Type_Task__c ='NP in-port';
     cases.NP_Order__c =np.Id;
     cases.Anlaeg_No_New__c='00924111';      
     cases.Customer_Number__c='123456769';
     cases.Origin='Kasia';
     cases.Product_2__c = 'YOT Call Back';
     cases.Department__c ='Blockbuster';
     cases.RecordTypeId = '012200000001M7E'; 
     cases.OwnerId ='00G200000015GGiEAM';
     system.debug('record type c------'+cases.RecordTypeId);
     system.debug(' cases.OwnerId------'+ cases.OwnerId);


    insert cases;
     system.debug(' cases.OwnerId--'+ cases.OwnerId);*/
         Case case2 = new Case();
         insert case2;
        ApexPages.currentPage().getParameters().put('id', case2.Id);
        
         NP_ORDER__c np1 = new  NP_ORDER__c();
            np1.Telephone_Number__c = '12345678';
            np1.Customer_Number__c = '666';
            np1.Status__c='NP Order Arrived';
            np1.Customer_Name__c='namita P';
            np1.Current_Customer_Id__c='1234';
            np1.Customer_Email__c ='namita.patil@capegmini.com';
        insert np1;
        //  user u1=[select id from user where Isactive=true and profileId='00e200000010no5' limit 1];
      //  recordtype r1 = [select id from recordtype where name='' limit 1];
        Case case3 = new Case();

    
    case3.Status = 'Cancelled';
   
    case3.Internal_Comments_Close_Reason__c = 'hi this is a test demo';
    case3.Save_in_Kundelog__c=true;
    case3.AccountId=acc.id;
    case3.Type_Task__c ='NP in-port';
    case3.NP_Order__c =np1.Id;
    case3.Anlaeg_No_New__c='00924111';      
    case3.Customer_Number__c='123456769';
    case3.Origin='Kasia';
    case3.Product_2__c = 'YOT Call Back';
    case3.Department__c ='Blockbuster';
    //case3.RecordTypeId = r1.Id; 
    //case3.RecordTypeId ='012200000000ngBAAQ';
        system.debug('recordtype*************r1'+case3.RecordTypeId);
  
     
      case3.OwnerId ='00G200000015GGiEAM';
        //system.debug('owner id in c3****'+case3.OwnerId);
        insert case3;
        system.debug('owner id in c3.1****'+case3.OwnerId);
        system.debug('owner id in c3.1****'+case3.Owner.Name);
        ApexPages.currentPage().getParameters().put('id', case3.Id);
        
        standardController = new ApexPages.Standardcontroller(case3);
        controller = new clsWorkACaseController(standardController);
        controller.goToCase();
        //standardController = new ApexPages.Standardcontroller(case3);
        //controller = new clsWorkACaseController(standardController);
        controller.gotoCase2();
    }
     static testmethod void testWorkACaseController1(){
        
        ApexPages.Standardcontroller standardController;
        clsWorkACaseController controller = new clsWorkACaseController(standardController);
        controller.gotoCase2();
        
        YouSeeCustomSettings__c setting = new YouSeeCustomSettings__c();
		setting.Name = 'No_case_assignment_customerinformation';
		setting.Setting_Value__c = '00e20000001UQ6D,00e20000000vfam';
		insert setting;
		
        Address__c addr  = new Address__c();
        addr.Town__c = 'AH';
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        addr.Floor__c = 'Third';
        addr.House_No__c = 'testData';
        addr.Street__c = 'AH';
        addr.Entrance__c = 'A';
        insert addr;
        
        Account acc = new Account();
        acc.Name = 'TestHierarchy';
        acc.Type='Kunde';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
        acc.Street_YK__c = addr.Id;
        acc.Street_YK__r = addr;
        acc.Customer_No__c='1234';
        System.debug(' Address----- '+acc.Street_YK__r);
        insert acc;
        
        NP_ORDER__c np = new  NP_ORDER__c();
            np.Telephone_Number__c = '12345678';
            np.Customer_Number__c = '666';
            np.Status__c='NP Order Arrived';
            np.Customer_Name__c='namita P';
            np.Current_Customer_Id__c='1234';
            np.Customer_Email__c ='namita.patil@capegmini.com';
           
   /*  Case cases =new case();
     cases.Status = 'Cancelled';
     cases.Internal_Comments_Close_Reason__c = 'hi this is a test demo';
     cases.Save_in_Kundelog__c=true;
     cases.AccountId=acc.id;
     cases.Type_Task__c ='NP in-port';
     cases.NP_Order__c =np.Id;
     cases.Anlaeg_No_New__c='00924111';      
     cases.Customer_Number__c='123456769';
     cases.Origin='Kasia';
     cases.Product_2__c = 'YOT Call Back';
     cases.Department__c ='Blockbuster';
     cases.RecordTypeId = '012200000001M7E'; 
     cases.OwnerId ='00G200000015GGiEAM';
     system.debug('record type c------'+cases.RecordTypeId);
     system.debug(' cases.OwnerId------'+ cases.OwnerId);


    insert cases;
     system.debug(' cases.OwnerId--'+ cases.OwnerId);*/
         Case case2 = new Case();
         insert case2;
        ApexPages.currentPage().getParameters().put('id', case2.Id);
        
         NP_ORDER__c np1 = new  NP_ORDER__c();
            np1.Telephone_Number__c = '12345678';
            np1.Customer_Number__c = '666';
            np1.Status__c='NP Order Arrived';
            np1.Customer_Name__c='namita P';
            np1.Current_Customer_Id__c='1234';
            np1.Customer_Email__c ='namita.patil@capegmini.com';
        insert np1;
        //  user u1=[select id from user where Isactive=true and profileId='00e200000010no5' limit 1];
    //    recordtype r = [select id from recordtype where name='' limit 1];
        Case case3 = new Case();

    
    case3.Status = 'Cancelled';
   
    case3.Internal_Comments_Close_Reason__c = 'hi this is a test demo';
    case3.Save_in_Kundelog__c=true;
    case3.AccountId=acc.id;
    case3.Type_Task__c ='NP in-port';
    case3.NP_Order__c =np1.Id;
    case3.Anlaeg_No_New__c='00924111';      
    case3.Customer_Number__c='123456769';
    case3.Origin='Kasia';
    case3.Product_2__c = 'YOT Call Back';
    case3.Department__c ='Blockbuster';
  //  case3.RecordTypeId = r.Id; 
   //case3.RecordTypeId = '012200000000ngBAAQ';
    system.debug('recordtype*************r'+case3.RecordTypeId);
 
      case3.OwnerId ='00G200000015GGiEAM';
        //system.debug('owner id in c3****'+case3.OwnerId);
        insert case3;
        system.debug('owner id in c3.1****'+case3.OwnerId);
        system.debug('owner id in c3.1****'+case3.Owner.Name);
        ApexPages.currentPage().getParameters().put('id', case3.Id);
        
        standardController = new ApexPages.Standardcontroller(case3);
        controller = new clsWorkACaseController(standardController);
        controller.gotoCase2();
        //case3.OwnerId = '1234';
        //update case3;
            }
}