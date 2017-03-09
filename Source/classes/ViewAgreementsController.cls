/******************************************************************************************
*  ViewAgreementsController
*
*******************************************************************************************
*  @ChangeLog  
*  Jira#    Date    Description
*  SF-1567    7/15/2013  Change the logic of View contracts button to fetch the cloud file
*              id from SFDC and pass it to Amazon_ViewFile page.
*
*
*/

public class ViewAgreementsController {

    private List<c_SalesConceptParam> list_SalesConceptParam;
    public Id ysId;
    public String mainImage;
    public string cableUnitName ='';
    private String imageId;
    public String YouSeeContactName = '';
    public String YouSeeContactEmail = '';
    public String YouSeeContactTelephone = '';
  public String telephoneExt = '+45';    
    public String YouSeeContactMCode = '';
    public Boolean pollChecker = true;
    public Integer pollValue=0;
    public String DocumentID{get;set;}
    public String contentString{get;set;}
    public String portalBrugerRole {get; set;}
    public String absolutePath {get; set;}  
    //public boolean exists{get;set;}
  public blob  contentBlob{get;set;}
  private Account_Team__c accountTeam; 
    public Lookup_Account_Team_Role__c accountTeamRoleId = null;
    public Lookup_Account_Team_Role__c relationManagerRoleId = null;
  public ContentVersion content{get;set;}
  public String siteCoreUrl{get; set;}
  public CommonExceptionHandlerCls exceptionHandler = new CommonExceptionHandlerCls('ViewAgreementsController',' See agreements');
  public String cloudFileId {get; set;} // added for SF-1567
  public Boolean renderSection{get;set;}
  public list<Cable_Unit__c> cableUnit = new list<Cable_Unit__c>();
    
    // Temporary variable for checking test classes
    public Boolean tempTestFlag = false;
    
    public String  GetYouSeeContactName () {
        Return YouSeeContactName;       
    }
    public String  GetYouSeeContactEmail () {
        Return YouSeeContactEmail;      
    }
    public String  GetYsId () {
        return ysId;      
    }
     public String  GetYouSeeContactTelephone () {
        Return YouSeeContactTelephone;      
    }
    public String getMainImage() {
        return mainImage;
    }
    public void setMainImage(Id imageId) {
        this.mainImage = imageId;
    }
    
    public List<c_SalesConceptParam> getList_SalesConceptParam(){
        return list_SalesConceptParam;
    }
    
    public ViewAgreementsController(){
      try {
        String cableUnitNumber = ApexPages.CurrentPage().getParameters().get('cableunitnumber');
        String hostname = ApexPages.currentPage().getHeaders().get('Host'); 
        String accountID = ApexPages.currentPage().getParameters().get('accountId');
        cableunitName ='';
        
        // Support-5377 --------START
        Boolean cableUnitMatch = true;  // Support-5377 
        renderSection = true; // Support-5377

        list<Account> accList = new list<Account>();
            if(String.isNotBlank(accountID)){
                
                accList = [SELECT Id, Cable_Unit__r.Cable_Unit_No__c FROM Account where id =:accountID ];
            }
            
            if(!accList.isEmpty()){
                if(cableUnitNumber != null && accList[0].Cable_Unit__r.Cable_Unit_No__c != cableUnitNumber){
                    renderSection = false;
                    cableUnitMatch = false;
                    /* ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Cable Unit Not matched with Account');
                    ApexPages.addMessage(errorMsg); */ 
                }
            }
            else
            {
                renderSection = false;
                cableUnitMatch = false;
                
                 system.debug('***cableUnitMatch****renderSection****'+cableUnitMatch + '    ' + renderSection);
            }
            portalBrugerRole = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
                siteCoreUrl = ServiceCenter_CustomSettings__c.getInstance('Service_Center_SiteCoreURL').Value__c;
                
                cableUnit= [Select id, name, Current_Kiss_Case__r.Sales_Concept_Lookup__r.id from Cable_Unit__c where  Cable_Unit_No__c =:cableUnitNumber limit 1];
                  system.debug('***cableUnit********'+cableUnit);
                  
                  if(!cableUnit.isEmpty())
                    cableunitName = cableUnit[0].name;
                 
                  
            
            if(cableUnitMatch){
                
                absolutePath = 'https://' + hostname;
                tempTestFlag = false;
                
                  
                  // Added for SF-1567
                  // get the related cloud file record for this cable unit number
                  list <Cloud_File__c> listCF = [select id from Cloud_File__c where Cloud_File_Category__r.Name = 'Aftale' and Cloud_File_Document_Type__r.Name = 'Underskrevet Kontrakt' and Cloud_file_cu_no__c = :cableUnitNumber ORDER BY createdDate DESC];
                    if (!listCF.isEmpty()){ 
                        cloudFileId = listCF.get(0).Id;
                        system.debug ('Related cloud File Id:' + cloudFileId);
                        //exists = true;
                    }
                    /*else 
                        exists = false;*/
                        
                  
                  String salesConceptId = cableUnit[0].Current_Kiss_Case__r.Sales_Concept_Lookup__r.id;
                  System.debug('#salesConceptId#'+salesConceptId);
                  Map<string, List<Sales_Concept_Parameter__c>> salesconceptMap = new Map<String,List<Sales_Concept_Parameter__c>>();
              
              //Change according to SC-321 and SC-413
                  //List<Sales_Concept_Parameter__c> salesConceptParamList = [Select s.Parameter_Value__c, s.Parameter_PortalActive__c,s.sc_param_webContent_TextContent__c, s.Parameter_Head__c, s.Parameter_Group__c, s.Parameter_Code__c, s.Name, s.Head__c, s.Code__c From Sales_Concept_Parameter__c s where s.Sales_Concept__c =: salesConceptId and s.Parameter_PortalActive__c = true ];
                  
                  // Added for SC-469 Turning off ProductParameter based on ProductParameterValues
                  List<Sales_Concept_Parameter__c> salesConceptParamList = [Select s.Parameter_Value__c, s.Parameter_PortalActive__c,s.sc_param_webContent_TextContent__c, s.Parameter_Head__c, s.Parameter_Group__c, s.Parameter_Code__c, s.Name, s.Head__c, s.Code__c,ParameterValue_PortalActive__c From Sales_Concept_Parameter__c s where s.Sales_Concept__c =: salesConceptId and s.Parameter_PortalActive__c = true and ParameterValue_PortalActive__c = true];
                  System.debug('#salesConceptParamList#'+salesConceptParamList);
                  for(Sales_Concept_Parameter__c SC_Param: salesConceptParamList){
                      if(salesconceptMap.containsKey(SC_Param.Parameter_Group__c)){
                        if(salesconceptMap != null){
                        }
                        salesconceptMap.get(SC_Param.Parameter_Group__c).add(SC_Param);
                        /* Existing Change According to Gratis parameter
                        System.debug('#salesconceptMap#'+salesconceptMap);
                        if(SC_Param.Parameter_Head__c == 'Gratis ændringsgebyr nyindflytning'){
                            if(SC_Param.Parameter_Value__c != 'Nej'){
                              salesconceptMap.get(SC_Param.Parameter_Group__c).add(SC_Param);
                            }
                        }else{
                          salesconceptMap.get(SC_Param.Parameter_Group__c).add(SC_Param);
                        } */
                      }else {
                          List<Sales_Concept_Parameter__c> paramList = new List<Sales_Concept_Parameter__c>();
                          paramList.add(SC_Param);
                          salesconceptMap.put(SC_Param.Parameter_Group__c,paramList);
                          /* Existing Change According to Gratis parameter
                          System.debug('#SC_Param.Parameter_Head__c#'+SC_Param.Parameter_Head__c+'SC_Param.Parameter_Value__c'+SC_Param.Parameter_Value__c);
                          
                          if(SC_Param.Parameter_Head__c == 'Gratis ændringsgebyr nyindflytning'){
                            if(SC_Param.Parameter_Value__c != 'Nej'){
                              salesconceptMap.put(SC_Param.Parameter_Group__c,paramList);
                            }  
                            System.debug('#salesconceptMap#!!'+salesconceptMap);
                          }else{
                            salesconceptMap.put(SC_Param.Parameter_Group__c,paramList);
                          }*/  
                      }
                  }
                  
                  System.debug('#salesconceptMap@@#'+salesconceptMap);
                  list_SalesConceptParam = new List<c_SalesConceptParam>();
                  Set<String> paramGroupList = salesconceptMap.keySet();
                  for(String paramGroup: paramGroupList){
                      c_SalesConceptParam c_SC_Param = new c_SalesConceptParam();
                      c_SC_Param.salesConceptGroup=paramGroup;
                      c_SC_Param.salesConceptParam=salesconceptMap.get(paramGroup);
                      
                      list_SalesConceptParam.add(c_SC_Param);
                  }
                String relationManagerRoleName = ServiceCenter_CustomSettings__c.getInstance('Service Center RelationShip Manager').Value__c;
                relationManagerRoleId = [select Id from Lookup_Account_Team_Role__c where Name =: relationManagerRoleName];
                Id relManagerRoleId = relationManagerRoleId.Id;
                
                List<Account_Team__c> teamList = [Select a.Id,a.Customer_Team_Member__r.Name, a.Customer_Team_Member__r.Code__c,a.Customer_Team_Member__r.Telephone__c, a.Customer_Team_Member__r.Email__c From Account_Team__c a where a.Customer_Team_Role__r.Id =: relManagerRoleId and a.Customer__c =: accountID limit 1]; 
                 if(teamList != null && teamList.size() > 0){
                   accountTeam = teamList.get(0);
                   if(accountTeam.Customer_Team_Member__r.Name != null){
                     YouSeeContactName = accountTeam.Customer_Team_Member__r.Name;
                   }else{
                     YouSeeContactName = '';
                   }
                 
                   if(accountTeam.Customer_Team_Member__r.Email__c != null){
                     YouSeeContactEmail = accountTeam.Customer_Team_Member__r.Email__c;
                   }else{
                     YouSeeContactEmail = '';
                   }
                 
                   if(accountTeam.Customer_Team_Member__r.Telephone__c != null && accountTeam.Customer_Team_Member__r.Telephone__c != ''){
                     YouSeeContactTelephone = telephoneExt + accountTeam.Customer_Team_Member__r.Telephone__c;
                   }else{
                     YouSeeContactTelephone = accountTeam.Customer_Team_Member__r.Telephone__c;
                   }
                   
                   if(accountTeam.Customer_Team_Member__r.Code__c != null){
                     YouSeeContactMCode = accountTeam.Customer_Team_Member__r.Code__c;
                   }else{
                     YouSeeContactMCode = '';
                   }
                   
                   if(YouSeeContactEmail != null){
                     ysId = accountTeam.Customer_Team_Member__r.Id;
                     
                   }
                 }
                 ImageId = GetDocumentId(YouSeeContactMCode);
                   mainImage = ImageId; 
                 
                     /* List<ContentVersion> contentList = [select id, Title, Description from ContentVersion where Account__c =: ApexPages.CurrentPage().getParameters().get('accountId') order by CreatedDate DESC];
               if(contentList.size() > 0){
                content = contentList.get(0);
                DocumentID = content.id;
                exists = true;
               }else{
                 DocumentID = '';
                 exists = false;
               }*/
                    
            }
        
      
      } catch (Exception e){
          system.debug('***Exception*********'+ e.getMessage());
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
              ApexPages.addMessage(errorMsg);
        }       
    }
    
    public class c_SalesConceptParam{
        public string salesConceptGroup {public get;public set;}
        public List<Sales_Concept_Parameter__c> salesConceptParam {get; set;}
    }
        
    public String getImageId(){
        return imageId;
    } 
      
    public string getCableUnitName() {
        return cableUnitName ;
    }
    
    public Account_Team__c getAccountTeam(){
        return accountTeam;
    }
    
    public String GetTestImageId(){
        return '015R000000069yT' + '&oid=' + UserInfo.getOrganizationId();
    } 
    
    public PageReference writeToConsultant(){
      try {
            PageReference writeToConsultantPage;
            writeToConsultantPage= Page.writeToYourConsultant;
            writeToConsultantPage.getParameters().putAll(ApexPages.CurrentPage().getParameters());
            writeToConsultantPage.getParameters().put('previousPage','/apex/ViewAgreementsPage');
            // Added Extra for getting parameter
            writeToConsultantPage.getParameters().put('YouSeeContactEmail',GetYouSeeContactEmail());
            writeToConsultantPage.getParameters().put('ysId',GetYsId());
            
            if(tempTestFlag == true){
            integer J;
            J = 10/0;
          }
            return writeToConsultantPage;
      } catch (Exception e){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SC_commonError);
              ApexPages.addMessage(errorMsg);
              exceptionHandler.handleException(e,'writeToConsultant()',false,false,null,'Medium');
              return null;
         }        
    }
    
    public String GetDocumentId (String UserMCode ){
      try {
            String Result = '';
            for(Document docu : [Select d.Id From Document d where d.Name =: UserMCode]){
              Result = '/servlet/servlet.FileDownload?file=' + docu.Id;
            }
            if(tempTestFlag == true){
              integer I;
              I =10/0;
            }
            return Result;
      } catch (Exception e) {
        ApexPages.Message myMsg;
            myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,Label.SC_commonError);
            ApexPages.addMessage(myMsg);
            return null;
      }         
    }
}