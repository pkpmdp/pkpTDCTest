public with sharing class ConsoleCustomerLogComponent_CT {
    public Account account {get; set;}
    public List<scs_SidebarWrapper> dataList {get; set;}
    public String jsonData {get; set;}
    public Id accountId{get;set;} 
    public String AccStrIdforLog{get;set;}
    public String strRelatedListURLId{get;set;}
    
    public ConsoleCustomerLogComponent_CT(){}
    
    public ConsoleCustomerLogComponent_CT(ApexPages.StandardController stdController) {
        
        account = (Account) stdController.getRecord();  
        accountId = account.id;
        dataList = new List<scs_SidebarWrapper> ();
        system.debug('=====accountId========='+accountId);
        init();
        
    }   

    public void init() {
        
        system.debug('=====in init=========');
        strRelatedListURLId = Label.Customer_Log_Lookup_field;
        System.debug('In init ++++++');
        // get list of Custom Setting objects
        Map<String, salesConsoleSidebar__c> settings = salesConsoleSidebar__c.getAll();
        Map<String, Schema.SObjectType> objectMap = Schema.getGlobalDescribe();
        Map<Schema.SObjectType, SalesConsoleSidebar__c> objects = new Map<Schema.SObjectType, SalesConsoleSidebar__c>();
        dataList = new List<scs_SidebarWrapper> ();
          
        for(salesConsoleSidebar__c scs : settings.values()) {
            System.debug('~~' + scs.name +' - '+ scs.Object_Name__c + ' - ' + scs.field_Set_Name__c);
            
            if(objectMap.containsKey(scs.Object_Name__c)) { 
                objects.put(objectMap.get(scs.Object_Name__c), scs);
            }   
        }
        // for each custom setting get fieldset labels and values
        Set<Schema.SObjectType> keys = objects.keySet();
        for(Schema.SObjectType key : keys) {
            System.debug(LoggingLevel.INFO, '~~ Key ['+key+']'); 
        
            SalesConsoleSidebar__c customSetting = (SalesConsoleSidebar__c)objects.get(key);
            FieldSet fieldSet = key.getDescribe().fieldSets.getMap().get(customSetting.Field_Set_Name__c);
        
            List<String> fieldLabels = new List<String>();
            List<String> fieldNames = new List<String>();
        
            String query = 'SELECT ';
            for(Schema.FieldSetMember fsm : fieldSet.getFields()) {
                fieldLabels.add(fsm.getLabel());
                fieldNames.add(fsm.getFieldPath());
                query += fsm.getFieldPath() + ', ';
            }
            fieldNames.add('id');
            fieldLabels.add('id');
            query += 'Id FROM '+key+ ' WHERE '+ customSetting.Parent_Object_Field_Name__c +' = \''+accountId+'\' ORDER BY CreatedDate Desc LIMIT 3 ';
            System.debug('~~ query ['+query+']');    
            try {   
                List<SObject> sObjects = Database.query(query);
                dataList.add(buildData(key, fieldNames, fieldLabels, sObjects));
            } catch (QueryException qe) {
                System.debug('No objects!');
            }   
        }   
        //dataList.sort();
        system.debug('=====dataList========'+dataList);
        jsonData = JSON.serialize(dataList);
    }
    

    public scs_SidebarWrapper buildData(Schema.SObjectType objType, List<String> fieldNames, List<String> fieldLabels, List<SObject> objects) {
        
        String pluralLabel = objType.getDescribe().getLabelPlural();
        scs_SidebarWrapper wrapper = new scs_SidebarWrapper(pluralLabel);
        wrapper.fieldLabels = fieldLabels;
        wrapper.fieldNames = fieldNames;
        
        List<List<Object>> dataValues = new List<List<Object>>();
        
        List<Map<String,Object>> moreValues = new List<Map<String,Object>>();
        
        for(Sobject obj : objects) {
            List<Object> fieldValues = new List<Object>();
            Map<String, Object> valueMap = new Map<String, Object>();
            for(Integer i=0 ; i<fieldNames.size() ; i++) {
                
                String fieldName = fieldNames.get(i);
                String fieldLabel = fieldLabels.get(i);
                String dateStr='';
                if(fieldName == 'Date__c'){
                    Object val3 = obj.get(fieldName);
                    dateStr = String.valueOf(val3);
                    if(dateStr != null && dateStr != ''){
                        dateStr = dateStr.substring(0,10);
                    }
                }
                Object val = obj.get(fieldName);
                fieldValues.add(val);
                if(val == null) {
                    val = ' ';
                }
                if(fieldName == 'Date__c'){
                    val = dateStr;
                }
                valueMap.put(fieldName, val);
            }
            moreValues.add(valueMap);
            dataValues.add(fieldValues);
        }
        
        wrapper.dataValues = moreValues;
        wrapper.fieldValues = dataValues;
        return wrapper;
    }
    
    public pagereference invoke(){
      accountId = ID.valueOf(AccStrIdforLog);
      system.debug('accountId in constr console Log: '+AccStrIdforLog);
      dataList = new List<scs_SidebarWrapper>();
      init();       
      return null;
    }
}