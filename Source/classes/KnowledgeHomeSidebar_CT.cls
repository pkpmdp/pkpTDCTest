// This is a common controller for all the YO and YK Homepage sidebar components
//
// @Author - Sarabdeep Ahluwalia
// @Date - 2/9/2013
//
public class KnowledgeHomeSidebar_CT {
    public String viewId {get; set;}  
    public List<YO_OperationConsultant__c> listInfo {get; set;}
    public User userData {get; set;}
    public Boolean isAdmin {get; set;}
    
    public String sectionInfo   {get;set;}
    public String sectionTextInfo   {get;set;}
    public String sectionInfoId {get;set;}
    public String sectionId {get;set;}
    public String sectionTextInfoId {get;set;}
    
    // Boolean variables for YO Homepage
    public Boolean showYOTDS{get; set;}
    public Boolean showVagtInfo{get; set;}
    public Boolean showYKInfo{get; set;}
    public Boolean showBookingInfo{get; set;}
    
    public String operationConsultantKeyPrefix  {get;set;}
    
    // for booking info
    public String bookingAuto   {get;set;}
    public String bookingStik   {get;set;}
    public String bookingFiber  {get;set;}
    String[] strTempbookingAuto = new String[]{}; 
    String[] strTempbookingStik = new String[]{}; 
    String[] strTempbookingFiber = new String[]{}; 
    public String ddmmyyDateFAuto{get; set;} 
    public String ddmmyyDateFStik{get; set;} 
    public String ddmmyyDateFFiber{get; set;}
    
    public Boolean pageLoad {set;}
    
    
    public Boolean getPageLoad()
    {
        //viewId = ApexPages.currentPage().getParameters().get('viewId');
        Schema.DescribeSObjectResult yoOperationConsultant = YO_OperationConsultant__c.SObjectType.getDescribe();
        operationConsultantKeyPrefix = yoOperationConsultant.getKeyPrefix();
        
        System.debug('>>>>viewId:' + viewId);
        
        if(viewId == 'YKINFO')
        {
             showYKInfo();      
        }
        if(viewId == 'BKINFO'){
             showBookingInfo();
        }
        
        if(viewId == 'Specialdrift') {
            showYotdsInfo();
        }
        
        if(viewId == 'VAGT') {
            showVagtInfo();
        } 
        
        return true;    
    }
      
    
    // constructor  
    public KnowledgeHomeSidebar_CT()
    {
       /*
        //viewId = ApexPages.currentPage().getParameters().get('viewId');
        Schema.DescribeSObjectResult yoOperationConsultant = YO_OperationConsultant__c.SObjectType.getDescribe();
        operationConsultantKeyPrefix = yoOperationConsultant.getKeyPrefix();
        
        System.debug('>>>>viewId:' + viewId);
        
        if(viewId == 'YKINFO')
        {
             showYKInfo();      
        }
        if(viewId == 'BKINFO'){
             showBookingInfo();
        }
        
        if(viewId == 'YOTDS') {
            showYotdsInfo();
        }
        
        if(viewId == 'VAGT') {
            showVagtInfo();
        }
      */  
    }
    
    
    // gets the data from YK Info section
    public void showYKinfo()
    {
          ID YKInfoRecTyp = [SELECT Id, Name FROM RecordType WHERE Name = 'YK Info'].Id;
            
          listInfo = [SELECT Id, Name, YK_Info__c FROM YO_OperationConsultant__c
                          WHERE RecordTypeId =:YKInfoRecTyp LIMIT 1];
                          
          isAdmin = YKSpocUtils.isYKAdmin(UserInfo.getUserId()); 
           
       /*   // Added the below code as we are allowing access through permission set as well
          Set<Id> usersWithPermissionSet = new Set<Id>();
          for(PermissionSetAssignment p : [Select p.SystemModstamp, p.PermissionSetId, p.Id, p.AssigneeId From PermissionSetAssignment p where p.PermissionSetId IN (Select p.Id From PermissionSet p where p.Name='KnowledgeBase_AdminRights')])
           {
                    usersWithPermissionSet.add(p.AssigneeId);
                    System.debug('AssigneeId***'+p.AssigneeId);
          }
           if(usersWithPermissionSet.contains(UserInfo.getUserId())){
                isAdmin = true;
           }  */
          
          showYKInfo = true;   
    }
    
    public void showBookingInfo()
    {
        
        ID bookingInfoRecTyp = [SELECT Id, Name FROM RecordType WHERE Name = 'Booking Details'].Id;
        listInfo = [SELECT Id, Name, Information__c 
                               FROM YO_OperationConsultant__c
                               WHERE RecordTypeId =: bookingInfoRecTyp LIMIT 1];     
        
        
        bookingAuto = '';      
        bookingStik = '';
        bookingFiber = '';   
        
        isAdmin = YKSpocUtils.isYKAdmin(UserInfo.getUserId());  
        
      /*  // Added the below code as we are allowing access through permission set as well
          Set<Id> usersWithPermissionSet = new Set<Id>();
          for(PermissionSetAssignment p : [Select p.SystemModstamp, p.PermissionSetId, p.Id, p.AssigneeId From PermissionSetAssignment p where p.PermissionSetId IN (Select p.Id From PermissionSet p where p.Name='KnowledgeBase_AdminRights')])
           {
                    usersWithPermissionSet.add(p.AssigneeId);
                    System.debug('AssigneeId***'+p.AssigneeId);
          }
           if(usersWithPermissionSet.contains(UserInfo.getUserId())){
                isAdmin = true;
           }   */
        
        // parsing
        Document d = [Select Body From Document Where Name = 'YK Booking Data' Limit 1];
        String body = d.Body.toString();
        DateTime dtNow = DateTime.Now();
        //String s = dtNow.format('M/d/yyyy');
        String s = dtNow.format('d/M/yyyy');
        String s1 = dtNow.format('d-MM-yyyy');
        
        for(String f : body.split('\n'))
        {                        
            if(f.split(',')[1] == s || f.split(',')[1] == s1){
                bookingAuto = f.split(',')[2];                  
                if(bookingAuto.contains('/')){
                    strTempbookingAuto = bookingAuto.split('/'); ///
                }else if(bookingAuto.contains('-')){
                    strTempbookingAuto = bookingAuto.split('-');
                }
                
                if(strTempbookingAuto.size() == 3)
                {                         
                    if(strTempbookingAuto[0].length() == 1){
                        strTempbookingAuto[0] = strTempbookingAuto[0];
                    }
                    else if(strTempbookingAuto[0].length() == 2){                            
                        if(strTempbookingAuto[0].startsWith('0')){
                            strTempbookingAuto[0] = strTempbookingAuto[0].remove(strTempbookingAuto[0].left(1));
                        }
                        else{
                            strTempbookingAuto[0] = strTempbookingAuto[0];
                        }
                    }
                        
                    if(strTempbookingAuto[1].length() == 1){
                        strTempbookingAuto[1] = strTempbookingAuto[1];
                    }
                    else if(strTempbookingAuto[1].length() == 2){                            
                        if(strTempbookingAuto[1].startsWith('0')){
                            strTempbookingAuto[1] = strTempbookingAuto[1].remove(strTempbookingAuto[1].left(1));
                        }
                        else{
                            strTempbookingAuto[1] = strTempbookingAuto[1];
                        }
                    }
                    
                    ddmmyyDateFAuto = strTempbookingAuto[0] + '-' + strTempbookingAuto[1] + '-' + strTempbookingAuto[2];
                }
                                                   
                bookingStik = f.split(',')[3];                
                if(bookingStik.contains('/')){
                    strTempbookingStik = bookingStik.split('/'); ///
                }else if(bookingStik.contains('-')){
                    strTempbookingStik = bookingStik.split('-');
                }
                
                if(strTempbookingStik.size() == 3)
                {                         
                    if(strTempbookingStik[0].length() == 1){
                        strTempbookingStik[0] = strTempbookingStik[0];
                    }
                    else if(strTempbookingStik[0].length() == 2){                            
                        if(strTempbookingStik[0].startsWith('0')){
                            strTempbookingStik[0] = strTempbookingStik[0].remove(strTempbookingStik[0].left(1));
                        }
                        else{
                            strTempbookingStik[0] = strTempbookingStik[0];
                        }
                    }
                        
                    if(strTempbookingStik[1].length() == 1){
                        strTempbookingStik[1] = strTempbookingStik[1];
                    }
                    else if(strTempbookingStik[1].length() == 2){                            
                        if(strTempbookingStik[1].startsWith('0')){
                            strTempbookingStik[1] = strTempbookingStik[1].remove(strTempbookingStik[1].left(1));
                        }
                        else{
                            strTempbookingStik[1] = strTempbookingStik[1];
                        }
                    }
                    
                    ddmmyyDateFStik = strTempbookingStik[0] + '-' + strTempbookingStik[1] + '-' + strTempbookingStik[2];
                }
                                
                bookingFiber = f.split(',')[4];               
                if(bookingFiber.contains('/')){
                    strTempbookingFiber = bookingFiber.split('/'); ///
                }else if(bookingFiber.contains('-')){
                    strTempbookingFiber = bookingFiber.split('-');
                }
                
                if(strTempbookingFiber.size() == 3)
                {                         
                    if(strTempbookingFiber[0].length() == 1){
                        strTempbookingFiber[0] = strTempbookingFiber[0];
                    }
                    else if(strTempbookingFiber[0].length() == 2){                            
                        if(strTempbookingFiber[0].startsWith('0')){
                            strTempbookingFiber[0] = strTempbookingFiber[0].remove(strTempbookingFiber[0].left(1));
                        }
                        else{
                            strTempbookingFiber[0] = strTempbookingFiber[0];
                        }
                    }
                        
                    if(strTempbookingFiber[1].length() == 1){
                        strTempbookingFiber[1] = strTempbookingFiber[1];
                    }
                    else if(strTempbookingFiber[1].length() == 2){                            
                        if(strTempbookingFiber[1].startsWith('0')){
                            strTempbookingFiber[1] = strTempbookingFiber[1].remove(strTempbookingFiber[1].left(1));
                        }
                        else{
                            strTempbookingFiber[1] = strTempbookingFiber[1];
                        }
                    }
                    
                    ddmmyyDateFFiber = strTempbookingFiber[0] + '-' + strTempbookingFiber[1] + '-' + strTempbookingFiber[2];
                }

                
                break;
            }
        }
        showBookingInfo = true;
    }
    
    // Show vagtInfo section on the YO home page
    public void showVagtInfo()
    {
        getSectionData('Vagt Info');
        isAdmin = YOSpocUtils.isYOAdmin(UserInfo.getUserId());
      /*  // Added the below code as we are allowing access through permission set as well
          Set<Id> usersWithPermissionSet = new Set<Id>();
          for(PermissionSetAssignment p : [Select p.SystemModstamp, p.PermissionSetId, p.Id, p.AssigneeId From PermissionSetAssignment p where p.PermissionSetId IN (Select p.Id From PermissionSet p where p.Name='KnowledgeBase_AdminRights')])
           {
                    usersWithPermissionSet.add(p.AssigneeId);
                    System.debug('AssigneeId***'+p.AssigneeId);
          }
           if(usersWithPermissionSet.contains(UserInfo.getUserId())){
                isAdmin = true;
           }  */
        showVagtInfo = true;
    }
    
    // Show yotdsInfo on the YO Home Page
    public void showYotdsInfo()
    {
        getSectionData('YOTDS Info');
        isAdmin = YOSpocUtils.isYOAdmin(UserInfo.getUserId());
         System.debug('isAdmin -->'+isAdmin );
     /*   // Added the below code as we are allowing access through permission set as well
          Set<Id> usersWithPermissionSet = new Set<Id>();
          for(PermissionSetAssignment p : [Select p.SystemModstamp, p.PermissionSetId, p.Id, p.AssigneeId From PermissionSetAssignment p where p.PermissionSetId IN (Select p.Id From PermissionSet p where p.Name='KnowledgeBase_AdminRights')])
           {
                    usersWithPermissionSet.add(p.AssigneeId);
                    System.debug('AssigneeId***'+p.AssigneeId);
          }
           if(usersWithPermissionSet.contains(UserInfo.getUserId())){
                isAdmin = true;
           }  */
        showYOTDS = true;
    }
    
    // get section data for vagt and yotds
    public void getSectionData(String section)
    {
        YOHomePage__c yoHomePage = YOHomePage__c.getInstance(section);
        YO_OppConsult_View__c yoOppConsultView = YO_OppConsult_View__c.getInstance(section);
        System.debug('View Id'+yoOppConsultView.ViewId__c);
        
        List<YO_OperationConsultant__c> listInfo = [select oc.Id,oc.User__c, oc.onDuty__c, oc.Information__c 
                                                        from YO_OperationConsultant__c oc 
                                                        where oc.onDuty__c = true 
                                                        and RecordTypeId =: yoHomePage.RecordTypeId__c];
        yoHomePage = YOHomePage__c.getInstance(section + ' Text');
        List<YO_OperationConsultant__c> listTextInfo = [select Id, YK_Info_Text__c, YOTDS_Info_Text__c 
                                                    from YO_OperationConsultant__c oc 
                                                    where RecordTypeId =: yoHomePage.RecordTypeId__c];  
        if(!listInfo.isEmpty())
        {
          //  sectionInfoId = listInfo[0].Id;
            sectionInfoId = '/' + operationConsultantKeyPrefix + '?fcf='+yoOppConsultView.ViewId__c; 
            sectionInfo = listInfo[0].Information__c;
            if(section == 'Vagt Info'){
                sectionTextInfoId = listTextInfo[0].Id;
                sectionTextInfo = listTextInfo[0].YK_Info_Text__c;
            }else if(section == 'YOTDS Info'){
                sectionTextInfoId = listTextInfo[0].Id;
                sectionTextInfo = listTextInfo[0].YOTDS_Info_Text__c;
            }    
            userData = [Select u.SmallPhotoUrl, u.Phone, u.Name, u.Email 
                            From User u 
                            where u.id = :listInfo[0].User__c limit 1]; 
        }                                                   
    }
}