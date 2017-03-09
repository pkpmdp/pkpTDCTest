/*
 *Jira Issue SF-1795 :- The users should be able to move documents from one Anlæg to another and 
 *                      from Anlægsprojekt to Anlæg and vice versa
 * Description - User can move a file from Document record detail page. File can be moved to another Cable Unit. 
 *               Only those files which are associated with Cable Units can be moved. 
 * VF - Amazon_MoveFile
*/ 
public class Amazon_MoveFile_CT {    
    
    public String cuNo{get; set;}
    Cloud_File__c clf{get;set;}
    public Boolean movable {get; set;}
    AWSKey__c awsConfig;
    public String Id{get;set;}   
    public Boolean rendrd {get;set;}    
        
    public Amazon_MoveFile_CT() {
        awsConfig = AmazonUtil.getAWSConfig();
        rendrd = true;
        
        Id = ApexPages.CurrentPage().getParameters().get('Id');
        system.debug('Id= '+Id);
        
        clf = [SELECT Id, Name, Cloud_File_Bucket_Name__c, Cloud_file_cu_no__c, Cloud_file_Title__c, Cloud_File_Full_Name__c, 
                      Cloud_File_Customer_Numbers__c, Cloud_file_related_to_id__c, Cloud_file_KISS_doc_type__c, Cloud_file_Status__c, 
                      Cloud_file_Hierarchi_Cust_no__c, Cloud_File_Path_Prefix__c     
               FROM Cloud_File__c WHERE Id=:Id LIMIT 1];
                                     
        Map<string,AmazonAdminProfiles__c> mapAdminProfs =AmazonAdminProfiles__c.getAll();
        Set<String> setadmProfiles = mapAdminProfs.keySet();
        User loginUsr = [SELECT ID,ProfileId,Profile.Name FROM User WHERE id=:Userinfo.getUserId()];
        if(setadmProfiles.contains(loginUsr.Profile.Name)){
            movable = True;
        } 
        
        if(clf.Cloud_file_KISS_doc_type__c != Null){
            rendrd = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Dokument (er) uploadet fra KISS kan ikke flyttes.'));
        }else if (movable == false){
            rendrd = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Du er ikke autoriseret til at flytte denne fil. Kun administrator kan flytte en fil.'));
        }else if (clf.Cloud_file_Hierarchi_Cust_no__c != Null){
            rendrd = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Du forsøger at flytte et dokument til en mappe, dokumentet ikke kan flyttes til. Det er kun muligt at flytte dokumenter fra en Kabelnetnummermappe til en anden Kabelnetnummermappe.'));
        }
    }
    
    /*public PageReference onPageLoad(){
        if(c.Cloud_file_KISS_doc_type__c != Null){
            rendrd = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Du kan ikke opdatere denne fil.'));
        }else if (c.Cloud_file_Status__c == 'Låst' && c.OwnerId != UserInfo.getUserId() && movable == false){
            rendrd = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Du kan ikke opdatere denne fil.'));
        }
    } */
        
    //MoveFile function - To move a file from one CU to another CU    
    public PageReference MoveFile(){
        List<Account> acc = new List<Account>();
        
        if(movable == True){
            system.debug('***admin user***');
            if(clf.Cloud_file_KISS_doc_type__c == Null || String.isNotBlank(clf.Cloud_file_KISS_doc_type__c)){
                system.debug('***Not KISS Doc***');
                if(String.isNotBlank(cuNo) || String.isNotEmpty(cuNo)){
                    if(cuNo.length() <> 10){
                        if(cuNo.length() < 10){
                            Integer diff = 10 - cuNo.length();
                            String zeros = '';
                            
                            for(Integer i = 0; i<= diff - 1; i++){
                                zeros = zeros + '0';
                            }
                            cuNo = zeros + cuNo;
                            
                            
                        }else if(cuNo.length() > 10){
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Kundenr kan ikke være mere at 10 cifre'));
                        }
                    }
                    
                    acc = [SELECT Id, Name, Cable_Unit_No__c FROM Account 
                           WHERE Cable_Unit_No__c =:cuNo LIMIT 1];                    
                    
                    system.debug('acc= '+acc);      
                    if(!acc.isEmpty()){
                        system.debug('***Cable Unit Exists with Account***');
                        if(cuNo != clf.Cloud_file_cu_no__c){
                            String origBucket = clf.Cloud_File_Bucket_Name__c;
                            String origFileName = clf.Cloud_File_Path_Prefix__c + '/' + clf.Cloud_File_Full_Name__c;
                            String newBucket = clf.Cloud_File_Bucket_Name__c;
                            String newFileName = clf.Cloud_File_Path_Prefix__c + '/' + cuNo + '/' + clf.Cloud_file_Title__c;
                                                
                            //Move File
                            Boolean moved = AmazonUtil.copyFile(origBucket, origFileName, newBucket, newFileName);
                            
                            //If file is successfully moved then update the Amazon file record and delete the file from old 
                            //cable unit folder from Amazon
                            if(moved == True){
                                DateTime now = DateTime.now();
                                S3.AmazonS3 as3;
                                
                                as3 = new S3.AmazonS3(awsConfig.Key__c,awsConfig.Secret__c);
                                if(!Test.isRunningTest()){
                                S3.Status deleteObjectReslt= as3.DeleteObject(origBucket,origFileName,as3.key,now,as3.signature('DeleteObject',now), as3.secret);
                                }
                                //clf.Cloud_File_Full_Name__c = newFileName;
                                clf.Cloud_File_Full_Name__c = cuNo + '/' + clf.Cloud_file_Title__c;
                                //String relatedToId = acc[0].Id;
                                //clf.Cloud_file_related_to_id__c = relatedToId.substring(0, 15);
                                clf.Cloud_file_related_to_id__c = acc[0].Id;
                                clf.Cloud_File_Customer_Numbers__c = cuNo;
                                clf.Cloud_file_cu_no__c = cuNo;
                                
                                /*User usr = [SELECT Id, Name, MID__c, IsActive FROM User WHERE MID__c = :clf.Cloud_File_MID__c LIMIT 1];               
                                if(usr.IsActive == true){
                                    clf.Cloud_File_Uploaded_By__c =  usr.Name;
                                }*/
                                
                                List<Cloud_File__c> listclf = new List<Cloud_File__c>();
                                listclf.add(clf);
                                
                                if(!listclf.isEmpty()){
                                    update listclf;
                                }
                                
                                PageReference p = new PageReference('/'+Id);
                                return p;
                            }
                        }else{
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Fil findes allerede i denne Kundenr'));
                        }
                    }else{
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Indtastede Kundenr findes ikke.'));
                    }
                }else{
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Indtast Kundenr'));
                }
            }else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Du forsøger at flytte et dokument til en mappe, dokumentet ikke kan flyttes til. Det er kun muligt at flytte dokumenter fra en Kabelnetnummermappe til en anden Kabelnetnummermappe.'));
            }
        }else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Du kan ikke flytte denne fil. Du har måske ikke tilstrækkelige rettigheder.'));
        }                    
        
        return null;
    }
    
    
    
    public PageReference Cancel(){
        Id redirect = ApexPages.CurrentPage().getParameters().get('Id');
        PageReference p = new PageReference('/'+redirect);
        return p;
    }
}