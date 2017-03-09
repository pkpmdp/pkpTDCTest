/*******************************************************************************************************
* @Class        DealerwebSearch_Util
* @author       Capgemini India Pvt.Ltd
* @date         17 October 2013
* @description: This is the utility class which is used to find the addresses and display the customers 
*               present on the give address.
* @Version:     Version 1.0
* @Invocation:  The class methods are invocated from DealerProductPageController3.          
********************************************************************************************************/
public class DealerwebSearch_Util {
    
    /**
    * @method     : findCityName
    * @Inputs     : String pinNumber
    * @Return     : String cityName
    * @Description: This method is used to find the name of the city for a given postal code.
    *               The city is then displayed on a visual force page namely DealerCustomerSearch.
    * @Version 1.0: Implemented the above mentioned task.   
    * @Invocation : The method is invocated from DealerProductPageController3.
    */
    public String findCityName(String pinNumber){
        system.debug('pinNumber in DealerwebSearch_Util class------------------'+pinNumber);
        String cityName='';
        List<Address__c> townName = [Select a.Town__c From Address__c a where Postcode__c =:pinNumber limit 1];
        system.debug('TownName  in DealerwebSearch_Util class------------------'+townName);
        if (townName!=null && townName.size()==1){
            cityName = townName[0].Town__c;
        }else{
            cityName = '@@##';
        }
        return cityName;
    }
    
    /**
    * @method     : findStreets
    * @Inputs     : String street,String searchPostNrText       
    * @Return     : String streetSuggestion
    * @Description: This method is used to display the street suggestions on a visual force page namely DealerCustomerSearch.
    * @Version 1.0: Implemented the above mentioned task.   
    * @Invocation : The method is invocated from DealerProductPageController3.
    */
    public String findStreets(String street,String searchPostNrText){
       system.debug('street in DealerwebSearch_Util class------------------'+street);
       boolean flag = true;
       String streetSuggestion = '[';
       for(AggregateResult sl:[Select a.Street__c From Address__c a where a.Postcode__c = :searchPostNrText and a.Street__c LIKE :street group by Street__c] ){
            streetSuggestion+='"'+(String)sl.get('Street__c')+'",';
            flag=false;
       }
       streetSuggestion= streetSuggestion.subString(0,streetSuggestion.length()-1); 
       if(flag){
           streetSuggestion = '[';
       }
       streetSuggestion+=']';
       system.debug('streetSuggestion in DealerwebSearch_Util class---- '+streetSuggestion);
       return streetSuggestion;
    }
    
    /**
    * @method     : searchAddress
    * @Inputs     : String streetName,String searchPostNrText,String houseNo
    * @Return     : List<Address__c> addrs
    * @Description: This method is used to search the addresses associated to the given street name and post number.
    * @Version 1.0: Implemented the above mentioned task.   
    * @Invocation : The method is invocated from DealerProductPageController3.
    */
    public List<Address__c> searchAddress(String streetName,String searchPostNrText,String houseNo){
        system.debug('Debug in DealerwebSearch_Util class searchAddress method streetName = '+streetName+' searchPostNrText = '+searchPostNrText+' houseNo = '+houseNo);
        //Action_Flag__c != 'D' condition added for SPOC-980 
        //Action_Flag__c != 'E' condition added for DW-763, SF-1388
        List<Address__c> addrs = [select External_Id__c,Door_No__c,Street__c,house_No__c,Floor__c, postcode__c, town__c, entrance__c from Address__c
                                      where Street__c =: streetName and Postcode__c =:searchPostNrText and 
                                      house_No__c =: houseNo and Action_Flag__c != 'D' and Action_Flag__c != 'E' ORDER BY Floor__c,entrance__c,Door_Number_Dev__c];                                      
        
         system.debug('addrs in DealerwebSearch_Util class searchAddress method------------------->'+addrs);
         return addrs;
    }
    
   
    /**
    * @method     : selectAnAddress
    * @Inputs     : String streetName,String searchPostNrText,String houseNo
    * @Return     : List<Address__c> addrs
    * @Description: This method is used to search the addresses associated to the given street name and post number.
    * @Version 1.0: Implemented the above mentioned task.   
    * @Invocation : The method is invocated from DealerProductPageController3.
    */
    public Address__c selectAnAddress(String amsId){        
        Address__c  addr = [Select a.Town__c, a.Street__c, a.Postcode__c, a.House_No__c,a.District__c, 
                a.Floor__c, a.Entrance__c, a.Door_No__c, (Select Id,  Name, INSTALLATION_ID__c, Installation_Status_Code__c, Status__c, Start_Date__c, 
                Move_Flag__c, Location__c From Installations__r) From Address__c a where a.External_Id__c=:amsId limit 1];
                
        return addr;                             
    }
    
    /**
    * @method     : getnetInstallationsOnAddress
    * @Inputs     : Address__c  addr
    * @Return     : Map<String,Net_Installations__c> netInstallMap
    * @Description: This method is used to get the installations associated to an address.
    * @Version 1.0: Implemented the above mentioned task.   
    * @Invocation : The method is invocated from DealerProductPageController3.
    */
    public Map<String,Net_Installations__c> getnetInstallationsOnAddress(Address__c  addr){
        Map<String,Net_Installations__c> netInstallMap = new Map<String,Net_Installations__c>();
        List<Net_Installations__c> netInstall = addr.Installations__r;
        for(Net_Installations__c net : netInstall){
          netInstallMap.put(net.INSTALLATION_ID__c,net);
        }
        return netInstallMap;
    }
    /**
    * @method     : activeOffnetCustomers
    * @Inputs     : String amsId
    * @Return     : List<DealerCustomerPOJO> custLst
    * @Description: This method is used to get the list of offnet customers on a given address.
    * @Version 1.0: Implemented the above mentioned task.   
    * @Invocation : The method is invocated from DealerProductPageController3.
    */
    public List<DealerCustomerPOJO> activeOffnetCustomers(String amsId){
         /**List<Account> accList = [Select Id, PersonEmail,Billing_Rating_Text__c, Phone, LastName, FirstName , Name, Customer_No__c 
                                   from Account where Street_YK__r.External_Id__c =:amsId];*/
          List<Account> accList = [Select Id, PersonEmail,Billing_Rating_Text__c, Phone, LastName, FirstName , Name, Customer_No__c,
                                   Home_Phone__c,PersonMobilePhone,PersonHomePhone 
                                   from Account where (Street_YK__r.External_Id__c =:amsId AND Customer_type__c !='Organiseret')];
          
          system.debug('customer size is - '+accList.size());
          List<DealerCustomerPOJO> custLst = new  List<DealerCustomerPOJO>();
          if (accList.size()>0) {
                DealerCustomerPOJO cust = new DealerCustomerPOJO();
                for (Account customerDetail : accList){
                    system.debug('customerDetail.Customer__r.Customer_No__c is  - '+customerDetail.Customer_No__c);
                    if(customerDetail.Customer_No__c != null && customerDetail.Customer_No__c != ''){
                        cust = new DealerCustomerPOJO();
                        cust.customerNumber = customerDetail.Customer_No__c;
                        cust.sfdcID = customerDetail.Id;
                        cust.firstName = customerDetail.FirstName;
                        cust.lastName = customerDetail.LastName;
                        //cust.phone= customerDetail.Phone;
                        //Added for 831
                        cust.phone= customerDetail.PersonHomePhone;
                        cust.mobilePhone = customerDetail.PersonMobilePhone;
                        cust.customerName= customerDetail.Name;
                        cust.installationID = '0';
                        System.debug('cust.installationID->'+cust.installationID);
                        cust.conformEmail=customerDetail.PersonEmail;
                        cust.email=customerDetail.PersonEmail;
                       if('Almindelig' == customerDetail.Billing_Rating_Text__c || 'Ukendt' == customerDetail.Billing_Rating_Text__c){
                            system.debug('######################### INSIDE ALMINDELIG ####################### ');
                            cust.credit = false;
                        }else{
                            cust.credit = true;
                        }  
                        System.debug(' CUSTOMER CREDIT RATING VALUE is ##################-------------->'+cust.credit);               
                        custLst.add(cust);
                        system.debug('custLst is------------------------------------------------###################'+custLst);
                    }
                }
          }
          return custLst;
    }
    
    public List<DealerCustomerPOJO> activeOnNetCustomersList{get;set;}
    public List<DealerCustomerPOJO> inActiveOnNetCustomersList{get;set;}
    /**
    * @method     : onNetCustomers
    * @Inputs     : String amsId
    * @Return     : List<DealerCustomerPOJO> activeOnNetCustomersList
    * @Description: This method is used to get the list of on net customers on a given address.
    * @Version 1.0: Implemented the above mentioned task.   
    * @Invocation : The method is invocated from DealerProductPageController3.
    */
    public  List<DealerCustomerPOJO> onNetCustomers(String amsId){
         /**
         List<Customer_Installation_Address__c> customers = [Select c.Customer__c,c.Active_Sub__c,c.Customer__r.PersonEmail,c.customer__r.Billing_Rating_Text__c, c.Name, c.Installation_Address_External_ID__c,c.Address__r.House_No__c, 
                c.Address__r.Postcode__c,c.Address__r.Town__c,c.Customer__r.Phone, c.Customer__r.LastName, c.Customer__r.FirstName , 
                c.Customer__r.Name,c.Customer__r.Customer_No__c,
                Installation_ID__c, c.Address__r.External_Id__c  From Customer_Installation_Address__c c 
                where c.Address__r.External_Id__c =:amsId 
                AND (c.Customer__r.BillingRating__c != '0' OR c.Active_Sub__c = true OR c.Active_sub__c = false)];
          */
        
         List<Customer_Installation_Address__c> customers = [Select c.Customer__c,c.Active_Sub__c,c.Customer__r.PersonEmail,c.customer__r.Billing_Rating_Text__c, c.Name, c.Installation_Address_External_ID__c,c.Address__r.House_No__c, 
                c.Address__r.Postcode__c,c.Address__r.Town__c,c.Customer__r.Phone, c.Customer__r.LastName, c.Customer__r.FirstName , 
                c.Customer__r.Name,c.Customer__r.Customer_No__c,
                Installation_ID__c, c.Address__r.External_Id__c,
                Customer__r.PersonMobilePhone,Customer__r.PersonHomePhone  
                From Customer_Installation_Address__c c 
                where (c.Address__r.External_Id__c =:amsId AND c.customer__r.Customer_type__c !='Organiseret') 
                AND (c.Customer__r.BillingRating__c != '0' OR c.Active_Sub__c = true OR c.Active_sub__c = false)];
                    
        system.debug('customer size is - '+customers.size());
        List<DealerCustomerPOJO> custLst = new  List<DealerCustomerPOJO>();
        activeOnNetCustomersList = new List<DealerCustomerPOJO>();
        inActiveOnNetCustomersList = new List<DealerCustomerPOJO>();
        if (customers.size()>0) {
            DealerCustomerPOJO cust = new DealerCustomerPOJO();
            for (Customer_Installation_Address__c customerDetail : customers){
                system.debug('customerDetail.Customer__r.Customer_No__c is  - '+customerDetail.Customer__r.Customer_No__c);
                if(customerDetail.Customer__r.Customer_No__c != null && customerDetail.Customer__r.Customer_No__c != ''){
                    cust = new DealerCustomerPOJO();
                    cust.customerNumber = customerDetail.Customer__r.Customer_No__c;
                    cust.sfdcID = customerDetail.Customer__c;
                    cust.firstName = customerDetail.Customer__r.FirstName;
                    cust.lastName = customerDetail.Customer__r.LastName;
                    //cust.phone= customerDetail.Customer__r.Phone;
                    //Added for 831
                    cust.phone= customerDetail.Customer__r.PersonHomePhone;
                    cust.mobilePhone = customerDetail.Customer__r.PersonMobilePhone;
                    cust.customerName= customerDetail.Customer__r.Name;
                    cust.installationID = customerDetail.Installation_ID__c;
                    System.debug('cust.installationID->'+cust.installationID);
                    if (customerDetail.Customer__r.PersonEmail!=null){
                        cust.conformEmail=customerDetail.Customer__r.PersonEmail;
                        cust.email=customerDetail.Customer__r.PersonEmail;                    
                        } else {
                        cust.conformEmail=customerDetail.Customer__r.PersonEmail;
                        cust.email=customerDetail.Customer__r.PersonEmail;
                    }
                    system.debug('customerDetail.Customer__r.PersonEmail ' +customerDetail.Customer__r.PersonEmail);
                    //Updated for JIRA DEALERWEB-613                       
                    if('Almindelig' == customerDetail.customer__r.Billing_Rating_Text__c || 'Ukendt' == customerDetail.customer__r.Billing_Rating_Text__c){ 
                        cust.credit = false;
                        System.debug(' CUSTOMER CREDIT RATING VALUE is ##################-------------->'+cust.credit);     
                    }else{
                        cust.credit = true;
                    } 
                    //Updated for JIRA DEALERWEB-613                                  
                    custLst.add(cust);
                    system.debug('custLst is------------------------------------------------###################'+custLst);
                    
                    // Modified for DW - 770
                    system.debug('################### active sub: ' +customerDetail.Active_sub__c );
                    system.debug('################### customer number: ' +customerDetail.Customer__r.Customer_No__c);
                    if(customerDetail.Active_sub__c)
                        activeOnNetCustomersList.add(cust);
                    else if(!customerDetail.Active_sub__c)
                        inActiveOnNetCustomersList.add(cust); 
              }
            }
        }
      return custLst;
  }
}