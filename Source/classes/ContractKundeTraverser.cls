@RestResource(urlMapping='/customer/*')
global class ContractKundeTraverser {
    
    @HttpGet
    global static AccountContainer getAction(){
        String action = RestContext.request.params.get('action');
        if(String.isBlank(action)){
            return new AccountContainer();
        }
        if('getKontraktKunde'.equalsIgnoreCase(action)){
            return getYSKontraktDetails();
        }
        return null;
    }   
    
    global static AccountContainer getYSKontraktDetails() {
        System.debug('###Called');
        YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');    
        String ysContactRecordType = ysRecords.YS_Contact_Record_Type__c;
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String cableUnitno = req.params.get('cableunitno');
        if(String.isNotBlank(cableUnitno)){
                while(cableUnitno.length() < 10){
                    cableUnitno = '0' + cableUnitno;
                }
        }else{
        	System.debug('####Inside$$$$$');
        	return new AccountContainer();
        }
        System.debug('#####cableUnitno'+cableUnitno);
        List<Account> accList = [Select Name, Cable_Unit__c, Anlaeg_No__c, ParentId, Id, Cable_Unit__r.Name, Street_YK__r.External_Id__c, Active__c, PO_Box__c, PO_Box_alt__c, CA_Arrears_Code__c, CA_Debit_Code__c,AddressId__c, Kontraktkunde__c, Kontraktkunde__r.Name, Kontraktkunde__r.AddressId__c, Kontraktkunde__r.Active__c, Kontraktkunde__r.PO_Box_alt__c, Kontraktkunde__r.CA_Debit_Code__c, Kontraktkunde__r.CA_Arrears_Code__c,Kontraktkunde__r.Street_Yk__r.External_Id__c,Kontraktkunde__r.Type,Type From Account where Cable_Unit_No__c =: cableUnitno];
        if(accList != null && accList.size() > 0){
            return getMapToAccountList(accList);
        }else{
            return new AccountContainer();
        }
        return null;
    }
    
    global static AccountContainer getMapToAccountList(List<Account> accountList){
        //AccountContainer listWrapper = new AccountContainer();
        AccountContainer accWrapper = new AccountContainer();
            for(Account acc : accountList){
                //AccountContainer accWrapper = new AccountContainer();
                System.debug('$$$acc.Kontraktkunde__c'+acc.Kontraktkunde__c);
                if(acc.Kontraktkunde__c != null){
                    accWrapper.id = acc.Kontraktkunde__c;
                    accWrapper.organization = acc.Kontraktkunde__r.Name;
                    accWrapper.active = acc.Kontraktkunde__r.Active__c;
                    accWrapper.poBoxNr = acc.Kontraktkunde__r.PO_Box_alt__c;
                    accWrapper.debitorAccount = acc.Kontraktkunde__r.CA_Debit_Code__c;
                    accWrapper.paymentCode = acc.Kontraktkunde__r.CA_Arrears_Code__c;
                    accWrapper.kontractKunde = acc.Kontraktkunde__r.Type;
                    /*accWrapper.id = acc.Id;
                    accWrapper.organization = acc.Kontraktkunde__r.Name;
                    accWrapper.active = acc.Active__c;
                    accWrapper.poBoxNr = acc.PO_Box_alt__c;
                    accWrapper.debitorAccount = acc.CA_Debit_Code__c;
                    accWrapper.paymentCode = acc.CA_Arrears_Code__c;*/
                    System.debug('###Inside'+acc.Kontraktkunde__r.AddressId__c);
                    //if(acc.Kontraktkunde__c != null && acc.Kontraktkunde__c != ''){
                        if(acc.Kontraktkunde__r.Street_Yk__r.External_Id__c != null && acc.Kontraktkunde__r.Street_Yk__r.External_Id__c != '')
                            accWrapper.addressID = Long.valueOf(acc.Kontraktkunde__r.Street_Yk__r.External_Id__c);
                   	   
                }else{
                    accWrapper.id = acc.Id;
                    accWrapper.organization = acc.Cable_Unit__r.Name;
                    accWrapper.active = acc.Active__c;
                    accWrapper.poBoxNr = acc.PO_Box_alt__c;
                    accWrapper.debitorAccount = acc.CA_Debit_Code__c;
                    accWrapper.paymentCode = acc.CA_Arrears_Code__c;
                    accWrapper.kontractKunde = acc.Type;
                    if(acc.Street_YK__r.External_Id__c != null && acc.Street_YK__r.External_Id__c != '')
                        accWrapper.addressID = Long.valueOf(acc.Street_YK__r.External_Id__c);
                }
                //listWrapper.add(accWrapper);
            }
        return accWrapper;
    }
    
    global class AccountContainer{
        public String Id;
        public String organization;
        public Boolean active;
        public String poBoxNr;
        public String debitorAccount;
        public String paymentCode;
        public Long addressId;
        public String kontractKunde;
        //public String addressId;
        
    }
    
}