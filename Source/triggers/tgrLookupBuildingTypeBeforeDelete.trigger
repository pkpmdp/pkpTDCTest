trigger tgrLookupBuildingTypeBeforeDelete on Lookup_Building_Type__c (before delete) {
   
    //Tmp code to controll triggers in production
	//Retriving environment unique field ids for customer lookup fields
	YSTriggerControl__c YSTriggerControl = YSTriggerControl__c.getInstance('YSTriggerControl');	
	Boolean runTrigger = false;
	YSTriggerControl__c config = YSTriggerControl__c.getInstance('YSTriggerControl');
	//Start Trigger switch
	if (config != null && (runTrigger = config.Building_Type__c) == true) {
			
		
   	for(Lookup_Building_Type__c old : trigger.old)
    	old.AddError('Det er ikke muligt at slette data, fordi det anvendes på relaterede objekter');
   
	}//End TMP Trigger switch
   
   
   
   /*
   List <Lookup_Building_Type__c> buildingTypeList = Trigger.old;    
   List<Account> accountList = [select Cable_Unit__r.Building_Type__c from Account where Cable_Unit__r.Building_Type__c IN : buildingTypeList];
   List<Cable_Unit__c> cableUnit_BuildingTypeList = [select Building_Type__c from Cable_Unit__c where Building_Type__c IN :buildingTypeList];
          
          if (accountList.size() > 0 && buildingTypeList.size() > 0) {          
               for (Lookup_Building_Type__c bType : buildingTypeList) {
                    for (Account acc : accountList) {
                        if (acc.Cable_Unit__r.Building_Type__c == bType.Id) {
                            bType.addError('Det er ikke muligt at slette data, fordi det anvendes på relaterede objekter');
                            break;
                        } 
                  } 
               }

            }             
            if (cableUnit_BuildingTypeList.size() > 0 && buildingTypeList.size() > 0) {
                   for (Lookup_Building_Type__c bType : buildingTypeList) {
                      for (Cable_Unit__c CU : cableUnit_BuildingTypeList) {
                            if (CU.Building_Type__c == bType.Id) {
                                bType.addError('Det er ikke muligt at slette data, fordi det anvendes på relaterede objekter');
                                break;
                            } 
                      }
                      }
                   }               
        }
   }
   */
}//End trigger