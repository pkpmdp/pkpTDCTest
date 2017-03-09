trigger Amazon_Test_Update_Trigger on Cloud_File__c (before update) {
 Map<Id,Cloud_File__c> map_CloudFile = new Map<Id,Cloud_File__c>();
for(Cloud_File__c a: Trigger.new){
       
        map_CloudFile.put(a.Id,a);
    }
List<Cloud_File__c> objLst=map_CloudFile.values();
List<DocumentCategoryType__c> lstDCT=[Select Id,Value__c,Type__c,Parent__c from DocumentCategoryType__c];
List<Cloud_File__c> lst_to_update=new List<Cloud_File__c>();
for(Cloud_File__c obj : objLst)
{
     Id parentId;
    if(String.isNotBlank(obj.Cloud_File_Centa_Doc_Type__c)||String.isNotBlank(obj.Centa_Document_Name__c))  
    for(DocumentCategoryType__c tempObj: lstDCT)
    {   
        if(String.isNotBlank(obj.Cloud_File_Centa_Doc_Type__c))    
        if((obj.Cloud_File_Centa_Doc_Type__c).equalsIgnoreCase(tempObj.Value__c)&&((tempObj.Type__c).equalsIgnoreCase('Category')))
        {
            parentId=tempObj.Id;
            obj.Cloud_File_Category__c=tempObj.Id;
        }
        if(String.isNotBlank(obj.Centa_Document_Name__c))
        if((obj.Centa_Document_Name__c).equalsIgnoreCase(tempObj.Value__c)&&(tempObj.Parent__c==parentId)&&((tempObj.Type__c).equalsIgnoreCase('Document Type')))
        {
            obj.Cloud_File_Document_Type__c=tempObj.Id;
        }
        lst_to_update.add(obj);
    }
}

}