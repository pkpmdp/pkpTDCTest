/*
 *Description:- Used on VF - Amazon_UpdateIsActive. If file is uploaded to Amazon S3 the success URL will be redirected to VF Amazon_UpdateIsActive.
 *				Document record will be updated and IsActive field will be updated to True. Only active records will be listed on Account(Customer)
*/
public class Amazon_UpdateIsActive_CT {
    public Amazon_UpdateIsActive_CT(){
        
    }
    
    public pageReference UpdateIsActive(){
        String cloudFlId = APexpages.currentPage().getParameters().get('Id');
        //system.debug('Cloud File Id&&&'+cloudFlId);
        String isactive = APexpages.currentPage().getParameters().get('callback');
        List<Cloud_File__c> listClF2 = [SELECT Id, Name, Cloud_file_related_to_id__c, Cloud_file_cu_no__c, 
                                       Cloud_File_Bucket_Name__c,
                                       Cloud_File_Full_Name__c, Cloud_file_content_Type__c,
                                       Cloud_file_Title__c, IsActive__c   
                                       FROM Cloud_File__c WHERE Id =:cloudFlId LIMIT 1];
        
        if(!listClF2.isEmpty()){
            if(isactive == 'True'){
                listClF2[0].IsActive__c = True;
            }
            else{
                listClF2[0].IsActive__c = False;
            }             
        
            update listClF2;
        }
        
        PageReference p = new PageReference('/' + cloudFlId);        
        return p;
        //return null;
    }
}