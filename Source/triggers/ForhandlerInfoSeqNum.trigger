trigger ForhandlerInfoSeqNum on ForhandlerInformations__c (after delete, after update, after insert) 
{
    if(!commonClass.isRecursiveTrigger)
    {
        List<ForhandlerInformations__c> updateList = new List<ForhandlerInformations__c>();
        
        
        if(Trigger.isDelete)
        {
        	system.debug('---------- Inisde Delete  ----------- '+Trigger.old);
            for(ForhandlerInformations__c deletedRow : Trigger.old)
            {
            	system.debug('---------- deletedRow.Sequence_Number__c  ----------- ' + deletedRow.Sequence_Number__c); 
                for(ForhandlerInformations__c updatableRow : [select Sequence_Number__c from ForhandlerInformations__c where Page_Type__c =:deletedRow.Page_Type__c and Sequence_Number__c > :deletedRow.Sequence_Number__c])
                {
                    //Decrement Sequence_Number__c by 1
                    updatableRow.Sequence_Number__c =  updatableRow.Sequence_Number__c - 1;
                    updateList.add(updatableRow);
                }
            }
        }
        
        if(Trigger.isUpdate)
        {
        	system.debug('---------- Inisde Update ----------- ');
            for(ForhandlerInformations__c updatedRow : Trigger.old)
            {
                integer oldSeqNo = integer.valueof(Trigger.old[0].Sequence_Number__c);
                integer newSeqNo = integer.valueof(Trigger.new[0].Sequence_Number__c);
                System.debug('Old Sequence Number -------------> ' + oldSeqNo);
                System.debug('New Sequence Number -------------> ' + newSeqNo);
                if(newSeqNo < oldSeqNo)
                {
                    for(ForhandlerInformations__c updatableRow : [select Name,Sequence_Number__c from ForhandlerInformations__c where Page_Type__c =:updatedRow.Page_Type__c and Sequence_Number__c >= :newSeqNo and Sequence_Number__c <= :oldSeqNo-1 and id!=:updatedRow.id])
                    {
                        updatableRow.Sequence_Number__c = updatableRow.Sequence_Number__c + 1;
                        updateList.add(updatableRow);
                        
                    }
                }
                else
                {
                    for(ForhandlerInformations__c updatableRow : [select Name,Sequence_Number__c from ForhandlerInformations__c where Page_Type__c =:updatedRow.Page_Type__c and Sequence_Number__c >= :oldSeqNo+1 and Sequence_Number__c <= :newSeqNo and id!=:updatedRow.id])
                    {
                        updatableRow.Sequence_Number__c = updatableRow.Sequence_Number__c - 1;
                        updateList.add(updatableRow);
                        
                    }
                }
                
            }
            
        }
        
        if(Trigger.isInsert)
        {
        	system.debug('---------- Inisde Insert  ----------- '+Trigger.new);
            for(ForhandlerInformations__c insertedRow : Trigger.new)
            {
                integer count = [select Sequence_Number__c from ForhandlerInformations__c where Page_Type__c =:insertedRow.Page_Type__c and Sequence_Number__c = :insertedRow.Sequence_Number__c].size();
             	 System.debug('count rigger.isInsert -------------> ' + count);   
                // This does not execute when rows with a new sequence number are inserted
                if(count > 1)
                {
                    for(ForhandlerInformations__c updatableRow : [select Sequence_Number__c from ForhandlerInformations__c where Page_Type__c =:insertedRow.Page_Type__c and Sequence_Number__c >= :insertedRow.Sequence_Number__c and id!=:insertedRow.id])
                    {
                        //Increment Sequence_Number__c by 1
                        updatableRow.Sequence_Number__c =  updatableRow.Sequence_Number__c + 1;
                        updateList.add(updatableRow);
                    }
                }
            }
        }
        
        commonClass.isRecursiveTrigger = true;
        
        if(!updateList.isempty())
         update updateList;
    }
}