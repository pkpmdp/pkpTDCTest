trigger tgrLeadAfterUpdate on Lead (before insert, before update, after update) {
    
    // convert logic is contained in util class
    clsConvertLeadUtil util = new clsConvertLeadUtil();
    // set the contact address to be the same as the lead
    util.setContactAddresses(Trigger.new);
    //String ykLeadType = ServiceCenter_CustomSettings__c.getInstance('RecordTypeYKLead').value__c;
    String ykLeadType = System.Label.RecordTypeYKLead;
    
    //start of updating permission record SPOC-1589
    RecordType recordtypes = [select Id,Name,DeveloperName from RecordType where DeveloperName='YK_Lead' limit 1];
    
    if(Trigger.isInsert){
    	for(Lead leadList : Trigger.new){
    		System.debug('##leadList###'+leadList+'#####ykLeadType####'+ykLeadType);
    		if(leadList.Street_Lookup__c != null && leadList.RecordTypeId == ykLeadType){
    			leadList.Lead_Billing_Address__c = leadList.Street_Lookup__c;
    		}
    		System.debug('$$$leadList.Lead_Billing_Address__c$$$'+leadList.Lead_Billing_Address__c);
    	}
    }
    
    if(Trigger.isUpdate && Trigger.isBefore){
    	System.debug('##### Before Update Trigger');
    	for(Lead leadList1 : Trigger.new){
    		System.debug('##Update Trigger###'+leadList1);
    		if(leadList1.Street_Lookup__c != null && leadList1.RecordTypeId == ykLeadType){
    			leadList1.Lead_Billing_Address__c = leadList1.Street_Lookup__c;
    		}
    		System.debug('leadList1.Lead_Billing_Address__c$$$'+leadList1.Lead_Billing_Address__c);
    	}
    }
    
    List<Permission__c> updatePermission = new List<Permission__c>();
    permission__c perm;
    List<Account> updateAccountList = new List<Account>(); 
    Map<Id,Lead> AccLeadMap = new Map<Id,Lead>();
    for (Lead l : Trigger.new) {
    system.debug('ConvertedContactId: '+l.ConvertedContactId+' l.convertedAccountId: '+l.convertedAccountId);
    
	     if(trigger.isUpdate && l.IsConverted && !trigger.oldmap.get(l.id).IsConverted && l.convertedAccountId!=null && l.RecordTypeId == recordtypes.id){
	        AccLeadMap.put(l.convertedAccountId,l);
	     }
    }

if(AccLeadMap.size()>0){
    for(Permission__c p:[select id,customer__c from permission__c where customer__c in :AccLeadMap.keySet() ]){
        if(AccLeadMap.get(p.customer__c)!=null){
            Lead l = AccLeadMap.get(p.customer__c);
      perm = new permission__c(id=p.id);
     if(l.Permission__c=='Ja'){
     perm.Marketing_Permission__c = true;
    // Date datePerm = l.Permission_Updated__c;
     perm.Marketing_permission_Opdateret_af__c = l.Permission_Updated_By__c;
    // perm.Marketing_permission_Opdateret_Dato__c = datetime.newInstance(datePerm.year(), datePerm.month(),datePerm.day());
     perm.Marketing_permission_Opdateret_Dato__c = l.Permission_Updated__c;
     }else if(l.Permission__c=='Nej'){
     perm.Marketing_Permission__c = false;
     perm.Marketing_permission_Opdateret_af__c = l.Permission_Updated_By__c;
    // Date datePerm = l.Permission_Updated__c;
    // perm.Marketing_permission_Opdateret_Dato__c = datetime.newInstance(datePerm.year(), datePerm.month(),datePerm.day()); 
    perm.Marketing_permission_Opdateret_Dato__c = l.Permission_Updated__c;
     }
     
     perm.Nej_til_markedsforing__c = l.No_Thank_You__c;
     if(l.No_Thank_you_Updated__c!=null){
    // Date dateNoT = l.No_Thank_you_Updated__c;
   //  perm.Nej_til_markedsforing_Opdateret_Dato__c = datetime.newInstance(dateNoT.year(), dateNoT.month(),dateNoT.day());
   perm.Nej_til_markedsforing_Opdateret_Dato__c = l.No_Thank_you_Updated__c;
   perm.Nej_til_markedsforing_Opdateret_af__c = l.No_Thankyou_Updated_By__c;
     }
    // else
   //  perm.Nej_til_markedsforing_Opdateret_Dato__c = Date.today();
     			// perm.Nej_til_markedsforing_Opdateret_Dato__c = datetime.now();
     
      
       
       updatePermission.add(perm);
        }
    }
    if(updatePermission.size()>0)
    update updatePermission;

    for(Account a : [select id, Street_YK__c,Billing_Address__c from Account where id in :AccLeadMap.keySet()]){
    if(AccLeadMap.get(a.id)!=null){ 
        Lead la = AccLeadMap.get(a.id);
        if(la.Street_Lookup__c!=null){
        a.CustomerSubType__c = 'Normal';
        a.Street_YK__c =  la.Street_Lookup__c;
        a.Billing_Address__c = la.Street_Lookup__c;
        updateAccountList.add(a);
        }
        }
    }
    System.debug('##updateAccountList Before###'+updateAccountList);
    if(updateAccountList.size()>0)
    	update updateAccountList;
    	System.debug('##updateAccountList After###'+updateAccountList);
    }    
//end of updating permission record SPOC-1589
    
}