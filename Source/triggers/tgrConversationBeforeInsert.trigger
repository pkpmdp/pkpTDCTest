trigger tgrConversationBeforeInsert on sf4twitter__Twitter_Conversation__c (before insert) {

    Id rtId = [select Id from RecordType where DeveloperName='Unknown_Facebook_User' and SObjectType='Lead' limit 1].Id;
    List<String> externalIds = new List<String>();
    for(sf4twitter__Twitter_Conversation__c con: Trigger.new){
        externalIds.add(con.sf4twitter__Author_External_Id__c);
    }
    Map<String,Account> accMap = new Map<String,Account>();
    List<Account> accList = [select id,sf4twitter__Fcbk_User_Id__pc from Account where sf4twitter__Fcbk_User_Id__pc in:externalIds];
    for (Account accItem:accList){
        accMap.put(accItem.sf4twitter__Fcbk_User_Id__pc,accItem);
    }

    Map<String,Lead> leadMap = new Map<String,Lead>();
    List<Lead> leadList = [select id,sf4twitter__Fcbk_User_Id__c,Email from Lead where sf4twitter__Fcbk_User_Id__c in:externalIds];
    for (Lead leadItem:leadList){
        leadMap.put(leadItem.sf4twitter__Fcbk_User_Id__c,leadItem);
    }

    Map<String,Lead> leadsMapToInsert = new Map<String,Lead>();
    for(sf4twitter__Twitter_Conversation__c con: Trigger.new){

        System.debug('con.sf4twitter__Author_Name__c='+con.sf4twitter__Author_Name__c);
        System.debug('con.sf4twitter__Author_Real_Name__c='+con.sf4twitter__Author_Real_Name__c);

        if (con.sf4twitter__Type__c=='Wall Post' && con.sf4twitter__Author_External_Id__c!=null){
            if (!accMap.containsKey(con.sf4twitter__Author_External_Id__c)){
                Lead l;
                if (!leadMap.containsKey(con.sf4twitter__Author_External_Id__c) && !leadsMapToInsert.containsKey(con.sf4twitter__Author_External_Id__c)){
                    l = new Lead(RecordTypeId=rtId);
                    if (con.sf4twitter__Author_Real_Name__c!=null){
                        Integer lastSpace = con.sf4twitter__Author_Real_Name__c.lastIndexOf(' ');
                        if (lastSpace!=-1){
                            l.FirstName = con.sf4twitter__Author_Real_Name__c.substring(0,lastSpace);
                            l.LastName = con.sf4twitter__Author_Real_Name__c.substring(lastSpace+1);
                        }
                        else {
                            l.FirstName = '-';
                            l.LastName = con.sf4twitter__Author_Real_Name__c;
                        }
                    }
                    if (con.sf4twitter__Author_Name__c!=null){
                        l.Email = con.sf4twitter__Author_Name__c + '@facebook.com';
                    } 
                    else {
                        l.Email = con.sf4twitter__Author_External_Id__c.substring(3) + '@facebook.com';
                    }
                    
                    //l.LeadSource = 'Web';
                    l.sf4twitter__Fcbk_Image_Url__c = con.sf4twitter__Image__c;
                    l.sf4twitter__Fcbk_Profile_Url__c = con.sf4twitter__Author_URL__c;
                    l.sf4twitter__Fcbk_Username__c = con.sf4twitter__Author_Name__c;
                    l.sf4twitter__Fcbk_User_Id__c = con.sf4twitter__Author_External_Id__c;
                    l.sf4twitter__Origin__c = 'Facebook2';
    
                    leadsMapToInsert.put(con.sf4twitter__Author_External_Id__c,l);
        
                }
            }
        }
    }
    
    insert leadsMapToInsert.values();
    
    for(sf4twitter__Twitter_Conversation__c con: Trigger.new){
        if (leadsMapToInsert.containsKey(con.sf4twitter__Author_External_Id__c)){
            con.sf4twitter__Lead__c = leadsMapToInsert.get(con.sf4twitter__Author_External_Id__c).Id;
        }
    }
}