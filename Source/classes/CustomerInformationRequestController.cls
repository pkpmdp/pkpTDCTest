public with sharing class CustomerInformationRequestController {    
    public ITemplates beforeSaleTemplates; 
    public ITemplates afterSaleTemplates;
    public ITemplates campainTemplates;
    public Customer_Information_Request__c customerInformationRequest{get;set;}
    public Map<String,Mail_Mapping__c> mapIdMailMapping;
    public List<Mail_Mapping__c> mailMapping; 
    public String actimoURL{get; set;}
    public String baseURL;
    public String customerNumber;
    public final String KEY = '9a77cbb3-dfc1-47a9-93af-8ac75587210d';
    
    public static String BEFORE_SALE = 'Before Sale'; 
    public static String AFTER_SALE = 'After Sale'; 
    public static String CAMPAIN = 'Campagne'; 
    public static String INTEGRATEERRORMSG = System.Label.CL_INTEGRATEERRORMSG;
    //'Your chosen value doesn\'t exist anymore in Mail Mapping. Please refresh the page :';
    public static String VALIDATIONTEMPLATEERRMSG =  System.Label.CL_VALIDATIONTEMPLATEERRMSG;
    //'At least one template must be checked!';
    public static String VALIDATIONTEMPLATEERREDITMSG =  System.Label.CL_VALIDATIONTEMPLATEERREDITMSG;
    //'Only one template must be checked!';
    public static Map <String,String> groupNameRecordType = new Map<String, String>{
            'Editable Information Request' => 'YK', 
            'Editable Information Request YO' => 'YO',
            'Read Only Information Request' => 'YK'         
        };

    public class IntegrateException extends Exception {}    
    public class ValidationException extends Exception {}
    public String isConsole{get;set;}                
    public interface ITemplates {
        List<SelectOption> getItems();
        String[] getTemplates(); 
        void setTemplates(String[] templates);
        void setMailMapping(List<Mail_Mapping__c> mailMapping);
        Boolean getRender(); 
    }
    
    public virtual  class Templates implements ITemplates{
        List<String> templates = new List<String>();
        public List<Mail_Mapping__c> mailMapping;
        public List<SelectOption> options;
        public virtual List<SelectOption>  getItems (String groupName ){
            List<SelectOption> options = new List<SelectOption>();
            mailMapping.sort();                
            for(Integer i=0; i<mailMapping.size() ; i++) {              
                if (groupName == ((Mail_Mapping__c)mailMapping[i]).Group_Name__c){
                    /*
                    options.add(new SelectOption(((Mail_Mapping__c)mailMapping[i]).Id,
                        ((Mail_Mapping__c)mailMapping[i]).Picklist_Name__c ));
                    */
                    Mail_Mapping__c mailMap = (Mail_Mapping__c)mailMapping[i];
                    SelectOption opt = new SelectOption(mailMap.Id,
                        getOptionValueAsLink(mailMap.Web_Link__c ,mailMap.Picklist_Name__c));
                    System.debug('****Wen debug'+mailMap.Id+mailMap.Picklist_Name__c);                        
                    opt.setEscapeItem(false);
                    options.add(opt);
                    
                    /*
                    if (((Mail_Mapping__c)mailMapping[i]).Default__c==true){
                        templates.add(((Mail_Mapping__c)mailMapping[i]).Id);                    
                    }
                    */
                }
            }           
            return options;         
        }
        
        public virtual Boolean getRender(){
            return (options!=null && options.size()> 0);
        } 
        
        public virtual List<SelectOption> getItems(){         
            return options;
        }
        
        public virtual void setTemplates(String[] templates){
            this.templates = templates;
        }
    
        public virtual String[] getTemplates(){
            return templates;
        } 
        public virtual void setMailMapping(List<Mail_Mapping__c> mailMapping){
            this.mailMapping = mailMapping;
        }
        
        public virtual String getOptionValueAsLink(String link, String name ){
            return getStartAnchor(link) + name + getEndAnchor();
        }
        
        protected virtual String getStartAnchor(String link){
            return '<a href="'+ link + '" target="_blank">';
        }
        protected virtual String getEndAnchor(){
            return '</a>';
        }
        
    }
    
    public virtual  class NewTemplates extends Templates{
        public NewTemplates( String groupName, List<Mail_Mapping__c> mailMapping ){
            setMailMapping(mailMapping);
            options = getItems(groupName);
        }
    }
    
    public virtual  class EditTemplates extends Templates{
        public Customer_Information_Request__c customerInformationRequest{get;set;}
        public EditTemplates( String groupName, List<Mail_Mapping__c> mailMapping,
            Customer_Information_Request__c customerInformationRequest ){
            this.customerInformationRequest = customerInformationRequest;
            setMailMapping(mailMapping);
            options = getItems(groupName);
        }
        
        public override List<SelectOption>  getItems (String groupName ){
            if (customerInformationRequest.Group_Template__c!=null && 
                customerInformationRequest.Group_Template__c!= ''){
                templates.add(customerInformationRequest.Mail_Mapping__c);
            }
            List<SelectOption> options = new List<SelectOption>();
            mailMapping.sort();            
            for(Integer i=0; i<mailMapping.size() ; i++) {              
                if (groupName == ((Mail_Mapping__c)mailMapping[i]).Group_Name__c){
                    /*
                    options.add(new SelectOption(((Mail_Mapping__c)mailMapping[i]).Id,
                        ((Mail_Mapping__c)mailMapping[i]).Picklist_Name__c));
                    */
                    Mail_Mapping__c mailMap = (Mail_Mapping__c)mailMapping[i];
                    SelectOption opt = new SelectOption(mailMap.Id,
                        getOptionValueAsLink(mailMap.Web_Link__c ,mailMap.Picklist_Name__c));
                    opt.setEscapeItem(false);
                    options.add(opt);
                }
            }            
            return options;         
        }       
    }
        
    public CustomerInformationRequestController(ApexPages.StandardController controller) {
        isConsole = ApexPages.currentPage().getParameters().get('isdtp');
        system.debug('****Wen debug isConsole'+isConsole);
        customerInformationRequest = (Customer_Information_Request__c) controller.getRecord();
        generateURL(customerInformationRequest);
        mailMapping = getMailMapping();
        mailMapping.sort();        
        this.mapIdMailMapping = new Map<String,Mail_Mapping__c>();      
        for(Integer i=0; i<mailMapping.size() ; i++) {  
            this.mapIdMailMapping.put(((Mail_Mapping__c)mailMapping[i]).Id, mailMapping[i]);
        } 
        if(ApexPages.currentPage().getUrl().toLowerCase().contains(
            Page.CustomerInformationRequestEdit.getUrl())){
            //'customerinformationrequestedit')){           
            this.beforeSaleTemplates = new  EditTemplates(BEFORE_SALE,mailMapping,
                customerInformationRequest);
            this.afterSaleTemplates = new EditTemplates(AFTER_SALE,mailMapping,
                customerInformationRequest);
            this.campainTemplates = new EditTemplates(CAMPAIN,mailMapping,
                customerInformationRequest);
        }else{
            customerInformationRequest.Email__c = getPersonEmail(customerInformationRequest.Account__c);
            this.beforeSaleTemplates = new  NewTemplates(BEFORE_SALE,mailMapping);
            this.afterSaleTemplates = new NewTemplates(AFTER_SALE,mailMapping);
            this.campainTemplates = new NewTemplates(CAMPAIN,mailMapping);
        }
    }
    
    public void generateURL(Customer_Information_Request__c customerInformationRequest)
     {
          Account acc = new Account();
         
          acc = [Select Customer_No__c, Name, PersonMobilePhone, PersonEmail from Account where Id=:customerInformationRequest.Account__c];
         
          baseURL = Actimo_CS__c.getInstance('Actimo_Base_URL').Value__c;          
         
          actimoURL = baseURL;
          actimoURL+= '?api-key='+KEY;
          actimoURL+= '&emailenabled=1';
          actimoURL+= '&emailrequired=0';
          actimoURL+= '&name='+acc.Name;
          if(acc.PersonEmail != null)
              actimoURL+= '&email='+acc.PersonEmail;
          if(acc.PersonMobilePhone != null)
              actimoURL+= '&phonenumber='+acc.PersonMobilePhone;
          actimoURL+= '&sendmore=1';         
     }
        
    /* public String getCustomer(String accountId)
     {
         Account acc = new Account();
         
         return [Select Customer_No__c,Name from Account where Id=:accountId].Customer_No__c;
     }*/
    public String getMID(String accountId)
     {
         
         return [Select Owner.MID__c from Account where Id=:accountId].Owner.MID__c;

     }
    
    public String getPersonEmail(String accountId){
        return [Select PersonEmail from Account where Id=:accountId].PersonEmail;
    }
    
    public List<Mail_Mapping__c> getMailMapping(){
        Schema.DescribeSObjectResult oSObjectResult = Customer_Information_Request__c.SObjectType.getDescribe();
        String recordTypeName;
        String recordTypeId;
        for(Schema.RecordTypeInfo rtInfo : oSObjectResult.getRecordTypeInfos()){
            if (rtInfo.isDefaultRecordTypeMapping()){
                recordTypeId=rtInfo.getRecordTypeId();
                break;  
            }           
        }
        recordTypeName = ((RecordType)[Select Name From RecordType Where Id =: recordTypeId]).Name;     
        return [Select Id, Default__c ,Group_Name__c, Mail_Mapping_External_Id__c,
                Picklist_Name__c , Technical_Mapping_Name__c , Template_Group__c,Web_Link__c
                From Mail_Mapping__c where Template_Group__c =:(String)groupNameRecordType.get(recordTypeName) Order By Picklist_Name__c]; 
    }
        
    public ITemplates getBeforeSaleTemplates (){
        return beforeSaleTemplates;
    }
    
    public ITemplates getAfterSaleTemplates (){
        return afterSaleTemplates;
    }
    
    public ITemplates getCampainTemplates (){
        return campainTemplates;
    }
    
    
    public boolean mailMappingValueExist(List<Mail_Mapping__c> mapping,String groupName, String Id ){
        for(Integer j=0; j<mapping.size() ; j++) {
            if (((Mail_Mapping__c)mailMapping[j]).Group_Name__c == groupName 
            && ((Mail_Mapping__c)mailMapping[j]).Id == Id){
                return true;
            }           
        }
        return false;
    }
    
    public void checkValuesNew(){
        if ( beforeSaleTemplates.getTemplates().size()==0 && afterSaleTemplates.getTemplates().size()==0 
        && campainTemplates.getTemplates().size()==0){
            ApexPages.addMessages(new ValidationException(VALIDATIONTEMPLATEERRMSG));           
            return; 
        }
        checkMailMappingIntegration();
    }
        
    public void checkValuesEdit(){
        if ((beforeSaleTemplates.getTemplates().size() + afterSaleTemplates.getTemplates().size() + 
         campainTemplates.getTemplates().size())!=1){
            ApexPages.addMessages(new ValidationException(VALIDATIONTEMPLATEERREDITMSG));           
            return; 
        }
        checkMailMappingIntegration();
    }
    
    public void checkMailMappingIntegration(){      
        List<Mail_Mapping__c> mapping = getMailMapping();
        for(Integer i=0; i<beforeSaleTemplates.getTemplates().size() ; i++) {
            if (!mailMappingValueExist(mapping,BEFORE_SALE, beforeSaleTemplates.getTemplates()[i])){
                ApexPages.addMessages(new IntegrateException(INTEGRATEERRORMSG + beforeSaleTemplates.getTemplates()[i]));
                return; 
            }       
        }
        for(Integer i=0; i<afterSaleTemplates.getTemplates().size() ; i++) {
            if (!mailMappingValueExist(mapping,AFTER_SALE, afterSaleTemplates.getTemplates()[i])){
                ApexPages.addMessages(new IntegrateException(INTEGRATEERRORMSG+ afterSaleTemplates.getTemplates()[i]));
                return;  
            }       
        }
        for(Integer i=0; i<campainTemplates.getTemplates().size() ; i++) {
            if (!mailMappingValueExist(mapping,CAMPAIN, campainTemplates.getTemplates()[i])){
                ApexPages.addMessages(new IntegrateException(INTEGRATEERRORMSG+ campainTemplates.getTemplates()[i]));
                return;  
            }       
        }
    }
    public Customer_Information_Request__c insertOne(String mailMappingId){
        Customer_Information_Request__c cir = new Customer_Information_Request__c(); 
        cir.Account__c= customerInformationRequest.Account__c;
        cir.Date_Requested__c = DateTime.now();
        cir.Email__c = customerInformationRequest.Email__c;
        cir.Send__c = true;
        cir.Group_Template__c =((Mail_Mapping__c)mapIdMailMapping.get(mailMappingId)).Picklist_Name__c;
        cir.Mail_Mapping__c =  mailMappingId;
        insert cir;
        return cir;
    }
    
    public Customer_Information_Request__c updateCir(){
        String mailMappingId = beforeSaleTemplates.getTemplates().size()==0? 
            (afterSaleTemplates.getTemplates().size()==0? 
                campainTemplates.getTemplates()[0]: afterSaleTemplates.getTemplates()[0])
            :beforeSaleTemplates.getTemplates()[0];
        customerInformationRequest.Date_Requested__c = DateTime.now();
        customerInformationRequest.Group_Template__c =((Mail_Mapping__c)mapIdMailMapping.get(mailMappingId)).Picklist_Name__c;
        customerInformationRequest.Mail_Mapping__c =  mailMappingId;
        update customerInformationRequest;
        return customerInformationRequest;
    }
       
    public void insertAll(){
        Set <String> defaultIds = new Set<String>();
        String id;              
        for(Integer i=0; i<beforeSaleTemplates.getTemplates().size() ; i++) {
             id = beforeSaleTemplates.getTemplates()[i];
             insertOne(id); 
             defaultIds.add(id);    
        }
        for(Integer i=0; i<afterSaleTemplates.getTemplates().size() ; i++) {
             id = afterSaleTemplates.getTemplates()[i];
             insertOne(id);
             defaultIds.add(id);        
        }
        for(Integer i=0; i<campainTemplates.getTemplates().size() ; i++) {
            id = campainTemplates.getTemplates()[i];
            insertOne(id);
            defaultIds.add(id);                     
        }
        //setDefaultTemplate(defaultIds);
    }
    
    public void setDefaultTemplate(Set <String> Ids){
        for(Mail_Mapping__c   mail : mailMapping){
            mail.Default__c = false;
            if (Ids.contains(mail.id)){
                mail.Default__c = true;
            } 
        } 
        update mailMapping;
    }
        
    public PageReference save() {
        checkValuesNew();
        if (ApexPages.getMessages().size()>0) return null;
        insertAll();
        return backToAccount();     
    }
    
    public PageReference saveAndNew() {
        checkValuesNew();
        if (ApexPages.getMessages().size()>0) return null;
        insertAll();
        return ApexPages.currentPage();     
    }
    
    public PageReference updateOne() {
        checkValuesEdit();
        if (ApexPages.getMessages().size()>0) return null;
        updateCir();
        return backToAccount();     
    }
    
    public PageReference backToAccount(){
        if(isConsole != null && 'vw'.equals(isConsole)){          
            //PageReference pageRef = new PageReference('/apex/ConsoleSendTab?id=' + customerInformationRequest.Account__c);
            PageReference pageRef = new PageReference('/'+customerInformationRequest.Account__c);
            system.debug('***Wen debug inside isconsole if'+pageRef);
            return pageRef.setRedirect(true);
        }               
        PageReference parentPage = new PageReference('/'+customerInformationRequest.Account__c);
        parentPage.setRedirect(true);
        return parentPage;
     }
   
    public PageReference cancel() {                 
        return backToAccount();      
    }
    
    
    static testMethod void testNewInfoRequestNew(){
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        // add.House_No__c = 1;
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;
        
        Account acc = new Account();
        acc.Name = 'Test Account 1';
        acc.Street_YK__c = add.Id;
        acc.Customer_No__c = '5436789';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        insert acc;
        
        Mail_Mapping__c m = new Mail_Mapping__c();
        m.Picklist_Name__c = 'Test 1';
        m.Technical_Mapping_Name__c = 'Test1';
        m.Web_Link__c = 'http://ecm.yousee.dk/?sc_itemid={11EC5787-88C0-4E71-89BD-5B21CD147DA8}';
        m.Template_Group__c = 'YK';
        m.Group_Name__c = BEFORE_SALE;
        m.Default__c = true; 
        insert m;
        
        Mail_Mapping__c ma = new Mail_Mapping__c();
        ma.Picklist_Name__c = 'Test 2';
        ma.Technical_Mapping_Name__c = 'Test2';
        ma.Web_Link__c = 'http://ecm.yousee.dk/?sc_itemid={507CAACA-7BD7-452B-A59D-EE538597017C}';
        ma.Template_Group__c = 'YK';
        ma.Group_Name__c = AFTER_SALE;
        ma.Default__c = true; 
        insert ma;
        
        Mail_Mapping__c mb = new Mail_Mapping__c();
        mb.Picklist_Name__c = 'Test 3';
        mb.Technical_Mapping_Name__c = 'Test3';
        mb.Web_Link__c = 'http://ecm.yousee.dk/?sc_itemid={EEDFB455-9242-43B5-9964-7EC3944B4F32}';
        mb.Template_Group__c = 'YK';
        mb.Group_Name__c = CAMPAIN;
        mb.Default__c = true; 
        insert mb;
         
        Customer_Information_Request__c testCustomer = new Customer_Information_Request__c();
        testCustomer.Account__c = acc.Id;
        Test.setCurrentPage(Page.CustomerInformationRequestNew);        
        ApexPages.StandardController sc = new ApexPages.StandardController(testCustomer);        
        CustomerInformationRequestController controller = new CustomerInformationRequestController(sc);
        controller.customerInformationRequest.Account__c = acc.Id;
        controller.customerInformationRequest.Email__c = 'jh@jh.sk';
        controller.customerInformationRequest.Send__c = true;
        controller.beforeSaleTemplates.setTemplates(new String []{m.id}); 
        controller.afterSaleTemplates.setTemplates(new String []{ma.id});
        controller.campainTemplates.setTemplates(new String []{mb.id});
        controller.save();
        
        system.assert(controller.beforeSaleTemplates.getItems().size()>=1);
        system.assert(controller.afterSaleTemplates.getItems().size()>=1);
        system.assert(controller.campainTemplates.getItems().size()>=1);
        
        Integer countCir = 0;
        Map<String,Customer_Information_Request__c> cir=new Map<String,Customer_Information_Request__c>();
        for (Customer_Information_Request__c cust :[Select Email__c, Send__c , 
            Group_Template__c, Mail_Mapping__c from Customer_Information_Request__c 
            where Account__c =: acc.Id ]){
                cir.put(cust.Mail_Mapping__c,cust);
                countCir++;
            }
        System.assert(3==countCir);
        /*
        Customer_Information_Request__c exp = (Customer_Information_Request__c)cir.get(m.id);
        System.assert(exp!=null); 
        System.assert(exp.Email__c == 'jh@jh.sk'); 
        System.assert(exp.Send__c == true);     
        System.assert(exp.Group_Template__c == m.Picklist_Name__c);     
        
        exp = (Customer_Information_Request__c)cir.get(ma.id);
        System.assert(exp!=null); 
        System.assert(exp.Email__c == 'jh@jh.sk'); 
        System.assert(exp.Send__c == true);     
        System.assert(exp.Group_Template__c == ma.Picklist_Name__c);
        
        exp = (Customer_Information_Request__c)cir.get(mb.id);
        System.assert(exp!=null); 
        System.assert(exp.Email__c == 'jh@jh.sk'); 
        System.assert(exp.Send__c == true);     
        System.assert(exp.Group_Template__c == mb.Picklist_Name__c);
        */
        
        System.assert(controller.getBeforeSaleTemplates()!=null);
        System.assert(controller.getAfterSaleTemplates()!=null);
        System.assert(controller.getCampainTemplates()!=null);
        
        
        testCustomer = new Customer_Information_Request__c();
        testCustomer.Account__c = acc.Id;
        Test.setCurrentPage(Page.CustomerInformationRequestNew);        
        sc = new ApexPages.StandardController(testCustomer);        
        controller = new CustomerInformationRequestController(sc);
        controller.customerInformationRequest.Account__c = acc.Id;
        controller.customerInformationRequest.Email__c = 'jh@jh.sk';
        controller.customerInformationRequest.Send__c = true;
        controller.beforeSaleTemplates.setTemplates(new String []{m.id}); 
        controller.afterSaleTemplates.setTemplates(new String []{ma.id});
        controller.campainTemplates.setTemplates(new String []{mb.id});
        system.assert(Page.CustomerInformationRequestNew.getUrl()
            ==controller.saveAndNew().getUrl());        
        countCir = 0;
        cir=new Map<String,Customer_Information_Request__c>();
        for (Customer_Information_Request__c cust :[Select Email__c, Send__c , 
            Group_Template__c, Mail_Mapping__c from Customer_Information_Request__c 
            where Account__c =: acc.Id ]){
                cir.put(cust.Mail_Mapping__c,cust);
                countCir++;
            }
        System.assert(6==countCir);
        controller.cancel();        
            
    }
    
    static testMethod void testNewInfoRequestEdit(){        
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        // add.House_No__c = 1;
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;
        
        Account acc = new Account();
        acc.Name = 'Test Account 1';
        acc.Street_YK__c = add.Id;
        acc.Customer_No__c = '5436789';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        insert acc;
        
        Mail_Mapping__c m = new Mail_Mapping__c();
        m.Picklist_Name__c = 'Test 1';
        m.Technical_Mapping_Name__c = 'Test1';
        m.Web_Link__c = 'http://ecm.yousee.dk/?sc_itemid={11EC5787-88C0-4E71-89BD-5B21CD147DA8}';
        m.Template_Group__c = 'YK';
        m.Group_Name__c = BEFORE_SALE;
        m.Default__c = true; 
        insert m;
        
        Mail_Mapping__c ma = new Mail_Mapping__c();
        ma.Picklist_Name__c = 'Test 2';
        ma.Technical_Mapping_Name__c = 'Test2';
        ma.Web_Link__c = 'http://ecm.yousee.dk/?sc_itemid={507CAACA-7BD7-452B-A59D-EE538597017C}';
        ma.Template_Group__c = 'YK';
        ma.Group_Name__c = AFTER_SALE;
        ma.Default__c = true; 
        insert ma;
        
        Mail_Mapping__c mb = new Mail_Mapping__c();
        mb.Picklist_Name__c = 'Test 3';
        mb.Technical_Mapping_Name__c = 'Test3';
        mb.Web_Link__c = 'http://ecm.yousee.dk/?sc_itemid={EEDFB455-9242-43B5-9964-7EC3944B4F32}';
        mb.Template_Group__c = 'YK';
        mb.Group_Name__c = CAMPAIN;
        mb.Default__c = true; 
        insert mb;
        
        
        Customer_Information_Request__c cir = new Customer_Information_Request__c(); 
        cir.Account__c= acc.id;
        cir.Date_Requested__c = DateTime.now();
        cir.Email__c = 'jhu@jhu.sk';
        cir.Send__c = true;
        cir.Group_Template__c = m.Picklist_Name__c;
        cir.Mail_Mapping__c =  m.id;
        insert cir;
        
                        
        Test.setCurrentPage(Page.CustomerInformationRequestEdit);        
        ApexPages.StandardController sc = new ApexPages.StandardController(cir);        
        CustomerInformationRequestController controller = new CustomerInformationRequestController(sc);
        controller.customerInformationRequest.Email__c = 'jh@jh.sk';
        controller.customerInformationRequest.Send__c = true;
        controller.beforeSaleTemplates.setTemplates(new String []{}); 
        controller.afterSaleTemplates.setTemplates(new String []{ma.id});
        controller.campainTemplates.setTemplates(new String []{});
        controller.updateOne();
        
        system.assert(controller.beforeSaleTemplates.getItems().size()>=1);
        system.assert(controller.afterSaleTemplates.getItems().size()>=1);
        system.assert(controller.campainTemplates.getItems().size()>=1);   
        
        Integer countCir = 0;
        Map<String,Customer_Information_Request__c> ciReq=new Map<String,Customer_Information_Request__c>();
        for (Customer_Information_Request__c cust :[Select Email__c, Send__c , 
            Group_Template__c, Mail_Mapping__c from Customer_Information_Request__c 
            where Account__c =: acc.Id ]){
                ciReq.put(cust.Mail_Mapping__c,cust);
                countCir++;
            }
        System.assert(1==countCir);
        /*
        Customer_Information_Request__c exp = (Customer_Information_Request__c)ciReq.get(ma.id);
        System.assert(exp!=null); 
        System.assert(exp.Email__c == 'jh@jh.sk'); 
        System.assert(exp.Send__c == true);     
        System.assert(exp.Group_Template__c == ma.Picklist_Name__c);    
        */

    }
    
    static testMethod void testNewInfoRequestCheck(){
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        // add.House_No__c = 1;
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;
        
        Account acc = new Account();
        acc.Name = 'Test Account 1';
        acc.Street_YK__c = add.Id;
        acc.Customer_No__c = '5436789';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        insert acc;
        
        Mail_Mapping__c m = new Mail_Mapping__c();
        m.Picklist_Name__c = 'Test 1';
        m.Technical_Mapping_Name__c = 'Test1';
        m.Web_Link__c = 'http://ecm.yousee.dk/?sc_itemid={11EC5787-88C0-4E71-89BD-5B21CD147DA8}';
        m.Template_Group__c = 'YK';
        m.Group_Name__c = BEFORE_SALE;
        m.Default__c = true; 
        insert m;
        
        Mail_Mapping__c ma = new Mail_Mapping__c();
        ma.Picklist_Name__c = 'Test 2';
        ma.Technical_Mapping_Name__c = 'Test2';
        ma.Web_Link__c = 'http://ecm.yousee.dk/?sc_itemid={507CAACA-7BD7-452B-A59D-EE538597017C}';
        ma.Template_Group__c = 'YK';
        ma.Group_Name__c = AFTER_SALE;
        ma.Default__c = true; 
        insert ma;
        
        Mail_Mapping__c mb = new Mail_Mapping__c();
        mb.Picklist_Name__c = 'Test 3';
        mb.Technical_Mapping_Name__c = 'Test3';
        mb.Web_Link__c = 'http://ecm.yousee.dk/?sc_itemid={EEDFB455-9242-43B5-9964-7EC3944B4F32}';
        mb.Template_Group__c = 'YK';
        mb.Group_Name__c = CAMPAIN;
        mb.Default__c = true; 
        insert mb;
        String ID = mb.id;
        delete mb;
         
        Customer_Information_Request__c testCustomer = new Customer_Information_Request__c();
        testCustomer.Account__c = acc.Id;
        Test.setCurrentPage(Page.CustomerInformationRequestNew);        
        ApexPages.StandardController sc = new ApexPages.StandardController(testCustomer);        
        CustomerInformationRequestController controller = new CustomerInformationRequestController(sc);
        controller.customerInformationRequest.Account__c = acc.Id;
        controller.customerInformationRequest.Email__c = 'jh@jh.sk';
        controller.customerInformationRequest.Send__c = true;
        controller.beforeSaleTemplates.setTemplates(new String []{}); 
        controller.afterSaleTemplates.setTemplates(new String []{});
        controller.campainTemplates.setTemplates(new String []{});
        system.assert(controller.beforeSaleTemplates.getRender());
        controller.save();

        controller.campainTemplates.setTemplates(new String []{ID});
        controller.beforeSaleTemplates.setTemplates(new String []{ID}); 
        controller.afterSaleTemplates.setTemplates(new String []{ID});      
        controller.save();      

        Test.setCurrentPage(Page.CustomerInformationRequestEdit);        
        sc = new ApexPages.StandardController(testCustomer);        
        controller = new CustomerInformationRequestController(sc);
        controller.beforeSaleTemplates.setTemplates(new String []{m.id}); 
        controller.afterSaleTemplates.setTemplates(new String []{ma.id});
        controller.updateOne();         
    }   
}