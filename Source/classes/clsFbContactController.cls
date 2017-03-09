public class clsFbContactController extends FacebookLoginController {

    public String postedMessage {get;set;}
    public String fbUserFullName {get;set;}
    public String firstName {get;set;}
    public String lastName {get;set;}
    public String email {get;set;}
    //public String customerNumber {get;set;}
    public String comment {get;set;}
    
    //public String selectedValue {get;set;}
    private sf4twitter__Twitter_Conversation__c conversation;
    private String conversationId;

	//private static String CASE_PRODUCT='Forum Support YOT'; //Test
	private static String CASE_PRODUCT='YOT Forum Support'; //Production
	
    public static String FB_PARAM_SUFFIX='#_=_';
    public static String FB_UID_ME='me';
    transient public FacebookUser user {get;set;}

    public String searchPostNrText{get;set;} 
    public String searchStreetText{get;set;}
    public String searchHouseText{get;set;}
    public String cityName{get;set;}
    public String streetSuggestion{get;set;}
    public String streetNumbersSuggestion{get;set;}
    public String searchAddressMsg {get;set;}
    private Boolean showAddressPicklists;
    public Boolean getShowAddressPicklists(){
        return this.showAddressPicklists;
    }
    private Boolean isStreetValidated;
    public Boolean getIsStreetValidated() {
        return this.isStreetValidated;
    }
    private Boolean isHouseValidated;
    public Boolean getIsHouseValidated() {
        return this.isHouseValidated;
    }
    public List<SelectOption> floorAndDoorItems{get;set;}
    public String selectedFloorAndDoor{get; set;}
    public String addressJsonResponse{get; set;}
    private map<String, List<String>> houseTextMap;
    private map<String, List<String>> floorAndDoorMap;
    private set<String> houseNrSet;
    
    private String simpleAddressExtId;
    
    private String baseURL = URL_Prefix__c.getOrgDefaults()!=null?URL_Prefix__c.getOrgDefaults().Internal__c:''; 
    //'https://cs16.salesforce.com';//URL.getSalesforceBaseUrl().toExternalForm();

    private Boolean isTest = false;    

public clsFbContactController() {
    houseTextMap = new map<String, List<String>>();
    floorAndDoorMap = new map<String, List<String>>();
    houseNrSet = new set<String>();
    conversationId= ApexPages.currentPage().getParameters().get('state');
    if (conversationId!=null){
        System.debug('conversationId='+conversationId);
        if (conversationId.endsWith(FB_PARAM_SUFFIX)){
            conversationId=conversationId.substring(0, conversationId.length()-FB_PARAM_SUFFIX.length());
            System.debug('conversationId='+conversationId);
        }
        List<sf4twitter__Twitter_Conversation__c> convList = [select sf4twitter__Message__c, sf4twitter__Author_Real_Name__c,sf4twitter__Author_Name__c, sf4twitter__Author_External_Id__c, sf4twitter__Case__c, FbFormIsSubmitted__c from sf4twitter__Twitter_Conversation__c where id=:conversationId limit 1];
        if (convList.size()==1){
            conversation = convList[0];
            postedMessage = conversation.sf4twitter__Message__c;
            if (postedMessage!=null && postedMessage.length()>500){
                postedMessage = postedMessage.substring(0, 400) + ' ...';
            } 
            fbUserFullName = conversation.sf4twitter__Author_Real_Name__c;
        }
    }
}
    
public PageReference initialize() {
    if (!isTest){
        Map<String, String> headers = ApexPages.currentPage().getHeaders();
        if (headers.containsKey('User-Agent')) {
            String agent = headers.get('User-Agent');
            if (agent.startsWith('facebookexternalhit/1.1')) {
                return null;
            }
        }
        
        PageReference superLogin = super.login();
        if(superLogin!=null){
            return superLogin;
        }
        
        //same facebook identity check and update of email address. 
        user = new FacebookUser(FacebookToken.getAccessToken(), FB_UID_ME);
        System.debug('Facebook userID:'+user.id);
        if (conversation==null || user==null || conversation.sf4twitter__Author_External_Id__c != ('FB_'+user.id)){
            //if conversation not found or not same user
            return Page.FBUnauthorizedPage;
        }
    }

    /*
    if (conversation.sf4twitter__Case__c!=null || (l!=null && l.IsConverted)){
        return Page.FbConfirmationPage;
    }*/
    
    //if form is already submitted then redirect to confirmation page
    //if lead doesnot exist or is already converted then redirect to confirmation page
    List<Lead> leadList = [select id, IsConverted from Lead where sf4twitter__Fcbk_User_Id__c=:conversation.sf4twitter__Author_External_Id__c limit 1];
    Lead l; 
    if (leadList.size()==1){
        l =leadlist[0];
    }
    
    //if form was already submitted then redirect to confirmation page
    if (conversation.FbFormIsSubmitted__c==true || l==null || l.IsConverted){
        return Page.FbConfirmationPage;
    }
    
    return null;
}


    public PageReference selectAddress(){
    	try {
	        List<String> amsIds = new List<String>();
	        List<Address__c> addrs = findAddressByPostCodeStreetAndHouseNo();
	        if (addrs!=null && addrs.size()==1){
	            amsIds.add(addrs[0].External_Id__c);
	        }
	        else if(addrs!=null && addrs.size()>1){
	            addrs = findAddressByFormFields();
	            if (addrs!=null) {
	                for (Address__c a:addrs){
	                    if (a.External_Id__c!=null){
	                        amsIds.add(a.External_Id__c);
	                    }
	                }
	            }
	        }        
	        
	        if (amsIds.isEmpty()){
	            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error,'Adressen findes ikke!');
	            ApexPages.addMessage(m);
	            return null;
	        }/*else{
	            //TODO remove
	            
	            Address__c add = [ select External_Id__c,Door_No__c,Street__c,house_No__c,Floor__c,side__c, postcode__c, town__c, Entrance__c from Address__c
	                               where External_Id__c =: amsIds[0] ];
	            
	            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error,'Address found. Adresses size:' +amsIds.size()+' First Address:'+amsIds[0] + ' Accs:'+findAccountByAddress(amsIds).size() +
	                                  ' Full address: ' + add.postcode__c + ', ' + add.Street__c + ' ' + add.House_No__c + (add.Entrance__c!=null?add.Entrance__c:'') + ' ' + add.Floor__c + ' ' + add.Door_No__c);
	            ApexPages.addMessage(m);
	            return null;
	        }*/
	        List<Lead> leadList = [select id, email, name, firstname, lastname,sf4twitter__Fcbk_Image_Url__c, sf4twitter__Fcbk_Profile_Url__c, sf4twitter__Fcbk_Username__c, sf4twitter__Fcbk_User_Id__c, sf4twitter__Origin__c from Lead where sf4twitter__Fcbk_User_Id__c=:conversation.sf4twitter__Author_External_Id__c limit 1];
	        Lead l; 
	        if (leadList.size()==1){
	            l =leadlist[0];
	        }
	
	        List<Account> la = findAccountByAddress(amsIds);

	        if (la.size()==0){
	            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error,'No active customer found on selected address.');
	            ApexPages.addMessage(m);
	            return null;
	        } else {
	            Case c=new Case();
	            c.sf4twitter__Author_External_Id__c = l.sf4twitter__Fcbk_User_Id__c;
	            c.Origin = 'Facebook';
	            c.email__c = this.email;
	            c.Description = createCommonCaseDesc(l);
	            if (conversation.sf4twitter__Message__c!=null && conversation.sf4twitter__Message__c.length()>255){
	                c.Subject = conversation.sf4twitter__Message__c.substring(0, 255);
	                c.Description += conversation.sf4twitter__Message__c;
	            } else {
	                c.Subject = conversation.sf4twitter__Message__c;
	            }
	            
	            c.SuppliedName = conversation.sf4twitter__Author_Real_Name__c;
	            
	            Database.DMLOptions dmo = new Database.DMLOptions();
	            dmo.assignmentRuleHeader.useDefaultRule= true; 
	            RecordType recordType = [Select Id From RecordType Where Name = 'Queue Owned Case']; 
	            c.setOptions(dmo); 
	            c.RecordTypeId = recordType.id;
	            c.Department__c = 'YOT';
	            c.Product_2__c = CASE_PRODUCT;
	            
	            insert c;
	            
	            //update conversation
	            conversation.sf4twitter__Case__c = c.id;
	            conversation.FbFormIsSubmitted__c = true;
	            update conversation;
	            //update all child conversations
	            List<sf4twitter__Twitter_Conversation__c> childConversations = [select id,sf4twitter__Case__c from sf4twitter__Twitter_Conversation__c where sf4twitter__Parent__c=:conversation.id and sf4twitter__Case__c = null];
	            for (sf4twitter__Twitter_Conversation__c childConversation:childConversations){
	                childConversation.sf4twitter__Case__c = c.id;
	            }
	            update childConversations;
	            
	            try {
	                boolean updateNeeded=false;
	                if (this.firstName!=null && this.firstName.trim()!=''){
	                    l.FirstName = this.firstName.trim();
	                    updateNeeded=true;
	                }
	                if (this.lastName!=null && this.lastName.trim()!=''){
	                    l.lastName = this.lastName.trim();
	                    updateNeeded=true;
	                }
	                if (this.email!=null && this.email.trim()!=''){
	                    l.Email = this.email.trim();
	                    updateNeeded=true;
	                }
	                if (updateNeeded){
	                    update l;
	                }
	            } catch(Exception e){
	                String errorMessage = 'Lead update falied. ' + e;
	                System.debug(errorMessage);
	                if (c.Description!=null){
	                    c.Description += '\n'+errorMessage + '\n';
	                }
	                else{
	                    c.Description = errorMessage;
	                }
	                update c;
	            }
	            
	            /*if (la.size()==1){
	                try {
	                    Account a = la[0]; 
	                    Database.LeadConvertResult lcr = clsFbLeadConvertUtil.convertLead(l.Id, a.Id, null);
	
	                    c.AccountId = a.id;
	                    c.ContactId = lcr.getContactId();
	                    update c;
	                                        
	                } catch(Exception e){
	                    String errorMessage = 'Lead conversion falied. ' + e;
	                    System.debug(errorMessage);
	                    if (c.Description!=null){
	                        c.Description += '\n'+errorMessage;
	                    }
	                    else{
	                        c.Description = errorMessage;
	                    }
	                    update c;
	                }
	            } else if (la.size()>1){*/
	                if (c.Description!=null){
	                    c.Description = createCaseDesc(la,l,c) + c.Description;
	                } else {
	                    c.Description = createCaseDesc(la,l,c);
	                }
	                update c;
	            //}
	        }
	        
            return Page.FbConfirmationPage;
        
        } catch(Exception e){
            System.debug(e);
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, e.getMessage());
            ApexPages.addMessage(m);
            return null;
        }
    }

    private String createCommonCaseDesc(Lead l){
            //String result = 'Lead: '+this.firstName+' '+this.lastName+' '+baseUrl+'/'+l.id+'\nCustomer number:'+this.customerNumber+'\nComment:'+this.comment+'\n-------\n\n';
            String result = 'Lead: '+this.firstName+' '+this.lastName+' '+baseUrl+'/'+l.id+'\nComment:'+this.comment+'\n-------\n\n';
            return result;
    }

    private String createCaseDesc(List<Account> la, Lead l,Case c){
        String result = '';
        for (Account a:la){
            result +=a.Name + ': ' + baseURL +'/'+ a.id +'\n';
            result +='Convert lead: ' + baseURL +'/apex/FbLeadConverter?id='+ l.id +'&accid='+a.id+'&caseid='+c.id+'\n\n';
        }
        result +='Convert Lead to different account: ' + baseURL +'/apex/FbLeadConverter?id='+ l.id +'&caseid='+c.id+'\n';
        result += clsFbLeadConvertUtil.CASE_DESC_SEPARATOR + '\n';
        return result;
    }
    /*
    private void mergeLeadAndAccount(Lead l, Account a){
        a.sf4twitter__Fcbk_Image_Url__pc = l.sf4twitter__Fcbk_Image_Url__c;
        a.sf4twitter__Fcbk_Profile_Url__pc = l.sf4twitter__Fcbk_Profile_Url__c;
        a.sf4twitter__Fcbk_Username__pc = l.sf4twitter__Fcbk_Username__c;  
        a.sf4twitter__Fcbk_User_Id__pc = l.sf4twitter__Fcbk_User_Id__c; 
        a.sf4twitter__Origin__pc = l.sf4twitter__Origin__c;
        update a;
    }
    */
    private List<Account> findAccountByAddress(List<String> amsIds){
        System.debug('-----amsIds:'+amsIds);
        List<Account> accounts = [select Id, PersonEmail, FirstName, LastName, Name, sf4twitter__Fcbk_Image_Url__pc, sf4twitter__Fcbk_Profile_Url__pc, sf4twitter__Fcbk_Username__pc, sf4twitter__Fcbk_User_Id__pc, sf4twitter__Origin__pc from Account where AddressId__c IN:amsIds AND Status_YK__c='Active'];    
        return accounts;
    }
    
    public void findCityName(){
        
        List<Address__c> townName = [Select a.Town__c From Address__c a where Postcode__c =:searchPostNrText limit 1];
        system.debug('townName------------------'+townName);
        if (townName!=null && townName.size()==1){
            cityName = townName[0].Town__c;
        }else{
            cityName = '@@##';
        }
        showAddressPicklists = false;
    }

    public void findStreets(){
       String street = searchStreetText+'%';
       boolean flag = true;
       streetSuggestion = '[';
       for(AggregateResult sl:[Select a.Street__c From Address__c a where a.Postcode__c = :searchPostNrText and a.Street__c LIKE :street group by Street__c] ){
            streetSuggestion+='"'+(String)sl.get('Street__c')+'",';
            flag=false;
       }
       streetSuggestion= streetSuggestion.subString(0,streetSuggestion.length()-1); 
       if(flag){
           streetSuggestion = '[';
       }
       streetSuggestion+=']';
       system.debug('streetSuggestion ---- '+streetSuggestion);
    }

    public void validateStreet() {
        system.debug('validateStreet ---- postcode: ' + searchPostNrText + ' street: ' + searchStreetText);
        Address__c[] adds = [Select a.Street__c From Address__c a where a.Postcode__c = :searchPostNrText and a.Street__c = :searchStreetText limit 1];
        if (adds.size() > 0) {
            isStreetValidated = true;
        } else {
            isStreetValidated = false;
        }
        system.debug('validateStreet ---- '+(isStreetValidated?'Validated':'Not validated'));
    }
    
    public void validateHouse() {
        system.debug('validateHouse ---- postcode: ' + searchPostNrText + ' street: ' + searchStreetText);
        Address__c[] adds = [Select a.Street__c From Address__c a where a.Postcode__c = :searchPostNrText and a.Street__c = :searchStreetText limit 1];
        if (adds.size() > 0) {
            isHouseValidated = true;
        } else {
            isHouseValidated = false;
        }
        system.debug('validateHouse ---- '+(isStreetValidated?'Validated':'Not validated'));
    }

    public void findStreetNumbers(){
        String streetNumber, entrance;
        system.debug('findStreetNumbers ---- begining');
        if (!houseNrSet.isEmpty()) {
            if (houseNrSet.contains(searchHouseText)) {
                system.debug('findStreetNumbers ---- 1');
                streetNumber = searchHouseText+'%';
                entrance = '%';
            } else {
                Set<String> keys = houseTextMap.keySet();
                system.debug('findStreetNumbers ---- 2');
                for (String s :keys) {
                    system.debug('findStreetNumbers ---- loop searchHouseText:' + searchHouseText);
                    if (searchHouseText.startsWith(s)) {
                        system.debug('findStreetNumbers ---- loop in s: ' + s);
                        list<String> hePair = houseTextMap.get(s);
                        streetNumber = hePair[0]+'%';
                        entrance = searchHouseText.removeStart(hePair[0])+'%';
                        break;
                    }
                }
            }
            houseTextMap.clear();
            houseNrSet.clear();
        } 
        if (streetNumber == null) {
            system.debug('findStreetNumbers ---- 3');
            streetNumber = searchHouseText+'%';
            entrance = '%';
        }
        streetNumbersSuggestion = '[';
        system.debug('findStreetNumbers params ---- streetNumber:'+streetNumber+' entrance:'+entrance+' searchPostNrText:'+searchPostNrText+' searchStreetText:'+searchStreetText);
        AggregateResult[] sls;
        if (entrance == null || entrance == '%') {
            sls = [Select House_No__c, Entrance__c From Address__c where Postcode__c = :searchPostNrText and Street__c = :searchStreetText
                   and House_No__c like :streetNumber group by House_No__c, Entrance__c];
        } else {
            sls = [Select House_No__c, Entrance__c From Address__c where Postcode__c = :searchPostNrText and Street__c = :searchStreetText
                   and House_No__c like :streetNumber and Entrance__c like :entrance group by House_No__c, Entrance__c];    
        }
        for(AggregateResult sl :sls){
            String sNumber = (String)sl.get('House_No__c') + (sl.get('Entrance__c')!=null?(String)sl.get('Entrance__c'):'');
            streetNumbersSuggestion+='"'+sNumber+'",';
            String[] hePair = new String[]{(String)sl.get('House_No__c'), (String)sl.get('Entrance__c')};
            houseTextMap.put(sNumber, hePair);
            houseNrSet.add((String)sl.get('House_No__c'));
        }
        if (streetNumbersSuggestion.length()>1){
            streetNumbersSuggestion= streetNumbersSuggestion.subString(0,streetNumbersSuggestion.length()-1);
        } 
        streetNumbersSuggestion+=']';
        system.debug('streetNumbersSuggestion ---- '+streetNumbersSuggestion);
    }
    
    private List<Address__c> findAddressByPostCodeStreetAndHouseNo(){
        System.debug('---------findAddressByPostCodeStreetAndHouseNo params ---- searchStreetText:'+searchStreetText+' searchPostNrText:'+searchPostNrText+' searchHouseText:'+searchHouseText);
        List<Address__c> addrs;
        if (houseTextMap.containsKey(searchHouseText)) {
            List<String> hePair = houseTextMap.get(searchHouseText);
            System.debug('---------findAddressByPostCodeStreetAndHouseNo matching hePair ---- houseNr:'+hePair[0]+' entrance:'+hePair[1]);
            addrs = [select External_Id__c,Door_No__c,Street__c,house_No__c,Floor__c,side__c, postcode__c, town__c, Entrance__c from Address__c
                     where Street__c =: searchStreetText and Postcode__c =:searchPostNrText and 
                     house_No__c =: hePair[0] and Entrance__c =: hePair[1]
                     ORDER BY entrance__c,Floor__c,Door_No__c];
            System.debug('---------findAddressByPostCodeStreetAndHouseNo returns:'+addrs);
        }                    
        return addrs;
    }
    
    private List<Address__c> findAddressByFormFields(){
        System.debug('-----------findAddressByFormFields house:'+searchHouseText +' floorAndDoor:'+selectedFloorAndDoor);
        List<Address__c> addrs;
        if (houseTextMap.containsKey(searchHouseText)&& floorAndDoorMap.containsKey(selectedFloorAndDoor)) {
            List<String> hePair = houseTextMap.get(searchHouseText);
            System.debug('---------findAddressByFormFields matching hePair ---- houseNr:'+hePair[0]+' entrance:'+hePair[1]);
            List<String> fdPair = floorAndDoorMap.get(selectedFloorAndDoor);
            System.debug('---------findAddressByFormFields matching fdPair ---- floor:'+fdPair[0]+' door:'+fdPair[1]);
            addrs = [select External_Id__c from Address__c
                     where Street__c =: searchStreetText and Postcode__c =:searchPostNrText and 
                     house_No__c =: hePair[0] and Entrance__c =: hePair[1] and 
                     Floor__c =: fdPair[0] and Door_No__c=: fdPair[1]];
            System.debug('-----------findAddressByFormFields returns:'+addrs);
        }
        return addrs;
    }

    
    public void searchAddress(){
        List<Address__c> addrs = findAddressByPostCodeStreetAndHouseNo();
        system.debug('addrs:'+addrs);
        if(addrs!= null && addrs.size()==1){
            simpleAddressExtId=addrs[0].External_Id__c;
            showAddressPicklists=false;
            isHouseValidated = true;
        }
        else if(addrs!= null && addrs.size()>1){
            system.debug('If addrs size is greater than 1.');
            simpleAddressExtId=null;
            showAddressPicklists=true;
            isHouseValidated = true;
            findFloorsAndDoors();
        }
        else {
            simpleAddressExtId=null;
            showAddressPicklists=false;
            isHouseValidated = false;
            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error,'Adressen findes ikke.');
            ApexPages.addMessage(m);
        }
    }
    
    public void hideAddressPicklists() {
        showAddressPicklists=false;
    }

    public void findFloorsAndDoors(){
        if (searchHouseText!=null&&searchHouseText!=''){
            floorAndDoorItems = new List<SelectOption>();
            selectedFloorAndDoor = null;
            floorAndDoorMap.clear();
            list<String> hePair = houseTextMap.get(searchHouseText);
            for(AggregateResult sl:[Select Floor__c, Door_No__c From Address__c where Postcode__c = :searchPostNrText and Street__c = :searchStreetText
                                    and House_No__c = :hePair[0] and Entrance__c = :hePair[1] group by Floor__c, Door_No__c order by Floor__c, Door_No__c ASC NULLS FIRST] ){
                String value = (sl.get('Floor__c')!=null?(String)sl.get('Floor__c'):'') + ' ' +
                               (sl.get('Door_No__c')!=null?(String)sl.get('Door_No__c'):'');
                String[] fdPair = new String[]{(String)sl.get('Floor__c'), (String)sl.get('Door_No__c')};
                floorAndDoorMap.put(value, fdPair);
                System.debug('### FloorAndDoorItems value: ' + value);
                floorAndDoorItems.add(new SelectOption(value,value));
            }
        }
    }
    
    public static testmethod void testControler() {
        // Prepare KKD-14's required data
        Decimal TESTNUM = 68999998;
        CustomerNumberSeq__c custSeq = new CustomerNumberSeq__c();
        custSeq.lastNumber__c = TESTNUM;             
        insert custSeq;
        // Add custom setting required by tgrPopulateAccountInfo
        Yousee13Campaign__c yousee13 = new Yousee13Campaign__c(Name='Registration');
        insert yousee13;
        
        sf4twitter__Twitter_Conversation__c testConv = new sf4twitter__Twitter_Conversation__c();
        testConv.sf4twitter__Author_External_Id__c = '123654231345';
        testConv.sf4twitter__TwitterID__c = 'FB_321654987654231_123456789132546';
        testConv.sf4twitter__Type__c='Wall Post';
        testConv.sf4twitter__Author_Real_Name__c='Johny Doe';
        insert testConv;
        
        //Lead will be created by trigger tgrConversationBeforeInsert
        /*
        Lead testLead = new Lead();
        testLead.FirstName = 'Johny';
        testLead.lastName = 'Doe';
        testLead.sf4twitter__Fcbk_User_Id__c = '123654231345';
        insert testLead;
        */
        Address__c testAddress1 = new Address__c();
        testAddress1.Street__c = 'Test Street';
        testAddress1.External_Id__c = '123456';
        testAddress1.Postcode__c = '1234';
        testAddress1.Town__c = 'Test Town';
        testAddress1.House_No__c = '1';
        insert testAddress1;

        Address__c testAddress2 = new Address__c();
        testAddress2.Street__c = 'Test Street';
        testAddress2.External_Id__c = '123457';
        testAddress2.Postcode__c = '1234';
        testAddress2.Town__c = 'Test Town';
        testAddress2.House_No__c = '2';
        testAddress2.Entrance__c = 'A';
        testAddress2.Floor__c = '1';
        testAddress2.Door_No__c = 'TH';
        insert testAddress2;

        Address__c testAddress3 = new Address__c();
        testAddress3.Street__c = 'Test Street';
        testAddress3.External_Id__c = '123458';
        testAddress3.Postcode__c = '1234';
        testAddress3.Town__c = 'Test Town';
        testAddress3.House_No__c = '2';
        testAddress3.Entrance__c = 'A';
        testAddress3.Floor__c = '1';
        testAddress3.Side__c = 'L';
        testAddress3.Door_No__c = 'MF';
        insert testAddress3;

        Account testAccount1 = new Account();
        testAccount1.firstName='John';
        testAccount1.lastName='Doe10';
        testAccount1.Status_YK__c='Active';
        testAccount1.Street_YK__c=testAddress2.id;
        insert testAccount1;

        Account testAccount2 = new Account();
        testAccount2.firstName='John';
        testAccount2.lastName='Doe11 1';
        testAccount2.Status_YK__c='Active';
        testAccount2.Street_YK__c=testAddress3.id;
        insert testAccount2;

        Account testAccount3 = new Account();
        testAccount3.firstName='John';
        testAccount3.lastName='Doe11 2';
        testAccount3.Status_YK__c='Active';
        testAccount3.Street_YK__c=testAddress3.id;
        insert testAccount3;
        
        Test.startTest();
        Test.setCurrentPage(Page.FbContact);
        ApexPages.currentPage().getParameters().put('state', testConv.id + FB_PARAM_SUFFIX);
        clsFbContactController controller = new clsFbContactController();
        controller.isTest = true;
        controller.initialize();
        controller.searchPostNrText = '1234';
        controller.findCityName();
        controller.searchStreetText = 'Test Street';
        controller.findStreets();
        //no address
        controller.searchHouseText = '0';
        controller.searchAddress();
        controller.selectAddress();
        //address with 0 customer
        controller.searchHouseText = '1';
        controller.findStreetNumbers();
        controller.searchAddress(); // 1 address found
        System.assert(!controller.getShowAddressPicklists());
        controller.selectAddress();
        //address with 2 customers
        List<String> hePair = new String[]{'2', 'A'};
        controller.houseTextMap.put('2A', hePair);
        controller.searchHouseText = '2A';
        controller.searchAddress(); //2 addresses found
        System.assert(controller.getShowAddressPicklists());
        List<String> fdPair = new String[]{'1', 'MF'};
        controller.floorAndDoorMap.put('1 MF', fdPair);
        controller.selectedFloorAndDoor = '1 MF';
        controller.selectAddress();
        
        //address with 1 customer
        controller.firstName = 'John';
        controller.lastName = 'Doe';
        controller.email = 'John.Doe@gmail.com';
        fdPair = new String[]{'1', 'TH'};
        controller.floorAndDoorMap.put('1 TH', fdPair);
        controller.selectedFloorAndDoor = '1 TH';
        controller.selectAddress();
        Test.stopTest();
    }

}