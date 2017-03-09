trigger CheckForHierarkiAcc on Account (before insert, before update,after update,before delete) {

    Map<Id,Id> mapIdToParId = new Map<Id,Id>();
    Map<Id,Id> mapIdToKKId = new Map<Id,Id>();
    Map<Id,Id> mapIdToIdHier = new Map<Id,Id>();
    Set<Id>setAllTopIds = new Set<Id>();
    List<Account>lstKunde = new List<Account>();
    Map<Id,List<Account>>MapAccNewToListKunde = new Map<Id,List<Account>>();
    Set<Id> setHierSuccess = new Set<Id>();
    Map<Id,id>MapHierToAccOnKundeUpdate = new Map<Id,Id>();
    List<Account>lstAccHierTriggNew = new List<Account>();
    Set<Id>setHierToDel = new Set<Id>();
    checkHierakiCust objcheckHierakiCust;
    if(trigger.isBefore){
        if(trigger.isInsert || trigger.isUpdate){
            
            if(RunOnceKontraktKundeTrigg.getIsFirstRun()){
                system.debug('==trigger.newmap=='+trigger.new);
                for(Account objAcc: trigger.new){
                    //Handling validations for Kunde Customer
                    if(objAcc.RecordTypeName__c == 'YS Customer Account' && objAcc.Dummy_Account__c == false){
                        System.debug('In Outer IF ********* ');
                        if(trigger.isUpdate){
                           System.debug('Trigger Is Update ******** ');
                           if(trigger.oldMap.get(objAcc.id).ParentId != objAcc.ParentId && objAcc.ParentId != null){
                                
                                    mapIdToParId.put(objAcc.id,objAcc.ParentId);
                                    mapIdToKKId.put(objAcc.id , objAcc.Kontraktkunde__c);
                                    lstKunde.add(objAcc);                                                    
                            }else if(trigger.oldMap.get(objAcc.id).ParentId != objAcc.ParentId && objAcc.ParentId == null){ // To handle situation when you dont have parentid
                                        objAcc.SampleText__c = '';  
                                        objAcc.KundeSuperiorAcc__c = '';    
                                        objAcc.Kontraktkunde__c = null;                 
                            }
                        }
                        if(trigger.isInsert){
                            if(objAcc.ParentId!=null){ 
                                mapIdToParId.put(objAcc.id,objAcc.ParentId);
                                mapIdToKKId.put(objAcc.id ,objAcc.Kontraktkunde__c);
                                lstKunde.add(objAcc);    
                            }
                            else{
                                objAcc.SampleText__c = '';  
                                objAcc.KundeSuperiorAcc__c = '';    
                                objAcc.Kontraktkunde__c = null;  
                            }
                        }
                       
                    }
                    // handling validations for Hieararchy customer 
                    if(objAcc.RecordTypeName__c == 'YS Hierarchy Account'){
                        if(trigger.isUpdate){
                        //Parent Id changed
                            if(trigger.oldMap.get(objAcc.id).ParentId!=null && trigger.oldMap.get(objAcc.id).ParentId!=objAcc.ParentId){                            
                                system.debug('==in hierarki trigger=='+trigger.oldMap);                               
                                mapIdToIdHier.put(objAcc.id,trigger.oldMap.get(objAcc.id).ParentId);
                                lstAccHierTriggNew.add(objAcc);
                            }
                            else if(trigger.oldMap.get(objAcc.id).ParentId==null && trigger.oldMap.get(objAcc.id).ParentId!=objAcc.ParentId)
                            {
                                objAcc.OldParentAccount__c = objAcc.id;
                            }
                        }
                    }       
                }
                
                // To ensure parentid and kontrakunde are in same hierarchy
                if(!mapIdToParId.isEmpty() && !mapIdToKKId.isEmpty() && !lstKunde.isEmpty()){
                     objcheckHierakiCust = new checkHierakiCust();
                    List<Account> setId = objcheckHierakiCust.getHieraki(mapIdToParId,mapIdToKKId,trigger.newmap,lstKunde);
                    if(!setId.isEmpty()){
                        for(Account objId : setId){
                                objId.addError('Den valgte kontraktkunde hører ikke til i hierarkiet under den valgte overliggende kunde.');
                        }   
                    }           
                }   
                
                if(!mapIdToIdHier.isEmpty()){
                    objcheckHierakiCust = new checkHierakiCust();
                    Map<Id,Set<Id>> MapIdToOldHiearTop = objcheckHierakiCust.MatchHierarki(mapIdToIdHier);
                    system.debug('==MapIdToOldHiearTop==in trigger=='+MapIdToOldHiearTop);
                    if(!MapIdToOldHiearTop.isEmpty())
                        for(Id objIter: MapIdToOldHiearTop.keyset())
                            setAllTopIds.addAll(MapIdToOldHiearTop.get(objIter));   
                    if(!setAllTopIds.isEmpty())
                    MapAccNewToListKunde = objcheckHierakiCust.KundeErrHierarki(setAllTopIds,MapIdToOldHiearTop.keySet());
                    Map<Id,String>MapHierToMsg = objcheckHierakiCust.UpdateHierarKUnde(MapAccNewToListKunde,lstAccHierTriggNew);
                    
                    if(!MapHierToMsg.isEmpty()){
                        for(Id objHier: MapHierToMsg.keyset()){
                            trigger.newMap.get(objHier).addError(MapHierToMsg.get(objHier),false);
                        }
                    }
                }
                RunOnceKontraktKundeTrigg.setIsFirstRun();
                }           
            }
            if(trigger.isDelete){
                if(RunOnceKontraktKundeTrigg.getIsKundeUpdateOnHierDel()){
                    for(Account objAcc: trigger.old){
                        if(objAcc.RecordTypeName__c == 'YS Hierarchy Account'){
                            setHierToDel.add(objAcc.id);
                            system.debug('=setHierToDel=='+setHierToDel);
                        }
                    }
                    if(!setHierToDel.isEmpty())
                        checkHierakiCust.delKundeKKonHierDel(setHierToDel);
                }
            }
            
        }   
        
        if(trigger.isAfter){    
            if(trigger.isUpdate){
                if(RunOnceKontraktKundeTrigg.getIsUpdateKundeHier()){
                    for(Account objAcc: trigger.new){
                        if(objAcc.RecordTypeName__c == 'YS Hierarchy Account'){
                            if(trigger.oldMap.get(objAcc.id).ParentId!=objAcc.ParentId){                            
                                system.debug('==in hierarki trigger=='+trigger.new);
                                setHierSuccess.add(objAcc.id);
                                MapHierToAccOnKundeUpdate.put(objAcc.id,objAcc.OldParentAccount__c);
                            }   
                        }
                    }
                    
                    if(!setHierSuccess.isEmpty()){
                        objcheckHierakiCust = new checkHierakiCust();
                        objcheckHierakiCust.UpdateKundeField(setHierSuccess,MapHierToAccOnKundeUpdate);
                        
                    }
                }               
            }
        }
    }