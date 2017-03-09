/*
  @Author: mkha@yousee.dk  
  Contains test classes for Account_team__c (internal contact roles)
*/
@isTest
/*
Update July 7th - 2011: Make sure all KISS validation rules are respected when changing the 4 KISS rules.
There was a problem with rule4 which didn't comply with the latest changes in validation rules.
*/
private class clstgrAccountTeamTest {
/*
    cleanUp()
    testSingleDeletePositive
    testSingleDeleteNegative
    testSingleDeleteNoKISS
    testSingleDuplicate()
    testBulk()
    testSingleAddNegativeNoKISSRule
    testSingleAddNegativeInActiveRole
    testSingleUpdatePositive
    testSingleUpdateNegativeDuplicate
    testSingleUpdateNegativeExpiredRole
    testSingleUpdateNegativeNoKISSRule
    testSingleUpdateNegativeRuleMaxExceeded
    testSingleUpdateNegativeRuleMinError
    testSingleDeleteCastIron
    testSingleUpdateCastIron    
    */
    
    static KISS_Role_Validation_Rules__c rule1, rule2, rule3, rule4;
    static Lookup_Account_Team_Role__c role1, role2, role3, role4, role5;
    static Lookup_Account_Team_Member__c member1, member2;
    static Account account;
      
    //Common testdata for all cases
    static {
        //To testroller - en positive og en negativ     
        system.debug('******Initializing test of clstgrAccountTeamTest*****');
        //Creating contact roles to match KISS rules            
        try{
          role1 = 
              new Lookup_Account_Team_Role__c(Name = 'Rolle1', Start_Date__c = Date.valueOf('2011-01-01'),
                                          End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = 'rolle1-Id',
                                          Code__c = 'Rolle1');
          insert role1;
          
          role2 = 
              new Lookup_Account_Team_Role__c(Name = 'Rolle2', Start_Date__c = Date.valueOf('2011-01-01'),
                                          End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = 'rolle2-Id',
                                          Code__c = 'Rolle2' );
          insert role2;
          
          role3 = 
              new Lookup_Account_Team_Role__c(Name = 'Rolle3', Start_Date__c = Date.valueOf('2011-01-01'),
                                          End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = 'rolle3-id',
                                          Code__c = 'Rolle3' );
          insert role3;
          
          //Expired role by date
          role4 = 
              new Lookup_Account_Team_Role__c(Name = 'Rolle4', Start_Date__c = Date.valueOf('2011-01-01'),
                                          End_Date__c = Date.valueOf('2011-01-31'), SourceId__c = 'rolle4-id',
                                          Code__c = 'Rolle4');
          insert role4; 
          
          //Mispelling in role name = no associated KISS rule
          role5 = 
              new Lookup_Account_Team_Role__c(Name = 'NoRule', Start_Date__c = Date.valueOf('2011-01-01'),
                                          End_Date__c = Date.valueOf('2100-01-30'), SourceId__c = 'rolle5-id');
          insert role5;
              
          //Four different kinds of KISS rules
          rule1 = 
              new KISS_Role_Validation_Rules__c( Name = 'Rolle1',
                                                 Unlimited__c = true, Required__c = 1, Possible__c = 0, Type__c = 'YouSee Customer Teams', Customer_Team_Role__c = role1.Id);
          insert rule1;
          
          rule2 = 
              new KISS_Role_Validation_Rules__c( Name = 'Rolle2',
                                                 Unlimited__c = false, Required__c = 1, Possible__c = 1, Type__c = 'YouSee Customer Teams', Customer_Team_Role__c = role2.Id);
          insert rule2;
          
          rule3 = 
              new KISS_Role_Validation_Rules__c( Name = 'Rolle3',
                                                 Unlimited__c = true, Required__c = 0, Possible__c = 0, Type__c = 'YouSee Customer Teams', Customer_Team_Role__c = role3.Id);
          insert rule3;
           
          //Used for testing expired roles
          rule4 = 
              new KISS_Role_Validation_Rules__c( Name = 'Rolle4',
                                                 Unlimited__c = true, Required__c = 0, Possible__c = 0, Type__c = 'YouSee Customer Teams', Customer_Team_Role__c = role4.Id); 
          insert rule4;              
          
                                          
          member1 = new Lookup_Account_Team_Member__c( Name = 'Michel Kenneth Hansen', SourceId__c = 'member-id1');
          member2 = new Lookup_Account_Team_Member__c(Name = 'Otto Hansen', SourceId__c = 'member-id2');
         // Cable_Unit__c cable_unit = new Cable_Unit__c( Name = 'TestCustomerTeamRoleTrigger');
         
          Cable_Unit__c cable_unit = new Cable_Unit__c();
          cable_unit.Name = 'cu_kundeCust_testing';
          cable_unit.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
          cable_unit.Municipaly__c = clsTestDataForYS.getMunicipaly();
          cable_unit.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
          cable_unit.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
          cable_unit.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
          cable_unit.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
          /*
          Cable_Unit__c cable_unit = 
              new Cable_Unit__c( Name = 'TestCustomerAccountRoleTrigger',
                                 Municipaly__c = '157 Gentofte', Cable_Unit_Post_Code__c = '3230',
                                 CA_Sales_Concept__c = 'Antenneforening', Housing_Ownership__c = 'Andel', 
                                 Housing_Type__c = 'Bolig, Ungdom', Building_Type__c = 'Parcel');
          
          */      
          account = new Account( Name = 'TestAccountTeamRoleTrigger', RecordTypeID = '012200000000nf3', Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment());
          account.Cable_Unit__c = cable_unit.Id;
            insert cable_unit;
            insert account;
            insert member1;
            insert member2;
        }catch (System.DmlException e){
            System.debug('Error initializing test for Account Team Role delete/change trigger : ' + e.getDmlMessage(0));   
        }        
        system.debug('*****Initializing test of clstgrAccountTeamTest finished*****'); 
    }//End static init
   
    private static void cleanUp(){
        system.debug('*****Starting cleanUp*****');
        try{
            delete [Select Id from Account_Team__c where Customer__c = : account.id];
        }catch(System.DmlException e){
            System.debug('Error performing cleanup for account contact roles : ' + e.getDmlMessage(0));   
        }
        system.debug('*****Finishing cleanUp*****');        
    }
  
    static testMethod void testSingleDeletePositive(){
        cleanUp();
        system.debug('*****Starting testSingleDeletePositive*****');
        Account_Team__c ct = 
            new Account_Team__c(Customer__c = account.Id, 
                                Customer_Team_Member__c = member1.Id,                                       
                                Customer_Team_Role__c = role3.Id);
        ct.StaffActorID__c = 'fake-id1';    
        //Creation of new contact roles                                     
        Test.startTest();
        try{
            insert ct;
            system.debug('Inserted new ct: customer-id:' + account.Id + ' member-id: ' + member1.Id + ' Role-id: ' + role3.Id);
            delete ct;  
            system.debug('ct succesfully deleted');
        }catch(System.DmlException e){
            System.debug('An error was catched in testSingleDeletePostive: ' + e.getDmlMessage(0));
            return;               
        } 
        //System.assert(false);
        system.debug('*****Finishing testSingleDeletePositive*****');
       
        Test.stopTest();    
    }    
    
    static testMethod void testSingleDeleteNegative(){
        cleanUp();
        system.debug('*****Starting test testSingleDeleteNegative*****');
        //Inserts role with associated rule that requires at least one contact role
        Account_Team__c ct = 
            new Account_Team__c(Customer__c = account.Id, 
                                Customer_Team_Member__c = member1.Id,                                       
                                Customer_Team_Role__c = role2.Id);                                      
        ct.StaffActorID__c = 'fake-id2';
        Test.startTest(); 
        try{
            insert ct;
            system.debug('Inserted new ct: customer-id:' + account.Id + ' member-id: ' + member1.Id + ' Role-id: ' + role2.Id);
            delete ct;
        }catch(System.DmlException e){
            System.assert(e.getDmlMessage(0).contains('Sletning af påkrævet rolle ikke mulig'));
            return;  
        }
        finally{
            Test.stopTest();
            system.debug('*****Finishing testSingleDeleteNegative*****');           
        }    
        //System.assert(false);
    } 
        
    static testMethod void testSingleDuplicate(){
        cleanUp();
        system.debug('*****Starting testSingleDuplicate*****');
        //Inserts role with associated rule that requires at least one contact role
        Account_Team__c ct1 = 
            new Account_Team__c(Customer__c = account.Id, 
                                Customer_Team_Member__c = member1.Id,                                       
                                Customer_Team_Role__c = role2.Id); 
        Account_Team__c ct2 = 
            new Account_Team__c(Customer__c = account.Id, 
                                Customer_Team_Member__c = member1.Id,                                       
                                Customer_Team_Role__c = role2.Id);                                      
        ct1.StaffActorID__c = 'fake-id3';
        ct2.StaffActorID__c = 'fake-id4';
        Test.startTest();
        try{
            system.debug('Inserting duplicate ct1: customer-id:' + account.Id + ' member-id: ' + member1.Id + ' Role-id: ' + role2.Id);
            insert ct1;
             
            system.debug('Inserting dupliate ct2: customer-id:' + account.Id + ' member-id: ' + member1.Id + ' Role-id: ' + role2.Id);
            insert ct2; 
        }catch(System.DmlException e){
            System.assert(e.getDmlMessage(0).contains('Duplikeret kontaktrolle findes. Man må ikke indtaste identisk kontakt og rolle.')); 
            return; 
        }
        finally{
            Test.stopTest();
            system.debug('*****Finishing testSingleDuplicate*****');            
        }        
        //System.assert(false);
    } 
    
    static testMethod void testSingleAddNegativeNoKiSSRule(){
        cleanUp();
        system.debug('*****Starting testSingleAddNegativeNoKiSSRule*****');
        
        Account_Team__c ct = 
            new Account_Team__c(Customer__c = account.Id, 
                                Customer_Team_Member__c = member1.Id,
                                Customer_Team_Role__c = role5.Id);
        ct.StaffActorID__c = 'fake-id5';
        Test.startTest();               
        try{
            insert ct;          
            system.debug('Inserting ct with no KISS rule ct: customer-id:' + account.Id + ' member-id: ' + member1.Id + ' Role-id: ' + role5.Id);           
        }catch(System.DmlException e){
            System.assert(e.getDmlMessage(0).contains('Der findes ikke en KISS valideringsregel for YouSee kontaktrollen'));
            return;  
        }
        finally{
            Test.stopTest();
            system.debug('*****Finishing testSingleAddNegativeNoKiSSRule*****');            
        }      
        //System.assert(false);
    }
    
    static testMethod void testSingleAddNegativeInActiveRole(){
        cleanUp();
        system.debug('*****Starting testSingleAddNegativeInActiveRole*****');
        
        Account_Team__c ct = 
            new Account_Team__c(Customer__c = account.Id, 
                                Customer_Team_Member__c = member1.Id,
                                Customer_Team_Role__c = role4.Id);
        ct.StaffActorID__c = 'fake-id6';
        Test.startTest();               
        try{
            insert ct;
            system.debug('Inserting ct with inactive contact role: customer-id:' + account.Id + ' member-id: ' + member1.Id + ' Role-id: ' + role4.Id);
        }catch(System.DmlException e){
            System.assert(e.getDmlMessage(0).contains('er udgået og må ikke længere anvendes')); 
            return; 
        }
        finally{
            Test.stopTest();
            system.debug('*****Finishing testSingleAddNegativeInActiveRole*****');              
        }      
        //System.assert(false);
    }
    
    static testMethod void testSingleUpdatePositive(){
        cleanUp();
        system.debug('*****Starting testSingleUpdatePostive*****');
        Account_Team__c ct = 
            new Account_Team__c(Customer__c = account.Id, 
                                Customer_Team_Member__c = member1.Id,                                       
                                Customer_Team_Role__c = role3.Id);                                      
        ct.StaffActorID__c = 'fake-id7';
        Test.startTest();
        try{
            insert ct;
            system.debug('Inserted new ct: customer-id:' + account.Id + ' member-id: ' + member1.Id + ' Role-id: ' + role3.Id);                 
            ct.Customer_Team_Role__c = role1.Id;
            update ct;
            //Update with new role-ID
            system.debug('ct succesfully updated');
        }catch(System.DmlException e){
            System.debug('An error was catched in testSingleUpdatePostive: ' + e.getDmlMessage(0));               
        }
        System.assertEquals(ct.Customer_Team_Role__c, role1.Id);         
        Test.stopTest();
        system.debug('*****Finishing testSingleUpdatePostive*****');        
    }   
    
        
    static testMethod void testSingleUpdateNegativeDuplicate(){
        cleanUp();
        system.debug('*****Starting testSingleUpdateNegativeDuplicate*****');
        //Inserts role with associated rule that requires at least one contact role
        Account_Team__c ct1 = 
            new Account_Team__c(Customer__c = account.Id, 
                                Customer_Team_Member__c = member1.Id,                                       
                                Customer_Team_Role__c = role1.Id); 
        Account_Team__c ct2 = 
            new Account_Team__c(Customer__c = account.Id, 
                                Customer_Team_Member__c = member1.Id,                                       
                                Customer_Team_Role__c = role3.Id);                                      
        ct1.StaffActorID__c = 'fake-id8';
        ct2.StaffActorID__c = 'fake-id9';
        Test.startTest();
        try{
            system.debug('Inserting ct1: customer-id:' + account.Id + ' member-id: ' + member1.Id + ' Role-id: ' + role1.Id);
            insert ct1;
             
            system.debug('Inserting ct2: customer-id:' + account.Id + ' member-id: ' + member1.Id + ' Role-id: ' + role3.Id);
            insert ct2; 
            
            system.debug('Inserting duplicate role: ' + role1.Id);
            ct2.Customer_Team_Role__c = role1.Id;
            update ct2;             
        }catch(System.DmlException e){
            System.assert(e.getDmlMessage(0).contains('Duplikeret kontaktrolle findes. Man må ikke indtaste identisk kontakt og rolle.')); 
            return; 
        }
        finally{
            Test.stopTest();
            system.debug('*****Finishing testSingleUpdateNegativeDuplicate*****');          
        }        
        //System.assert(false);       
    }
        
    static testMethod void testSingleUpdateNegativeExpiredRole(){
        cleanUp();
        system.debug('*****Starting testSingleUpdateNegativeExpiredRole*****');
        Account_Team__c ct = 
            new Account_Team__c(Customer__c = account.Id, 
                                Customer_Team_Member__c = member1.Id,                                       
                                Customer_Team_Role__c = role3.Id);                                      
        ct.StaffActorID__c = 'fake-id10';
        Test.startTest();
        try{
            insert ct;
            system.debug('Inserted new ct: customer-id:' + account.Id + ' contact-id: ' + member1.Id + ' Role-id: ' + role3.Id);                
            ct.Customer_Team_Role__c = role4.Id;
            update ct;              
        }catch(System.DmlException e){
            System.assert(e.getDmlMessage(0).contains('er udgået og må ikke længere anvendes'));
            return;               
        }
        finally{
            Test.stopTest();
            system.debug('*****Finishing testSingleUpdateNegativeExpiredRole*****');                
        }      
        //System.assert(false); 
    }
    
    static testMethod void testSingleUpdateNegativeNoKISSRule(){
        cleanUp();
        system.debug('*****Starting testSingleUpdateNegativeNoKISSRule*****');
        Account_Team__c ct = 
            new Account_Team__c(Customer__c = account.Id, 
                                Customer_Team_Member__c = member1.Id,                                       
                                Customer_Team_Role__c = role3.Id);                                      
        ct.StaffActorID__c = 'fake-id11';       
        Test.startTest();
        try{
            insert ct;
            system.debug('Inserted new acr: customer-id:' + account.Id + ' contact-id: ' + member1.Id + ' Role-id: ' + role3.Id);               
            ct.Customer_Team_Role__c = role5.Id;
            update ct;
        }catch(System.DmlException e){
            System.assert(e.getDmlMessage(0).contains('Der findes ikke en KISS valideringsregel for YouSee kontaktrollen')); 
            return;              
        }
        finally{
            Test.stopTest();
            system.debug('*****Finishing testSingleUpdateNegativeNoKISSRule*****'); 
        }        
        //System.assert(false); 
    }
    
    static testMethod void testSingleUpdateNegativeRuleMaxExceeded(){
        cleanUp();
        system.debug('*****Starting testSingleUpdateNegativeRuleMaxExceeded*****');
        Account_Team__c ct1 = 
            new Account_Team__c(Customer__c = account.Id, 
                                Customer_Team_Member__c = member1.Id,                                       
                                Customer_Team_Role__c = role2.Id);
        Account_Team__c ct2 = 
            new Account_Team__c(Customer__c = account.Id, 
                                Customer_Team_Member__c = member2.Id,                                       
                                Customer_Team_Role__c = role3.Id);                                              
        ct1.StaffActorID__c = 'fake-id12';
        ct2.StaffActorID__c = 'fake-id13';
        Test.startTest();
        try{
            insert ct1;             
            system.debug('Inserted new ct1: customer-id:' + account.Id + ' member-id: ' + member1.Id + ' Role-id: ' + role2.Id);
            insert ct2;
            system.debug('Inserted new ct2: customer-id:' + account.Id + ' member-id: ' + member2.Id + ' Role-id: ' + role3.Id);                
            ct2.Customer_Team_Role__c = role2.Id;
            update ct2;
        }catch(System.DmlException e){
            System.assert(e.getDmlMessage(0).contains('Der må maks. være'));
            return;               
        }
        finally{
            Test.stopTest();
            system.debug('*****Finishing testSingleUpdateNegativeRuleMaxExceeded*****');    
        }        
        //System.assert(false);                         
                
    }
    
    static testMethod void testSingleUpdateNegativeRuleMinError(){
        cleanUp();
        system.debug('*****Starting testSingleUpdateNegativeRuleMinError*****');
        Account_Team__c ct = 
            new Account_Team__c(Customer__c = account.Id, 
                                Customer_Team_Member__c = member1.Id,                                       
                                Customer_Team_Role__c = role2.Id);                                                  
        ct.StaffActorID__c = 'fake-id14';
        Test.startTest();
        try{
            insert ct;              
            system.debug('Inserted new ct: customer-id:' + account.Id + ' member-id: ' + member1.Id + ' Role-id: ' + role2.Id);                             
            ct.Customer_Team_Role__c = role3.Id;
            update ct;
        }catch(System.DmlException e){              
            System.assert(e.getDmlMessage(0).contains('Der skal mindst være'));
            return;               
        }
        finally{
            Test.stopTest();
            system.debug('*****Finishing testSingleUpdateNegativeRuleMinError*****');   
        }
        //System.assert(false);                   
    }
    
    static testMethod void testSingleDeleteCastIron(){
        cleanUp();
        system.debug('*****Starting testSingleDeleteCastIron*****');
        Account_Team__c ct = 
            new Account_Team__c(Customer__c = account.Id, 
                                Customer_Team_Member__c = member1.Id,                                       
                                Customer_Team_Role__c = role2.Id);          
        ct.StaffActorID__c = 'fake-id15';
        Test.startTest();
        //Retrives CI User from known ID
        User CI = [Select ID from User where ID= :'005200000012Dn3AAE'];
        //CI is bypassed in code so there should not be any error message regardsless of action
        System.runAs(CI){
            try{
                insert ct;              
                system.debug('Inserted new ct: customer-id:' + account.Id + ' member-id: ' + member1.Id + ' Role-id: ' + role2.Id);                             
                delete ct;              
            }catch(System.DmlException e){              
                System.assert(false);                              
            }
            finally{
                Test.stopTest();
                system.debug('*****Finishing testSingleDeleteCastIron*****');   
            }
        }
        //System.assert(true);            
    }
    
    static testMethod void testSingleUpdateCastIron(){
        cleanUp();
        system.debug('*****Starting testSingleUpdateCastIron*****');
        Account_Team__c ct = 
            new Account_Team__c(Customer__c = account.Id, 
                                Customer_Team_Member__c = member1.Id,                                       
                                Customer_Team_Role__c = role2.Id);          
        ct.StaffActorID__c = 'fake-id16';
        Test.startTest();
        //Retrives CI User from known ID
        User CI = [Select ID from User where ID= :'005200000012Dn3AAE'];
        //CI is bypassed in code so there should not be any error message regardsless of action
        System.runAs(CI){
            try{
                insert ct;              
                system.debug('Inserted new ct: customer-id:' + account.Id + ' member-id: ' + member1.Id + ' Role-id: ' + role2.Id);                             
                ct.Customer_Team_Role__c = role3.Id;
                update ct;              
            }catch(System.DmlException e){              
                System.assert(false);                              
            }
            finally{
                Test.stopTest();
                system.debug('*****Finishing testSingleUpdateCastIron*****');   
            }
        }
        //System.assert(true);            
    }

    static testMethod void testSingleAddHistoryLog(){
      cleanUp();
      Test.startTest();
      system.debug('*****Starting testSingleAddHistoryLog*****');        
      Account_Team__c ct = new Account_Team__c(Customer__c = account.Id, Customer_Team_Member__c = member1.Id, Customer_Team_Role__c = role2.Id);                 
      ct.StaffActorID__c = 'fake-id17';               
                     
      try{
          insert ct;            
          system.debug('Inserting ct1: customer-id:' + account.Id + ' member-id: ' + member1.Id + ' Role-id: ' + role2.Id);
      }catch(System.DmlException e){
          System.debug('An error was catched in testSingleAddHistoryLog: ' + e.getDmlMessage(0));              
      } 
      
      Test.stopTest();
  }
    
     static testMethod void testSingleUpdateHistoryLog(){
    cleanUp();
    Test.startTest();
    system.debug('*****Starting testSingleUpdateHistoryLog*****');        
    Account_Team__c ct = 
        new Account_Team__c(Customer__c = account.Id, 
                            Customer_Team_Member__c = member1.Id,                                       
                            Customer_Team_Role__c = role3.Id);         
    ct.StaffActorID__c = 'fake-id18';
    try{
        insert ct;
        system.debug('Inserting ct1: customer-id:' + account.Id + ' member-id: ' + member1.Id + ' Role-id: ' + role3.Id);
        ct.Customer_Team_Member__c = member2.Id;
        ct.Customer_Team_Role__c = role1.Id;           
        update ct;            
        system.debug('Updating ct1: customer-id:' + account.Id + ' member-id: ' + member2.Id + ' Role-id: ' + role1.Id);
    }catch(System.DmlException e){
        System.debug('An error was catched in testSingleUpdateHistoryLog: ' + e.getDmlMessage(0));              
    }    
    Test.stopTest();
  }

    static testMethod void testSingleDeleteHistoryLog(){
        cleanUp();
        Test.startTest();
        system.debug('*****Starting testSingleDeleteHistoryLog*****');
        Account_Team__c ct = 
            new Account_Team__c(Customer__c = account.Id, 
                                Customer_Team_Member__c = member1.Id,                                       
                                Customer_Team_Role__c = role3.Id);
        ct.StaffActorID__c = 'fake-id19';             
        try{
            insert ct;            
            system.debug('Inserting ct1: customer-id:' + account.Id + ' member-id: ' + member1.Id + ' Role-id: ' + role3.Id);
            delete ct; 
        }catch(System.DmlException e){
            System.debug('An error was catched in testSingleDeleteHistoryLog: ' + e.getDmlMessage(0));              
        }        
        Test.stopTest();
   }                                                   
           
}//End test-class