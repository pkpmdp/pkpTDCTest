public class VideoHelpLinkCC{
    public Video_Message__c vidMes{get;set;}
    public String salesSelection{get;set;}
    public String selectedHeadline{get;set;}
    public list<String> helpTipLinks{get;set;}
    public String actimoURL {get;set;}
    public String actimoURL_SH {get;set;}
    public string baseURL ='';
    public final String KEY = '9a77cbb3-dfc1-47a9-93af-8ac75587210d';
    public Boolean showFrame{get;set;}
    public Boolean showFrame_SH{get;set;}
    public Boolean showHeadline{get;set;}
    
    public VideoHelpLinkCC(){
        vidMes = new Video_Message__c();
        helpTipLinks = new list<String>();
        salesSelection = '';
        selectedHeadline = '';
        showFrame = false;
        showFrame_SH =false;
        showHeadline = false;
        system.debug('***check lang***'+ system.label.cancel);
     }
    public List<SelectOption> getMessageOptions(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Video_Message__c.Sales_Events__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
            if(f.getvalue()== 'Before')
                options.add(new SelectOption(f.getValue(),System.Label.Before));
            else if(f.getValue()== 'After')
                options.add(new SelectOption(f.getValue(), System.Label.After));
         }
         //SPOC-2392>
        if(System.label.Switch_Hardware_Enable=='TRUE'){
            options.add(new SelectOption('Switch hardware', System.Label.Switch_hardware));
        }
        return options;
        //EOC SPOC-2392    
    }
    
    /*
    public List<SelectOption> getPopulateSalesEventNames(){
        List<SelectOption> options = new List<SelectOption>();
        for(Video_Message__c vm : [SELECT id,Headline_on_video__c,Help_Tips__c FROM Video_Message__c WHERE Sales_Event__c = : salesSelection]){
            if(String.isNotBlank(vm.Headline_on_video__c) && String.isNotBlank(vm.Help_Tips__c)){
                options.add(new SelectOption(vm.id,vm.Headline_on_video__c));
                helpTipLinks.add(vm.Help_Tips__c);
            }
            
        }
        return options;
    }
    *///SPOC-2301 START
    public list<Video_Message__c> getVMList(){
        System.debug('Check1'+salesSelection);
        list<Video_Message__c> vmList = new list<Video_Message__c>();
        for(Video_Message__c vm : [SELECT id,Headline_on_video__c,Help_Tips__c,Message_Id__c FROM Video_Message__c WHERE Sales_Events__c INCLUDES(:salesSelection ,'Before;After;Switch hardware','After;Before;Switch hardware','Switch hardware;After;Before','Switch hardware;Before;After') ORDER BY Headline_on_video__c]){
            vmList.add(vm);
        }
        return vmList;
     }
    //SPOC-2301 END
     public void generateURL()
     {
            String accId = '';
          if(String.isNotBlank(ApexPages.currentPage().getParameters().get('accId'))){
              accId = ApexPages.currentPage().getParameters().get('accId');
          }
          Account acc = new Account();
          if(String.isNotBlank(accId)){
               acc = [Select Customer_No__c, Name, PersonMobilePhone, PersonEmail from Account where Id=:accId];
          }         
            User u = [SELECT Id,MId__c FROM USER WHERE Id = : userInfo.getUserId()];
         System.debug('Inside');
         baseURL = Actimo_CS__c.getInstance('Actimo_Base_URL').Value__c;          
         actimoURL = baseURL;
          actimoURL+= '?api-key='+KEY;
          actimoURL+= '&emailenabled=1';
          actimoURL+= '&emailrequired=0';
          actimoURL+= '&name='+EncodingUtil.urlEncode(acc.Name,'UTF-8' );
          if(acc.PersonEmail != null)
              actimoURL+= '&email='+acc.PersonEmail;
          if(acc.PersonMobilePhone != null)
              actimoURL+= '&phonenumber='+acc.PersonMobilePhone;
                 if(u.MID__c != null)
              actimoURL+= '&ref='+u.MID__c+','+acc.Customer_No__c+',';
          actimoURL+= '&sendmore=1';
          // assigning message id
          String messageid = ''; // to get the message code from params
          messageid = Apexpages.currentPage().getParameters().get('msgCode');
          actimoURL+='&message='+messageid;
          showFrame = true;
           showFrame_SH = false;
          System.debug('*****actimoURL*****'+actimoURL);
     }
    public void generateURLForSwitchHardware()
     {
          String accId = '';
          if(String.isNotBlank(ApexPages.currentPage().getParameters().get('accId'))){
              accId = ApexPages.currentPage().getParameters().get('accId');
          }
          Account acc = new Account();
          if(String.isNotBlank(accId)){
               acc = [Select Customer_No__c, Name, PersonMobilePhone from Account where Id=:accId];
          }         
            User u = [SELECT Id,MId__c FROM USER WHERE Id = : userInfo.getUserId()];
            System.debug('Inside');
         baseURL = Actimo_CS__c.getInstance('Actiomo_Switch_Hardware_URL').Value__c;          
         actimoURL_SH = baseURL;
          actimoURL_SH+= '?api-key='+KEY;
          actimoURL_SH+= '&name='+EncodingUtil.urlEncode(acc.Name,'UTF-8' );
        if(acc.Customer_No__c!= null)
              actimoURL_SH+= '&Customer_No__c='+acc.Customer_No__c; 
          if(acc.PersonMobilePhone != null)
              actimoURL_SH+= '&phonenumber='+acc.PersonMobilePhone; 
          showFrame_SH = true; 
          showHeadline = false;
          showFrame =false;
          System.debug('*****actimoURL*****'+actimoURL_SH);
     }
    public void resetShowFrame(){
        showFrame = false;
        showHeadline = true;
        showFrame_SH = false;
       }
}