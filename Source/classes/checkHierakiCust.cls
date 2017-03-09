public with sharing class checkHierakiCust {
 
    Set<Id>setAccId;
    List<Account> setErrAccs; 
    public static Map<Id,Account> staticMapIdToAcc = new Map<Id,Account>();
    public Map<Id,Account> mapIdToAcc;
    Map<Id,Account> mapIdToaccHier;
    Map<Id,Account> mapIdToAccKunde;
    Map<Id,Set<Id>>MapKundeToParHierAccs;
    Set<Id> setHierarId;
    Set<Id> setKundeId;
    Map<Id,List<Account>>MapNewAccAndKunde;
    Map<Id,Set<Id>> MapHierToNewHier;
    Map<Id,Id>MapHierToOldParent;
    public static YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');
    public static String ysHierarchy = ysRecords.YS_Hierarchy_Account__c;  //012200000000o7Z
    public static String customerRecordType1 = ysRecords.YS_CUSTOMER_ACCOUNT_RECORD_TYPE_ID1__c;  //012200000000nf3
    
    public checkHierakiCust()
    {
        if(!Test.isRunningTest()){
            //Tried to avoid a query because of to many soql rows 50001 error
            if(checkHierakiCust.staticMapIdToAcc.isEmpty()){
                mapIdToAcc = new map<ID,Account>([select Name,parentid ,Type, Customer_No__c,id, parent.name from Account where RecordTypeId = :ysHierarchy and isdeleted=false order by Createddate desc ]);
                checkHierakiCust.staticMapIdToAcc = mapIdToAcc;
            }else{
                mapIdToAcc = checkHierakiCust.staticMapIdToAcc;
            }
            system.debug('==mapIdToAcc==='+mapIdToAcc);
        }
        else{
            mapIdToAcc = new map<ID,Account>([select Name,parentid ,Type, Customer_No__c,id, parent.name from Account where RecordTypeId = :ysHierarchy and isdeleted=false order by Createddate desc limit 5]);
            system.debug('==mapIdToAcc==='+mapIdToAcc);
        }
    }
    
    public List<Account> getHieraki(Map<Id,Id>mapIdtoPar,Map<Id,Id>MapIdToKKId,Map<Id,Account>MapIdToAccFrStr,List<Account>lstKunde){
        setErrAccs = new List<Account>();

        for(Account accId: lstKunde)
        {
            setAccId = new Set<Id>();
            String strKunde = '';
            String kundeParentid = accId.ParentId;
            String strSupAcc = '';

            do{     
                if(mapIdToAcc.containsKey(kundeParentid))
                {
                    setAccId.add(kundeParentid);
                    String str = kundeParentid;
                    strSupAcc = kundeParentid;
                    if(strKunde == '')
                        strKunde = str;
                    else
                        strKunde = strKunde +','+ str;
                    if(mapIdToAcc.get(kundeParentid).parentid !=null)
                        kundeParentid = mapIdToAcc.get(kundeParentid).parentid;
                    else
                        break;
                }   
            }while((!mapIdToAcc.isEmpty()));
            
            if(!setAccId.contains(accId.Kontraktkunde__c) && accId.Kontraktkunde__c!=null)
                setErrAccs.add(accId);
            else
            {
                accId.SampleText__c = strKunde;
                accId.KundeSuperiorAcc__c = strSupAcc;
            }
        }
        return setErrAccs;
    }
    public Map<Id,Set<Id>> MatchHierarki(Map<Id,Id>mapIdToOldId)
    {
        MapKundeToParHierAccs = new Map<Id,Set<Id>>();
        MapHierToOldParent = new Map<Id,Id>();
        
        for(Id accId: mapIdToOldId.keySet())
        {
            setHierarId = new Set<Id>();
            String strParent = '';
            String kundeParentid = mapIdToOldId.get(accId);
            do{             
                if(mapIdToAcc.containsKey(kundeParentid))
                {
                    setHierarId.add(kundeParentid);
                    strParent = kundeParentid;
                    if(mapIdToAcc.get(kundeParentid).parentid !=null)
                        kundeParentid = mapIdToAcc.get(kundeParentid).parentid;
                    else
                        break;
                }   
            }while((!mapIdToAcc.isempty()));
            MapKundeToParHierAccs.put(accId,setHierarId);
            MapHierToOldParent.put(accId,strParent);
        }
        return MapKundeToParHierAccs;
    }
    
     public Map<Id,List<Account>> KundeErrHierarki(Set<Id>setHierId,Set<Id>setNewIds)
    {
        Set<Id>kundeParId = new Set<Id>();
        List<Account> lstKundeAcc = new List<Account>([Select Name,id,SampleText__c,Kunde_link__c,ParentId ,Kontraktkunde__c from Account where RecordTypeId=:customerRecordType1 and Kontraktkunde__c in:setHierId and Dummy_Account__c =false]);         
        system.debug('==lstKundeAcc=='+lstKundeAcc);
        MapNewAccAndKunde = new Map<Id,List<Account>>();
        if(!lstKundeAcc.isEmpty()){     
            for(Id accId: setNewIds)
            {   
                for(Account objacc : lstKundeAcc)
                {
                    if(objacc.SampleText__c != '' )
                    {
                        system.debug('==objacc.SampleText__c=='+objacc.SampleText__c);
                        List<String>lstContainHierId = new List<String>(objacc.SampleText__c.split(','));
                        Set<String>setContainHierId = new Set<String>();
                        setContainHierId.addAll(lstContainHierId);
                        if(!setContainHierId.isEmpty())
                        {
                            if(setContainHierId.contains(accId))
                            {   
                                if (MapNewAccAndKunde.containsKey(accId)){
                                    MapNewAccAndKunde.get(accId).add(objacc);
                                }
                                else{   
                                     MapNewAccAndKunde.put(accId, new List <Account> {objacc});
                                }  
                            }     
            
                        }
                    }
                        
                }
            }
        }
        return MapNewAccAndKunde;
    }
    
    public Map<Id,String> UpdateHierarKUnde(Map<Id,List<Account>>MapUpdate,List<Account>lstAcc){
        
        Map<Id,String>MapIdToMsg = new Map<Id,String>();
            system.debug('==MapIdToMsg=='+MapIdToMsg);
            system.debug('===MapHierToOldParent=='+MapHierToOldParent);
            for(Account objAccToUpdate : lstAcc)
            {
                String s ;
                string q = '';
                if(!MapUpdate.isEmpty()){
                    if(MapUpdate.keyset().contains(objAccToUpdate.id)){
                        if(MapUpdate.containsKey(objAccToUpdate.id)){
                            
                            for(Account objAcc: MapUpdate.get(objAccToUpdate.id))
                            {
                                
                                objAcc.Kontraktkunde__c = null;
                                q = q+ ' '+objAcc.Kunde_link__c+ ',';
                                
                                system.debug('==objAcc=='+objAcc);                          
                            }
                            Integer intlastcomma = q.lastIndexOf(',');
                            q = q.substring(0,intlastcomma);
                        s = 'Du kan ikke ændre din hierarkikunde, da du har brugt kunder i dette hierarki som kontraktkunde på følgende kunder:'+q+'. Du skal fjerne kontraktkunden fra disse kunder, hvis du vil ændre hierarki.'; 
                        }
                        MapIdToMsg.put(objAccToUpdate.id,s);
                    }   
                }
                else
                {
                    objAccToUpdate.OldParentAccount__c = MapHierToOldParent.get(objAccToUpdate.id);
                }               
            }

        return MapIdToMsg;
    }
    
    Map<Id,Account>MapHierToNewKunde = new Map<Id,Account>();
    
    public void UpdateKundeField(Set<Id>setSuccessHier,Map<Id,Id>MapHierToHierObj){

         Set<Id>setSAIds = new Set<Id>();
         Map<Id,Set<Id>>mapHiToSetHi= GetNewHier(setSuccessHier);
         Map<Id,List<Account>>MapSAtoKunde = new Map<Id,List<Account>>();
         setSAIds.addAll(MapHierToHierObj.values()); 
         system.debug('==setSAIds==='+setSAIds);
         List<Account>lstToUpdate = new List<Account>();
        
         if(Test.isRunningTest()){
            for(Account objAcc :[Select Name,id,SampleText__c,KundeSuperiorAcc__c,Kunde_link__c,ParentId ,Kontraktkunde__c from Account where RecordTypeId=:customerRecordType1 and  KundeSuperiorAcc__c in :setSAIds and Dummy_Account__c = false limit 1]){
                if (MapSAtoKunde.containsKey(objAcc.KundeSuperiorAcc__c)){
                    MapSAtoKunde.get(objAcc.KundeSuperiorAcc__c).add(objacc);
                }
                else{   
                    MapSAtoKunde.put(objAcc.KundeSuperiorAcc__c, new List <Account> {objacc});
                } 
            }
         }else{
        
            for(Account objAcc :[Select Name,id,SampleText__c,KundeSuperiorAcc__c,Kunde_link__c,ParentId ,Kontraktkunde__c from Account where RecordTypeId=:customerRecordType1 and  KundeSuperiorAcc__c in :setSAIds and Dummy_Account__c =false]){
                if (MapSAtoKunde.containsKey(objAcc.KundeSuperiorAcc__c)){
                    MapSAtoKunde.get(objAcc.KundeSuperiorAcc__c).add(objacc);
                }
                else{   
                     MapSAtoKunde.put(objAcc.KundeSuperiorAcc__c, new List <Account> {objacc});
                } 
            }
            system.debug('==MapSAtoKunde==='+MapSAtoKunde);     
            
            if(!MapSAtoKunde.isEmpty()){
                for(Id objHier:MapHierToHierObj.keyset()){
                    if(MapSAtoKunde.containsKey(MapHierToHierObj.get(objHier))){
                        for(Account objAcc: MapSAtoKunde.get(MapHierToHierObj.get(objHier))){
                            if(objacc.SampleText__c != '' )
                            {
                                List<String>lstContainHierId = new List<String>(objacc.SampleText__c.split(','));
                                Set<String>setContainHierId = new Set<String>();
                                setContainHierId.addAll(lstContainHierId);
                                if(!setContainHierId.isEmpty())
                                {
                                    if(setContainHierId.contains(objHier))
                                    {   
                                        lstToUpdate.add(objAcc);
                                        system.debug('==lstToUpdate=='+lstToUpdate);
                                    }     
                    
                                }
                            }
                        }
                    }
                }
        }
            UpdateHierKunde(lstToUpdate);
        
         }
    }
    
    public void UpdateHierKunde(List<Account>lstToUpdate){
        List<Account>lstNewKunde = new List<Account>();
        if(!lstToUpdate.isEmpty()){
            for(Account objAcc : lstToUpdate){
                String strKunde = '';
                String kundeParentid = objAcc.ParentId;
                String strSupAcc = '';
                do{     
                    if(mapIdToAcc.containsKey(kundeParentid))
                    {
                        String str = kundeParentid;
                        strSupAcc = kundeParentid;
                        if(strKunde == '')
                            strKunde = str;
                        else
                            strKunde = strKunde +','+ str;
                        if(mapIdToAcc.get(kundeParentid).parentid !=null)
                            kundeParentid = mapIdToAcc.get(kundeParentid).parentid;
                        else
                            break;
                    }   
                }while((!mapIdToAcc.isEmpty()));
                Account objNew = new Account(id = objAcc.id);
                objNew.SampleText__c = strKunde;
                objNew.KundeSuperiorAcc__c = strSupAcc;
                
                system.debug('==lstNewKunde=='+lstNewKunde);
                lstNewKunde.add(objNew);
                
            }
            RunOnceKontraktKundeTrigg.setIsUpdateKundeHier();
            if(!lstNewKunde.isEmpty())
            try{
                update lstNewKunde;
            }catch(Exception e){
                
            }
                
        }
    }
    
    public Map<Id,Set<Id>> GetNewHier (Set<Id>setNewHier){
        
        Set<Id> setHieraNewId;
        MapHierToNewHier = new Map<Id,Set<Id>>();
        for(Id accId: setNewHier)
        {
            setHieraNewId = new Set<Id>();
            String kundeParentid = accId;
            do{             
                if(mapIdToAcc.containsKey(kundeParentid))
                {
                    setHieraNewId.add(kundeParentid);
                    if(mapIdToAcc.get(kundeParentid).parentid !=null)
                        kundeParentid = mapIdToAcc.get(kundeParentid).parentid;
                    else
                        break;
                }   
            }while((!mapIdToAcc.isempty()));
            MapHierToNewHier.put(accId,setHieraNewId);
            system.debug('==MapKundeToParHierAccs=='+MapKundeToParHierAccs);
        }
        return MapHierToNewHier;
        
    }
    
    public static void delKundeKKonHierDel(Set<Id>setIdToDel){
        
        List<Account>lstKundeKKToUpdate = new List<Account>();
        List<Account>lstToDelKunde = new List<Account>();
        lstKundeKKToUpdate = [Select id,ParentId ,Kontraktkunde__c from Account where RecordTypeId = :customerRecordType1 and ParentId in :setIdToDel and Kontraktkunde__c!=null];
        system.debug('==lstKundeKKToUpdate=='+lstKundeKKToUpdate);
        if(!lstKundeKKToUpdate.isEmpty()){
            for(Account obj:lstKundeKKToUpdate){
                Account objAcc = new Account(id=obj.id);
                objAcc.Kontraktkunde__c = null;
                objAcc.KundeSuperiorAcc__c = '';
                objAcc.SampleText__c = '';
                lstToDelKunde.add(objAcc);
            }
        }
        system.debug('==lstToDelKunde=='+lstToDelKunde);
        RunOnceKontraktKundeTrigg.setIsKundeUpdateOnHierDel();
        if(!lstToDelKunde.isEmpty())
        try{
                update lstToDelKunde;
            }catch(Exception e){
                
            }
    }
}