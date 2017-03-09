public class UrlEncodingController {
    private final Net_Installations__c installation;
    //public Customer_Subscription__c cusSubscription;
    private String link;
    private String CustomerNo;
    List<Customer_Subscription__c> cusSubscription = new List<Customer_Subscription__c>();
    List <string> progpack = new List<string>();
    public String programpack;
    
    //private final String[] programpakke_GP = new String[]{'Agent1 med inst.', 'GP', 'Grundpakke'};
    //private final String[] programpakke_MP = new String[]{'Agent 2 med inst.,Agent1 med inst.', 'Agent2 m. inst', 'GP,LT', 'Grundpakke,LT', 'LT,GP', 'LT,Grundpakke', 'MP', 'MP,GP', 'Mellempakke', 'Grundpakke,Lille Tillægspk', 'Lille Tillægspk,Grundpakke'};
    //private final String[] programpakke_FP = new String[]{'Agent 2 med inst.', 'Agent1 med inst.,Agent3 m.inst', 'Agent3 m.inst', 'Agent3 m.inst,Agent1 med inst.', 'FP', 'FP,GP', 'FP,MP', 'GP,FP', 'MP,ST', 'ST,MP', 'Fuldpakke' , 'Fuldpakke,Grundpakke', 'Fuldpakke,Mellempakke' , 'GP,TP', 'Mellempakke,Stor Tillægspakke','Grundpakke,Tillægspakke'};
    
    private final String[] programpakke_GP = new String[]{'Grundpakke', 'Mellempakke med Bland Selv', 'Fuldpakke med Bland Selv','Agentpakke 1','Agentpakke 2 med Bland Selv','Agentpakke 3 med Bland selv','Lille Tillægspakke Bland Selv','Tillægspakke med Bland Selv','Grundpakke med TV-boks',''};
    private final String[] programpakke_MP = new String[]{'Mellempakke', 'Agentpakke 2', 'Mellempakke med TV-boks','Lille Tillægspakke'};
    private final String[] programpakke_FP = new String[]{'Fuldpakke', 'Agentpakke 3', 'Fuldpakke med TV-boks','Tillægspakke'};
    private final String Ukendt = '4';
    private final String FP = '3';
    private final String MP = '2';
    private final String GP = '1';
    private final String DI = '6';
    // SPOC-2351 START
    public List<String> calloutParameter = new List<String>();
    public List<String> calloutValue = new List<String>();

    public String getLink(){
        return link;
    }   
    
    public UrlEncodingController() {
        //cusSubscription = new Customer_Subscription__c();
        installation = [Select Id, Cable_Unit__c, Name, INSTALLATION_ID__c, PACKAGE_SELECTION__c, Cable_Unit__r.Docsis_Type__c, Cable_Unit__r.Key_Box__c, Cable_Unit__r.HF_no__c, Cable_Unit_No__c, Cable_Unit__r.Cable_Type__c, Address__r.Postcode__c, Address__r.Name, Address__r.House_No__c, Address__r.Entrance__c, Address__r.Floor__c, Address__r.Side__c, Address__r.Door_No__c, Address__r.External_Id__c, Cable_Unit__r.Customer__r.Customer_No__c, Cable_Unit__r.Signal_Source__c, Cable_Unit__r.Service_for_hold__c,Cable_Unit__r.CA_Ownership_Code__c from Net_Installations__c where Id =:ApexPages.currentPage().getParameters().get('id')];
        /* commented for SF-1478 Installation Merge
        installation = [select Package_selection__c, Name, Key_box_placement__c, Id, HF_no__c, Cable_Unit_no__c, Cable_Type__c, Box_No__c, Address__r.Postcode__c, Address__r.Name, Address__r.House_No__c, Address__r.Entrance__c, Address__r.Floor__c, Address__r.Side__c, Address__r.Door_No__c, Customer__r.Customer_No__c, Service_for_hold__c,Address__r.External_Id__c from Installation__c where Id =:ApexPages.currentPage().getParameters().get('id')];*/
        CustomerNo =ApexPages.currentPage().getParameters().get('cus');
        try{
             //cusSubscription = [SELECT Id, Name, Product__c, Product__r.Name, Installation_Id__c, Customer__c, Customer_Number__c FROM Customer_Subscription__C WHERE Installation_Id__c = :Installation.INSTALLATION_ID__c AND Customer_Number__c =:CustomerNo];
                 cusSubscription = [SELECT Id, Name, Product__c, Product__r.Name, Installation_Id__c, Customer__c, Customer_Number__c FROM Customer_Subscription__C WHERE Installation_Id__c = :Installation.INSTALLATION_ID__c];
            
            for(Customer_Subscription__c custSub :cusSubscription){
                programpack = custSub.Product__r.Name;
                progpack.add(programpack);
           }
            
        }catch(Exception e){
        }
       link = createLink();
    }
    
    public String createLink() {
        String params = ''; 
         //SPOC-2351 START
        calloutParameter.add('null');
        calloutValue.add(installation.Cable_Unit_no__c);
        String digitalRes;
        if(!Test.isRunningTest()){
            digitalRes = clsConnectionUtils_Admin.callout1('DigitalFilter',calloutParameter,calloutValue);
        }else{
            digitalRes = '<Digitalfilter xmlns="http://yousee.dk/stag/fokus"><Digitalfilter><ANLAEGS_NR>4005322</ANLAEGS_NR><INSTAL_SEQ_NR>1350604</INSTAL_SEQ_NR><AMS_ADR_NR>7364833</AMS_ADR_NR><TV_PAKKE>DI</TV_PAKKE></Digitalfilter></Digitalfilter>';
        }
        calloutParameter = new List<String>();
        calloutValue = new List<String>();
        Map<String, string> digitalFilterInstallation = new Map<String, String>();
        digitalFilterInstallation = OasisCallouts.digitalXMLPaeser(digitalRes);
        system.debug('Digital '+digitalFilterInstallation);
        //SPOC-2351 END
        if(installation.Address__r.Postcode__c != null){
            params = params + 'postnr='+ installation.Address__r.Postcode__c;
        }
        if(installation.Cable_Unit_no__c != null){
            params = params + '&anlaegsnummer=' + installation.Cable_Unit_no__c;
        }
        if(CustomerNo != null){
            params = params + '&kundenr=' + CustomerNo;
        }
        if(installation.Cable_Unit__r.Docsis_Type__c != null){
            params = params + '&docsis=' + EncodingUtil.urlEncode(installation.Cable_Unit__r.Docsis_Type__c, 'ISO-8859-1');
        }
        String noegleboks ='';
        if(installation.Cable_Unit__r.Key_Box__c != null && installation.Cable_Unit__r.Key_Box__c.length() > 0){
            noegleboks=installation.Cable_Unit__r.Key_Box__c;
        } else{
            noegleboks='-';
        }
        
        params= params+ '&noegleboks=' + EncodingUtil.urlEncode(noegleboks, 'ISO-8859-1'); //Danish characters are taken care by  ISO-8859-1 spoc-2027
        
        //params = params + '&noegleboks=' + (installation.Cable_Unit__r.Key_Box__c != null && installation.Cable_Unit__r.Key_Box__c.length() > 0 ? installation.Cable_Unit__r.Key_Box__c: '-');
        
        params = params + '&system=SPOC';
        
        // serviceforhold
        String serviceforhold = '0';
        if(installation.Cable_Unit__c != null && installation.Cable_Unit__r.CA_Ownership_Code__c != null){
            if(installation.Cable_Unit__r.CA_Ownership_Code__c.equals('0')){
                serviceforhold = '1';
            } else if(installation.Cable_Unit__r.Service_for_hold__c != null && installation.Cable_Unit__r.Service_for_hold__c.equals('Ja') && installation.Cable_Unit__r.CA_Ownership_Code__c.equals('1')){
                serviceforhold = '2';
            } else if(installation.Cable_Unit__r.Service_for_hold__c != null && installation.Cable_Unit__r.Service_for_hold__c.equals('Nej') && installation.Cable_Unit__r.CA_Ownership_Code__c.equals('1')){
                serviceforhold = '3';
            }
        }
        params = params + '&serviceforhold=' + serviceforhold;
        
        
        /*String serviceforhold = '0';
        List<Cable_Unit__c> cableUnits = [Select c.Cable_Unit_No__c, c.CA_Ownership_Code__c From Cable_Unit__c c where c.Cable_Unit_No__c =:installation.Cable_Unit_no__c];
        if (cableUnits != null && cableUnits.size() > 0){
            if(cableUnits[0] != null && cableUnits[0].CA_Ownership_Code__c != null){  
                if(cableUnits[0].CA_Ownership_Code__c.equals('0')){
                    serviceforhold = '1';
                } else if (installation.Cable_Unit__r.Service_for_hold__c != null && installation.Cable_Unit__r.Service_for_hold__c.equals('Ja') && cableUnits[0].CA_Ownership_Code__c.equals('1')) {
                    serviceforhold = '2';
                } else if (installation.Cable_Unit__r.Service_for_hold__c != null && installation.Cable_Unit__r.Service_for_hold__c.equals('Nej') && cableUnits[0].CA_Ownership_Code__c.equals('1')) {
                    serviceforhold = '3';
                }  
            }
        }
        
        params = params + '&serviceforhold=' + serviceforhold;*/

        // hf_nummer
        if(installation.Cable_Unit__r.HF_no__c != null){
            params = params + '&hf_nummer=' + installation.Cable_Unit__r.HF_no__c;
        }
        
        // programpakke
          
        String programpakke = null;
        //SUPPORT-6299 START
        if(progpack != null){
            if (programpakke == null && CheckProgramPakke(programpakke_FP, progpack)){
            programpakke = FP;
          }

         else if (programpakke == null && CheckProgramPakke(programpakke_MP, progpack)){
            programpakke = MP;
          }
         else if (programpakke == null && CheckProgramPakke(programpakke_GP, progpack)){
            programpakke = GP;
          }
        }else if(digitalFilterInstallation.get(installation.INSTALLATION_ID__c) != null){
            programpakke = DI;
        }
        
        if (programpakke == null){
            programpakke = Ukendt;
        }
        //SOPPURT - 6299 END
        
       /* if(cusSubscription != null && cusSubscription.Product__c != null){
          if (programpakke == null && CheckProgramPakke(programpakke_GP, cusSubscription.Product__r.Name)){
            programpakke = GP;
          }
          if (programpakke == null && CheckProgramPakke(programpakke_MP, cusSubscription.Product__r.Name)){
            programpakke = MP;
          }
          if (programpakke == null && CheckProgramPakke(programpakke_FP, cusSubscription.Product__r.Name)){
            programpakke = FP;
          }
        }else if(digitalFilterInstallation.get(installation.INSTALLATION_ID__c) != null){
            programpakke = DI;
        }
        
        if (programpakke == null){
            programpakke = Ukendt;
        }
        */
        
        params = params + '&programpakke=' + programpakke;
        
        // fejladresse
        String fejladresse = '';
        
        if(installation.Address__r.Name != null) {
            fejladresse = fejladresse + installation.Address__r.Name.toUpperCase() + ' ';   
        }
        
        if(installation.Address__r.House_No__c != null) {
            fejladresse = fejladresse + installation.Address__r.House_No__c;    
        }
        
        if(installation.Address__r.Entrance__c != null) {
            fejladresse = fejladresse + ' '+ installation.Address__r.Entrance__c;
        }
        
        if(installation.Address__r.Floor__c != null || installation.Address__r.Door_No__c != null) {
            fejladresse = fejladresse + ',';    
        }

        if(installation.Address__r.Floor__c != null) {
            fejladresse = fejladresse + ' '+ installation.Address__r.Floor__c;
        }
        /*if(installation.Address__r.Side__c != null) {
            fejladresse = fejladresse + ' '+ installation.Address__r.Side__c;
        }*/
        if(installation.Address__r.Door_No__c != null) {
            fejladresse = fejladresse + ' DØR: ' + installation.Address__r.Door_No__c;
        }
        
        params = params + '&fejladresse=' +  EncodingUtil.urlEncode(fejladresse, 'ISO-8859-1');
        
        params = params + '&amsid=' + installation.Address__r.External_Id__c;
        params = params + '&modul=Inst.seq: '+ installation.INSTALLATION_ID__c; // spoc-2475
        return System.Label.BierLink + params; //test bier url
    }
    // SUPPORT - 6299
    private Boolean CheckProgramPakke(List<String> valsPakke, list<String> Package_selection){
        Set<String> setPackage = new Set<String>(Package_selection);
      for(String tmpPakke : valsPakke){
          if(setPackage.contains(tmpPakke)){
              return true;
          }
      }
      return false;
    }
    /*private Boolean CheckProgramPakke(List<String> valsPakke, String Package_selection){
      for(String tmpPakke : valsPakke){
        if (tmpPakke == Package_selection){
          return true;
        }
      }
      return false;
    }*/
}