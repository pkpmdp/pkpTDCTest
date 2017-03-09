public with sharing class clsCustomerRelatedAddressesYKController {
    private Account account;
    private List<DisplayAddress> addresses;
    public Account acc{get;set;}
//SPOC-2294 START
     public Id currentId{get; set;}
//SPOC-2294 END
    //constructor
    public clsCustomerRelatedAddressesYKController(ApexPages.StandardController controller) {
        this.account = (Account) controller.getRecord();
        System.debug('#####account'+this.account);
    }
//SPOC-2294 START
    public clsCustomerRelatedAddressesYKController(){}
//SPOC-2294 END
    public String getAccountId() {
        return account.Id;
    }
    public List<DisplayAddress> getAddresses(){
//SPOC-2294 START
        if(currentId != null){
            system.debug('==in here 4===='+currentId);
        	this.account = [SELECT Id,Name FROM Account WHERE Id=: currentId];
        } //SPOC-2294 END
        List<Customer_Related_Address__c> relatedAddresses = [select Installation_Address__c, Juridical_Address__c, Payer_Address__c, Installations_Status__c, Cable_Type__c from Customer_Related_Address__c where Customer__c=:account.id];
        return populateDisplayAddressList(relatedAddresses);
    }
    //Codes added for SPOC-2234
    public String getPreInstalledModem(){
        String preInstalledModemStr = '';
        List<String> cuNoList = new List<String>();
        Account acct = [select Street_YK__c, Street_YK__r.Cableunit_number__c From Account where Id=:account.Id];
        System.debug('within getPreInstalledModem method');
        if(acct != null && acct.Street_YK__c != null && acct.Street_YK__r.Cableunit_number__c != null){
            if(acct.Street_YK__r.Cableunit_number__c.contains(',')){
                cuNoList = acct.Street_YK__r.Cableunit_number__c.split(',');
                List<Cable_Unit__c> cableunitList = [select Pr_installeret_udstyr_p_anl_g__c, Cable_Unit_No__c from Cable_Unit__c where Cable_Unit_No__c in :cuNoList];
                if(cableunitList != null && cableunitList.size() > 0){
                    for(Cable_Unit__c cableunit : cableunitList){
                        if(cableunit.Pr_installeret_udstyr_p_anl_g__c != null){
                            preInstalledModemStr = ' <' + cableunit.Pr_installeret_udstyr_p_anl_g__c + ' På anlæg ' + cableunit.Cable_Unit_No__c + ' > \n';
                            System.debug('*****preInstalledModemStr*****' + preInstalledModemStr);
                        }
                    }
                    if(preInstalledModemStr != '') {
                        preInstalledModemStr = preInstalledModemStr.subString(0, preInstalledModemStr.length() - 2);
                    }
                }
            } else {
                Cable_Unit__c cableunit = [select Pr_installeret_udstyr_p_anl_g__c, Cable_Unit_No__c from Cable_Unit__c where Cable_Unit_No__c = :acct.Street_YK__r.Cableunit_number__c];
                if(cableunit != null && cableunit.Pr_installeret_udstyr_p_anl_g__c != null){
                    preInstalledModemStr = 'På anlæg ' + cableunit.Cable_Unit_No__c + ': ' + cableunit.Pr_installeret_udstyr_p_anl_g__c + '\n';
                    System.debug('*****preInstalledModemStr*****' + preInstalledModemStr);
                }
            }
        }
        return preInstalledModemStr;
    }
    private List<DisplayAddress> populateDisplayAddressList(List<Customer_Related_Address__c> relatedAddresses){
        
        List<DisplayAddress> result = new List<DisplayAddress>();
        List<DisplayAddress> installAddr = new List<DisplayAddress>();
        List<DisplayAddress> billingAddr = new List<DisplayAddress>();
        List<DisplayAddress> juridicAddr = new List<DisplayAddress>();
        List<DisplayAddress> payerAddr = new List<DisplayAddress>();
        List<DisplayAddress> usageAddr = new List<DisplayAddress>();
List<String> addressIDs = new List<String>();
// Added to display address of type Installation from different objects
        acc = [select Id,Net_Installation__c,Billing_Address__c, Billing_Address__r.Full_Address__c, Street_YK__c, Street_YK__r.Full_Address__c,Net_Installation__r.Address__c,Net_Installation__r.Installation_Status__c,Net_Installation__r.Cable_Unit_No__c,Net_Installation__r.Location__c From Account where Id=:account.Id];
        List<Customer_Installation_Address__c> custInstAddr = [select Active_Sub__c, Installation_ID__c, Customer__c,Address__c from Customer_Installation_Address__c where Customer__c =:acc.Id and Address__c=:acc.Street_YK__c order by LastModifiedDate desc];
        List<Net_Installations__c> net = new List<Net_Installations__c>();
        //List<Installation__c> installations = new List<Installation__c>();
        List<String> extInstalId = new List<String>();
        List<String> tempextInstId = new List<String>();
        List<String> actualList = new List<String>();
        List<String> addressInstId = new List<String>();
        Map<String,Net_Installations__c> netSet = new Map<String,Net_Installations__c>();
        //Map<String,Installation__c> instSet = new Map<String,Installation__c>();
        if(custInstAddr != null && custInstAddr.size() > 0){
            for(Customer_Installation_Address__c cia : custInstAddr){
                addressInstId.add(cia.Address__c);
                if(cia.Active_Sub__c == true){
                        System.debug('Inside if****'+cia);
                        extInstalId.add(cia.Installation_ID__c);
                        break;
                }else{
                        System.debug('Inside else ****'+cia);
                        if(tempextInstId.isEmpty()){
                            tempextInstId.add(cia.Installation_ID__c);
                        }   
                }
                System.debug('%%%%%%%%%addressInstId%%%'+addressInstId);
            }
        }
        if(extInstalId != null && extInstalId.size() > 0){
            actualList.addAll(extInstalId);
        }else{
            actualList.addAll(tempextInstId);
        }
        System.debug('@@@@@@actualList'+actualList+'@@@@@@addressInstId%%%'+addressInstId);
        /*if(custInstAddr.size() == 0){
            custInstAddr = [select Active_Sub__c, Installation_ID__c, Customer__c from Customer_Installation_Address__c where Customer__c =:acc.Id and Address__c=:acc.Street_YK__c order by LastModifiedDate desc limit 1];
        }
        if(custInstAddr.size() > 0){
            for(Customer_Installation_Address__c cust : custInstAddr){
                System.debug('Inside for****');
                extInstalId.add(cust.Installation_ID__c);
            }
        }*/
        System.debug('%%actualList'+actualList.size());
        if(actualList.size()>0){    
            net = [select Address__c,Status__c,Cable_Unit_no__c,Cable_Unit__c,Location__c,INSTALLATION_ID__C,Cable_Unit__r.Cable_Type__c from Net_Installations__c where INSTALLATION_ID__C =:actualList and Address__c =: addressInstId];
            System.debug('@@@@@@@net .size()'+net.size()+'@@@@@@@Net Installations'+net);
            //installations = [SELECT Id, Installation_ID__c, Cable_Unit_no__c, Cable_Type__c FROM Installation__c where Installation_ID__c =:actualList and Address__c =: addressInstId];
            //System.debug('@@@@@@@installations size()'+installations.size()+'@@@@@@@installations records'+installations);
        }
        if(net.size() > 0){
            for(Net_Installations__c n : net){
                addressIDs.add(n.Address__c);
                netSet.put(n.INSTALLATION_ID__C,n);
            }
        }
        /*if(installations.size() > 0){
            for(Installation__c i : installations){
                instSet.put(i.Installation_ID__c,i);
            }
            
        }*/
        /*
        for(Customer_Related_Address__c relatedAddress:relatedAddresses){
            
            if (relatedAddress.Installation_Address__c!=null){
                addressIDs.add(relatedAddress.Installation_Address__c);
            }
            if (relatedAddress.Juridical_Address__c!=null){
                addressIDs.add(relatedAddress.Juridical_Address__c);
            }
            if (relatedAddress.Payer_Address__c!=null){
                addressIDs.add(relatedAddress.Payer_Address__c);
            }
        }*/
        List<Address__c> addresses = [select Id, Name , Street__c, Full_Address__c , Cableunit_number__c from Address__c where Id IN :addressIDs];
        System.debug('@@actualList.size()'+actualList.size()+'@@@@@net.isEmpty()'+net.isEmpty());
        if(actualList.size() > 0 && net.size() > 0){
            for(String s : actualList){
                installAddr.add(new DisplayAddress(netSet.get(s).Address__c,Label.Customer_Address_Type_Installation,netSet.get(s).Status__c,netSet.get(s).Cable_Unit__r.Cable_Type__c,netSet.get(s).Cable_Unit_no__c,netSet.get(s).Location__c ,addresses));
                System.debug('%%%%%%% Inside all%%%%%%%'+installAddr);
            }
        }/*else if(actualList.size() > 0 && net.size() > 0 && installations.isEmpty()){
            for(String s : actualList){
                installAddr.add(new DisplayAddress(netSet.get(s).Address__c,Label.Customer_Address_Type_Installation,netSet.get(s).Status__c,netSet.get(s).Location__c ,addresses));
                System.debug('%%%%%%% Inside Net Installation%%%%%%%'+installAddr);
            }
        }else if(actualList.size() > 0 && net.isEmpty() && installations.size() > 0){
            for(String s : actualList){
                installAddr.add(new DisplayAddress(Label.Customer_Address_Type_Installation,instSet.get(s).Cable_Type__c,instSet.get(s).Cable_Unit_no__c,addresses));
                System.debug('%%%%%%% Inside Installation__c%%%%%%%'+installAddr);
            }   
        }*/
        /*if(extInstalId.size()>0){
            for(String s : extInstalId){
                installAddr.add(new DisplayAddress(netSet.get(s).Address__c,Label.Customer_Address_Type_Installation,netSet.get(s).Status__c,instSet.get(s).Cable_Type__c,instSet.get(s).Cable_Unit_no__c,netSet.get(s).Location__c ,addresses));
            }
        }*/
        
        /*
        for(Customer_Related_Address__c relatedAddress:relatedAddresses){
            if (relatedAddress.Installation_Address__c!=null){
                installAddr.add(new DisplayAddress(relatedAddress.Installation_Address__c,Label.Customer_Address_Type_Installation,relatedAddress.Installations_Status__c,relatedAddress.Cable_Type__c, addresses));
            }
            if (relatedAddress.Juridical_Address__c!=null){
                juridicAddr.add(new DisplayAddress(relatedAddress.Juridical_Address__c,Label.Customer_Address_Type_Legal,null,null,null,null,addresses));
            }
            if (relatedAddress.Payer_Address__c!=null){
                payerAddr.add(new DisplayAddress(relatedAddress.Payer_Address__c,Label.Customer_Address_Type_Billing,null,null,null,null,addresses));
            }
        }*/
        System.debug('@@@@@@@@@@@juridicAddr'+juridicAddr+'!!!!!!!!!Size'+juridicAddr.size());
        
        if(juridicAddr.size() == 0){
            List<Address__c> addressesJur = [select Id, Full_Address__c, Cable_type__c, Anaeleg_Status__c, Street__c From Address__c where Id=:acc.Street_YK__c];
            if(addressesJur.size() > 0){
                juridicAddr.add(new DisplayAddress(addressesJur[0].Id,Label.Customer_Address_Type_Legal,null,null,null,null,addressesJur));  
            }
        }
        //SPOC-2294 START
        if(billingAddr.size() == 0){
            List<Address__c> addressesbill = [select Id, Full_Address__c, Cable_type__c, Anaeleg_Status__c, Street__c From Address__c where Id=:acc.Billing_address__c];
            if(addressesbill.size() > 0){
                billingAddr.add(new DisplayAddress(addressesbill[0].Id,Label.Customer_Address_Type_Billing_Address,null,null,null,null,addressesbill));  
            }
        }//SPOC-2294 END
        /* displaying status from installation object
        if(installAddr.size() == 0){
            List<Customer_Installation_Address__c> cias = [Select Id, Address__c, Customer__c, Installations_Status__c, LastModifiedDate From Customer_Installation_Address__c where Active_Sub__c =: true and Address__c=:acc.Street_YK__c order by LastModifiedDate desc];
            
            System.debug('----------- Inside Loop 1 ----------------');
            if(cias.size() > 0){
                Customer_Installation_Address__c cia = cias[0];
                System.debug('----------- Inside Loop 2 ----------------');
                Address__c address = [select Id, Full_Address__c, Cable_type__c, Cableunit_number__c From Address__c where Id=:cia.Address__c];
                
                System.debug('----------- Address ----------------'+ cias[0].Address__c);
                System.debug('----------- Cable unit Number ----------------'+ address.Cableunit_number__c );
                System.debug('----------- Cable Type ----------------'+ address.Cable_type__c);
                
                List<Installation__c> installationList = [Select i.Installations_Status__c, i.Cable_Unit_no__c, i.Cable_Type__c, i.Address__c 
                From Installation__c i where  i.Address__c  =: cias[0].Address__c and i.Cable_Unit_no__c =: address.Cableunit_number__c 
                and i.Cable_type__c =: address.Cable_type__c]; 
                
                System.debug('----------- installationList Size ----------------'+ installationList.size());
                
                String cableUnitType = '';
                
                String installationStatus = '';
                if(installationList != null & installationList.size() > 0){
                    
                    System.debug('----------- Inside Installation -------------------');
                    
                    
                    for(Installation__c installation : installationList){
                        
                        System.debug('----------- Inside Installation Loop  1-------------------');
                        
                        if(installation.Cable_Type__c != null){
                            cableUnitType = installation.Cable_Type__c;
                        }   
                        
                        System.debug('----------- Inside Installation Loop  2-------------------'+installation.Installations_Status__c);
                        
                        if(installation.Installations_Status__c != null && !''.equals(installation.Installations_Status__c)){
                            System.debug('----------- Inside Installation Loop  3-------------------');
                              if(!installationStatus.contains(installation.Installations_Status__c)){   
                                  if(installationStatus == ''){
                                        System.debug('----------- Inside Installation Loop  4-------------------');
                                        installationStatus += installation.Installations_Status__c;
                                  }else{
                                    System.debug('----------- Inside Installation Loop  5------------------');
                                        installationStatus += ',' + installation.Installations_Status__c;
                                  } 
                             }
                         }      
                    }
                }
                System.debug('----------- Inside Installation Loop  6------------------');
                DisplayAddress dia = new DisplayAddress();
                dia.address = address;
                dia.addressType=Label.Customer_Address_Type_Installation;
                dia.installationsStatus =  installationStatus ;//cia.Installations_Status__c;
                dia.cableType = cableUnitType; //address.Cable_type__c;
                dia.cableUnitNo = address.Cableunit_number__c;
                installAddr.add(dia);
            } 
         }*/
        result.addAll(installAddr);
        result.addAll(juridicAddr);
        result.addAll(billingAddr);
        result.addAll(payerAddr);
        result.addAll(usageAddr);
        return result;
    }
    public class DisplayAddress {
        public DisplayAddress(){}
    // working one
        public DisplayAddress(String addressId,String addressType,String installationsStatus, String cableType, String cableUnitNo,String location, List<Address__c> addresses){
            this.address = getAddressFromList(addresses,addressId);
            this.addressType=addressType;
            this.installationsStatus = installationsStatus;
            this.cableType = cableType;
            this.cableUnitNo = cableUnitNo;
          //  setCableUnitNo();
            this.location = location;
        }
    /* Not using
    public DisplayAddress(String addressType1, String cableType1, String cableUnitNo1 , List<Address__c> addresses1){
            this.address = getAddressFromList(addresses1);
            this.addressType=addressType1;
            this.cableType = cableType1;
            this.cableUnitNo = cableUnitNo1;
          //  setCableUnitNo();
        }
        public DisplayAddress(String addressId2,String addressType2,String installationsStatus2, String location1, List<Address__c> addresses2){
            this.address = getAddressFromList(addresses2,addressId2);
            this.addressType=addressType2;
            this.installationsStatus = installationsStatus2;
            this.location = location1;
        }*/
        public Address__c getAddressFromList(List<Address__c> addresses,String addressId){
             System.debug('%%addresses2 parameter%%'+addresses);
             if(addresses.size() > 0){    
                 for(Address__c address:addresses){
                     if(address.Id == addressId){
                         return address;
                     }
                 }
             }    
             return null;
        }
        /*public Address__c getAddressFromList(List<Address__c> addresses1){
            System.debug('%%addresses1 parameter%%'+addresses1);
            if(addresses1.size() > 0){
                for(Address__c ad : addresses1){
                    return ad;
                }
            }    
            return null;
        }*/
        public void setCableUnitNo(){
            this.cableUnitNo = (this.address != null && 
                addressType==Label.Customer_Address_Type_Installation) ?  
                    this.address.Cableunit_number__c : null;            
        }
        public Address__c address {get;set;}
        public String addressType {get;set;}
        public String installationsStatus{get;set;}
        public String cableType{get;set;}
        public String cableUnitNo{get;set;}
        public String location{get;set;}
    }
}