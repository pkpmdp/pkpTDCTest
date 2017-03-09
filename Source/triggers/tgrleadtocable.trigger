/* trigger for spoc-2033*/
trigger tgrleadtocable on Lead (before insert,before update) {
     String strAddexField ;
     list<Lead> leadList = new List<Lead>();
     Map<String,Lead> LeadMap = new Map<String,Lead>();
     Map<String,String> AddMap = new Map<String,String>();
     //RecordType rtype = [select Id,Name from RecordType where Name='YK Lead'];
     RecordType reType = [SELECT Id FROM RecordType WHERE DeveloperName LIKE :System.label.Yousee_O_customerLeadRecordType];
 //to get the address id
   
    for (Lead l : trigger.new){
 
        if(l.RecordTypeId != reType.Id)
        {
			 if(l.Address_External_Id__c == null){
               system.debug('*****'+l.FirstName);
               l.Cable_Unit_1__c = null;
             }
             else if(l.Address_External_Id__c != ''){
                 if(l.LeadSource=='Web - 300 Mbit'){   
                  
                    LeadMap.put(l.Address_External_Id__c,l);
                }
             }
        }
    }
    if(!LeadMap.isEmpty()){     
    List<Address__c> addlist = new List<Address__c>();
        addlist =[SELECT Id,Cableunit_number__c,External_Id__c FROM Address__c where External_Id__c in :LeadMap.keySet()];
        system.debug('*****addlist***'+addlist);
     
            for(Address__c addval :[SELECT Id,Cableunit_number__c,External_Id__c FROM Address__c where External_Id__c in :LeadMap.keySet() and Cableunit_number__c!=''])
            {
                AddMap.put(addval.Cableunit_number__c,addval.External_Id__c);
            }
            List<Cable_Unit__c> cablist =new List<Cable_Unit__c>([SELECT Id,Name,Cable_Unit_No__c FROM Cable_Unit__c where Cable_Unit_No__c in :AddMap.keySet()]);
            Map<String,Cable_Unit__c> cabmap = new Map<String,Cable_Unit__c>();
            
            if(!cablist.isEmpty()){
                for(Cable_Unit__c cabval:cablist)
                {
                    if(AddMap.containsKey(cabval.Cable_Unit_No__c))
                     cabmap.put(AddMap.get(cabval.Cable_Unit_No__c),cabval);
                }
            }
            if(!LeadMap.isEmpty()){
                
                for(Lead l :LeadMap.values()){
                   
                    if(cabmap.containskey(l.Address_External_Id__c)){
                      
                        l.Cable_Unit_1__c = cabmap.get(l.Address_External_Id__c).Id;
                    }
                }
            }
        }
    }