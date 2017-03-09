/*********************************************************************************
*	class Oasis_CUSearch_CT
*	This is the controller for the CU search page in Oasis.
*
*********************************************************************************/
global  without sharing class Oasis_CUSearch_CT{
    public String cable_unit_No 		  {get; set;}
    public Cable_Unit__c cableUnit 	      {get; set;}
    public String regCode 			      {get; set;} 				// regcode for the SPOC case
    public String comments 			      {get; set;}
    public Boolean lockedCableUnit        {get;set;}			    // check cable unit lock status
    public Case createdCase			      {get; set;}				// case number of created case
    public List<Cable_Unit__c> listCU	  {get;set;}
    
    public Oasis_CUSearch_CT()  
    {    	
     	// if the user clicks on the CU number link on the installation searhc page
        String cuNo = Apexpages.currentPage().getParameters().get('id');
        if(!String.isBlank(cuNo))
            cable_unit_No = cuNo;        
      	
        cableUnit = null;
        if(!String.isEmpty(cable_unit_No))
        	searchCU();
    }
    
    // event handler for the search CU button
    public pageReference searchCU()
    {
    	lockedCableUnit = false;
    //	createdCase = null;
        listCU = [select Id,  Name, customer__r.Id, 
        									cable_unit_no__c, 
                                      		current_kiss_case__r.sales_concept__c, 
                                      		PRIMARY_KLULNEJER__c, 
                                      		CA_Ownership__c, 
                                      		Operation_Date__c, 
                                      		Subtype__c, 
                                      		NOEGLEBOKS__c,
                                      		Head_End__c,
                                      		Key_Box__c,
                                      		HF_no__c ,
                                      		Oasis_Lock__c, control_date__c  
                                     	from cable_unit__c 
                                      	where cable_unit_no__c = :cable_unit_No]; 
        if(!listCU.isEmpty()){
            cableUnit = listCU[0];
            if(listCU[0].Oasis_Lock__c == '1'){
        		lockedCableUnit = true;
        	}
        }
        return null;
    }
     
    
    public List<SelectOption> getListCURegCodes()
    {
        return Oasis_Utils.getCURegistrationCodes(); 
    }
      
    
    public pageReference registerCase()
    {
    	createdCase = createCaseforCU(cable_unit_No, regCode, comments);
    	system.debug('createdCase>>>' + createdCase);    	
    	
    	// clear the values
    	regCode = '';
    	comments = '';
    	
    	// reget the details for CU
    	searchCU();
    	
    	return null;
    }
    
    // this method will create a case for the passed cable unit number.
    private Case createCaseforCU(String cuNo, String regCode, String comments)
    {
    	
    	// get the corresponding customer account id for the cable unit no
    	Account a = new Account();
        Address__c acctAddress = new Address__c();
        List<Account> listAccount = new List<Account>();
    	listAccount = [select Id, Billing_Address__c,Address_merge_customer__c,addressId__c, 
                                     			PersonContactId, Customer_No__c,
                                     			Billing_Address__r.Street__c,
                                     			Billing_Address__r.House_No__c,
                                     			Billing_Address__r.Floor__c,
                                     			Billing_Address__r.Door_No__c,
                                     			Billing_Address__r.PostCode__c,
                                     			Billing_Address__r.Town__c
                                     from Account where cable_unit_no__c = :cuNo];
    	if(!listAccount.isEmpty())
    		a =  listAccount[0];
        
        // use account address Id to get the address record
        List<Address__c> listAddress = new List<Address__c>();
        listAddress = [select Id,Street__c,House_No__c,Floor__c,Door_No__c,Entrance__c,PostCode__c,Town__c from Address__c where external_id__c = :a.addressId__c];
        if(!listAddress.isEmpty())
            acctAddress = listAddress[0];
        
        // create the oasis case record
    	Oasis_Case__c oc = new Oasis_Case__c();    	
    	oc.Oasis_CU_Case_Reg_Code__c = regCode;
    	oc.Oasis_Comments__c = comments; 
    	oc.Oasis_CU_No__c =  cuNo;  
    	
    	// get the current oasis user
    	Oasis_User__c oasisUser = Oasis_Utils.getOasisUser(ApexPages.currentPage());
        if(oasisUser != null) {
            	oc.Oasis_User__c = oasisUser.Id;
        }
          		
    	insert oc;
        
    	// create a case record and save it    	 
    	Case c = new Case();
    	
    	// get case dept, product and type/task info based on the reg code
        Oasis_Case_Assignment__c caseInfo = Oasis_Utils.getCaseDetailsforRegCode(regCode, Oasis_Utils.CASE_INFO_FOR_CABLEUNIT);
    	c.Department__c = caseInfo.Case_Dept__c;
    	c.Product_2__c = caseInfo.Case_Product__c;
    	c.Type_Task__c = caseInfo.Case_Type_Task__c;
    	    	
    	c.AccountId = a.Id;
        c.ContactId = a.PersonContactId;
        c.Address_old__c = acctAddress.Id;
	    c.Customer_Number__c = a.Customer_No__c;
	    c.Anlaeg_No_New__c = cuNo;
	    c.Oasis_Case__c = oc.Id;
	    
                
        // set the subject as Reg Code : Address 
        c.Subject = regcode + ':' + Oasis_Utils.formatAddress(acctAddress);
        
        // set the description to the comments
        c.Description = comments;
        c.Origin = Oasis_Utils.CASE_SOURCE_OASIS;   	
    	    	
    	Database.Dmloptions dmo = new Database.Dmloptions();
        dmo.assignmentRuleHeader.useDefaultRule= true;
        Database.insert(c,dmo);     	
    	
    	// update the cable unit control date with current date
    	cable_unit__c cu = new Cable_Unit__c();
    	cu.Id = cableUnit.Id;
    	cu.Cable_Unit_No__c = cuNo;
    	cu.control_date__c = Date.today();
    	update cu;
    	
    	
    	// requery the record to get the case number
    	List<Case> listCase = [select id, caseNumber from case where id = :c.Id];
    	system.debug('Case>>>>' + listCase);
    	if(!listCase.isEmpty())
    		return listCase[0];
    	
    	return null;
    } 
    
    public void searchCUWrapper(){
   		createdCase = null;
   		searchCU();
   	}
   
   
}