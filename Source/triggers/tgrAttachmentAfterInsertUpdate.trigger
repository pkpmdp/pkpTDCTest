trigger tgrAttachmentAfterInsertUpdate on Attachment (after insert, after update) {
	Set<Id> attachmentIds = new Set<Id>();
	Set<Id> emailMessageIds = new Set<Id>();
	Set<Id> caseIds = new Set<Id>();

	if(Trigger.isInsert){
		
		for(Attachment attachment:Trigger.new){
			
			String parentId = attachment.ParentId;
			
			if(parentId.startsWith('02s')){
				attachmentIds.add(attachment.Id);
				emailMessageIds.add(parentId);
			}
			
		}
		
	}
	
	Map<Id,Attachment> triggerAttachments = new Map<Id,Attachment>([Select Id, Name, OwnerId, Body, ContentType, ParentId, IsPrivate from Attachment where Id IN :attachmentIds]);
	Map<Id, EmailMessage> emailMessages = new Map<Id, EmailMessage>([Select Id, ParentId from EmailMessage where Id IN :emailMessageIds]);
	
	for (EmailMessage emailMessage:emailMessages.values()){
		String caseId = emailMessage.ParentId;
		if(caseId.startsWith('500')){
			caseIds.add(caseId);
		}
	}
	
	List<Transfer_Case__c> transferCases = [Select Id, Case__c from Transfer_Case__c where Case__c IN :caseIds];
	Map<Id,Transfer_Case__c> transferCasesMap = new Map<Id,Transfer_Case__c>();
	for(Transfer_Case__c tc:transferCases){
		transferCasesMap.put(tc.Case__c,tc);
	}  
	
	System.debug('emailMessages.size()=' + emailMessages.size());
	
	List<Attachment> newAttachments = new List<Attachment>();
	if(emailMessages.size() > 0){
		
		for(Attachment attachment:Trigger.new){
			
			Attachment triggerAttachment = triggerAttachments.get(attachment.Id);
			EmailMessage emailMessage = emailMessages.get(attachment.ParentId);

			String parentId = triggerAttachment.ParentId;
			String caseId = emailMessage.ParentId;

			System.debug('parentId=' + parentId);

			if (!transferCasesMap.containsKey(caseId)){
				
				if(parentId.startsWith('02s')){
					
					System.debug('caseId=' + caseId);
					
					if(caseId.startsWith('500')){
						
						
						Attachment newAttachment = new Attachment();
						newAttachment.ParentId = caseId;
						//newAttachment.ParentId = '500T0000002ZB1U';
						newAttachment.OwnerId = triggerAttachment.OwnerId ;
						newAttachment.Name = 'Email: ' + triggerAttachment.Name ; 
						newAttachment.IsPrivate = triggerAttachment.IsPrivate ;
						newAttachment.ContentType = triggerAttachment.ContentType ;
						newAttachment.Body = triggerAttachment.Body;
						newAttachments.add(newAttachment);
					}
						
				}
			}
						
					
			
		}		
	}
	System.debug('newAttachments.size()=' + newAttachments.size());
	
	try{
		
		insert newAttachments;
	
	} catch(DMLException e) {
		
		System.debug('ERROR getDmlFieldNames='+ e.getDmlFieldNames(0));
		System.debug('ERROR getDmlFields='+ e.getDmlFields(0));
		System.debug('ERROR getDmlMessage='+ e.getDmlMessage(0));
		System.debug('ERROR getDmlStatusCode='+ e.getDmlStatusCode(0));
		System.debug('ERROR getDmlType='+ e.getDmlType(0));
	}
	
}