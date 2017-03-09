global class SC_BatchCreateEditDeleteContactRoles implements Database.batchable<Account_Contact_Role__c>, Database.Stateful {
   public enum OPERATION {CREATE_ROLE, UPDATE_ROLE, DELETE_ROLE}
   public OPERATION mode {get;set;}
   List<Account_Contact_Role__c> contactRoleList;
   
   global class ContactRoleIterable implements Iterator<Account_Contact_Role__c>, Iterable<Account_Contact_Role__c>{
   	List<Account_Contact_Role__c> contactRoles {get;set;}
   	Integer i;
   	
	   	public ContactRoleIterable(List<Account_Contact_Role__c> contactRoles){
	   		this.contactRoles = contactRoles;
	   		i = 0;
	   	}
	   	
	   	global boolean hasNext() {
            return (i >= contactRoles.size()) ? false : true;
        }

        global Account_Contact_Role__c next() {
            if (hasNext()) {
                i = i+1;
                return contactRoles[i-1];
            } else {
                return null;
            }
        }
        
        global Iterator<Account_Contact_Role__c> Iterator(){
        	return this;
        }	   	
   }//End inner class ContactRoleIterable
    
   public SC_BatchCreateEditDeleteContactRoles(List<Account_Contact_Role__c> contactRoles, OPERATION mode){
   		this.mode = mode;
   		this.contactRoleList = contactRoles;   		    		
   }   
   
   global Iterable<Account_Contact_Role__c> start(Database.batchableContext bc){
   		return new ContactRoleIterable(contactRoleList);	
   }
   
    //EXECUTE method
    global void execute(Database.batchableContext bc, List<Account_Contact_Role__c> scope) { 
		Database.DeleteResult[] DeleteResult;
		Database.SaveResult[] InsertUpdateResult;					
		try{        		
			if (mode == OPERATION.CREATE_ROLE)
				InsertUpdateResult = Database.insert(scope, true);
			else if(mode == OPERATION.UPDATE_ROLE)
				InsertUpdateResult = Database.update(scope, true);
			else if(mode == OPERATION.DELETE_ROLE)
				DeleteResult = Database.delete(scope, true);
	    } catch (DMLException e){	    		    		    		    				
        	System.debug('Failed performing DML operation of type = ' + mode + ' on contact roles. Error message: ' + e.getMessage());          
		}
		
		//Logging
		//http://boards.developerforce.com/t5/Apex-Code-Development/Batch-Apex-Error-Handling/td-p/248777
		if(mode != OPERATION.DELETE_ROLE){
			for(Database.SaveResult error: InsertUpdateResult)
			{
   				if(!error.isSuccess()){   					
                	system.debug('Error in insert/update operation on Account Contact role: ' + error.getErrors()[0].getMessage());
            	}   				   
			}	
		}
		else{
			for(Database.DeleteResult error: DeleteResult)
			{
   				if(!error.isSuccess()){
                	system.debug('Error in delete operation on Account Contact Role: ' + error.getErrors()[0].getMessage());
            	}
			}		
		}
		
    }

    // FINISH method
    global void finish(Database.batchableContext bc) { 
    	        
    }
 
    public static testMethod void testExecuteBatch(){
		Account cable_unit_customer = clsTestFactory.getTestFactoryInstance().createYSCableUnitCustomer();
		Contact contact = clsTestFactory.getTestFactoryInstance().createYSContact(); 
        
        /*Lookup_Contact_Roles__c tmpRole1 = clsTestFactory.getTestFactoryInstance().createExternalRoleTypeWithRule('Rolle445');             
        Account_Contact_Role__c acr1 = new Account_Contact_Role__c( 
        								Contact__c = contact.Id, 
        								Customer__c = cable_unit_customer.Id,
        								Role__c = tmpRole1.Id);        
        
        Account_Contact_Role__c acr2 = clsTestFactory.getTestFactoryInstance().createYSContactRole(contact.Id, cable_unit_customer.id);        
        Account_Contact_Role__c acr3 = clsTestFactory.getTestFactoryInstance().createYSContactRole(contact.Id, cable_unit_customer.id);
        
        Lookup_Contact_Roles__c tmpRole3 = clsTestFactory.getTestFactoryInstance().createExternalRoleTypeWithRule('Rolle999');
        Account_Contact_Role__c acr4 = new Account_Contact_Role__c( 
        								Contact__c = contact.Id, 
        								Customer__c = cable_unit_customer.Id,
        								Role__c = tmpRole3.Id);   
        
        Lookup_Contact_Roles__c tmpRole2 = clsTestFactory.getTestFactoryInstance().createExternalRoleTypeWithRule('Rolle351');*/
        List<Account_Contact_Role__c> contactRoles = new List<Account_Contact_Role__c>();
        
        Test.startTest();
        //Test Create Action        
        //contactRoles.add(acr1);
        //contactRoles.add(acr4); 
       // SC_BatchCreateEditDeleteContactRoles batch = new SC_BatchCreateEditDeleteContactRoles(contactRoles, OPERATION.CREATE_ROLE);        
        //Database.executebatch(batch, 50);
        
        //Test Edit Action
        //contactRoles.clear();
        //acr2.Role__c = tmpRole2.Id;
        //contactRoles.add(acr2);
        //batch = new SC_BatchCreateEditDeleteContactRoles(contactRoles, OPERATION.UPDATE_ROLE);
        //Database.executebatch(batch, 50);
        
        //Test Delete Action
        /*contactRoles.clear();
        contactRoles.add(acr3);       
        batch = new SC_BatchCreateEditDeleteContactRoles(contactRoles, OPERATION.DELETE_ROLE);
        Database.executebatch(batch, 50);        
        Test.stopTest();
        
       	//Verify Insert actions
       	Account_Contact_Role__c acr1_confirm = [Select Id from Account_Contact_Role__c where Role__c =: tmpRole1.Id];
       	system.assertNotEquals(acr1_confirm, null);
       	Account_Contact_Role__c acr4_confirm = [Select Id from Account_Contact_Role__c where Role__c =: tmpRole3.Id];
       	system.assertNotEquals(acr4_confirm, null);
       	
		//Verify edit actions
       	Account_Contact_Role__c acr2_confirm = [Select Id, Role__c from Account_Contact_Role__c where id =: acr2.Id];
       	system.assertEquals(acr2_confirm.Role__c, tmpRole2.Id);
       	
       	//Verify delete actions
       	Account_Contact_Role__c acr3_confirm;*/
       	/*try{
       		acr3_confirm = [Select Id from Account_Contact_Role__c where id =: acr3.Id];
       	}catch(Exception e){}
       	system.assertEquals(acr3_confirm, null);*/     	
    }
    
    public static testMethod void testExecuteBatch1(){
    	
    	Account cable_unit_customer = clsTestFactory.getTestFactoryInstance().createYSCableUnitCustomer();
		Contact contact = clsTestFactory.getTestFactoryInstance().createYSContact();
		
		Lookup_Contact_Roles__c tmpRole1 = clsTestFactory.getTestFactoryInstance().createExternalRoleTypeWithRule('Rolle445');             
        Account_Contact_Role__c acr1 = new Account_Contact_Role__c( 
        								Contact__c = contact.Id, 
        								Customer__c = cable_unit_customer.Id,
        								Role__c = tmpRole1.Id);
        								
        List<Account_Contact_Role__c> contactRolesTest = new List<Account_Contact_Role__c>();
        
        Account_Contact_Role__c acr2 = clsTestFactory.getTestFactoryInstance().createYSContactRole(contact.Id, cable_unit_customer.id);
        Lookup_Contact_Roles__c tmpRole2 = clsTestFactory.getTestFactoryInstance().createExternalRoleTypeWithRule('Rolle351');
		
		Test.startTest();
		//Test for batch execution for creation of contact roles
		contactRolesTest.add(acr1);
		SC_BatchCreateEditDeleteContactRoles batch = new SC_BatchCreateEditDeleteContactRoles(contactRolesTest, OPERATION.CREATE_ROLE);        
        Database.executeBatch(batch);
        
        Integer i = [SELECT COUNT() FROM Lookup_Contact_Roles__c where Name = 'Rolle445'];
        System.assertEquals(i, 1);
        
		//Test for batch execution for updation of contact roles
        contactRolesTest.clear();
        acr2.Role__c = tmpRole2.Id;
        contactRolesTest.add(acr2);
        batch = new SC_BatchCreateEditDeleteContactRoles(contactRolesTest, OPERATION.UPDATE_ROLE);
        Database.executebatch(batch);
        
        //Test for batch execution for deletion of contact roles
        batch = new SC_BatchCreateEditDeleteContactRoles(contactRolesTest, OPERATION.DELETE_ROLE);
        Database.executebatch(batch);
        
        Test.stopTest();
    }
}