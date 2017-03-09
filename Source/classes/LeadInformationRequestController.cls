public with sharing class LeadInformationRequestController {    
    public ITemplates beforeSaleTemplates; 
    public ITemplates afterSaleTemplates;
    public ITemplates campainTemplates;
    public Lead_Information_Request__c leadInformationRequest{get;set;}
    public Map<String,Mail_Mapping__c> mapIdMailMapping;
    public List<Mail_Mapping__c> mailMapping; 
    
    public static String BEFORE_SALE = 'Before Sale'; 
    public static String AFTER_SALE = 'After Sale'; 
    public static String CAMPAIN = 'Campagne'; 
    public static String INTEGRATEERRORMSG = System.Label.CL_INTEGRATEERRORMSG;
    //'Your chosen value doesn\'t exist anymore in Mail Mapping. Please refresh the page :';
    public static String VALIDATIONTEMPLATEERRMSG =  System.Label.CL_VALIDATIONTEMPLATEERRMSG;
    //'At least one template must be checked!';
    public static String VALIDATIONTEMPLATEERREDITMSG =  System.Label.CL_VALIDATIONTEMPLATEERREDITMSG;
    //'Only one template must be checked!';
/*    public static Map <String,String> groupNameRecordType = new Map<String, String>{
            'Editable Information Request' => 'YK', 
            'Editable Information Request YO' => 'YO',
            'Read Only Information Request' => 'YK'         
        };
*/
    public class IntegrateException extends Exception {}    
    public class ValidationException extends Exception {}
                    
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
            for(Integer i=0; i<mailMapping.size() ; i++) {              
                if (groupName == ((Mail_Mapping__c)mailMapping[i]).Group_Name__c){
                    /*
                    options.add(new SelectOption(((Mail_Mapping__c)mailMapping[i]).Id,
                        ((Mail_Mapping__c)mailMapping[i]).Picklist_Name__c ));
                    */
                    Mail_Mapping__c mailMap = (Mail_Mapping__c)mailMapping[i];
                    SelectOption opt = new SelectOption(mailMap.Id,
                        getOptionValueAsLink(mailMap.Web_Link__c ,mailMap.Picklist_Name__c));
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
            return '<a href="'+ link + '">';
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
        public Lead_Information_Request__c leadInformationRequest{get;set;}
        public EditTemplates( String groupName, List<Mail_Mapping__c> mailMapping,
            Lead_Information_Request__c leadInformationRequest ){
            this.leadInformationRequest = leadInformationRequest;
            setMailMapping(mailMapping);
            options = getItems(groupName);
        }
        
        public override List<SelectOption>  getItems (String groupName ){
            if (leadInformationRequest.Group_Template__c!=null && 
                leadInformationRequest.Group_Template__c!= ''){
                templates.add(leadInformationRequest.Mail_Mapping__c);
            }
            List<SelectOption> options = new List<SelectOption>();
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
        
    public LeadInformationRequestController(ApexPages.StandardController controller) {
        leadInformationRequest = (Lead_Information_Request__c) controller.getRecord();
        mailMapping = getMailMapping();
        this.mapIdMailMapping = new Map<String,Mail_Mapping__c>();      
        for(Integer i=0; i<mailMapping.size() ; i++) {  
            this.mapIdMailMapping.put(((Mail_Mapping__c)mailMapping[i]).Id, mailMapping[i]);
        } 
        if(ApexPages.currentPage().getUrl().toLowerCase().contains(
            Page.LeadInformationRequestEdit.getUrl())){
           // 'customerinformationrequestedit')){           
            this.beforeSaleTemplates = new  EditTemplates(BEFORE_SALE,mailMapping,
                leadInformationRequest);
            this.afterSaleTemplates = new EditTemplates(AFTER_SALE,mailMapping,
                leadInformationRequest);
            this.campainTemplates = new EditTemplates(CAMPAIN,mailMapping,
                leadInformationRequest);
        }else{
            leadInformationRequest.Email__c = getLeadEmail(leadInformationRequest.Lead__c);
            this.beforeSaleTemplates = new  NewTemplates(BEFORE_SALE,mailMapping);
            this.afterSaleTemplates = new NewTemplates(AFTER_SALE,mailMapping);
            this.campainTemplates = new NewTemplates(CAMPAIN,mailMapping);
        }
    }
    
    public String getLeadEmail(String leadId){
        return [Select Email from Lead where Id=:leadId].Email;
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
                From Mail_Mapping__c where Template_Group__c = 'Lead'];
                //:(String)groupNameRecordType.get(recordTypeName) ]; 
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
    public Lead_Information_Request__c insertOne(String mailMappingId){
        Lead_Information_Request__c cir = new Lead_Information_Request__c(); 
        cir.Lead__c= leadInformationRequest.Lead__c;
        cir.Date_Requested__c = DateTime.now();
        cir.Email__c = leadInformationRequest.Email__c;
        cir.Send__c = true;
        cir.Group_Template__c =((Mail_Mapping__c)mapIdMailMapping.get(mailMappingId)).Picklist_Name__c;
        cir.Mail_Mapping__c =  mailMappingId;
        insert cir;
        return cir;
    }
    
    public Lead_Information_Request__c updateCir(){
        String mailMappingId = beforeSaleTemplates.getTemplates().size()==0? 
            (afterSaleTemplates.getTemplates().size()==0? 
                campainTemplates.getTemplates()[0]: afterSaleTemplates.getTemplates()[0])
            :beforeSaleTemplates.getTemplates()[0];
        leadInformationRequest.Date_Requested__c = DateTime.now();
        leadInformationRequest.Group_Template__c =((Mail_Mapping__c)mapIdMailMapping.get(mailMappingId)).Picklist_Name__c;
        leadInformationRequest.Mail_Mapping__c =  mailMappingId;
        update leadInformationRequest;
        return leadInformationRequest;
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
        setDefaultTemplate(defaultIds);
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
        PageReference parentPage = new PageReference('/'+leadInformationRequest.Lead__c);
        parentPage.setRedirect(true);
        return parentPage;
     }
   
    public PageReference cancel() {                 
        return backToAccount();      
    }
    
    @isTest(SeeAllData=true)
    static void testNewInfoRequestNew(){
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;        
        
        // Create lead record        
        Lead l = new Lead();
        l.FirstName = 'Tom';
        l.LastName = 'Jones';
        l.Company = 'ACME';
        //l.RecordTypeId = '012200000000nzaAAA';      
        l.Street_Lookup__c = add.Id;
        l.Email = 'tomjones@yousee.dk';
        l.Phone = '01322788767';
        l.Type__c = 'Kunde';
        l.Status = 'Åben';
        l.Estimated_Potential__c = 100;
        l.No_Email_Address__c = false;
        insert l;        
              
        Mail_Mapping__c m = new Mail_Mapping__c();
        m.Picklist_Name__c = 'Test 1';
        m.Technical_Mapping_Name__c = 'Test1';
        m.Web_Link__c = 'http://ecm.yousee.dk/?sc_itemid={11EC5787-88C0-4E71-89BD-5B21CD147DA8}';
        m.Template_Group__c = 'Lead';
        m.Group_Name__c = BEFORE_SALE;
        m.Default__c = true; 
        insert m;
        
        Mail_Mapping__c ma = new Mail_Mapping__c();
        ma.Picklist_Name__c = 'Test 2';
        ma.Technical_Mapping_Name__c = 'Test2';
        ma.Web_Link__c = 'http://ecm.yousee.dk/?sc_itemid={507CAACA-7BD7-452B-A59D-EE538597017C}';
        ma.Template_Group__c = 'Lead';
        ma.Group_Name__c = AFTER_SALE;
        ma.Default__c = true; 
        insert ma;
        
        Mail_Mapping__c mb = new Mail_Mapping__c();
        mb.Picklist_Name__c = 'Test 3';
        mb.Technical_Mapping_Name__c = 'Test3';
        mb.Web_Link__c = 'http://ecm.yousee.dk/?sc_itemid={EEDFB455-9242-43B5-9964-7EC3944B4F32}';
        mb.Template_Group__c = 'Lead';
        mb.Group_Name__c = CAMPAIN;
        mb.Default__c = true; 
        insert mb;
         
        Lead_Information_Request__c testLead = new Lead_Information_Request__c();
        testLead.Lead__c = l.Id;
        Test.setCurrentPage(Page.LeadInformationRequestNew);        
        ApexPages.StandardController sc = new ApexPages.StandardController(testLead);        
        LeadInformationRequestController controller = new LeadInformationRequestController(sc);
        controller.leadInformationRequest.Lead__c = l.Id;
        controller.leadInformationRequest.Email__c = 'jh@jh.sk';
        controller.leadInformationRequest.Send__c = true;
        controller.beforeSaleTemplates.setTemplates(new String []{m.id}); 
        controller.afterSaleTemplates.setTemplates(new String []{ma.id});
        controller.campainTemplates.setTemplates(new String []{mb.id});
        controller.save();
        
        system.assert(controller.beforeSaleTemplates.getItems().size()>=1);
        system.assert(controller.afterSaleTemplates.getItems().size()>=1);
        system.assert(controller.campainTemplates.getItems().size()>=1);
        
        Integer countCir = 0;
        Map<String,Lead_Information_Request__c> cir=new Map<String,Lead_Information_Request__c>();
        for (Lead_Information_Request__c ld :[Select Email__c, Send__c , 
            Group_Template__c, Mail_Mapping__c from Lead_Information_Request__c 
            where Lead__c =: l.Id ]){
                cir.put(ld.Mail_Mapping__c,ld);
                countCir++;
            }
        System.assert(3==countCir);
        Lead_Information_Request__c exp = (Lead_Information_Request__c)cir.get(m.id);
        System.assert(exp!=null); 
        System.assert(exp.Email__c == 'jh@jh.sk'); 
        System.assert(exp.Send__c == true);     
        System.assert(exp.Group_Template__c == m.Picklist_Name__c);     
        
        exp = (Lead_Information_Request__c)cir.get(ma.id);
        System.assert(exp!=null); 
        System.assert(exp.Email__c == 'jh@jh.sk'); 
        System.assert(exp.Send__c == true);     
        System.assert(exp.Group_Template__c == ma.Picklist_Name__c);
        
        exp = (Lead_Information_Request__c)cir.get(mb.id);
        System.assert(exp!=null); 
        System.assert(exp.Email__c == 'jh@jh.sk'); 
        System.assert(exp.Send__c == true);     
        System.assert(exp.Group_Template__c == mb.Picklist_Name__c);
        
        System.assert(controller.getBeforeSaleTemplates()!=null);
        System.assert(controller.getAfterSaleTemplates()!=null);
        System.assert(controller.getCampainTemplates()!=null);
        
        
        testLead = new Lead_Information_Request__c();
        testLead.Lead__c = l.Id;
        Test.setCurrentPage(Page.LeadInformationRequestNew);        
        sc = new ApexPages.StandardController(testLead);        
        controller = new LeadInformationRequestController(sc);
        controller.leadInformationRequest.Lead__c = l.Id;
        controller.leadInformationRequest.Email__c = 'jh@jh.sk';
        controller.leadInformationRequest.Send__c = true;
        controller.beforeSaleTemplates.setTemplates(new String []{m.id}); 
        controller.afterSaleTemplates.setTemplates(new String []{ma.id});
        controller.campainTemplates.setTemplates(new String []{mb.id});
        system.assert(Page.LeadInformationRequestNew.getUrl()
            ==controller.saveAndNew().getUrl());        
        countCir = 0;
        cir=new Map<String,Lead_Information_Request__c>();
        for (Lead_Information_Request__c ld :[Select Email__c, Send__c , 
            Group_Template__c, Mail_Mapping__c from Lead_Information_Request__c 
            where Lead__c =: l.Id ]){
                cir.put(ld.Mail_Mapping__c,ld);
                countCir++;
            }
        System.assert(6==countCir);
        controller.cancel();        
            
    }
    @isTest(SeeAllData=true)
    static void testNewInfoRequestEdit(){        
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        // add.House_No__c = 1;
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;
        
        // Create lead record        
        Lead l = new Lead();
        l.FirstName = 'Tom';
        l.LastName = 'Jones';
        l.Company = 'ACME';
        //l.RecordTypeId = '012200000000nzaAAA';      
        l.Street_Lookup__c = add.Id;
        l.Email = 'tomjones@yousee.dk';
        l.Phone = '01322788767';
        l.Type__c = 'Kunde';
        l.Status = 'Åben';
        l.Estimated_Potential__c = 100;
        l.No_Email_Address__c = false;
        insert l;        
        
        Mail_Mapping__c m = new Mail_Mapping__c();
        m.Picklist_Name__c = 'Test 1';
        m.Technical_Mapping_Name__c = 'Test1';
        m.Web_Link__c = 'http://ecm.yousee.dk/?sc_itemid={11EC5787-88C0-4E71-89BD-5B21CD147DA8}';
        m.Template_Group__c = 'Lead';
        m.Group_Name__c = BEFORE_SALE;
        m.Default__c = true; 
        insert m;
        
        Mail_Mapping__c ma = new Mail_Mapping__c();
        ma.Picklist_Name__c = 'Test 2';
        ma.Technical_Mapping_Name__c = 'Test2';
        ma.Web_Link__c = 'http://ecm.yousee.dk/?sc_itemid={507CAACA-7BD7-452B-A59D-EE538597017C}';
        ma.Template_Group__c = 'Lead';
        ma.Group_Name__c = AFTER_SALE;
        ma.Default__c = true; 
        insert ma;
        
        Mail_Mapping__c mb = new Mail_Mapping__c();
        mb.Picklist_Name__c = 'Test 3';
        mb.Technical_Mapping_Name__c = 'Test3';
        mb.Web_Link__c = 'http://ecm.yousee.dk/?sc_itemid={EEDFB455-9242-43B5-9964-7EC3944B4F32}';
        mb.Template_Group__c = 'Lead';
        mb.Group_Name__c = CAMPAIN;
        mb.Default__c = true; 
        insert mb;
        
        
        Lead_Information_Request__c cir = new Lead_Information_Request__c(); 
        cir.Lead__c= l.id;
        cir.Date_Requested__c = DateTime.now();
        cir.Email__c = 'jhu@jhu.sk';
        cir.Send__c = true;
        cir.Group_Template__c = m.Picklist_Name__c;
        cir.Mail_Mapping__c =  m.id;
        insert cir;
        
                        
        Test.setCurrentPage(Page.LeadInformationRequestEdit);        
        ApexPages.StandardController sc = new ApexPages.StandardController(cir);        
        LeadInformationRequestController controller = new LeadInformationRequestController(sc);
        controller.leadInformationRequest.Email__c = 'jh@jh.sk';
        controller.leadInformationRequest.Send__c = true;
        controller.beforeSaleTemplates.setTemplates(new String []{}); 
        controller.afterSaleTemplates.setTemplates(new String []{ma.id});
        controller.campainTemplates.setTemplates(new String []{});
        controller.updateOne();
        
        system.assert(controller.beforeSaleTemplates.getItems().size()>=1);
        system.assert(controller.afterSaleTemplates.getItems().size()>=1);
        system.assert(controller.campainTemplates.getItems().size()>=1);   
        
        Integer countCir = 0;
        Map<String,Lead_Information_Request__c> ciReq=new Map<String,Lead_Information_Request__c>();
        for (Lead_Information_Request__c ld :[Select Email__c, Send__c , 
            Group_Template__c, Mail_Mapping__c from Lead_Information_Request__c 
            where Lead__c =: l.Id ]){
                ciReq.put(ld.Mail_Mapping__c,ld);
                countCir++;
            }
        System.assert(1==countCir);
        Lead_Information_Request__c exp = (Lead_Information_Request__c)ciReq.get(ma.id);
        System.assert(exp!=null); 
        System.assert(exp.Email__c == 'jh@jh.sk'); 
        System.assert(exp.Send__c == true);     
        System.assert(exp.Group_Template__c == ma.Picklist_Name__c);    

    }
    @isTest(SeeAllData=true)
    static void testNewInfoRequestCheck(){
        Address__c add = new Address__c();
        add.Street__c = 'Main Street';
        // add.House_No__c = 1;
        add.Town__c = 'Leeds';
        add.Postcode__c = 'LS1';
        insert add;
        
        // Create lead record        
        Lead l = new Lead();
        l.FirstName = 'Tom';
        l.LastName = 'Jones';
        l.Company = 'ACME';
        //l.RecordTypeId = '012200000000nzaAAA';      
        l.Street_Lookup__c = add.Id;
        l.Email = 'tomjones@yousee.dk';
        l.Phone = '01322788767';
        l.Type__c = 'Kunde';
        l.Status = 'Åben';
        l.Estimated_Potential__c = 100;
        l.No_Email_Address__c = false;
        insert l;   
        
        Mail_Mapping__c m = new Mail_Mapping__c();
        m.Picklist_Name__c = 'Test 1';
        m.Technical_Mapping_Name__c = 'Test1';
        m.Web_Link__c = 'http://ecm.yousee.dk/?sc_itemid={11EC5787-88C0-4E71-89BD-5B21CD147DA8}';
        m.Template_Group__c = 'Lead';
        m.Group_Name__c = BEFORE_SALE;
        m.Default__c = true; 
        insert m;
        
        Mail_Mapping__c ma = new Mail_Mapping__c();
        ma.Picklist_Name__c = 'Test 2';
        ma.Technical_Mapping_Name__c = 'Test2';
        ma.Web_Link__c = 'http://ecm.yousee.dk/?sc_itemid={507CAACA-7BD7-452B-A59D-EE538597017C}';
        ma.Template_Group__c = 'Lead';
        ma.Group_Name__c = AFTER_SALE;
        ma.Default__c = true; 
        insert ma;
        
        Mail_Mapping__c mb = new Mail_Mapping__c();
        mb.Picklist_Name__c = 'Test 3';
        mb.Technical_Mapping_Name__c = 'Test3';
        mb.Web_Link__c = 'http://ecm.yousee.dk/?sc_itemid={EEDFB455-9242-43B5-9964-7EC3944B4F32}';
        mb.Template_Group__c = 'Lead';
        mb.Group_Name__c = CAMPAIN;
        mb.Default__c = true; 
        insert mb;
        String ID = mb.id;
        delete mb;
         
        Lead_Information_Request__c testLead = new Lead_Information_Request__c();
        testLead.Lead__c = l.Id;
        Test.setCurrentPage(Page.LeadInformationRequestNew);        
        ApexPages.StandardController sc = new ApexPages.StandardController(testLead);        
        LeadInformationRequestController controller = new LeadInformationRequestController(sc);
        controller.leadInformationRequest.Lead__c = l.Id;
        controller.leadInformationRequest.Email__c = 'jh@jh.sk';
        controller.leadInformationRequest.Send__c = true;
        controller.beforeSaleTemplates.setTemplates(new String []{}); 
        controller.afterSaleTemplates.setTemplates(new String []{});
        controller.campainTemplates.setTemplates(new String []{});
        system.assert(controller.beforeSaleTemplates.getRender());
        controller.save();

        controller.campainTemplates.setTemplates(new String []{ID});
        controller.beforeSaleTemplates.setTemplates(new String []{ID}); 
        controller.afterSaleTemplates.setTemplates(new String []{ID});      
        controller.save();      

        Test.setCurrentPage(Page.LeadInformationRequestEdit);        
        sc = new ApexPages.StandardController(testLead);        
        controller = new LeadInformationRequestController(sc);
        controller.beforeSaleTemplates.setTemplates(new String []{m.id}); 
        controller.afterSaleTemplates.setTemplates(new String []{ma.id});
        controller.updateOne();         
    }   
}