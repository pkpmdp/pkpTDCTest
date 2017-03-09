/*
* This extension is used by the Amazon_NewOverride page to override the New button 
* on the Amazon File object. 
*
* @Date - 7/12/2013
*/
public class Amazon_NewOverride_CTE{
	Boolean noParent = false; // this flag is set if the retURL param is missing 
    
    public Amazon_NewOverride_CTE(ApexPages.StandardController stdcontroller)
    {
  
    }
    
    public pageReference redirect()
    {
        //String redirectId;
        // get the value of the retURL param from the request
        String id = Apexpages.currentPage().getParameters().get('retURL');
        String cloudFileId = id.substring(1); 
        system.debug('cloudFileId>>' + cloudFileId);
        
        // This value is a cloud file record, so we query the parent account
        // and redirect the user to the Doc_Upload page.
        
         
        // This value is a cloud file record, so we query the parent account
        // and redirect the user to the Doc_Upload page.
        If(!String.isBlank(cloudFileId))
        {
          List<cloud_file__c> listCF = [select cloud_file_related_to_id__c 
                                        		from cloud_file__c where id = :cloudFileId];
            
          if(!listCF.isEmpty())
          {
              //redirectId = listAccounts[0].Id; 
              return new pageReference ('/apex/Amazon_DocUpload?relatedTo=' + listCF[0].cloud_file_related_to_id__c);
          }
            
        } else {
         	// no retURL param present, the user must have clicked the New button
            noParent = true;   
        }
        
        return null; 
    }
    
    
    
}