public class DealerwebInformationController{
    
    public String pageHeaderValue{get;set;}
    public User loggedInUser {get;set;}
    public string newpwd {get;set;}
    public string confirmpwd {get;set;}
    public boolean changePwdSection {get;set;}
    public boolean pwdChangeMsg {get;set;}
    public boolean showPageBlock {get;set;}
    public boolean showTable {get;set;}
    public boolean showNoRecordsMessage {get;set;}
    public String fromDate {get;set;}
    public String toDate {get;set;}
    public string confirmMsg {get;set;}
    public commonClass objCommon {get;set;}    
    public string productType {get; set;}
    public List<String> forhInfoIds {get; set;}
    public Map<String,String> forhIdNameMap {get;set;}
    public Map<Id,List<ForhandlerInformations__c>> forhIdToOppsMap {get; set;}
    public Map<Id,String> forhDescription {get; set;}
    public string subGroupDescription {get; set;}
    public string selectedDocType {get; set;}
    //The code below is used to show a popup to remind the dealler about ordered dealer goods.
    public String dealerGoods{get;set;}
    public Integer defectAndMissingHardware{get;set;}
    public String defectAndMissingHardwareSerialNumbers{get;set;}
    public List<Document> recieptList{get;set;}
    public String SearchDocumentText{get;set;}
    public  string maintenanceFlag{get;set;}//DW-881
    public boolean showMsg{get;set;}//DW-881
    public boolean formRender{get;set;}//DW-881
    //   custom setting to fetch details about Dealer Web conference 
    public DWConferenceCustomSetting__c youseeConferenceRecords{get;set;}
    
    public void changePassword()
    {
        try
        {
            pwdChangeMsg = true;
            System.setPassword(loggedInUser.Id, newpwd);
            changePwdSection = false;
            confirmMsg = 'Success';
        }
        catch(Exception ex)
        {
            confirmMsg = 'Failed';
            newpwd = null;
        }
    }
    
    public void pwdChangeAction()
    {
        changePwdSection = true;
        pwdChangeMsg = false;
        newpwd=null;
    }
    
    public Map<String, String> accountMap{get;set;}
    
    public DealerwebInformationController(){
        try{
            showMsg=false;
            if(DealerWeb_Custom_Setting__c.getInstance('DW_Login_Access').Value__c=='True')
            {
                showMsg=true;
                formRender=false;
                maintenanceFlag=DealerWeb_Custom_Setting__c.getInstance('Maintenance message').Value__c;
            }
            else
            {
                 showMsg=false;
                formRender=true;
            }
            showPageBlock = true;
            showTable = false;
            showNoRecordsMessage = false;
            youseeConferenceRecords = DWConferenceCustomSetting__c.getInstance('youseeConferenceRecords');
            buildForhList();
            getProductDescription();
            pageHeaderValue = ApexPages.CurrentPage().getParameters().get('pageType');
            System.debug('pageHeaderValue--->'+pageHeaderValue);
            loggedInUser = [select Username from User where name= :Userinfo.getname() and id = :Userinfo.getUserId()];
            objCommon = new commonClass();
            if(pageHeaderValue == null){
                pageHeaderValue = 'Front Page';
            } else if('HelpSupport'.equals(pageHeaderValue)){
                pageHeaderValue = 'Hjælp og support';
            }else if('BlacklistedCustomers'.equals(pageHeaderValue)){
                pageHeaderValue = 'Spærrede kunder';
            }else if('NyttigInfo'.equals('NyttigInfo')){
                pageHeaderValue = 'Nyttig info';    
            }    
            if('Hjælp og support'.equals(pageHeaderValue)){
               buildForhList(); 
            }else{
               getInformation();
            }
            system.debug('###'+objCommon.dealerAccount.Dealer_Number__c);
            
            // get ordered dealer goods information.
            dealerGoodsCheck();
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Der er sket en teknisk fejl. Kontakt din administrator'));
        }
    }
    
    public PageReference redirectTOVaremodtagelsePage(){
        system.debug('redirectTOVaremodtagelse is called ');
        //PageReference pageRef = Page.VaremodtagelsePage;
        Pagereference pageRef = new Pagereference('/apex/VaremodtagelsePage');
        pageRef.setRedirect(false);
        return pageRef;
    }

    public PageReference backToHomePage(){ 
        String newPageUrl ='/apex/forhandlerHomePage';
        PageReference newPage = new PageReference(newPageUrl);
        newPage.setRedirect(true);
        return newPage;
    } 

    public Account account{get;set;}

    public List<ForhandlerInformations__c> getInformation(){
            
            List<ForhandlerInformations__c> informationList = [Select info.Description__c, info.EndDate__c, info.Group_Information__c, info.Dealer__r.Name, info.SubGroup_Information__c From ForhandlerInformations__c info where info.Page_Type__c =: pageHeaderValue order by Sequence_Number__c];
            Contact contact = [select accountId from Contact where id in (select contactid from User where id =:UserInfo.getUserId()) limit 1];                
            Account account = [select a.DealerGroup__c, a.DealerProducts__c, a.Name from Account a where id =: contact.accountId  limit 1];                
          //  String [] dealerProducts = account.DealerProducts__c.split(';');
            String [] dealerProducts;            
            //if(account.selectedProduct__c != null) {
              //  dealerProducts = account.selectedProduct__c.split(',');
            if(account.DealerProducts__c != null) {
                dealerProducts = account.DealerProducts__c.split(';');
            }    
            
            String [] dealerGroups = account.DealerGroup__c.split(';');
            accountMap = new Map<String, String> ();
            for(String delaerProduct :dealerProducts){
                if(delaerProduct == 'YouSee Ekstrakanaler'){
                    accountMap.put('Ekstrakanaler' , 'Ekstrakanaler' );
                }else{
                    accountMap.put(delaerProduct.trim() , delaerProduct.trim() );
                }
            }
            for(String dealerGroup : dealerGroups){
                accountMap.put(dealerGroup , dealerGroup);
            }
            List<ForhandlerInformations__c> filteredInformationList = new List<ForhandlerInformations__c>(); 
            Date todayDate = date.today();
            integer days;
                  for(ForhandlerInformations__c info : informationList) {
                     
                     if(info.EndDate__c != null){ 
                         days = todayDate.daysBetween(info.EndDate__c);
                     }    
                     
                     if((info.EndDate__c == null) ||  (info.EndDate__c != null && days > 0)) {
                           if('Produkt information'.equals(info.Group_Information__c) || 'Information til forhandlergruppe'.equals(info.Group_Information__c) ){   
                               if(accountMap.containsKey(info.SubGroup_Information__c)){
                                          filteredInformationList.add(info); 
                           }
                       } else if('Individuel information til forhandler'.equals(info.Group_Information__c)){ 
                            if((objCommon.dealerAccount.name).equals(info.Dealer__r.Name)) { 
                                filteredInformationList.add(info); 
                            }        
                       }
                       else if('General Information'.equals(info.Group_Information__c)){
                            filteredInformationList.add(info); 
                       }    
                     }                             
                  }     
                
                 system.debug('@@'+filteredInformationList); 
            return filteredInformationList;        
     }
     
     public void buildForhList(){
        //Instantiate variables
        forhInfoIds = new List<String>();
        //forhIdNameMap = new Map<String,String>();
        forhDescription = new Map<Id,String>();
        forhIdToOppsMap = new Map<Id,List<ForhandlerInformations__c>>();
        
        List<ForhandlerInformations__c> fors = [Select info.Id, info.Description__c, info.Group_Information__c, info.SubGroup_Information__c From ForhandlerInformations__c info where info.Page_Type__c ='Hjælp og support' 
            and info.Group_Information__c = 'Produkt Tab Information' order by Sequence_Number__c];
 
        for(ForhandlerInformations__c forh : fors){
            
            if('YouSee Telefoni'.equals(forh.SubGroup_Information__c)){
                forh.SubGroup_Information__c = 'Telefoni';
                
            }
            if('YouSee Bredbånd'.equals(forh.SubGroup_Information__c)){
                forh.SubGroup_Information__c = 'Bredbånd';
                
            }
            if('YouSee Plus'.equals(forh.subGroup_Information__c)){
                forh.SubGroup_Information__c = 'Digitalt kabel-tv';
            }
            //forhIdNameMap.put(forh.Id,forh.SubGroup_Information__c); 
            
            forhDescription.put(forh.Id,forh.Description__c);
            
            if(forhIdToOppsMap.get(forh.Id) == null){
                forhIdToOppsMap.put(forh.Id, new List<ForhandlerInformations__c>());   
                forhInfoIds.add(forh.SubGroup_Information__c); 
                System.debug('---SubGroup Information---'+forhInfoIds);           
            }
 
            forhIdToOppsMap.get(forh.Id).add(forh);
        } 
    }
     
     public PageReference getProductDescription(){
        productType = ApexPages.CurrentPage().getParameters().get('groupInfo');
        system.debug('productType ***** ' +productType);
        List<ForhandlerInformations__c> subGroupInfo = new List<ForhandlerInformations__c>();
        subGroupInfo = [Select m.Name, m.Id, m.Dealer__c, m.Description__c, m.Group_Information__c, m.Page_Type__c, m.SubGroup_Information__c
          From ForhandlerInformations__c m where Page_Type__c =: 'Hjælp og support' order by m.Name];         
        for(ForhandlerInformations__c groupInfo : subGroupInfo){
            System.debug('<---SubGroup Informations---> '+groupInfo.SubGroup_Information__c + ' ** productType: '+productType);
            if('YouSee Telefoni'.equals(groupInfo.SubGroup_Information__c)){
                groupInfo.SubGroup_Information__c = 'Telefoni';
            }
            if('YouSee Bredbånd'.equals(groupInfo.SubGroup_Information__c)){
                groupInfo.SubGroup_Information__c = 'Bredbånd';
            }
            if('YouSee Plus'.equals(groupInfo.SubGroup_Information__c)){
                groupInfo.SubGroup_Information__c = 'Digitalt kabel-tv';
            }            
            if(productType == groupInfo.SubGroup_Information__c){
                subGroupDescription = groupInfo.Description__c;
                System.debug('*** Sub Group Description***'+subGroupDescription);
                break;
            }else{
                if(groupInfo.SubGroup_Information__c.equals('YouSee Clear')){
                    subGroupDescription = groupInfo.Description__c;                     
                }
            }
        }
        if(productType == 'Kvitteringsarkiv'){
            recieptList = new List<Document>();
            showPageBlock = false;
            showTable = false;
            showNoRecordsMessage = false;
            SearchDocumentText = '';
            fromDate = '';
            toDate = '';
            
        }else{
            showPageBlock = true;            
        }
        return null;
    }
    
  //The method below is used to show a popup to remind the dealler about ordered dealer goods.  
    private void  dealerGoodsCheck(){
            DealerGoodsReceiptController dealerGoodsReceiptController = new DealerGoodsReceiptController();
            dealerGoodsReceiptController.callOutDealerGoods();
            dealerGoods = dealerGoodsReceiptController.dealerGoods;
            String jsonStr = dealerGoodsReceiptController.defectAndMissingHardware;
            System.debug('dealerGoods in DealerWebInformationController are  :-> '+dealerGoods);
            defectAndMissingHardware = 0;
            defectAndMissingHardwareSerialNumbers ='';
            //String jsonStr = '[{"Defective":[],"Missing":["838303341113"]},{"Defective":["838303365559"],"Missing":[]}]';
            List<String> myList = jsonStr.split('"');
            List<string> myNewList = new List<string>();
            Integer i = 0;
            boolean dandfflag = true;
            for(i=0;i<myList.size();i++){
                try{                    
                    long.valueOf(myList[i]);
                    myNewList.add( myList[i]);
                    if(dandfflag){
                        defectAndMissingHardwareSerialNumbers = '"';
                    }
                    defectAndMissingHardwareSerialNumbers = defectAndMissingHardwareSerialNumbers +myList[i]+'s';
                    dandfflag = false;
                }catch(Exception e){
                }
            }
            defectAndMissingHardware = myNewList.size();
            if(defectAndMissingHardware > 0){
                defectAndMissingHardwareSerialNumbers = defectAndMissingHardwareSerialNumbers.substring(0,defectAndMissingHardwareSerialNumbers.lastIndexOf('s'));
                defectAndMissingHardwareSerialNumbers = defectAndMissingHardwareSerialNumbers +'"'; 
            }else{
                defectAndMissingHardwareSerialNumbers = '"nope"';
            }
            system.debug('defectAndMissingHardware size is -->'+ myNewList.size());
            system.debug('defectAndMissingHardwareSerialNumbers --->'+defectAndMissingHardwareSerialNumbers);
    }
    
    public PageReference searchAllReciepts(){
        system.debug('start');
        datetime fDate;
        datetime tDate;
        if(fromdate.length()!= 0){
            String[] fromDateArray = fromdate.split('\\.');
            Integer d =  Integer.valueOf(fromDateArray[0]);
            Integer m = Integer.valueOf(fromDateArray[1]);
            Integer y = Integer.valueOf(fromDateArray[2]);
            fDate = datetime.newInstance(y, m, d);
        }
        if(toDate.length()!=0){
            String[] toDateArray = toDate.split('\\.');
            Integer d = Integer.valueOf(toDateArray[0]);
            Integer m = Integer.valueOf(toDateArray[1]);
            Integer y = Integer.valueOf(toDateArray[2]);
            tDate = datetime.newInstance(y, m, d);
        }
        showTable = false;
        showNoRecordsMessage = false;
        //recieptList = [Select id, CreatedDate, Name from Document where CreatedDate >=: fDate and CreatedDate <=: tDate];
        String searchText = '';
        if(SearchDocumentText!= null && SearchDocumentText!=''){
            searchText = SearchDocumentText.Trim();
        }
        system.debug('searchText------------------------>'+searchText);
        system.debug('fdate ----> ' +fDate);
        system.debug('tDate ----> ' +tDate);
        
        
        if(fDate!=null && tDate!=null && searchText.length()> 1){
            List<List<Document>> searchList = [FIND :searchText IN ALL FIELDS RETURNING Document(Id, CreatedDate)];
            recieptList = [Select Name, CreatedById, CreatedDate from Document where (CreatedDate >=: fDate AND CreatedDate <=: tDate + 1) AND (CreatedById =: UserInfo.getUserId()) AND Id IN: searchList[0]];
            if(recieptList.size()>0){
                showTable = true;
                
            }else{
                showNoRecordsMessage = true;
            }
        }else if(fDate!=null && tDate!=null){
            system.debug('I am in Date condition loop------------------->>>>>>>>>>>');
            recieptList = [Select Name, CreatedById, CreatedDate from Document where (CreatedDate >=: fDate AND CreatedDate <=: tDate + 1) AND (CreatedById =: UserInfo.getUserId()) order by CreatedDate];  
            if(recieptList.size()>0){
                showTable = true;
               
            }else{
                showNoRecordsMessage = true;
            }
        }else if(searchText.length()> 1){
            List<List<Document>> searchList = [FIND :searchText IN ALL FIELDS RETURNING Document(Id, CreatedDate)];
            recieptList = [Select Name, CreatedById, CreatedDate from Document where (CreatedById =: UserInfo.getUserId()) AND Id IN: searchList[0]];
            if(recieptList.size()>0){
                showTable = true;
                
            }else{
                showNoRecordsMessage = true;
            }           
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Invalid Input'));
        }
        
        
        //System.debug('size: ' +recieptList.size());
        return null;
    }
}