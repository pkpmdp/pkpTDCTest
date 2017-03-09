@RestResource(urlMapping='/customerteamcontactrole/*')
global class CustomerTeamContactRole {
    
    
    @HttpGet
    global static List<String> doGetAction(){
        String action = RestContext.request.params.get('action');   
        if(action == null || action == ''){
            return new List<String>();
         }
        if('emailid'.equalsIgnoreCase(action)){
            return getAccountTeamDetails(); 
        }
        return null;
    }
    
    global static List<String> getAccountTeamDetails(){ 
        YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');    
        String ysContactRecordType = ysRecords.YS_Contact_Record_Type__c;
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<String> strList = new List<String>();
        String paramtype = req.params.get('type');
        
     if(paramtype != null && paramtype != ''){   
        String roleName = req.params.get('rolename');         
       // roleName = roleName.trim();
        //roleName = roleName.replaceAll( '\\s+', ' ');
        String cableUnitno = req.params.get('cableunitno');
        if(cableUnitno != null && cableUnitno != ''){
            Integer accLength = cableUnitNo.length();
            Integer remLength = 10 - accLength;
            String tempLength ='';
            if(cableUnitNo.length() < 10){
              for(Integer i = 0; i < remLength; i++){
                tempLength += '0';
              }
              cableUnitNo = tempLength + cableUnitNo; 
            }
        }
            
        Set<String> idSet = new Set<String>();
        if(paramtype == 'external'){
              if(roleName != null && roleName != '' && cableUnitNo != null && cableUnitNo != ''){
                    List<Account_Contact_Role__c> acrList2 = [Select Id,Name,CableUnit__c,Contact__c,Contact__r.Email,Role__c,Role__r.Name,Contact__r.RecordTypeId from Account_Contact_Role__c where Role__r.Name =: rolename and CableUnit__c =:cableUnitNo and Contact__r.Email != '' and Contact__r.RecordTypeId =: ysContactRecordType limit 50000];
                    if(acrList2 != null && acrList2.size() > 0){
                        for(Account_Contact_Role__c acd1 : acrList2){
                            if(!idSet.contains(acd1.Contact__r.Email)){
                                if(acd1.Contact__r.Email != null && acd1.Contact__r.Email != ''){
                                    strList.add(acd1.Contact__r.Email);
                                    idSet.add(acd1.Contact__r.Email);
                                }
                            }
                        }
                    }else{
                        return new List<String>();
                    }
              }else if(roleName != null && roleName != ''){
                    List<Account_Contact_Role__c> acrList1 = [Select Id,Name,CableUnit__c,Contact__c,Contact__r.Email,Role__c,Role__r.Name,Contact__r.RecordTypeId from Account_Contact_Role__c where Role__r.Name =: rolename and Contact__r.Email != '' and Contact__r.RecordTypeId =: ysContactRecordType limit 50000];
                    if(acrList1 != null && acrList1.size() > 0){
                        for(Account_Contact_Role__c acd : acrList1){
                            if(!idSet.contains(acd.Contact__r.Email)){
                                if(acd.Contact__r.Email != null && acd.Contact__r.Email != ''){
                                    strList.add(acd.Contact__r.Email);
                                    idSet.add(acd.Contact__r.Email);
                                }
                            }
                        }
                        
                    }else{
                        return new List<String>();
                    }
              }
        }else if(paramtype == 'internal'){
            if(roleName != null && roleName != '' && cableUnitNo != null && cableUnitNo != ''){
                    List<Account_Team__c> acTeam = [Select Id,Name,Customer_Team_Role__c,Customer_Team_Member__c,Customer_Team_Member__r.Email__c,Customer_Team_Role__r.Name,Customer__r.Cable_Unit__r.Cable_Unit_No__c from Account_Team__c where Customer_Team_Role__r.Name =: roleName and Customer__r.Cable_Unit__r.Cable_Unit_No__c =: cableUnitNo and Customer_Team_Member__r.Email__c != '' limit 50000];
                    if(acTeam != null && acTeam.size() > 0){
                        for(Account_Team__c acd2 : acTeam){
                            if(!idSet.contains(acd2.Customer_Team_Member__r.Email__c)){
                                if(acd2.Customer_Team_Member__r.Email__c != null && acd2.Customer_Team_Member__r.Email__c != ''){
                                    strList.add(acd2.Customer_Team_Member__r.Email__c);
                                    idSet.add(acd2.Customer_Team_Member__r.Email__c);
                                }
                            }
                        }
                    }else{
                        
                      return new List<String>();
                    }
              }else if(roleName != null && roleName != ''){
                    List<Account_Team__c> acTeam1 = [Select Id,Name,Customer_Team_Role__c,Customer_Team_Member__c,Customer_Team_Member__r.Email__c,Customer_Team_Role__r.Name from Account_Team__c where Customer_Team_Role__r.Name =: roleName and Customer_Team_Member__r.Email__c != '' limit 50000];
                    if(acTeam1 != null && acTeam1.size() > 0){
                        for(Account_Team__c acd : acTeam1){
                            if(!idSet.contains(acd.Customer_Team_Member__r.Email__c)){
                                if(acd.Customer_Team_Member__r.Email__c != null && acd.Customer_Team_Member__r.Email__c != ''){
                                    strList.add(acd.Customer_Team_Member__r.Email__c);
                                    idSet.add(acd.Customer_Team_Member__r.Email__c);
                                }
                            }
                        }
                        
                    }else{
                       
                        return new List<String>();
                    }
              }
        }
        
            return strList;
    }else{   
    
            return new List<String>();      
    }
            
    }  

}