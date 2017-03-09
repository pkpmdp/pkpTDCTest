@RestResource(urlMapping='/getpicklistvalues/*')
global class AmazonWS_PicklistDetails {
    
    @HttpGet
    global static String doGetAction(){
        
         String action = RestContext.request.params.get('action');  
         if('category_documenttypes_upload'.equals(action))  
         {
            return getCategoryDocTypes('upload');
         }    
          if('category_documenttypes'.equals(action))  
         {
            return getCategoryDocTypes('search');
         }  
         if('status'.equals(action))  
         {
            return getStatusPickListValues();
         }    
         if('documenttag'.equals(action))  
         {
            return getDocTagPickListValues();
         }            
        return null;
    }  
   
    global static String getCategoryDocTypes(String action) {
        
        List<Category> categoryList=new List<Category>();
        List<DocumentCategoryType__c> lst_categories=new List<DocumentCategoryType__c>();
        List<DocumentCategoryType__c> lst_docTypes=new List<DocumentCategoryType__c>();
        if(action.equalsIgnoreCase('upload')){
         lst_categories=[SELECT Id,isActive__c,Name,Value__c,Parent__c,Type__c FROM DocumentCategoryType__c where isActive__c=true and Type__c ='Category' and Exclude_In_Upload__c=false];
         lst_docTypes=[SELECT isActive__c,Name,Value__c,Parent__r.Id,Type__c FROM DocumentCategoryType__c where isActive__c=true and Type__c ='Document Type' and Exclude_In_Upload__c=false];
        }else
        {
         lst_categories=[SELECT Id,isActive__c,Name,Value__c,Parent__c,Type__c FROM DocumentCategoryType__c where isActive__c=true and Type__c ='Category'];
         lst_docTypes=[SELECT isActive__c,Name,Value__c,Parent__r.Id,Type__c FROM DocumentCategoryType__c where isActive__c=true and Type__c ='Document Type'];
        }
            for(DocumentCategoryType__c cat : lst_categories){
                Category categoryObj=new Category(cat.Name,cat.Value__c);
                List<DocumentType> documentTypeList=new List<DocumentType>();
                for(DocumentCategoryType__c doctype : lst_docTypes){
                 if(doctype.Parent__r.Id==cat.Id)
                 {
                    DocumentType docTypeObj=new DocumentType(doctype.Name,doctype.Value__c);
                    documentTypeList.add(docTypeObj);
                 }
                }    
                 categoryObj.documenttypeslist=documentTypeList;
                 categoryList.add(categoryObj);     
            }
        String JSONString = JSON.serialize(categoryList);
        return JSONString;
    }
    
    global static String getStatusPickListValues(){
          
          List<Status> lst_status = new List<Status>();
          Schema.DescribeFieldResult fieldResult = Cloud_File__c.Cloud_file_Status__c.getDescribe();
          List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                
          for( Schema.PicklistEntry f : ple)
          {
            Status statusObj=new Status(f.getValue(),f.getValue());
            lst_status.add(statusObj);
          }       
          String JSONString = JSON.serialize(lst_status);
          return JSONString;
    }
    
    //Here for getting danish translation we have used toLabel() in soql which returns label according to logined users Local language.
    //In DM , Kiss Integration User is used, and its local language need to be set for Danish only for working this correctly.
     global static String getDocTagPickListValues(){        
         
          List<DocumentTag> lst_documentTag = new List<DocumentTag>();       
          Schema.DescribeFieldResult fieldResult = Cloud_File__c.Cloud_File_Document_Tag__c.getDescribe();
          List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();     
          System.debug('#picklist values:'+ple);        
          for( Schema.PicklistEntry f : ple)
          { 
            List<Cloud_File__c> lst_translatedTag=[Select Id,toLabel(Cloud_File_Document_Tag__c)from Cloud_File__c where Cloud_File_Document_Tag__c =:f.getValue() limit 1];           
            DocumentTag docTagObj=new DocumentTag(f.getValue(),lst_translatedTag[0].Cloud_File_Document_Tag__c);          
            lst_documentTag.add(docTagObj);
          }      
        
          String JSONString = JSON.serialize(lst_documentTag);
          return JSONString;
    }
    
    public class Category {
        
        public String categorylabel;
        public String categoryvalue;        
        public List<DocumentType> documenttypeslist;
        
        public Category(){          
        }
        
        public Category(String label, String value) {
            this.categorylabel = label;
            this.categoryvalue = value;
        }
    }
    
    public class DocumentType { 
            
        public String documenttypelabel;
        public String documenttypevalue;
        
        public DocumentType(){          
        }
        
        public DocumentType(String label,String Value) {
            this.documenttypelabel = label;
            this.documenttypevalue = Value;
        }
    }
   
    public class DocumentTag {
        
        public String documenttagname;
        public String documenttaglabel;
       
        public DocumentTag(){           
        }
        
        public DocumentTag(String documenttagname,String documenttaglabel) {
            this.documenttagname = documenttagname;
            this.documenttaglabel = documenttaglabel;
        }
    }
    
     public class Status{    
         
        public String statusname;
        public String statuslabel;
       
        public Status(){            
        }
        
        public Status(String statusname,String statuslabel){
             this.statusname = statusname;
             this.statuslabel = statuslabel;
        }
    }
  
}