trigger ManualOrderingDocumentSeqNum on ManualOrderingDocument__c (after delete, after update, after insert) 
{
    if(!commonClass.isRecursiveTrigger)
    {
        List<ManualOrderingDocument__c> updateList = new List<ManualOrderingDocument__c>();
        
        if(Trigger.isDelete)
        {
            for(ManualOrderingDocument__c deletedRow : Trigger.old)
            {
                for(ManualOrderingDocument__c updatableRow : [select SequenceNumber__c from ManualOrderingDocument__c where Document__c =:deletedRow.Document__c and SequenceNumber__c > :deletedRow.SequenceNumber__c])
                {
                    //Decrement SequenceNumber__c by 1
                    updatableRow.SequenceNumber__c =  updatableRow.SequenceNumber__c - 1;
                    updateList.add(updatableRow);
                }
            }
        }
        
        if(Trigger.isUpdate)
        {
            for(ManualOrderingDocument__c updatedRow : Trigger.old)
            {
                integer oldSeqNo = integer.valueof(Trigger.old[0].SequenceNumber__c);
                integer newSeqNo = integer.valueof(Trigger.new[0].SequenceNumber__c);
                
                if(newSeqNo < oldSeqNo)
                {
                    for(ManualOrderingDocument__c updatableRow : [select Name,SequenceNumber__c from ManualOrderingDocument__c where Document__c =:updatedRow.Document__c and SequenceNumber__c >= :newSeqNo and SequenceNumber__c <= :oldSeqNo-1 and id!=:updatedRow.id])
                    {
                        updatableRow.SequenceNumber__c = updatableRow.SequenceNumber__c + 1;
                        updateList.add(updatableRow);
                        
                    }
                }
                else
                {
                    for(ManualOrderingDocument__c updatableRow : [select Name,SequenceNumber__c from ManualOrderingDocument__c where Document__c =:updatedRow.Document__c and SequenceNumber__c >= :oldSeqNo+1 and SequenceNumber__c <= :newSeqNo and id!=:updatedRow.id])
                    {
                        updatableRow.SequenceNumber__c = updatableRow.SequenceNumber__c - 1;
                        updateList.add(updatableRow);
                        
                    }
                }
                
            }
            
        }
        
        if(Trigger.isInsert)
        {
            for(ManualOrderingDocument__c insertedRow : Trigger.new)
            {
                integer count = [select SequenceNumber__c from ManualOrderingDocument__c where Document__c =:insertedRow.Document__c and SequenceNumber__c = :insertedRow.SequenceNumber__c].size();
                
                // This does not execute when rows with a new sequence number are inserted
                if(count > 1)
                {
                    for(ManualOrderingDocument__c updatableRow : [select SequenceNumber__c from ManualOrderingDocument__c where Document__c =:insertedRow.Document__c and SequenceNumber__c >= :insertedRow.SequenceNumber__c and id!=:insertedRow.id])
                    {
                        //Increment SequenceNumber__c by 1
                        updatableRow.SequenceNumber__c =  updatableRow.SequenceNumber__c + 1;
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