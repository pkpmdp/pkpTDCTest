/*
 *Jira Issue SF-1807 :- Bulk upload one document to multi cable unit.
 *Description:- User can upload a single file to maximum 5 Cable Units.
 *VF - 1. Amazon_UploadFileToMultiCUs
 *     2. Amazon_UploadFileToMultiCUs1
 *     3. Amazon_UploadFileToMultiCUs2
*/

public class Amazon_DocUploadMultiCU_CT {
    
    public static String serverURL {get;set;}
    public String cuNo {get; set;}
    public List<CuWrapper> CWLst {get; set;}    
    public List<CuWrapper> selectedCUs = new List<CuWrapper>();
    public List<CuWrapper> unselectedCUs = new List<CuWrapper>();
    public Boolean rndrd{get;set;}
    Account acc;
    ApexPages.StandardController con;
    public Cloud_File__c record;
    AWSKey__c awsConfig;
    public AWSKey__c awskey;
    public string key { get {return awskey.Key__c;} }
    public AWSKey__c credentials;
    public String categoryVar{get;set;}
    public String docTypeVar{get;set;}
    public boolean isCategorySelected{get;set;}   
        
    public Amazon_DocUploadMultiCU_CT(ApexPages.StandardController stdController) {
      
        AmazonUtil auObj=new AmazonUtil();
        credentials = AmazonUtil.getAWSConfig();
        awskey=AmazonUtil.getAWSConfig();
        CWLst = new List<CuWrapper>();
        rndrd = false;
        this.con = stdController;
                
        try{
            this.record = [SELECT Id,Cloud_File_Bucket_Name__c,Cloud_file_content_Type__c, Name,Cloud_File_Full_Name__c, Cloud_File_Access__c, 
                                  Cloud_File_Description__c, Cloud_file_cu_no__c, Cloud_File_Category__c,Cloud_File_Document_Type__c,
                                  Cloud_file_Status__c,Cloud_File_Department__c, Cloud_file_Title__c, Cloud_file_Hierarchi_Cust_no__c,
                                  Cloud_File_Customer_Numbers__c, Cloud_File_Path_Prefix__c,
                                  Cloud_File_Category__r.Name,Cloud_File_Document_Type__r.Name      
                           FROM Cloud_File__c 
                           WHERE Id = :con.getRecord().id limit 1];
        } catch(Exception e){
            this.record = new Cloud_File__c();          
        }
    }
    
    public Amazon_DocUploadMultiCU_CT(){
        credentials = AmazonUtil.getAWSConfig();
    }
    
    public List<SelectOption> getCategories() {
      Set<ID> set_ids=new Set<ID>();
        List<DocumentCategoryType__c> lst_Obj=[SELECT Parent__r.Id FROM DocumentCategoryType__c where Type__c='Document Type' and isActive__c=true];
        for(DocumentCategoryType__c tempObj : lst_Obj)
        {
          set_ids.add(tempObj.Parent__r.Id);
        }
        List<DocumentCategoryType__c> lst_categories=[SELECT isActive__c,Name,Value__c,Parent__c,Type__c FROM DocumentCategoryType__c where isActive__c=true and Type__c ='Category' and Id IN : set_ids];
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
        List<DocumentCategoryType__c> lst_docTypes=new List<DocumentCategoryType__c>();
       List<DocumentCategoryType__c> lst_category2=[SELECT ID,Value__c FROM DocumentCategoryType__c where isActive__c=true and Type__c ='Category' and Value__c=:categoryVar];
       if(lst_category2.size()>0){
         lst_docTypes=[SELECT isActive__c,Name,Value__c,Parent__c,Type__c FROM DocumentCategoryType__c where isActive__c=true and Type__c ='Document Type' and Parent__c=:lst_category2[0].Id];
       }
        lst_docTypes.sort();
        List<SelectOption> options = new List<SelectOption>();
        if(String.isBlank(categoryVar)){
          isCategorySelected=false;
          String result = UserInfo.getLocale();
          String language=UserInfo.getLanguage();
          system.debug('##locale :'+result);
            system.debug('##language :'+language);
      if(language.equalsIgnoreCase('en_us')){
         options.add(new SelectOption(' ','--None--'));
      }else{
            options.add(new SelectOption(' ','--Ingen--'));
      }
        }else
        {
          isCategorySelected=true;
        }
        for(DocumentCategoryType__c lbl : lst_docTypes)
        {
          options.add(new SelectOption(lbl.Value__c,lbl.Name));
        }
      return options;
     }
   
    //Used on VF - Amazon_UploadFileToMultiCUs
    public PageReference Cancel(){
        PageReference p = new PageReference('/apex/Amazon_UploadFileToMultiCUs');
        p.setRedirect(true);
        return p;
    }
    
    
     public pageReference cancel1() {
        
        List<Cloud_File__c> listClF1 = [SELECT Id, Name, Cloud_file_related_to_id__c, Cloud_file_cu_no__c, Cloud_file_Hierarchi_Cust_no__c, 
                                        Cloud_File_Customer_Numbers__c, Cloud_File_Path_Prefix__c                                           
                                       FROM Cloud_File__c WHERE Id =:con.getRecord().id LIMIT 1];
        String relatedToId = listClF1[0].Cloud_file_related_to_id__c;
        if(!listClF1.isEmpty()){
            delete listClF1;
            system.debug('Deleted');
        }
        PageReference p = new PageReference('/apex/Amazon_UploadFileToMultiCUs');
        p.setRedirect(true);
        return p;   
    }
    
    //This function is used on VF - Amazon_UploadFileToMultiCUs
    //Description:- This function will search for entered Cable Unit and will add it to the Searched Cable Units table
    public PageReference searchCU() {
        if(cuNo != null && cuNo != '' && String.isNotBlank(cuNo) && String.isNotEmpty(cuNo)) {
            system.debug('***CU not null***'+cuNo);
            if(cuNo.length() <> 10) {
                if(cuNo.length() < 10){
                    /*Integer diff = 10 - cuNo.length();
                    String zeros = '';
                    
                    for(Integer i = 0; i<= diff - 1; i++){
                        zeros = zeros + '0';
                    }
                    cuNo = zeros + cuNo;*/
                    
                    cuNo = AmazonUtil.fixCableUnitNo(cuNo);
                }else if(cuNo.length() > 10){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Kundenr kan ikke være mere end 10 cifre.'));
                }
            }
                        
            List<Account> acccuLst = [SELECT Id, Name, Cable_Unit_No__c, Cable_Unit_Name__c FROM Account WHERE Cable_Unit_No__c =:cuNo];
            List<String> cuNumLst = new List<String>();
            
            if(!acccuLst.isEmpty()){
                for(Account a : acccuLst){
                    cuNumLst.add(a.Cable_Unit_No__c);
                }
                
                List<Account> aLst = new List<Account>([SELECT Id, Name, Cable_Unit_No__c, Cable_Unit_Name__c FROM Account WHERE Cable_Unit_No__c IN: cuNumLst]);
                
                
                for(Account ac : aLst){                                        
                    Boolean matched = false;
                    Boolean matched1 = false;
                    for(CuWrapper c : CWLst)
                        if(c.accw.id == ac.id)
                            matched = true;
                    
                                                        
                    if(!matched){                       
                        CuWrapper CW = new CuWrapper();
                        CW.accw = ac;
                        CW.selected = false;
                        CWLst.add(CW);                      
                    }
                }
                system.debug('CWLst= '+CWLst);
            }else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Indtastede Kundenr findes ikke.'));
            }
        }else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Indtast Kundenr.'));
        }
        return null;
    }
    
    //Function to get selected cable units. Selected Cable Units will be displayed in data table.
    public PageReference getSelected() {
        system.debug('!@#CWLst= '+CWLst);
        List<CuWrapper> cWrapSelectionCheck=new List<CuWrapper>();
        
        integer j = 0;
        if(!CWLst.isEmpty()){            
            for(CuWrapper cWrap : CWLst){
                if(cWrap.selected == True){
                    cWrapSelectionCheck.add(cWrap);
                    j++;
                    Boolean matchFound = false;
                    for(CuWrapper scw : selectedCUs)
                        if(scw.accw.id == cWrap.accw.id)
                            matchFound = true;
                            
                    if(!matchFound){                        
                        selectedCUs.add(cWrap);                          
                    }
                }       
            }
            
            system.debug('@@@@selectedCUs= '+selectedCUs);
            system.debug('@@@@selectedCUs size= '+selectedCUs.size());
            system.debug('@@@CWLst.size()= '+CWLst.size());
            
            for(Integer i = CWLst.size() - 1; i >= 0 ; --i){                
                if(CWLst[i].selected==true)
                CWLst.remove(i);                
            }
            for(Integer i = selectedCUs.size() - 1; i >= 0 ; --i){                      
                selectedCUs[i].selected=false;              
            }
            
        }
        if(cWrapSelectionCheck.size()==0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Du søge og vælg Kunde nr.(er)'));
        } 
        
        return null;
    }
        
    public List<CuWrapper> GetSelectedCUs() {
        system.debug('!@selectedCUs= '+selectedCUs);
        if(selectedCUs.size() > 0){         
            return selectedCUs;
        }else{
            return null;
        }
    }
    
    //Function to get unwanted cable units. Selected Cable Units will be get removed from 'Selected Cable Units' table.
    public PageReference getUnSelected() {
        if(!selectedCUs.isEmpty()){
            system.debug('***selectedCUs Not Empty***'+selectedCUs);
            unselectedCUs.clear();
            for(CuWrapper cWrap : selectedCUs){
                if(cWrap.selected == True){
                    system.debug('!!!cWrap.selected is true= '+cWrap.selected);
                    Boolean matchFound = false;
                    for(CuWrapper scw : CWLst)
                        if(scw.accw.id == cWrap.accw.id)
                            matchFound = true;
                            system.debug('@@@matchFound= '+matchFound);
                    
                    if(!matchFound){
                        system.debug('###Match not found= '+matchFound);
                        cWrap.selected = false;
                        system.debug('$$$cWrap.selected= '+cWrap.selected);
                        unselectedCUs.add(cWrap);     
                        system.debug('%%%unselectedCUs= '+unselectedCUs);     
                        system.debug('^^^CWLst= '+CWLst);
                        CWLst.add(cWrap);                       
                        system.debug('!!!!CWLst= '+CWLst);                          
                    }                   
                }       
            }
            
            for(Integer i = unselectedCUs.size() - 1; i >= 0 ; --i){
                selectedCUs.remove(i);              
            }
            
            system.debug('@@@@selectedCUs= '+selectedCUs);          
            system.debug('@@@CWLst.size()= '+CWLst.size());     
            
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Der er ingen Kundenr at fjerne fra tabellen.'));
        }       
        return null;
    }   
    
    //User can select upto 5 cable units only. If more than Cable Units are selected then display message on page.
    //Also if cable unit is not selected at all then display error message.    
    public void renderPB(){
        if(!selectedCUs.isEmpty()){         
            if(selectedCUs.size() > 5){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Du kan vælge op til 5 Kundenr alene.'));
            }else{
                rndrd = true;
            }
        }else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Vælg Kundenr'));
        }
    }
        
    //This function will save document record and will redirect to Amazon_UploadFileToMultiCUs1 VF to upload a file
    public PageReference save1() {
      
        User mid = [SELECT Id, MID__c, Name,Department, IsActive FROM User WHERE Id =: UserInfo.getUserId()];
        
        Cloud_File__c cldF = (Cloud_File__c)con.getRecord();            
      
      if(String.isNotBlank(mid.Department)){               
          cldF.Cloud_File_Department__c =mid.Department;
      } 
        
        system.debug('*** category:'+ categoryVar+' docType:'+docTypeVar);    
     
      if(String.isBlank(categoryVar)||String.isBlank(docTypeVar))
        {
          Apexpages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Vælg kategori og dokument type'));
           return null;
        }else{
          List<DocumentCategoryType__c> lst_categoryDocType=[Select Id,Type__c,Parent__c,Name,isActive__c from DocumentCategoryType__c where value__c IN(:categoryVar,:docTypeVar)];
          system.debug('***lst_categoryDocType size:'+lst_categoryDocType.size()+' lst_categoryDocType:'+lst_categoryDocType);
          Id parentId;
          for(DocumentCategoryType__c tempObj : lst_categoryDocType){        
          if((tempObj.Type__c).equalsIgnoreCase('Category')){
            cldF.Cloud_File_Category__c=tempObj.Id;
            parentId=tempObj.Id;
          }
         }   
          for(DocumentCategoryType__c tempObj : lst_categoryDocType){     
          if((tempObj.Type__c).equalsIgnoreCase('Document Type')&&(tempObj.Parent__c==parentId)&&(tempObj.Name).equalsIgnoreCase(docTypeVar)){
            cldF.Cloud_File_Document_Type__c=tempObj.Id;
             system.debug('***inside doc type');
           }  
          }     
        }
                
        /*Map<string,Amazon_NoUploadCategory__c> mapCat = Amazon_NoUploadCategory__c.getAll();
        Map<string,Amazon_NoUploadCategory__c> mapCat1 = new Map<string,Amazon_NoUploadCategory__c>();
        system.debug('!!!mapCat= '+mapCat);
        system.debug('@@@mapCat= '+mapCat.values());
                
        for(Amazon_NoUploadCategory__c a : mapCat.values()){
          system.debug('###In if###');
          mapCat1.put(a.Category__c, a);                       
       }
       system.debug('$$$mapCat1= '+mapCat1);
       
       Set<String> cat = new Set<String>();
       cat.addAll(mapCat1.keyset());
       system.debug('%%%cat= '+cat);
       
       system.debug('***Record Category= '+record.Cloud_File_Category__r.Name);
       system.debug('&&&&C0ntains= '+cat.contains(record.Cloud_File_Category__r.Name));
       
       if(cat.contains(cldF.Cloud_File_Category__r.Name)){
           system.debug('^^^In contains If^^^');
           Apexpages.addMessage(new ApexPages.message(ApexPages.severity.Error, Label.Doc_NoUploadCategory));
           return null;
       }else{ */        
          con.save();
         
          PageReference p = new PageReference('/apex/Amazon_UploadFileToMultiCUs1?id='+ con.getRecord().id );
          List<Cloud_File__c> listClF = [SELECT Id, Name, Cloud_file_related_to_id__c, Cloud_file_cu_no__c, Cloud_File_Bucket_Name__c, 
                                                isActive__c, Cloud_file_Hierarchi_Cust_no__c, Cloud_File_Customer_Numbers__c, Cloud_file_Status__c, 
                                                Cloud_File_Category__c, 
                                                Cloud_File_Document_Type__c, Cloud_File_Path_Prefix__c  
                                         FROM Cloud_File__c WHERE Id =:con.getRecord().id LIMIT 1];
                                         
          List<String> cuStrLst = new List<String>();
          
          for(CuWrapper act : selectedCUs){
              cuStrLst.add(act.accw.Cable_Unit_No__c);
          }
          
          if(!listClF.isEmpty()){
              Cloud_File__c cf =  listClF[0];
              acc = [SELECT Id, Name, Cable_Unit_No__c, HierarchyCustomerNumber__c, Type FROM Account WHERE Cable_Unit_No__c =:cuStrLst[0] LIMIT 1];
                            
              cf.Cloud_file_related_to_id__c = acc.Id;              
              cf.Cloud_file_cu_no__c = '';
                            
              for(Integer i =0; i < cuStrLst.size(); i++){
                  cf.Cloud_file_cu_no__c += cuStrLst[i] + ';';
              }
              
              cf.Cloud_File_Customer_Numbers__c = cuStrLst[0];               
              cf.Cloud_File_Bucket_Name__c = AmazonUtil.getCorrectBucket();
              cf.Cloud_File_Path_Prefix__c = AmazonUtil.getCloudFilePrefix(acc);
              cf.IsActive__c = false;
                                  
              if(mid.isActive == true){
                  cf.Cloud_File_MID__c = mid.MID__c;                  
              } 
                            
              update listClF;
          }
          
          p.getParameters().put('urlParam', serverURL);
          p.setRedirect(true);
          return p;
      /* }*/
    }
    
    public PageReference credentials(){
        try{
            awskey = AmazonUtil.getAWSConfig();
        }catch(Exception e){
            system.debug('Exception in credentials= '+e);                    
        }     
       return null; 
    }
    
    //This method will create a Policy 
    public static String createPolicy(Cloud_File__c cf){
      datetime expire = system.now().addDays(1);
      String formattedexpire = expire.formatGmt('yyyy-MM-dd')+'T'+
                               expire.formatGmt('HH:mm:ss')+'.'+
                               expire.formatGMT('SSS')+'Z'; 
                               
      String pkey = cf.Cloud_File_Path_Prefix__c + '/' + cf.Cloud_File_Customer_Numbers__c;
            
      system.debug('serverurl'+serverurl);                    
      String policy =  '{ "expiration": "'+formattedexpire +'",' + 
                         '"conditions": [ {"bucket": "' + cf.Cloud_File_Bucket_Name__c +'" } ' + 
                         ',{ "acl": "' + cf.Cloud_File_Access__c +'" },'+                              
                         '{"content-type":"'+cf.Cloud_file_content_Type__c+'"},'+
                         '{"success_action_redirect": "https://'+serverurl+'/apex/Amazon_UploadFileToMultiCUs2?ID='+cf.id+'&callback=True"},' +
                         '["starts-with", "$key", "'+ pkey +'"]]}';
      system.debug('>>>policy:' + policy);  
      
      return policy;  
    }
    
    //method that will sign
    private static String make_sig(string canonicalBuffer, String apiSecret) {        
        String macUrl ;          
        Blob mac = Crypto.generateMac('HMacSHA1', blob.valueof(canonicalBuffer),blob.valueof(apiSecret)); 
        macUrl = EncodingUtil.base64Encode(mac);                
        return macUrl;
    }
    
    public static String getSignature(String policyStr, String apiSecret){       
       return make_sig(EncodingUtil.base64Encode(Blob.valueOf(policyStr)), apiSecret);  
    }
    
    // this method is called from JS in Amazon_DocUploadToS3 page to upload the content type and 
    // and also generate the file title
    @RemoteAction
    public static RemoteActionResponse processFile(String cloudFileId, String fileExt, String contentType, String server_URL){
        // get the aws config
        AWSKey__c awsConfig1 = AmazonUtil.getAWSConfig();
        system.debug('>>>in updateContentType');
        List<Cloud_File__c> listCF = [SELECT Id, Cloud_file_content_Type__c, Cloud_File_Document_Type__r.Name, 
                                             Cloud_File_Bucket_Name__c, Cloud_File_Access__c, Cloud_file_cu_no__c,
                                             Cloud_file_KISS_doc_type__c, Cloud_file_Title__c, Cloud_File_Full_Name__c, 
                                             Cloud_file_Hierarchi_Cust_no__c, Cloud_File_Customer_Numbers__c, Cloud_file_Status__c, 
                                             Cloud_File_Path_Prefix__c  
                                      FROM Cloud_File__c
                                      WHERE Id = :cloudFileId];        
        if(!listCF.isEmpty()){
            Cloud_File__c cf =  listCF[0];
            cf.Cloud_file_content_Type__c = contentType;
            cf.Cloud_file_Title__c = AmazonUtil.getCloudFileTitle(cf, fileExt);
            cf.Cloud_File_Full_Name__c = cf.Cloud_File_Customer_Numbers__c + '/' + cf.Cloud_file_Title__c;
            system.debug('>>>>cf' + cf);
            update cf;
            
            system.debug('server_URL= '+server_URL);
            serverURL = server_URL;
            // return the file title back along with the 
            // recalculated policy and signature
            RemoteActionResponse res = new RemoteActionResponse();
            res.fileTitle = cf.Cloud_file_Title__c; 
            
            String policyStr = createPolicy(cf);
            res.policy = AmazonUtil.getPolicy(policyStr); 
            System.debug('Blob Policy>>>' + res.policy);
            System.debug('Hex Policy>>>' + EncodingUtil.convertToHex(Blob.valueOf(res.policy))); 
            
            system.debug('awsConfig1.Secret__c= '+awsConfig1.Secret__c);
            res.signature = getSignature(policyStr, awsConfig1.Secret__c);            
            system.debug('Signature>>>> '+res.signature + '@@@@@@' + 'Policy= '+res.policy);
            return res;
        }
        return null;
    } 
    
    public static String createServerURL(){
        serverURL = ApexPages.currentPage().getParameters().get('urlParam');
        system.debug('serverURL= '+serverURL);
        String urlDomain = serverURL.substring(serverURL.indexOf('://')+3,serverURL.indexOf('/services'));
        return urlDomain;
    }
    
    public PageReference page2onLoad() {
        List<Cloud_File__c> listClF1 = [SELECT Id, Name, Cloud_file_related_to_id__c, Cloud_file_cu_no__c,  
                                               Cloud_File_Bucket_Name__c, Cloud_File_Full_Name__c, Cloud_file_content_Type__c,
                                               Cloud_File_Document_Type__c, Cloud_file_Title__c, Cloud_file_Hierarchi_Cust_no__c,
                                               Cloud_File_Customer_Numbers__c, Cloud_file_Status__c, Cloud_File_Path_Prefix__c   
                                        FROM Cloud_File__c WHERE Id =:con.getRecord().id LIMIT 1];
                                        
        PageReference tempPageRef = credentials();
        serverURL = createServerURL();        
        return null;
    }
    
    //This function is used on VF - Amazon_UploadFileToMultiCUs2
    //Description:- Function to upload one file to multiple Cable Units
    public pageReference uploadMulti(){
      User mid = [SELECT Id, MID__c, Name,Department, IsActive FROM User WHERE Id =: UserInfo.getUserId()];     
        String cloudFlId = APexpages.currentPage().getParameters().get('Id');        
        String isactive = APexpages.currentPage().getParameters().get('callback');        
        List<Cloud_File__c> listClF3 = new List<Cloud_File__c>();
        Boolean copied;
        
        Cloud_File__c listClF2 = [SELECT Id, Name, Cloud_file_related_to_id__c, Cloud_file_cu_no__c,  
                                         Cloud_File_Bucket_Name__c, Cloud_File_Full_Name__c, Cloud_file_content_Type__c, Cloud_File_Document_Type__c, 
                                         Cloud_file_Title__c, IsActive__c, Cloud_file_Hierarchi_Cust_no__c, Cloud_File_Customer_Numbers__c, 
                                         Cloud_File_Description__c, Cloud_File_Category__c, Cloud_file_Status__c, Cloud_File_MID__c, 
                                         Cloud_File_Path_Prefix__c   
                                  FROM Cloud_File__c WHERE Id =:cloudFlId LIMIT 1];
                                  
         system.debug('##listClF2 = '+listClF2+'11'+listClF2.Cloud_file_cu_no__c+'%2%'+listClF2.Cloud_File_Customer_Numbers__c);
        if(listClF2 != Null){
            if(isactive == 'True'){
                listClF2.IsActive__c = True;
            }
            else{
                listClF2.IsActive__c = False;
            }
                        
            String cus = listClF2.Cloud_file_cu_no__c.remove(listClF2.Cloud_File_Customer_Numbers__c);
            List<String> listCus = new List<String>();        
            system.debug('cus= '+cus);
            listClF2.Cloud_file_cu_no__c = listClF2.Cloud_File_Customer_Numbers__c;
            
            if(cus.contains(';')){
                listCus = cus.split(';');
                system.debug('listCus= '+listCus);
                if(!listCus.isEmpty()){
                    String s  = listCus.remove(0);
                    system.debug('s= '+s);
                }               
            }
            
            for(Integer i=0; i < listCus.size(); i++){
                Account acc1 = new Account();
                acc1 = [SELECT Id, Name, Cable_Unit_No__c, Type FROM Account WHERE Cable_Unit_No__c =:listCus[i] LIMIT 1];  
                                
                Cloud_File__c cf1 = new Cloud_File__c();                       
                cf1.Cloud_file_related_to_id__c = acc1.Id;
                cf1.Cloud_file_cu_no__c = listCus[i];
                cf1.Cloud_File_Customer_Numbers__c = cf1.Cloud_file_cu_no__c;
                cf1.Cloud_File_Bucket_Name__c = AmazonUtil.getCorrectBucket();                
                cf1.Cloud_file_content_Type__c = listClF2.Cloud_file_content_Type__c;                
                cf1.Cloud_file_Title__c = listClF2.Cloud_file_Title__c;
                cf1.Cloud_File_Full_Name__c = cf1.Cloud_file_cu_no__c + '/' + listClF2.Cloud_file_Title__c;
                cf1.isActive__c = true;
               // cf1.Cloud_File_Centa_Doc_Type__c = listClF2.Cloud_File_Centa_Doc_Type__c; 
                cf1.Cloud_File_Category__c = listClF2.Cloud_File_Category__c;                     
                //cf1.Centa_Document_Name__c = listClF2.Centa_Document_Name__c;
                cf1.Cloud_File_Document_Type__c = listClF2.Cloud_File_Document_Type__c;
                cf1.Cloud_File_Description__c = listClF2.Cloud_File_Description__c;
                cf1.Cloud_file_Status__c = listClF2.Cloud_file_Status__c;
                cf1.Cloud_File_MID__c =  listClF2.Cloud_File_MID__c;
                cf1.Cloud_File_Path_Prefix__c = listClF2.Cloud_File_Path_Prefix__c;
                
                if(String.isNotBlank(mid.Department)){
                    cf1.Cloud_File_Department__c =mid.Department;
                }  
                   
                listClF3.add(cf1);
            }
            
            for(Cloud_File__c cf : listClF3){
                String origBucket = listClF2.Cloud_File_Bucket_Name__c;
                String origFileName = listClF2.Cloud_File_Path_Prefix__c + '/' + listClF2.Cloud_File_Full_Name__c;
                String newBucket = cf.Cloud_File_Bucket_Name__c;
                String newFileName = cf.Cloud_File_Path_Prefix__c + '/' + cf.Cloud_file_cu_no__c + '/' + cf.Cloud_file_Title__c;
                if(!Test.isRunningTest()){
                copied = AmazonUtil.copyFile(origBucket, origFileName, newBucket, newFileName);
                }
            }
            
            if(!listClF3.isEmpty()){
                if(copied == true){                    
                    insert listClF3;
                    
                }               
                system.debug('listClF3= '+listClF3);
                system.debug('listClF2= '+listClF2);
            }
            update listClF2;
        }
                
        PageReference p = new PageReference('/apex/Amazon_UploadFileToMultiCUs');        
        return p;
    }
    
    public class CuWrapper {
        public Account accw {get;set;}
        public boolean selected {get; set;}
    }
    
    public class RemoteActionResponse{
        public String policy {get; set;}
        public String signature {get; set;}
        public String fileTitle {get; set;}
    }
}