/*
 *JIRA Issue:- SF-1569 - Delete document from SFDC
 *Description:- VF - Amazon_FileDelete
 *				User can delete a document from Amazon S3 as well as Document record in Salesforce. User can delete all documents except 
 *              1. Documents having Category and Document Types in Custom Setting "AmazonNoDeleteCategories__c" 
 *				2. Documents which are not having Document Type
*/

public class Amazon_FileDelete_CTEX {
             
    public Boolean isDeletable {get;set;}
    public Boolean docTypeNull {get;set;}
    
    public Amazon_FileDelete_CTEX(ApexPages.StandardController controller) {        
        isDeletable = true;        
        docTypeNull = false;
    }
    
    //Description:- This function will delete a file from Amazon S3 as well as Document from Salesforce
    public pagereference deleteFile(){        
        String redirectid;
        String Id = ApexPages.CurrentPage().getParameters().get('Id');        
        
        List<Cloud_File__c> clf = [SELECT Id, Name, Cloud_File_Bucket_Name__c, Cloud_file_related_to_id__c, Cloud_file_Title__c, 
                                          Cloud_File_Full_Name__c, Cloud_File_Path_Prefix__c, Cloud_File_Category__r.Name,  
                                          Cloud_File_Document_Type__r.Name, Cloud_file_KISS_doc_type__c 
                                   FROM Cloud_File__c WHERE Id=:Id LIMIT 1];                             
        
        if(!clf.isEmpty()){
            redirectid = clf[0].Cloud_file_related_to_id__c;
            
            if(clf[0].Cloud_File_Document_Type__r.Name == Null && clf[0].Cloud_file_KISS_doc_type__c == Null){
                docTypeNull = true;
            }
            
            Map<string,AmazonNoDeleteCategories__c> mapCat = AmazonNoDeleteCategories__c.getAll();
            system.debug('mapCat= '+mapCat);
                
            Map<string,AmazonNoDeleteCategories__c> mapCat1 = new Map<string,AmazonNoDeleteCategories__c>();
            Map<string,AmazonNoDeleteCategories__c> mapDocType = new Map<string,AmazonNoDeleteCategories__c>();
                
            for(AmazonNoDeleteCategories__c a : mapCat.values()){
                mapCat1.put(a.Category__c, a);
                mapDocType.put(a.Document_Type__c,a);
                system.debug('mapCat1= '+mapCat1);
                system.debug('mapDocType= '+mapDocType);
            }
                 
            Set<String> cat = new Set<String>();
            cat.addAll(mapCat1.keyset());
            system.debug('cat= '+cat); 
               
            Set<String> docTypes = new Set<String>();
            docTypes.addAll(mapDocType.keyset());
            system.debug('docTypes= '+docTypes);
            
            if(cat.contains(clf[0].Cloud_File_Category__r.Name)  && docTypes.contains(clf[0].Cloud_File_Document_Type__r.Name)){
                isDeletable = false;
                system.debug('isDeletable= '+isDeletable);
            }            
        }
        
        if(isDeletable == True && docTypeNull == False){
            AmazonUtil.deleteFile(Id);
            PageReference p = new PageReference('/'+redirectid);        
            return p;
        }else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Dette dokument kan ikke slettes.'));          
        }       
        
        return null;    
        
    }   
        
    public pageReference Cancel(){
        String Id = ApexPages.CurrentPage().getParameters().get('Id');
        PageReference p = new PageReference('/'+Id);        
        return p;
    }

}