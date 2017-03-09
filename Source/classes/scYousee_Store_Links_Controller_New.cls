public class scYousee_Store_Links_Controller_New {
    
    public List<Links__c> listLinks;
    public String Comment { get; set; }
    public List<SelectOption> CategoryAll;
    public String Category { get; set; }
    //start – SPOC-2388 
    private String legalAccNumber;
    private String paymentAccNumber;
    private String cableunitName;
    private String legalAccId;
    private String paymentAccId;
    //end – SPOC-2388 
    public String cableUnitNumber;
    public String portalBrugerRole {get; set;}
    public String siteCoreUrl{get; set;}
    public String accountId{get;set;}//support-5377
    public Boolean renderSection{get;set;}//Support-5377
    public String LinkInput{get; set;}
    Public boolean renderpgblock2{get; set;}
    public string linkID{get; set;}
    public boolean isUpdateLink = false;
    public boolean isRenderError{get; set;}
    List<Cable_Unit__c>cableUnit=new List<Cable_Unit__c>();
    
    //start – SPOC-2388 
    public String getLegalAccId(){
        //System.debug('Legal Account id'+legalAccId);
        return legalAccId;
    }
    public String getPaymentAccId(){
        //System.debug('Payment Account Id'+paymentAccId);
        return paymentAccId;
    }
    public String getLegalAccNumber(){
        //System.debug('Legal Account Number'+legalAccNumber);
        return legalAccNumber;
    }
    public String getPaymentAccNumber(){
        //System.debug('Payment Account Number'+paymentAccNumber);
        return paymentAccNumber;
    }
    //end – SPOC-2388 
    public String getCableunitName(){
        //System.debug('CableUnitName'+cableunitName);
        return cableunitName;
    }
    
    
    public boolean displayPopup {get; set;}     
    
    public void closePopup() {        
        displayPopup = false;
        isRenderError = false;
    }     
    public void showPopup() {        
        displayPopup = true;    
    }
    public scYousee_Store_Links_Controller_New()
    {
        listLinks = new List<Links__c>();
        siteCoreUrl = ServiceCenter_CustomSettings__c.getInstance('Service_Center_SiteCoreURL').Value__c;
        portalBrugerRole = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
        accountId = ApexPages.CurrentPage().getParameters().get('accountId');
        cableUnitNumber = ApexPages.CurrentPage().getParameters().get('cableunitnumber');
        renderpgblock2 = true;
        if(!cableUnit.isEmpty())
            cableunitName = cableUnit[0].name; 
        accountId = ApexPages.CurrentPage().getParameters().get('accountId');
        Boolean cableUnitNotMatch = false;
        renderSection = true;
        cableUnit = [Select c.Current_Kiss_Case__r.Sales_Concept_Lookup__r.id,c.Id,c.Name, c.Legal_Account_No__c,c.Payment_Account_No__c ,c.Legal_Account_No__r.customer_No__c, c.Payment_Account_No__r.customer_No__c from Cable_Unit__c c where  c.Cable_Unit_No__c =: ApexPages.CurrentPage().getParameters().get('cableunitnumber') limit 1];//for – SPOC-2388 
        list<Account> accList = new list<Account>();
        accList = [SELECT Id, Cable_Unit__r.Cable_Unit_No__c FROM Account where id =:accountId ]; 
        if(!accList.isEmpty()){
            system.debug('*****accList*********' + accList[0].Cable_Unit__r.Cable_Unit_No__c);
            if(cableUnitNumber != null && accList[0].Cable_Unit__r.Cable_Unit_No__c != cableUnitNumber){
                
                renderSection = false;
            } 
            else{
                if(cableUnit!= null && cableUnit.size() > 0){
                    cableunitName  = cableUnit[0].Name;
                    
                    legalAccNumber = cableUnit[0].Legal_Account_No__r.customer_No__c;
                    
                    // Hard coded for checking
                    //paymentAccNumber = '611472946';
                    paymentAccNumber = cableUnit[0].Payment_Account_No__r.customer_No__c;
                    system.debug('$Legal Account Number$'+legalAccNumber+'$Payment Account Number$'+paymentAccNumber);
                    legalAccId = cableUnit[0].Legal_Account_No__c;
                    paymentAccId = cableUnit[0].Payment_Account_No__c; 
                    //System.debug('*1*'+cableunitName+'*2*'+legalAccNumber+'*3*'+paymentAccNumber+'*4*'+legalAccId+'*5*'+paymentAccId);        
                }
            }
        }
        else{
            
            renderSection=false;
        }
    } 
    public List<SelectOption> getCategoryAll()
    {
        List<string> allCatgry = new list<string>();
        Schema.DescribeFieldResult categoryField = Schema.SObjectType.Links__c.fields.Category__c;
        List<schema.PicklistEntry> listCategory = categoryField.getPicklistValues();
        system.debug('listCategory '+listCategory);
        for(schema.PicklistEntry oneCategory : listCategory)
        {
            allCatgry.add(oneCategory.getvalue());
        }
        system.debug('allCatgry '+allCatgry);
        List<SelectOption> options = new List<SelectOption>();
        options.add(new selectoption('','-Vælg-'));
        for(string c : allCatgry)
        {
            options.add(new selectoption(c,c));      
        }
        return options;
    }
    public List<Links__c> getListLinks()
    {
        renderpgblock2 = true;
        RecordType rectypId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Service_Centre_Link'];
        if(!cableUnit.isEmpty())
         listLinks = [select id,URL__c,comment__c,Category__c,Cable_unit__c,Cable_unit__r.name,Person_Account__c from Links__c  where recordtypeID=: rectypId.id and Cable_unit__c=:cableUnit[0].id];//– SPOC-2388 
       
        return listLinks;
    }
    public PageReference onSubmit() 
    {
        system.debug('onSubmit ');
        system.debug('onSubmit '+listLinks);
        RecordType rectypId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Service_Centre_Link'];
        list<Links__c> listLink = [select id,text__c,URL__c,Category__c,Comment__c,Person_Account__c from Links__c where Category__c =: Category and RecordTypeId =: rectypId.id and Cable_Unit__r.Cable_Unit_No__c =:cableUnitNumber limit 1];
        if(Category != null)
        {
            if(listLink.size() != 0 && isUpdateLink == false )
            {
                isRenderError = true;
                ApexPages.Message errorMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Du kan ikke gemme et link med en kategori, der allerede er tilføjet. Du kan redigere eller slette tilføjede links nedenfor på knapperne.');
                ApexPages.addMessage(errorMsg1);
            }
            else if((listLink.size() == 0 || listLink.size() != 0) && isUpdateLink == true)
            {
                Links__c linkToUpdate = [select id,URL__c,Category__c,Comment__c,Cable_Unit__c,RecordTypeId,Person_Account__c from Links__c where id =: linkId];
                isRenderError = false;
                if(listLink.size() == 0)
                {
                    isRenderError = false;
                    linkToUpdate.text__c = 'Service Center';
                    linkToUpdate.URL__c = LinkInput;
                    linkToUpdate.Category__c = Category;
                    linkToUpdate.Comment__c = comment;
                    linkToUpdate.Cable_Unit__c = cableUnit[0].id;
                    linkToUpdate.RecordTypeId = rectypId.id;
                    linkToUpdate.Account__c = accountId;
                    update linkToUpdate;
                }
                else if(listLink.size() != 0)
                {
                    if(linkToUpdate.Category__c == Category)
                    {
                        isRenderError = false;
                        linkToUpdate.text__c = 'Service Center';
                        linkToUpdate.URL__c = LinkInput;
                        linkToUpdate.Category__c = Category;
                        linkToUpdate.Comment__c = comment;
                        linkToUpdate.Cable_Unit__c = cableUnit[0].id;
                        linkToUpdate.RecordTypeId = rectypId.id;
                        linkToUpdate.Account__c = accountId;
                        update linkToUpdate;
                    }
                    else
                    {
                        isRenderError = true;
                        ApexPages.Message errorMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Du kan ikke gemme et link med en kategori, der allerede er tilføjet. Du kan redigere eller slette tilføjede links nedenfor på knapperne.');
                        ApexPages.addMessage(errorMsg1);
                    }
                }
                
            }
            else
            {
                isRenderError = false;
                Links__c newLink = new Links__c();
                newLink.URL__c = LinkInput;
                newLink.Category__c = Category;
                newLink.comment__c = Comment;
                newLink.text__c = 'Service Center';
                newLink.Cable_unit__c = cableUnit[0].id;
                newLink.recordtypeID = rectypId.id;
                newLink.Account__c = accountId;
                newLink.Person_Account__c= cableUnit[0].Payment_Account_No__c;//– SPOC-2388 
                insert newLink;
                system.debug('Link inserted ++ '+newLink);
                renderpgblock2 = true;
            }
        }
        else
        {
            isRenderError = true;
            ApexPages.Message errorMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Du skal angive en kategori før du kan tilføje.');
            ApexPages.addMessage(errorMsg1);
        }
        Comment='';
        Category='';
        LinkInput='';
        isUpdateLink = false;
        return null;
    }
    public PageReference editLink() {
        system.debug('Edit Link ');
        system.debug('LinkId'+linkID);
        isUpdateLink = true;
        Links__c objLink = [select id,URL__c,Category__c,Comment__c from Links__c where id =: linkId.substring(0,15) limit 1];
        LinkInput = objLink.URL__c;
        Category = objLink.Category__c;
        Comment = objLink.Comment__c;
        return null;
    }
    public PageReference delLink() 
    {
        List<Links__c> listLinksToDel = new List<Links__c>();
        Links__c objLink = [select id from Links__c where id =: linkId.substring(0,15) limit 1];
        delete objLink;
        displayPopup = false;
        isRenderError = false;
        isUpdateLink = false;
        return null;
    }
}