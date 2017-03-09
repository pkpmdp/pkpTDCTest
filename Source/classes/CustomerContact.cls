/************************************************************************************************
*             <Class Name>			: CustomerContact
*             <@Author Name>		: Amrish
*
*             <Business reason for creating this web service in one line.>
*             : Used for Party Actor Functionality wherein Kiss UI is Calling below web service for fetching Customer Contact Role records of salesforce
*             @ChangeList
*             Issue#                   Date                      Comment            
*			  Internal review		   7/10/13					 Using String class function to check null & not null(Changes Done by Amrish)
*************************************************************************************************/

@RestResource(urlMapping='/customercontactrole/*')
global class CustomerContact {
    
    @HttpGet
    global static List<CustomerContactRoleWrapper> getCustomerContactRoleDetails() {
        String cableUnitNumber;
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');    
        String ysContactRecordType = ysRecords.YS_Contact_Record_Type__c;
        String cableUnitNo =  req.params.get('cableunitno');
        
        if(String.isNotBlank(cableUnitNo)){
            cableUnitNumber = CustomerTeamDetails.modifyCableUnitNo(cableUnitno);
        }else{
            return new List<CustomerContactRoleWrapper>();
        }
        List<Account_Contact_Role__c> customerContactRoleList = [Select a.Title__c,a.Contact__r.RecordTypeId,a.CableUnit__c,a.Role__r.Name,a.Role__r.Vis_i_kontrakt__c,a.Role__r.Code__c,a.Contact__c,a.Contact__r.Phone,a.Contact__r.Email,a.Contact__r.MobilePhone,a.Total_Insight__c,a.Contact__r.Company_Customer__c,a.Contact__r.Title,a.Contact__r.Name,a.Contact__r.FirstName,a.Contact__r.LastName,a.Contact__r.HomePhone,a.Contact__r.Street_P__c,a.Contact__r.Street_P__r.PO_Box__c,a.Contact__r.Street_P__r.Town__c,a.Contact__r.Street_P__r.Postcode__c,a.Contact__r.Street_P__r.Door_No__c,a.Contact__r.Street_P__r.House_No__c,a.Contact__r.Street_P__r.Entrance__c,a.Contact__r.Street_P__r.Street__c,a.Contact__r.Street_P__r.Floor__c,a.Contact__r.Street_P__r.Side__c,a.Contact__r.Street_P__r.District__c,a.Contact__r.Street_P__r.External_Id__c From Account_Contact_Role__c a where a.customer__r.Customer_No__c =:cableUnitNumber and a.Contact__r.RecordTypeId =: ysContactRecordType];
        if(customerContactRoleList != null && customerContactRoleList.size() > 0){
            return mapToContactRoleList(customerContactRoleList);
        }else{
            return new List<CustomerContactRoleWrapper>();
        }
    }
    
    public static List<CustomerContactRoleWrapper> mapToContactRoleList(List<Account_Contact_Role__c> acrList){
		    List<CustomerContactRoleWrapper> listWrapper = new List<CustomerContactRoleWrapper>();
		    for(Account_Contact_Role__c acr : acrList){
		        CustomerContactRoleWrapper acrWrapper = new CustomerContactRoleWrapper();
		        acrWrapper.cableUnitNumber = acr.CableUnit__c;
			        if(String.isNotBlank(acr.Total_Insight__c)){
			        	acrWrapper.numberOfMagazies = Integer.valueOf(acr.Total_Insight__c);
			        }
			        acrWrapper.contactId = acr.Contact__c;
		            acrWrapper.title = acr.Contact__r.Title;
		            acrWrapper.email = acr.Contact__r.Email;
		            acrWrapper.fullName = acr.Contact__r.Name;
		            acrWrapper.firstName = acr.Contact__r.FirstName;
		            acrWrapper.lastName = acr.Contact__r.LastName;  
		            acrWrapper.organization = acr.Contact__r.Company_Customer__c;
		            acrWrapper.workPhone = acr.Contact__r.Phone;
		            acrWrapper.mobilePhone = acr.Contact__r.MobilePhone;
		            acrWrapper.privatePhone = acr.Contact__r.HomePhone;
		            acrWrapper.roleId = acr.Role__c;
		            acrWrapper.roleCode = acr.Role__r.Code__c;
		            acrWrapper.roleName = acr.Role__r.Name;
		            acrWrapper.streetName = acr.Contact__r.Street_P__r.Street__c;
		            acrWrapper.floor = acr.Contact__r.Street_P__r.Floor__c;
		            acrWrapper.doorNo = acr.Contact__r.Street_P__r.Door_No__c;   
		            acrWrapper.entrance = acr.Contact__r.Street_P__r.Entrance__c;
		            acrWrapper.houseNo = acr.Contact__r.Street_P__r.House_No__c;
		            acrWrapper.postCode = acr.Contact__r.Street_P__r.Postcode__c;
		            acrWrapper.town =  acr.Contact__r.Street_P__r.Town__c;
		            acrWrapper.POBoxNr =  acr.Contact__r.Street_P__r.PO_Box__c;
		            acrWrapper.locality = acr.Contact__r.Street_P__r.District__c;
		            acrWrapper.addressId = acr.Contact__r.Street_P__r.External_Id__c;
		            acrWrapper.visKontrakt = acr.Role__r.Vis_i_kontrakt__c;
		            listWrapper.add(acrWrapper);
	   		 }
	   		 return listWrapper;
	}
	
	global class CustomerContactRoleWrapper {
		   public String cableUnitNumber;
		   public Integer numberOfmagazies;
		   public String contactId;
		   public String title;
		   public String email;
		   public String fullName;
		   public String firstName;
		   public String lastName;
		   public String organization;
		   public String workPhone;
		   public String mobilePhone;
		   public String privatePhone;
		   public String roleCode;
		   public String roleName;
		   public String roleId;  
		   public String streetName;   
		   public String floor;
		   public String doorNo;
		   public String entrance;
		   public String houseNo;
		   public String postCode;    
		   public String town;
		   public String POBoxNr;
		   public String locality;
		   public String addressId;
		   public Boolean visKontrakt;
	}
	
}