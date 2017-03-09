/** This trigger set lookup refernece to Mail Mapping object */
trigger tgrSetMailMappingLookup on Customer_Information_Request__c (before insert, before update) {
    
    List<Mail_Mapping__c> mailMappings = [Select Id , Picklist_Name__c, Template_Group__c From Mail_Mapping__c ];
    List<RecordType> caseRecordTypes = [Select Id , Name From RecordType Where SobjectType = 
        'Customer_Information_Request__c' and IsActive = true];
    Map<ID, String> mapIdName = new Map<ID, String>();
    for(RecordType recordType: caseRecordTypes){
        mapIdName.put(recordType.Id,recordType.Name);     
    }
        
        for(Customer_Information_Request__c cir:Trigger.new){
            if ( mapIdName.get(cir.RecordTypeId)== 'Editable Information Request YO' || 
                mapIdName.get(cir.RecordTypeId)== 'Read Only Information Request YO') {
                    for ( Mail_Mapping__c mailMapping: mailMappings ){
                        if ( mailMapping.Template_Group__c == 'YO' && 
                            mailMapping.Picklist_Name__c == cir.New_Template__c ){
                            cir.Mail_Mapping__c = mailMapping.Id;
                        }                   
                    }
            }else if ( mapIdName.get(cir.RecordTypeId)== 'Editable Information Request' || 
                mapIdName.get(cir.RecordTypeId)== 'Read Only Information Request'){
                    for ( Mail_Mapping__c mailMapping: mailMappings ){
                        if ( mailMapping.Template_Group__c == 'YK' && 
                            mailMapping.Picklist_Name__c == cir.New_Template__c ){
                            cir.Mail_Mapping__c = mailMapping.Id;
                        }                   
                    }                
            }                 
        
        }
       

}