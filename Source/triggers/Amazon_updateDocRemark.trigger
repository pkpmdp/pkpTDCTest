/*
 *Description:- When Document record is created or Edited, Cloud_File_Uploaded_By__c, Cloud_File_Doc_Remark__c, 
*/
trigger Amazon_updateDocRemark on Cloud_File__c (before insert, before update) {
    
    List<Cloud_File__c> lst_cloudFile=new List<Cloud_File__c>();
    Map<String, Id> map_CloudFile = new Map<String,Id>();
    Map<String,User> map_user=new Map<String,User>();
    List<User> lst_user=new List<User>();
    String DocRem;

    String[] strDocRem = new String[]{};
  
   for(Cloud_File__c a: Trigger.new){
        system.debug('Inserted File id:'+a.Id);
        map_CloudFile.put(a.Cloud_File_MID__c,a.Id);
        lst_cloudFile.add(a);
    }
    
   lst_user=[SELECT Id, Name, MID__c, IsActive FROM User WHERE MID__c =:map_CloudFile.keyset() and isActive= true];

   for(User u: lst_user)
    {
       for(Cloud_File__c c:lst_cloudFile)
        {
        try{
            
                if(u.MID__c==c.Cloud_File_MID__c)
                {
                c.Cloud_File_Uploaded_By__c=u.Name;
                }
                if(c.Cloud_File_Doc_Remark__c != Null){
                            system.debug('*Not Null*');
                            c.Cloud_File_Document_Remark__c = c.Cloud_File_Doc_Remark__c;
                            DocRem = c.Cloud_File_Document_Remark__c;
                            if(DocRem.contains(';')){
                                strDocRem = DocRem.split(';');
                            }
                }
                if(strDocRem.size() > 10){
                            c.addError('You cannot select more than 10 Document Remarks');
                }
             
            }catch(Exception ex){
                  System.debug('Exception = '+ex);
            }
        }
    }
}