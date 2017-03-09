/*
 * JIRA Issue:- SF-1570 - Search for documents in SFDC
 * VF - Amazon_DocSearch
*/
public class Amazon_DocSearch_CTE  {
    private static String soql1 {get; set;}
    public String title1 {get;set;}
    private static Datetime startDateTime;
    private static Datetime endDateTime;
    public Cloud_File__c clf;
    public String calStrDate{set; get;}
    public String calEnDate{set; get;}
    public String calStartDate{set; get;}
    public String calEndDate{set; get;}
    public String categoryVar{get;set;}
    public String docTypeVar{get;set;}
    
   // public Static String url1 {get; set;}
   // public transient String fileData {get; set;}
   // public String contentType {get; set;}  
    public boolean isCategorySelected{get;set;} 
   
    public List<SelectOption> getCategories() {
        List<DocumentCategoryType__c> lst_categories=[SELECT isActive__c,Name,Value__c,Parent__c,Type__c FROM DocumentCategoryType__c where isActive__c=true and Type__c ='Category'];
        lst_categories.sort();
        List<SelectOption> options = new List<SelectOption>();
        String result = UserInfo.getLocale();
        String language=UserInfo.getLanguage();
        system.debug('##locale :'+result);
          system.debug('##language :'+language);
		if(language.equalsIgnoreCase('en_us')){
			 options.add(new SelectOption(' ','--None--'));
		}else{
       		 options.add(new SelectOption(' ','--Ingen--'));
		}
        for(DocumentCategoryType__c lbl : lst_categories)
        {
          options.add(new SelectOption(lbl.Value__c,lbl.Name));
        }
        return options;
     }
     
      public List<SelectOption> getDocTypes() {
     	System.debug('##Category:'+categoryVar);
    
     	List<DocumentCategoryType__c> lst_docTypes=new List<DocumentCategoryType__c>();
     	List<DocumentCategoryType__c> lst_category=[SELECT ID,Value__c FROM DocumentCategoryType__c where isActive__c=true and Type__c ='Category' and Value__c=:categoryVar];
     	if(lst_category.size()>0){
         lst_docTypes=[SELECT isActive__c,Name,Value__c,Parent__c,Type__c FROM DocumentCategoryType__c where isActive__c=true and Type__c ='Document Type' and Parent__c=:lst_category[0].Id];
     	}
        lst_docTypes.sort();
        String result = UserInfo.getLocale();
	    String language=UserInfo.getLanguage();
	    system.debug('##locale :'+result);
        system.debug('##language :'+language);
        
        List<SelectOption> options = new List<SelectOption>();
        if(language.equalsIgnoreCase('en_us')){
		   options.add(new SelectOption(' ','--None--'));
		}else{
	       options.add(new SelectOption(' ','--Ingen--'));
		}        
        if(String.isBlank(categoryVar)){
        	isCategorySelected=false;			
        }else{
        	isCategorySelected=true;
        }
        for(DocumentCategoryType__c lbl : lst_docTypes)
        {
          options.add(new SelectOption(lbl.Value__c,lbl.Name));
        }
    	return options;
     }

    @RemoteAction
    public static returnType remotePagination(Integer currentPageNumber,Boolean isGetMore, String Nav,String sortField,String sortDir,String title,String cuNo,String cpNo,String hCustNo,String centaDocType,String startDate,String endDate,String centaCat,String centaDocTag){
      
       Set<String> fileTypes=new Set<String>{'csv','doc','docx','xls','xlsx','img','msg','pdf','png','ppt','pptx','txt','text','tif','zip','rar','htm','html','snp','default','js','jpg','css','share','search','copy'};
       
       system.debug('sortField: '+sortField);
       if(sortField.equalsIgnoreCase('Cloud_File_Document_Type__r'))
       sortField='Cloud_File_Document_Type__r.Name';
       
       soql1 = createSOQL(title, cuNo, cpNo, hCustNo,centaCat, centaDocType,centaDocTag,startDate, endDate,sortField,sortDir);
       
       ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(Database.query(soql1));
    
       ssc.setPagesize(50);
       ssc.setPageNumber(currentPageNumber);
   
       system.debug('currentPageNumber: '+currentPageNumber);
        if (!isGetMore) { 
           returnType retVal = new returnType();
           retVal.lst_CloudFiles = ssc.getRecords();
            retVal.objects=new List<CloudFileWrapper>();
            system.debug('##list size:'+retVal.lst_CloudFiles.size());
            if(retVal.lst_CloudFiles.size()>0)
            for(Cloud_File__c cf:retVal.lst_CloudFiles){	
            	CloudFileWrapper cfwObj=new CloudFileWrapper(); 
	        	cfwObj.cfObj=cf;
	        	integer lastIndx=(cf.Cloud_File_Full_Name__c).lastIndexOf('.');
	        	String fullName=cf.Cloud_File_Full_Name__c;
	        	String fileType=(fullName.subString(lastIndx+1)).toLowerCase();
	        	String defaultFileType='default';
	        	if(fileTypes.contains(fileType))
	        	{
	        		cfwObj.fileType=fileType;
	        	}
	        	else
	        	{
	        		cfwObj.fileType=defaultFileType;
	        	}
	        	cfwObj.documentType=cf.Cloud_File_Document_Type__r.Name;
	        	retVal.objects.add(cfwObj);
	      	  }
           retVal.hasNext = ssc.getHasNext();
           retVal.hasPre = ssc.getHasPrevious();
           retVal.pageNumber = ssc.getPageNumber();
           retVal.totalRecords = ssc.getResultSize();
           retVal.size = ssc.getPagesize();
          
           return retVal;
       } else { //this is a getMore call
           if (Nav=='isNext' || Nav=='isPrev' || Nav=='isFirst' || Nav=='isLast') {
           system.debug('Nav : '+Nav);
       
        if(Nav=='isNext')
          ssc.Next();
          else if(Nav=='isPrev')
           ssc.previous();
          else if(Nav=='isLast')
           ssc.Last();
          else if(Nav=='isFirst')
            ssc.First(); 
            returnType retVal = new returnType();
            retVal.lst_CloudFiles = ssc.getRecords();
            retVal.objects=new List<CloudFileWrapper>();
            if(retVal.lst_CloudFiles.size()>0)
            for(Cloud_File__c cf:retVal.lst_CloudFiles){
            	CloudFileWrapper cfwObj=new CloudFileWrapper();
	        	cfwObj.cfObj=cf;
	        	integer lastIndx=(cf.Cloud_File_Full_Name__c).lastIndexOf('.');
	        	String fileType=((cf.Cloud_File_Full_Name__c).subString(lastIndx+1)).toLowerCase();
	        	String defaultFileType='default';
	        	if(fileTypes.contains(fileType))
	        	{
	        		cfwObj.fileType=fileType;
	        	}
	        	else
	        	{
	        		cfwObj.fileType=defaultFileType;
	        	}
	        	cfwObj.documentType=cf.Cloud_File_Document_Type__r.Name;
	        	retVal.objects.add(cfwObj);
	        }
            retVal.hasNext = ssc.getHasNext();
            retVal.hasPre = ssc.getHasPrevious();
            retVal.pageNumber = ssc.getPageNumber();
            retVal.totalRecords = ssc.getResultSize();
            retVal.size = ssc.getPagesize();
            return retVal;   
         }else { //no more records left to show, return null
            returnType retVal = new returnType();
            retVal.objects = null;
            retVal.hasNext = false;
            retVal.hasPre = false;
            retVal.pageNumber = ssc.getPageNumber();
            retVal.totalRecords = ssc.getResultSize();
            retVal.size = ssc.getPagesize();
            return retVal;
        }
        
      }
   }
	
   public class returnType{
      List<CloudFileWrapper> objects {get; set;}
      List<Cloud_File__c> lst_CloudFiles{get;set;}
      Integer totalRecords {get; set;}
      Boolean hasNext {get; set;}
      Boolean hasPre {get; set;}
      Integer pageNumber {get;set;}
      Integer size {get;set;}
    }
    public class CloudFileWrapper{
     
      Cloud_File__c cfObj{get;set;}
      String fileType{get;set;}
      String documentType{get;set;}
    }
                
    public Amazon_DocSearch_CTE(ApexPages.StandardController controller) {
       this.clf = (Cloud_File__c)controller.getRecord();       
    }
        
    public Amazon_DocSearch_CTE()
    {
    }
   
    // creates the SOQL that gets executed    
    private Static String createSOQL(String title,String Cloud_file_cu_no,String Cloud_File_Con_Proj_No,String Cloud_file_Hierarchi_Cust_no,String Cloud_File_Category, String Cloud_File_Document_Type,String Cloud_File_Document_Tag,String startDate,String endDate,String sortField,String sortDir)
    {
         // create the search query
        String sqlQuery = 'select Id, name, Cloud_File_Con_Proj_No__c, Cloud_file_cu_no__c, Cloud_file_Title__c, Cloud_File_DocTitle__c, '
             + 'Cloud_file_Hierarchi_Cust_no__c, Cloud_File_MID__c, Cloud_File_Uploaded_By__c, ' + 
             'CreatedDate,Cloud_File_Document_Tag__c,Cloud_File_Full_Name__c,Cloud_File_Category__c,Cloud_File_Document_Type__c, '+
             ' Cloud_File_Category__r.Name,Cloud_File_Document_Type__r.Name '+
             ' from Cloud_File__c where (name != null and isActive__c=true';
        
        // create where conditions
        String soql='';
        if(!String.isEmpty(title))
           soql = soql + ' and Cloud_file_Title__c Like \'' + '%' + title + '%' + '\'';
        if(!String.isEmpty(Cloud_file_cu_no))
           soql = soql + ' and Cloud_file_cu_no__c = \'' + Cloud_file_cu_no + '\'';        
        if(!String.isEmpty(Cloud_File_Con_Proj_No))
            soql = soql + ' and Cloud_File_Con_Proj_No__c = \'' + Cloud_File_Con_Proj_No + '\'';
        if(!String.isEmpty(Cloud_file_Hierarchi_Cust_no))
            soql = soql + ' and Cloud_file_Hierarchi_Cust_no__c = \'' + Cloud_file_Hierarchi_Cust_no + '\'';
            
        if(!String.isBlank(Cloud_File_Category))
            soql = soql + ' and Cloud_File_Category__r.Name = \'' + Cloud_File_Category + '\'';        
        if(!String.isBlank(Cloud_File_Document_Type) && Cloud_File_Document_Type != '__')
            soql = soql + ' and Cloud_File_Document_Type__r.Name = \'' + Cloud_File_Document_Type + '\''; 
        /*if(!String.isEmpty(Cloud_File_All_Categories))
            soql = soql + ' and Cloud_File_All_Categories__c = \'' + Cloud_File_All_Categories + '\'';        
        if(!String.isEmpty(Cloud_File_All_Document_Types) && Cloud_File_All_Document_Types != '__')
            soql = soql + ' and Cloud_File_All_Document_Types__c = \'' + Cloud_File_All_Document_Types + '\'';*/
             
        system.debug('startDate: '+startDate+' endDate: '+endDate);
        if(!String.isEmpty(startDate) && !String.isEmpty(endDate)) {
          Date startDate1 = setStringToDateFormat(startDate);
          Date endDate1 = setStringToDateFormat(endDate);
          startDateTime = DateTime.newInstance(startDate1.year(), startDate1.month(), startDate1.day(),0,0,0);
          endDateTime = DateTime.newInstance(endDate1.year(), endDate1.month(), endDate1.day(),23,59,59);
          soql = soql + ' and createdDate >= :startDateTime and createdDate <= :endDateTime';
        }
        if(!String.isEmpty(startDate) && String.isEmpty(endDate)){
            Date startDate1 = setStringToDateFormat(startDate);
            startDateTime = DateTime.newInstance(startDate1.year(), startDate1.month(), startDate1.day(),0,0,0);
            endDateTime = DateTime.Now();            
            soql = soql + ' and createdDate >= :startDateTime and createdDate <= :endDateTime';
        } 
        if(String.isEmpty(startDate) && !String.isEmpty(endDate)){
            Date endDate1 = setStringToDateFormat(endDate);
            endDateTime = DateTime.newInstance(endDate1.year(), endDate1.month(), endDate1.day(),23,59,59);
            soql = soql + ' and createdDate <= :endDateTime';
        } 
        
        String tagQuery= ' or (Id!=null and isActive__c=true '+soql;
        soql+='  and Cloud_File_Document_Tag__c=null) ';
         if(String.isNotBlank(Cloud_File_Document_Tag) ){
                soql+=tagQuery+' and Cloud_File_Document_Tag__c =\''+Cloud_File_Document_Tag+'\')';             
           }  
        // sorting
        soql = soql + ' Order By ' + sortField + ' ';
        
        // set order by
        soql = sqlQuery+soql + sortDir + (sortDir == 'DESC' ? ' NULLS LAST' : ' NULLS FIRST');
         
        // limiting the number of rows to 10000, becuase a set controller supports supports 10k records only
        soql = soql + ' limit 10000';
        
        system.debug('soql>>>' + soql); 
        return soql; 
    }   
   
   private static Date setStringToDateFormat(String myDate) {   
       String[] dateLiterals = myDate.split('\\.');
       Integer myIntDate;
       Integer myIntMonth;
       Integer myIntYear;
       myIntDate = integer.valueOf(dateLiterals[0]);
       myIntMonth = integer.valueOf(dateLiterals[1]);
       myIntYear = integer.valueOf(dateLiterals[2]);
       Date d = Date.newInstance(myIntYear,myIntMonth, myIntDate);
       return d;    
    }
}