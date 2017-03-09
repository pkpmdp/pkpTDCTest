@isTest
public class clsDummyClassForTrigger {
            public static YSTriggerControl__c YSTriggerControl = YSTriggerControl__c.getInstance('YSTriggerControl'); 
            public static Boolean runTrigger = false;
            public static YSTriggerControl__c config = YSTriggerControl__c.getInstance('YSTriggerControl');
         
            static testMethod void deleteCustTeamMember(){
                 
                List<Lookup_Account_Team_Member__c> lstTeam = new List<Lookup_Account_Team_Member__c>();
                config.Customer_Team_Member__c = true;
                runTrigger = config.Customer_Team_Member__c;
                 
                Lookup_Account_Team_Member__c  lt = new Lookup_Account_Team_Member__c();
                lt.Code__c = 'A11121';
                lt.Email__c = 'testtoCustomer@del.com';
                lt.Telephone__c = '23599';
                lt.Name = 'TestDeploy';
                lt.SourceId__c = 'Test12478';
                lstTeam.add(lt);
                insert lt;
                                 
                 List<Lookup_Account_Team_Member__c> lstTeam1 = [Select Id,Name From Lookup_Account_Team_Member__c where Id =: lt.Id];
                 
                 if(lstTeam1.size() > 0)
                        Database.DeleteResult[] drList = Database.delete(lstTeam1, false);
                
                    
            }
            
            static testMethod void deletelookupCustomerSegment(){
                 
                List<Lookup_Customer_Segment__c> lstTeam = new List<Lookup_Customer_Segment__c>();
                config.Customer_Segment__c = true;
                runTrigger = config.Customer_Segment__c;
                 
                Lookup_Customer_Segment__c customerSegmentObj = new Lookup_Customer_Segment__c(); 
                customerSegmentObj.Start_Date__c=date.today();
                customerSegmentObj.End_Date__c=date.today().addMonths(1);
                customerSegmentObj.Name='pisse guard';
                customerSegmentObj.code__c='1212';        
                customerSegmentObj.SourceId__c='DCRM 1211';        
                lstTeam.add(customerSegmentObj);
                if(lstTeam.size() > 0){
                    Database.SaveResult[] drList = Database.insert(lstTeam, false);
                }
             
                List<Lookup_Customer_Segment__c> lstTeam1 = [Select Id,Name From Lookup_Customer_Segment__c where Id =: lstTeam[0].Id];
             
                if(lstTeam1.size() > 0)
                    Database.DeleteResult[] drList = Database.delete(lstTeam1, false);

                    
            }
            
            static testMethod void deletelookupBuildingType(){
                 
                List<Lookup_Building_Type__c> lstTeam = new List<Lookup_Building_Type__c>();
                config.Building_Type__c = true;
                runTrigger = config.Building_Type__c;
                 
                Lookup_Building_Type__c buildingType = new Lookup_Building_Type__c();               
                buildingType.name ='Private bunglow';
                buildingType.Code__c='12121';
                buildingType.End_Date__c = date.today().addMonths(1);
                buildingType.Start_Date__c= date.today();
                buildingType.SourceId__c='Private bunglow34';
                lstTeam.add(buildingType);
                
                if(lstTeam.size() > 0){
                    Database.SaveResult[] drList = Database.insert(lstTeam, false);
                }     
                
                List<Lookup_Building_Type__c> lstTeam1 = [Select Id,Name From Lookup_Building_Type__c where Id =: lstTeam[0].Id];
             
                if(lstTeam1.size() > 0)
                    Database.DeleteResult[] drList = Database.delete(lstTeam1, false);

                    
            }
            
            static testMethod void deleteLookupCustomerSatisfaction(){
                 
                List<Lookup_Customer_Satisfaction__c > lstTeam = new List<Lookup_Customer_Satisfaction__c >();
                config.Building_Type__c = true;
                runTrigger = config.Building_Type__c;
                 
                Lookup_Customer_Satisfaction__c custSatis = new Lookup_Customer_Satisfaction__c();               
                custSatis.name ='Private bunglow4';
                custSatis.Code__c='121214';
                custSatis.End_Date__c = date.today().addMonths(1);
                custSatis.Start_Date__c= date.today();
                custSatis.SourceId__c='Private bunglow34';
                lstTeam.add(custSatis);
                if(lstTeam.size() > 0){
                    Database.SaveResult[] drList = Database.insert(lstTeam, false);
                }  
                List<Lookup_Customer_Satisfaction__c> lstTeam1 = [Select Id,Name From Lookup_Customer_Satisfaction__c where Id =: lstTeam[0].Id];
             
                if(lstTeam1.size() > 0)
                    Database.DeleteResult[] drList = Database.delete(lstTeam1, false);

                    
            }

}