public with sharing class DealerProductController {
        public List<c_dealerProduct> products {get; set;}
        public String[] toAddresses; // Setup by Custom Settings. See DealerProductController#initCustomSettings
        private String emailSubject; // Setup by Custom Settings. See DealerProductController#initCustomSettings
        private String emailBody = ''; // Initialize empty email body
        private String error;
        Map<string, List<Dealer_Product__c>> dealerProductGrpMap = new Map<String,List<Dealer_Product__c>>();
        public List<Dealer_Product__c> productsList;
        public List<Dealer_Product__c> productsAccountList;
        public commonclass objClass = new commonclass();  
        public List<String> strDealerList = new List<String>();
        public string dealerProducts;
        public Map<String, String> accountMap{get;set;}        
        
        
        public String userId{get;set;}
        
        
        public List<ForhandlerInformations__c> getProductValgInformation(){
               return getInformation('Produktvalg Page'); 
        } 
    
        public List<ForhandlerInformations__c> getGodkendInformation(){
               return getInformation('Godkend Page'); 
        }

        public List<ForhandlerInformations__c> getKvitteringInformation(){
               return getInformation('Kvittering Page'); 
        }
        
        public List<ForhandlerInformations__c> getInformation(String pageType){
               List<ForhandlerInformations__c> informationList = [Select info.Description__c, info.EndDate__c, info.Group_Information__c, info.Dealer__r.Name, info.SubGroup_Information__c From ForhandlerInformations__c info where info.Page_Type__c =: 'Bestil Varer' and Group_Information__c =: pageType and info.SubGroup_Information__c = 'Top' order by Sequence_Number__c];
               integer days = 0;
               Date todayDate = Date.today();
               
               List<ForhandlerInformations__c> filteredInformationList = new List<ForhandlerInformations__c>(); 
               for(ForhandlerInformations__c info : informationList) {
                     if(info.EndDate__c != null){
                         days = todayDate.daysBetween(info.EndDate__c);
                     }    
                     if((info.EndDate__c == null) ||  (info.EndDate__c != null && days >= 0)) {
                         filteredInformationList.add(info); 
                     }                             
                }  
                return filteredInformationList; 
        }        

        public DealerProductController(ApexPages.StandardController controller) {
                System.debug(' ------------------------- Inside Constructor -------------------------------');
                // Initialize Custom Settings
                
                initCustomSettings();
                setDealerProduct();
                            
                
                // Set Dealer Product
                /* Changed for DW-881 by #Shefali Vinchurkar
                
                  productsList = [SELECT Id, Name, Product_Number__c, Product_Group__c, Product_Descriptions__c, Quantity__c, 
                                    Max_Items_Allowed__c, Max_Antal_Dealer_Group__c, Dealer_Group__c
                                                        FROM Dealer_Product__c ORDER BY Product_Group__c,Product_Number__c, Product_Descriptions__c];
                                                         */
               productsList = [SELECT Id, Name, Product_Number__c, Product_Group__c, Product_Descriptions__c, Quantity__c, 
                                    Max_Items_Allowed__c, Max_Antal_Dealer_Group__c, Dealer_Group__c
                                                        FROM Dealer_Product__c 
                                                        WHERE Name NOT IN('Trådløst modem','YouSee Kort','Tvillingkort','Ekstrakort','Leje YouSee HD-boks','TREFOR TV-Boks')
                                                        ORDER BY Product_Group__c,Product_Number__c, Product_Descriptions__c];
                 
                System.debug('ProductListValues'+ productsList);    
                Account account = [select a.DealerGroup__c, a.DealerProducts__c, a.Name from Account a where id =: objClass.dealerAccount.Id  limit 1];                
               // String [] dealerProducts = account.DealerProducts__c.split(';');
                System.debug('Values Of Account are'+ account);
                String [] dealerProducts = account.DealerProducts__c.split(';');
               // String [] dealerProducts = account.selectedProduct__c.split(',');
                String [] dealerGroups = account.DealerGroup__c.split(';'); 
                System.debug('***Dealer Products*'+dealerProducts + '*Dealer Group*'+ dealerGroups); 
                accountMap = new Map<String, String> ();
                String accountGroup = dealerGroups[0];
                
                    for(String delaerProduct :dealerProducts){
                            accountMap.put(delaerProduct.trim() , delaerProduct.trim() );
                            
                        }
                   
                    for(Dealer_Product__c dealerProduct: productsList){
                        if(dealerProduct.Dealer_Group__c != null){
                            String [] dealerGroupArray = dealerProduct.Dealer_Group__c.split(';');  
                            for(String dGroup : dealerGroupArray ){
                                accountMap.put(dGroup , dGroup);
                            }
                        }
                        if(dealerProduct.Max_Antal_Dealer_Group__c != null && accountMap.containsKey(accountGroup )){
                            System.debug('Inside max antal');
                            dealerProduct.Max_Items_Allowed__c = dealerProduct.Max_Antal_Dealer_Group__c;
                            System.debug(dealerProduct.MAx_Items_Allowed__c);
                        }
                    
                        if(dealerProduct.Product_Group__c != 'Generelt'){
                                System.debug('Inside generelt checking');
                                if(accountMap.containsKey(dealerProduct.Product_Group__c)){
                                        System.debug('Inside generelt checking of account map');
                                        if(dealerProductGrpMap.containsKey(dealerProduct.Product_Group__c)){
                                                System.debug('Inside generelt checking of dealerProductGroup Map');
                                            dealerProductGrpMap.get(dealerProduct.Product_Group__c).add(dealerProduct);
                                        }
                                        else {
                                            List<Dealer_Product__c> dealerList =new List<Dealer_Product__c>();
                                            dealerList.add(dealerProduct);
                                            System.debug('Dealer List'+dealerList);
                                            dealerProductGrpMap.put(dealerProduct.Product_Group__c,dealerList);
                                        }
                                }
                         }
                }
                
                 //adding general info
                
                 system.debug('accountMap--->'+accountMap);
                System.debug('dealerList--->'+dealerProductGrpMap.keySet() + '-----' + dealerProducts) ;
                products = new List<c_dealerProduct>();
                Set<String> paramGroupList = dealerProductGrpMap.keySet();
                
                for(String paramGroup: paramGroupList){
                    c_dealerProduct dealerProdInrCls = new c_dealerProduct();
                    dealerProdInrCls.productGroup=paramGroup;
                    dealerProdInrCls.dealerProduct=dealerProductGrpMap.get(paramGroup);
                    products.add(dealerProdInrCls);
                 }
                 
                 for(Dealer_Product__c dealerProduct: productsList){
                 if(dealerProduct.Product_Group__c == 'Generelt'){
                        if(dealerProductGrpMap.containsKey(dealerProduct.Product_Group__c)){
                                dealerProductGrpMap.get(dealerProduct.Product_Group__c).add(dealerProduct);
                                System.debug('@@@@@@ dealerProductGrpMap'+dealerProductGrpMap);
                                }
                            else {
                                    List<Dealer_Product__c> dealerList =new List<Dealer_Product__c>();
                                    dealerList.add(dealerProduct);
                                    dealerProductGrpMap.put(dealerProduct.Product_Group__c,dealerList);
                                }
                    }
                 }
                
                for(String paramGroup: paramGroupList){
                    if(paramGroup == 'Generelt'){
                    c_dealerProduct dealerProdInrCls = new c_dealerProduct();
                    dealerProdInrCls.productGroup=paramGroup;
                    dealerProdInrCls.dealerProduct=dealerProductGrpMap.get(paramGroup);
                    products.add(dealerProdInrCls);
                    }
                 }
                 
                
                  System.debug(' ------------------------- End Constructor -------------------------------');
                System.debug('products-->'+products);
        }

     private void setDealerProduct(){
                System.debug(' ------------------------- setDealerProduct Start -------------------------------');
               ///objClass.setDealerInfo();
                //String productList = objClass.dealerAccount.selectedProduct__c;
                 String productList = objClass.dealerAccount.DealerProducts__c;
                 //dealerProducts = productList.replace(';',',');
                 System.debug('Selected Products'+ productList);
                 dealerProducts = productList;
                 //List<string> aQryStr = dealerProducts.split(',');
                 List<string> aQryStr = dealerProducts.split(';');
                    for(Integer i = 0; i < aQryStr.size(); i++){
                        strDealerList.add('\''+aQryStr[i]+'\'');
                        System.debug('Displayed List'+strDealerList);
                    }
                    
                System.debug(' ------------------------- setDealerProduct End -------------------------------');    
            }

        /**
         * Method for generating the order.
         */
        public PageReference generateOrder() {
                System.debug(' ------------------------- generateOrder Start -------------------------------');
               // Send Email
               if(!this.validateInput()) {
                                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, error);
                        ApexPages.addMessage(msg);
                        return null;
                        
               }
               else{
                
                //--start
                
                    //AssignmentRule AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
                    Database.DMLOptions dmlOpts = new Database.DMLOptions();
                    dmlOpts.assignmentRuleHeader.useDefaultRule= true;
                    RecordType recordType = [Select Id From RecordType Where Name = 'Queue Owned Case'];
                    Case newCase = new Case(Status = 'New',Department__c = 'YKFS',RecordTypeId = recordType.Id,
                                    Product_2__c = 'Visitering',Subject = 'testing case..') ;
                    newCase.setOptions(dmlOpts); 
                    insert newCase; 
                    System.debug('newCase.id - '+newCase.id);
                
                
                //--end                 
                
                String emailBody = this.sendEmail();
               }
                // Create activity
              /*  this.createActivity(emailBody);

                // Set OK message and return to page
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Tak for din varebestilling, ordren bliver ekspederet af vores lager inden for 24 timer.');
                ApexPages.addMessage(msg);
               
                 */
                String newPageUrl ='/apex/DealerProductFinal';
                PageReference newPage = new PageReference(newPageUrl);
                System.debug(' ------------------------- generateOrder Start -------------------------------');
                return newPage;
        }

        /**
         * Wrapper Class to hold the products according to their group.
         */
        public class c_dealerProduct{
                public string productGroup {public get;public set;}
                public List<Dealer_Product__c> dealerProduct {get; set;}
        }
        /**
         * Private helper method for creating an activity in order to do some tracking.
         */
        private void createActivity(String description) {
                System.debug(' ------------------------- createActivity Start -------------------------------');
                // Find Account based on user
                String userId = UserInfo.getUserId();
                User user = [SELECT Id, AccountId FROM User WHERE Id = :userId];
                system.debug('######## Account ID ############# '+user.AccountId);
                // Create Task
                Task task = new Task();
                task.WhatId = user.AccountId;
                task.Description = description;
                task.RecordTypeId = '01220000000TyI8';
                task.Status = 'Completed';
                task.Subject = 'Opfølgning';
                task.Type = 'Email';

                // Insert task
                insert task;
                System.debug(' ------------------------- createActivity End -------------------------------');
        }

        /**
         * Private helper method for validating user input.
        */ 
   
        private boolean validateInput2() {
                System.debug(' ------------------------- validateInput Start -------------------------------');
                Boolean flag = true;
                
                this.error = 'Du har forsøgt at bestille flere enheder, end det tilladte maks';
                for(Dealer_Product__c p : productsList) {
                        if(p.Quantity__c > p.Max_Items_Allowed__c) {
                                
                                this.error = this.error + '</br>' + p.Name;
                                flag = false;
                                
                        }
                        
                }
                // if(flag == false)this.error = 'Indsæt værdier for mindst et produkt';
                System.debug(' ------------------------- validateInput End -------------------------------');
                // All OK
                return flag;
        }
        
        private boolean validateInput1() {
                System.debug(' ------------------------- validateInput Start -------------------------------');
                Boolean flag = true;
                this.error = 'Du skal bestille mere end nul enheden, og klik derefter på leaving knappen';
                for(Dealer_Product__c p : productsList) {
                        if(p.Quantity__c == 0) {
                                this.error = this.error;
                                flag = false;
                        }else if(p.Quantity__c > 0) {
                                flag = true;
                                break;  
                        }
                        }
                                return flag;
                }
                        
        private boolean validateInput() {
                System.debug(' ------------------------- validateInput Start -------------------------------');
                Boolean flag = false;
                for(Dealer_Product__c p : productsList) {
                        if(p.Quantity__c > p.Max_Items_Allowed__c) {
                                this.error = 'Du har forsøgt at bestille flere enheder, end det tilladte maks (' + p.Name + ')';
                                flag = false;
                                return flag;
                        }
                        if(p.Quantity__c > 0){
                                flag = true;
                        }
                }
                if(flag == false)this.error = 'Indsæt værdier for mindst et produkt';
                System.debug(' ------------------------- validateInput End -------------------------------');
                // All OK
                return flag;
        }
        
        /**
         * Private helper method for initializing the application parameters/values.
         */
        private void initCustomSettings() {
        // Setup email recipients
        YouSeeCustomSettings__c cs = YouSeeCustomSettings__c.getValues('DealerWeb.Bestil_Varer.TO_ADDRESSES');
        String value;
    
        if(cs != null && cs.Setting_Value__c != null) {
                value = cs.Setting_Value__c;
                this.toAddresses = value.split(';');
               
        }
            // Setup email subject
           cs = YouSeeCustomSettings__c.getValues('DealerWeb.EMAIL_SUBJECT');
                if(cs != null && cs.Setting_Value__c != null) {
                    value = cs.Setting_Value__c;
                    this.emailSubject = value;
                }
        }

      /**
         * Private helper method for sending email.
         */
        private String sendEmail() {
                String orderNumber;
                if(this.toAddresses == null) {
                        System.debug('No recipients found');
                        return null;
                }
                integer i=1;
                dateTime dt = DateTime.now();
               
                // Generate emailBody based on products
                List<Dealer_ProductLineItems_Order__c> lineItemList = new List<Dealer_ProductLineItems_Order__c>();
                Dealer_Products_Order__c order = new Dealer_Products_Order__c();
                boolean orderCreated = false;
                
                if(!orderCreated)
                {
                    Integer hour = dt.hour() + 2;       
                    string format = dt.year() + '-' + dt.month() + '-' + dt.day() + ' ' + hour + ':' + dt.minute() + ':' + dt.second();
                    order.OrderDateTime__c = DateTime.valueof(format);
                    orderCreated = true;
                    insert order;
                    
                    System.debug('order.Name--->' + order);
                }
                 //Fetch the Delear Number
                
                Dealer_Products_Order__c d = [select name from Dealer_Products_Order__c where id=: order.Id limit 1];
                orderNumber = d.Name;                 
                string strBody='<html><head><title>Title of the document</title><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta></head><body>';
                strBody=strBody +'Bestilling af Forhandlervarer hos YouSee A/S <br/><br/>';
                strBody =strBody + 'Dato: ' + dt.day() + '.' + dt.month() + '.' + dt.year() + '<br/>';
                strBody =strBody + 'Forhandler oplysninger <br/>';
                strBody =strBody + 'Agentnr.:    ' + (objClass.dealerAccount.Dealer_Number__c==null?'':objClass.dealerAccount.Dealer_Number__c) + '<br/><font>';
                strBody =strBody + (objClass.street==''?'':objClass.street+',</font><br/>');
                strBody =strBody + (objClass.house==''?'':objClass.house+',');
                strBody =strBody + (objClass.door==''?'':objClass.door+',');
                strBody =strBody + (objClass.floor==''?'':objClass.floor+',');
                strBody =strBody + (objClass.entrance==''?'':objClass.entrance+',') + '<br/>';
                
                strBody =strBody + (objClass.side==''?'':objClass.side+',<br/>');
                strBody =strBody + (objClass.postCode==''?'':objClass.postCode + ' ');
                strBody =strBody + (objClass.town==''?'':objClass.town+'<br/>');
                
                strBody =strBody + '<br/>';
                strBody =strBody + '<br/>';
                strBody =strBody + '<br/>';
                strBody =strBody + '-------------------------------------------------------------------------------------------';
                strBody =strBody + '<br/>';
                strBody =strBody + '<br/>';
                strBody =strBody + 'Produkt oplysninger <br/> Køb af Forhandlervarer:';
                strBody =strBody + '<br/>';
                strBody =strBody + '<br/>';
                strBody =strBody + '<b>Order Number:</b> ' + orderNumber;
                strBody =strBody + '<p><Table width=80% border=1><tr><td width=5% bgcolor="#B2B2B2" /><td width=35% bgcolor="#B2B2B2" ><b>Produktnavn</b></td>';
                strBody =strBody + '<td width=15% bgcolor="#B2B2B2" ><b>Produktnr.</b></td>';
                strBody =strBody + '<td width=35% bgcolor="#B2B2B2" ><b>Beskrivelse </b></td>';
                strBody =strBody + '<td width=10% bgcolor="#B2B2B2" ><b>Antal</b></td></tr>';
                
              
                
                for(Dealer_Product__c p : productsList) {
                        // If quantity is 0 (zero) there is no need to include the product in the email 
                        if(p.Quantity__c <= 0 || p.Quantity__c == null) {
                                continue;
                        }
                        strBody=strBody + '<tr><td width=5%>'+ (i++) + '</td>';
                        strBody=strBody + '<td width=35%>'+ (p.Name==null?'-':p.Name) + '</td>';
                        strBody=strBody + '<td width=15%>'+ (p.Product_Number__c==null?'-':p.Product_Number__c) + '</td>';
                        strBody=strBody + '<td width=35%>'+ (p.Product_Descriptions__c==null?'-':p.Product_Descriptions__c) + '</td>';
                        strBody=strBody + '<td width=10%>'+ p.Quantity__c + '</td></tr>';
                        
                   // emailBody += (i++) + '\t' + p.Name + '\t\t\t' + p.Product_Number__c + '\t\t\t' + p.Product_Descriptions__c + '\t\t\t\t\t' + p.Quantity__c + '\n\r';   
                        
                        
                        // also update the Product_ordering object with the ordering data.
                        /****
                Product_Ordering__c prodOrderObj = new Product_Ordering__c();
                prodOrderObj.Quantity__c = p.Quantity__c;
                prodOrderObj.Product_Group__c = p.Product_Group__c;
                prodOrderObj.Product_Descriptions__c = p.Product_Descriptions__c;
                prodOrderObj.Product_Name__c = p.Name;
                ///prodOrderObj.Order_Date__c = Date.today();
                ///prodOrderObj.Dealer_Number__c = objClass.dealerAccount.Dealer_Number__c;
                insert prodOrderObj;
                ***/
              
                 
                Dealer_ProductLineItems_Order__c lineItem = new Dealer_ProductLineItems_Order__c();
                lineItem.Quantity__c = p.Quantity__c;
                lineItem.Product_Group__c = p.Product_Group__c;
                lineItem.Product_Description__c = p.Product_Descriptions__c;
                lineItem.Product_Name__c = p.Name;
                lineItem.Product_Number__c = p.Product_Number__c;
                lineItem.DealerOrderNumber__c = order.Id;
                lineItemList.add(lineItem);
                ///prodOrderObj.Order_Date__c = Date.today();
                ///prodOrderObj.Dealer_Number__c = objClass.dealerAccount.Dealer_Number__c;
                system.debug('### Records Inserted in Product_Ordering__c');
                }

                strBody=strBody + '</Table></body></html>';
                
                if(lineItemList.size()>0)
                 insert lineItemList;
              
                
                //added for template Id 
            //EmailTemplate templateid = [Select Id,Name,Subject,body from EmailTemplate];
            //System.debug('Template Id Is: ' + templateid);   
            //EmailTemplate templateId = [Select id from EmailTemplate where name = 'Waitlisted opportunity now open'];
            
                // Create email
            Messaging.SingleEmailMessage sem = new Messaging.SingleEmailMessage();
            sem.setUseSignature(false);
            sem.setCharset('UTF-8');
            //sem.setCharset('ISO-8859-1');
            sem.setToAddresses(this.toAddresses);
            sem.setSubject(orderNumber + ' ' +this.emailSubject);
            //sem.setTemplateId(templateid.Id);
            //sem.setTemplateId('01620000000Th3xAAC');
            sem.setHtmlBody('Varemodtagelse modtaget fra forhandler til vider behandling. Bestillingen er vedhæftet denne mail');
            Messaging.EmailFileAttachment emailattach = new Messaging.EmailFileAttachment();
            emailattach.setContentType('application/html');
            emailattach.setFileName('Bestil Varer'+ '.html');
            emailattach.setInline(false);
            System.debug('** Body Of Contents**'+ strBody);
            emailattach.Body = Blob.valueOf(strBody);
            System.debug('** Email Contents**'+ emailattach.Body);
            sem.setFileAttachments(new Messaging.EmailFileAttachment[] { emailattach});
            
            //sem.setPlainTextBody(this.emailBody);

                // Send email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { sem });
        //System.debug('*** Email Body ***'+ this.emailBody);
                // Return email body
       return emailBody;
       
        }

         /**
          * returns todays Date.
          */
         public String getLongDate() {
                String LongDate = ' ';
            Datetime cDT = System.now();
            LongDate = cDT.format('EEEE, MMMM d, yyyy');
            return LongDate;
        }

        
        public PageReference viewHistory() {
        System.debug('***Comes***');
        String newPageUrl ='/apex/ViewDealerOrderHistory';
        PageReference newPage = new PageReference(newPageUrl);
       
        return newPage;
        
    }
    
     
    
    public PageReference viewDealerProductSummary() {
         if(!this.validateInput2() || !this.validateInput1()) {
                        // Set error message and return to page
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, error);
                        ApexPages.addMessage(msg);
                        return null;
        }else{
        String newPageUrl ='/apex/DealerProductSummary';
        PageReference newPage = new PageReference(newPageUrl);
        return newPage;}
    }
    
   public List<c_dealerSummary> dealerSummary
    {   
        get {
        List<c_dealerSummary> dealerSummary = new List<c_dealerSummary>();
        
        c_dealerSummary obj = new c_dealerSummary();
        obj.title = 'Forhandler/Agent ID:';
        obj.value = objClass.dealerAccount.Dealer_Number__c;
        dealerSummary.add(obj);
        
        obj = new c_dealerSummary();
        obj.title = 'Navn:';
        obj.value = objClass.userContact.LastName;
        dealerSummary.add(obj);
        
        
        if(objClass.street!='')
        {
            obj = new c_dealerSummary();
            obj.title = 'Addresse:';       
            obj.value = objClass.street+' ';
            
        }
        
        obj.value = obj.value + (objClass.house==''|| objClass.house== null?'':' '+objClass.house);
        obj.value = obj.value + (objClass.door=='' || objClass.door== null?'':','+objClass.door);
        obj.value = obj.value + (objClass.floor=='' || objClass.floor== null?'':','+objClass.floor);
        obj.value = obj.value + (objClass.entrance==''?'':','+objClass.entrance);
        
        dealerSummary.add(obj);
        
        
        if(objClass.side!='')
        {
            obj = new c_dealerSummary();
            obj.title = '';
            obj.value = objClass.side+',';
            dealerSummary.add(obj);
        }
        
        
        
        obj = new c_dealerSummary();
        obj.title = 'Postnr/By:';
        obj.value = objClass.postCode;
        
        
        if(objClass.town!='')
        {
            obj.value += ' '+objClass.town;
        }
        
        dealerSummary.add(obj);
        
        return dealerSummary;
        }
    }
    
    public List<Dealer_Product__c> orderedProducts
    {
        get {
            
            List<Dealer_Product__c> ordProd = new List<Dealer_Product__c>();
            for(c_dealerProduct p : products)
            {
                List<Dealer_Product__c> dpList = p.dealerProduct;
                for(Dealer_Product__c dp : dpList)
                 if(dp.Quantity__c > 0)
                   ordProd.add(dp);
            }
            
            return ordProd;
        }
    }
    
    public pagereference backToDealerProductPage()
    {
        return page.DealerProductPage;
    }
    
    
    // Added for new button
    
    //public pagereference backToHistoryPage()
    //{
    //  return page.
    //}
    public pagereference refreshDataDealerProductPage(){
        PageReference pageRef = new PageReference('/apex/DealerProductPage');         
        pageRef.setRedirect(true);         
        return pageRef; 
        
    }
    
    
    public pagereference resetInputData()
    {
        System.debug(' ------------------- Inside Reset Data ------------------------');
        for(Dealer_Product__c p : productsList) {
            
        p.Quantity__c =0;
        }
        return null;
    }
    
    
    public class c_dealerSummary {
        public string title {get;set;}
        public string value {get;set;}
    }

}