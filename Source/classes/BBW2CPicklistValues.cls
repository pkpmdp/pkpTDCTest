public with sharing class BBW2CPicklistValues { 

    public static List<SelectOption>  getPlatform(){
        List<SelectOption> Options = new List<SelectOption>();
        Options.add(new SelectOption('','-Vælg-'));//TDC Changes for JIRA 1930 changed from None to Vælg
        Options.add(new SelectOption('PC/MAC','PC/MAC'));
        Options.add(new SelectOption('iPhone/iPad','iPhone/iPad'));
        Options.add(new SelectOption('Android mobil/tablet','Android mobil/tablet'));
        Options.add(new SelectOption('Playstation 3','Playstation 3'));
        Options.add(new SelectOption('Playstation 4','Playstation 4'));
        Options.add(new SelectOption('Smart TV - LG','Smart TV - LG'));
        Options.add(new SelectOption('Smart TV - Panasonic','Smart TV - Panasonic'));
        Options.add(new SelectOption('Smart TV - Philips','Smart TV - Philips'));
        Options.add(new SelectOption('Smart TV - Samsung','Smart TV - Samsung'));
        Options.add(new SelectOption('Smart TV - Sony','Smart TV - Sony'));
        return Options;
    }
    
    public static List<SelectOption>  getBrowserForPCMac(){
        List<SelectOption> Options = new List<SelectOption>();
        Options.add(new SelectOption('','-Vælg-'));//TDC Changes for JIRA 1930 changed from None to Vælg
        Options.add(new SelectOption('Google Chrome','Google Chrome'));
        Options.add(new SelectOption('Safari','Safari'));
        Options.add(new SelectOption('Internet Explorer','Internet Explorer'));
        Options.add(new SelectOption('Mozilla Firefox','Mozilla Firefox'));
        Options.add(new SelectOption('Anden','Anden'));
         Options.add(new SelectOption('EDGE','EDGE'));
        return Options;
    }
    
    public static List<SelectOption>  getOSForPCMac(){
     /*   List<SelectOption> Options = new List<SelectOption>();
        Options.add(new SelectOption('','-Vælg-'));//TDC Changes for JIRA 1930 changed from None to Vælg
        Options.add(new SelectOption('Windows 7','Windows 7'));
        Options.add(new SelectOption('Windows 8','Windows 8'));
         Options.add(new SelectOption('Windows 10','Windows 10'));
        
        Options.add(new SelectOption('Mac OS','Mac OS'));
        
        return Options;*/
         List<string> operatingSysList = new list<string>();
        Schema.DescribeFieldResult operatingField = Schema.SObjectType.Case.fields.BBW2C_Operating_System__c;
        List<schema.PicklistEntry> listOperating = operatingField.getPicklistValues();
        system.debug('listOperating '+listOperating);
        List<SelectOption> options = new List<SelectOption>();
        options.add(new selectoption('','-Vælg-'));
        for(schema.PicklistEntry oneOperating : listOperating)
        {
            //allCatgry.add(oneOperating.getvalue());
            options.add(new selectoption(oneOperating.getvalue(),oneOperating.getvalue()));      
        }
        system.debug('options '+options);
        return options;
    }
    
    public static List<SelectOption>  getProductForPCMac(){
        List<SelectOption> Options = new List<SelectOption>();
        Options.add(new SelectOption('','-Vælg-'));//TDC Changes for JIRA 1930 changed from None to Vælg
        Options.add(new SelectOption('Login','Login'));
        Options.add(new SelectOption('Brugeroprettelse','Brugeroprettelse'));
        Options.add(new SelectOption('Betaling','Betaling'));
        Options.add(new SelectOption('Afspilning','Afspilning'));
        Options.add(new SelectOption('Min konto','Min konto'));
        
        return Options;
    }
    public static List<SelectOption>  getProductForIPhone(){
        List<SelectOption> Options = new List<SelectOption>();
        Options.add(new SelectOption('','-Vælg-'));//TDC Changes for JIRA 1930 changed from None to Vælg
        Options.add(new SelectOption('Login','Login'));
        Options.add(new SelectOption('Brugeroprettelse','Brugeroprettelse'));
        Options.add(new SelectOption('Betaling','Betaling'));
        Options.add(new SelectOption('Afspilning via app','Afspilning via app'));
        Options.add(new SelectOption('Afspilning via Airplay','Afspilning via Airplay'));
        Options.add(new SelectOption('Afspilning via ChromeCast','Afspilning via ChromeCast '));
        Options.add(new SelectOption('Min konto','Min konto'));
        return Options;
    }
    
  public static List<SelectOption> getBBTypeForIpad(){
        List<SelectOption> Options = new List<SelectOption>();
        Options.add(new SelectOption('','-Vælg-'));//TDC Changes for JIRA 1930 changed from None to Vælg
        Options.add(new SelectOption('App','App'));
        Options.add(new SelectOption('Mobilwebsite','Mobilwebsite'));
        return Options;
    }
    
    public static List<SelectOption>  getProductForAndroid(){
        List<SelectOption> Options = new List<SelectOption>();
        Options.add(new SelectOption('','-Vælg-'));//TDC Changes for JIRA 1930 changed from None to Vælg
        Options.add(new SelectOption('Login','Login'));
        Options.add(new SelectOption('Brugeroprettelse','Brugeroprettelse'));
        Options.add(new SelectOption('Betaling','Betaling'));
        Options.add(new SelectOption('Afspilning via app','Afspilning via app'));
        Options.add(new SelectOption('Afspilning via ChromeCast','Afspilning via ChromeCast '));
        Options.add(new SelectOption('Min konto','Min konto'));
        return Options;
    }
    public static List<SelectOption>  getProductForPS3(){
        List<SelectOption> Options = new List<SelectOption>();
        Options.add(new SelectOption('','-Vælg-'));//TDC Changes for JIRA 1930 changed from None to Vælg
        Options.add(new SelectOption('Login','Login'));        
        Options.add(new SelectOption('Betaling','Betaling'));
        Options.add(new SelectOption('Afspilning','Afspilning'));
        Options.add(new SelectOption('Min konto','Min konto'));
        return Options;
    }
    
    public static List<SelectOption>  getAudVidMac(){
         List<SelectOption> Options = new List<SelectOption>();
         List<string> AudVidList = new list<string>();
        Schema.DescribeFieldResult AudVidField = Schema.SObjectType.Case.fields.BBW2C_Video_Audio__c;
        List<schema.PicklistEntry> listAudVid = AudVidField.getPicklistValues();
        system.debug('listOperating '+listAudVid);
        Options.add(new selectoption('','-Vælg-'));
        for(schema.PicklistEntry oneAudVid : listAudVid)
        {
            Options.add(new selectoption(oneAudVid.getvalue(),oneAudVid.getvalue()));      
        }
        return Options;
    }
    public static List<SelectOption>  getIntSupplMac(){
         List<SelectOption> Options = new List<SelectOption>();
         List<string> internetSuppList = new list<string>();
        Schema.DescribeFieldResult internetSuppField = Schema.SObjectType.Case.fields.BBW2C_Internet_supplier__c;
        List<schema.PicklistEntry> listInternetSupp = internetSuppField.getPicklistValues();
        system.debug('listOperating '+listInternetSupp);
        Options.add(new selectoption('','-Vælg-'));
        for(schema.PicklistEntry oneInternetSupp : listInternetSupp)
        {
            if(oneInternetSupp.getvalue() != 'TBA')
                Options.add(new selectoption(oneInternetSupp.getvalue(),oneInternetSupp.getvalue()));      
        }
        return Options;
    }
    public static List<SelectOption>  getIntConTypeMac(){
        List<SelectOption> Options = new List<SelectOption>();
        Options.add(new SelectOption('','-Vælg-'));//TDC Changes for JIRA 1930 changed from None to Vælg
        Options.add(new SelectOption('Kabel','Kabel'));
        Options.add(new SelectOption('Wifi','Wifi'));
        return Options;
    }
    
    public static List<SelectOption> getIntConTypeIphone(){
        List<SelectOption> Options = new List<SelectOption>();
        Options.add(new SelectOption('','-Vælg-'));//TDC Changes for JIRA 1930 changed from None to Vælg
        Options.add(new SelectOption('Mobilnetværk','Mobilnetværk'));
        Options.add(new SelectOption('Wifi','Wifi'));
        return Options;
    }
    
    public static List<SelectOption> getSmtTVUpdTV()
    {
        List<SelectOption> Options = new List<SelectOption>();
         List<string> SmartTvUpList = new list<string>();
        Schema.DescribeFieldResult SmartTvUpField = Schema.SObjectType.Case.fields.BBW2C_SmartTV_updated__c;
        List<schema.PicklistEntry> listSmartTvUp = SmartTvUpField.getPicklistValues();
        system.debug('listSmartTvUp '+listSmartTvUp);
        Options.add(new selectoption('','-Vælg-'));
        for(schema.PicklistEntry oneSmartTvUp : listSmartTvUp)
        {
            Options.add(new selectoption(oneSmartTvUp.getvalue(),oneSmartTvUp.getvalue()));   
        }
        return Options;
    }
    
    public Static List<SelectOption> getIntSupplTV()
    {
        List<SelectOption> Options = new List<SelectOption>();
         List<string> internetSuppList = new list<string>();
        Schema.DescribeFieldResult internetSuppField = Schema.SObjectType.Case.fields.BBW2C_Internet_supplier__c;
        List<schema.PicklistEntry> listInternetSupp = internetSuppField.getPicklistValues();
        system.debug('listOperating '+listInternetSupp);
        Options.add(new selectoption('','-Vælg-'));
        for(schema.PicklistEntry oneInternetSupp : listInternetSupp)
        {
            if(oneInternetSupp.getvalue() != 'TBA')
                Options.add(new selectoption(oneInternetSupp.getvalue(),oneInternetSupp.getvalue()));      
        }
        return Options;
    }
    
}