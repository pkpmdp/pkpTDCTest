@RestResource(urlMapping='/contact/*')
global class ContactDetailsRestService{
    
    @HttpPost
    global static List<ContactWrapper> doPostAction(){
        String action = RestContext.request.params.get('action');
        if(action == null || action == ''){
            return new List<ContactWrapper>();
        }
        if('all'.equalsIgnoreCase(action)){
            return getContactDetails(); 
        }
        if('findcontact'.equalsIgnoreCase(action)){
            return getContactDetailsByRoleId();
        }       
        return null;
    }
    
   
    global static List<ContactWrapper> getContactDetails() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes'); 
        String ysContactRecordType = ysRecords.YS_Contact_Record_Type__c;
        Blob body = req.requestBody;
        String bodyString = body.toString();
        String[] jsonwrap =(String[])JSON.deserialize(bodyString,String[].class);
        List<Id> idList = new List<Id>();
        for(String id1 : jsonwrap){
            idList.add(id1);
        }
        
        if(jsonwrap == null){
            return new List<ContactWrapper>();
        }
        List<Contact> contactList = [Select Name,FirstName,LastName,Company_Customer__c,Title,MobilePhone,Phone,HomePhone,Email,Street_P__r.Name,Street_P__r.Door_No__c,Street_P__r.Entrance__c,Street_P__r.House_No__c,Street_P__r.Postcode__c,Street_P__r.Town__c,Street_P__r.Street__c,Id,Street_P__r.Floor__c,Street_P__r.District__c,Street_P__r.PO_Box__c,IsPersonAccount from Contact where ID IN :idList and IsPersonAccount = false and RecordTypeId=:ysContactRecordType and IsConferenceContact__c = false];
        if(contactList != null && contactList .size() > 0){
            return getMapToContactList(contactList);
            
        }else{
            return new List<ContactWrapper>();
        }        
    }
    
    public static List<ContactWrapper> getMapToContactList(List<Contact> contactList){
    List<ContactWrapper> listWrapper = new List<ContactWrapper>();
    for(Contact cont : contactList){
            ContactWrapper contWrapper = new ContactWrapper();
            contWrapper.name = cont.Name;
            contWrapper.contactId = cont.Id;
            contWrapper.title = cont.Title;
            contWrapper.email = cont.Email;
            contWrapper.fullName = cont.Name;
            contWrapper.firstName = cont.FirstName;
            contWrapper.lastName = cont.LastName;
            contWrapper.organization = cont.Company_Customer__c;
            contWrapper.workPhone = cont.Phone;
            contWrapper.mobilePhone = cont.MobilePhone;
            contWrapper.privatePhone = cont.HomePhone;
            contWrapper.streetName = cont.Street_P__r.Street__c;
            contWrapper.floor = cont.Street_P__r.Floor__c;
            contWrapper.doorNo = cont.Street_P__r.Door_No__c;
            contWrapper.entrance = cont.Street_P__r.Entrance__c;
            contWrapper.houseNo = cont.Street_P__r.House_No__c;
            contWrapper.postCode = cont.Street_P__r.Postcode__c;
            contWrapper.town = cont.Street_P__r.Town__c;
            contWrapper.POBoxNr = cont.Street_P__r.PO_Box__c;
            contWrapper.locality = cont.Street_P__r.District__c;
            listWrapper.add(contWrapper);
         }    
         return listWrapper;
    }  
    
    global static String quoteKeySet(Set<String> mapKeySet)
    {
        String newSetStr = '' ;
        for(String str : mapKeySet){
            if(str != null || str != ''){
                newSetStr += '\'' + str + '\',';
            }
        }
        newSetStr = newSetStr.lastIndexOf(',') > 0 ? '(' + newSetStr.substring(0,newSetStr.lastIndexOf(',')) + ')' : newSetStr ;
        System.debug('quoteKeySet() :  newSetStr ============ ' + newSetStr);   

        return newSetStr;
    } 
    global static List<ContactWrapper> getContactDetailsByRoleId() {
         
           YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes'); 

            String ysContactRecordType = ysRecords.YS_Contact_Record_Type__c;

            RestContext.request.addHeader('Content-Type', 'ISO-8859-1');
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            String sqlQuery;
            List<Id> lst_acrContactIds;
            Blob body = req.requestBody;
            String bodyString = body.toString();
            //String bodyString = EncodingUtil.base64Encode(body);
            
            //Blob afterblob = EncodingUtil.base64Decode(bodyString);
            //System.debug('@@@@@@@afterblob$$$$$$'+afterblob);
            Jsondata2 jsonwrap =(Jsondata2)JSON.deserialize(bodyString,Jsondata2.class);
            
            //Jsondata2 jsonwrap =(Jsondata2)JSON.deserialize(bodyString,Jsondata2.class);
            /*String bodyString = EncodingUtil.base64Encode(req.requestBody);
            Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(bodyString);
            string newJson = Json.serialize(root);
            Jsondata2 jsonwrap =(Jsondata2)JSON.deserialize(newJson,Jsondata2.class);*/
            System.debug('@@@@@@@jsonwrap'+jsonwrap);
            
            if(jsonwrap == null){
                return new List<ContactWrapper>();
            }
            
            sqlQuery='Select RecordTypeId ,Name,FirstName,LastName,Company_Customer__c,Title,MobilePhone,Phone,HomePhone,Email,Street_P__r.Name,Street_P__r.Door_No__c,Street_P__r.Entrance__c,Street_P__r.House_No__c,Street_P__r.Postcode__c,Street_P__r.Town__c,Street_P__r.Street__c,Id,Street_P__r.Floor__c,Street_P__r.District__c,Street_P__r.PO_Box__c from Contact ';
       
            String whereString='';
            String filterString='';
            Set<String> idfList = new Set<String>(); 
                    
                       
            if(jsonwrap.contactIds != null){
                for(String stIds : jsonwrap.contactIds){
                    if(stIds != null)
                        idfList.add(stIds);
                }
            }                              
                    
           if (jsonwrap.roleId!=null && jsonwrap.roleId!='') {
                
                String subQuery='SELECT contact__r.ID FROM Account_Contact_Role__c ac WHERE ac.Role__c=\''+jsonwrap.RoleId+'\' limit 30000';
                 List<Account_Contact_Role__c> contactIDList = Database.query(subQuery);
                 for(Account_Contact_Role__c con : contactIDList){
                    if(con.Contact__r.Id != null)
                    idfList.add(con.Contact__r.Id);//  unique contacts in this set idflist
                 }
            }         
            
               
            if((idfList.size()>0) && ((jsonwrap.roleId!=null && jsonwrap.roleId!='')||(jsonwrap.contactIds!= null))){   
                String newSetStr = quoteKeySet(idfList);                
                 if(filterString==''){
                  filterString += ' Id IN '+newSetStr;
                }
                else{
                    filterString+=' and Id IN '+newSetStr;
                }
            }  
          /*   if(idfList.size()>0){   
                String newSetStr = quoteKeySet(idfList);                
                 if(filterString==''){
                  filterString += ' Id IN '+newSetStr;
                }
                else{
                    filterString+=' and IN '+newSetStr;
                }
            }
             if (jsonwrap.roleId != null && jsonwrap.roleId!='') {
                String subQuery;
                if(filterString==''){
                     subQuery='SELECT contact__c FROM Account_Contact_Role__c ac WHERE ac.Role__c=\''+jsonwrap.RoleId+'\'';
                    filterString += ' ID IN ('+subQuery+')'; 
                }
                else{
                    filterString+=' and ID IN ('+subQuery+')';
                }            
            }  */        
                        
             if (jsonwrap.firstName != null && jsonwrap.firstName!='') {
                if(filterString==''){
                  filterString += ' FirstName LIKE \''+jsonwrap.firstName+'%\''; 
                }
                else{
                    filterString+=' and FirstName LIKE \''+jsonwrap.firstName+'%\''; 
                }            
            }            
            if (jsonwrap.lastName != null && jsonwrap.lastName!='') {
              if(filterString==''){
                  filterString += ' LastName LIKE \'' + jsonwrap.lastName+'%\'';
                }
                else{
                    filterString+=' and LastName LIKE \'' + jsonwrap.lastName+'%\'';
                }
            }            
            if (jsonwrap.organizationName != null && jsonwrap.organizationName!='') {
               if(filterString==''){
                  filterString += ' Company_Customer__c LIKE \'' + jsonwrap.organizationName+'%\'';
                }
                else{
                    filterString+=' and Company_Customer__c LIKE \'' + jsonwrap.organizationName+'%\'';
                }              
            }
            if (jsonwrap.email != null && jsonwrap.email!='') {
                  if(filterString==''){
                  filterString += ' Email LIKE \'' + jsonwrap.email+'%\'';
                }
                else{
                    filterString+=' and Email LIKE \'' + jsonwrap.email+'%\'';
                }              
            }
            if (jsonwrap.title != null && jsonwrap.title!='') {
                 if(filterString==''){
                  filterString += ' Title LIKE \'' + jsonwrap.title+'%\'';
                }
                else{
                    filterString+=' and Title LIKE \'' + jsonwrap.title+'%\'';
                }               
            }
            if (jsonwrap.workPhone != null && jsonwrap.workPhone!='') {
                 if(filterString==''){
                  filterString += ' Phone LIKE \'' + jsonwrap.workPhone+'%\'';
                }
                else{
                    filterString+=' and Phone LIKE \'' + jsonwrap.workPhone+'%\'';
                }             
            }
            if (jsonwrap.mobilePhone != null && jsonwrap.mobilePhone!='') {
                 if(filterString==''){
                  filterString += ' MobilePhone LIKE \'' + jsonwrap.mobilePhone+'%\'';
                }
                else{
                    filterString+=' and MobilePhone LIKE \'' + jsonwrap.mobilePhone+'%\'';
                }              
            }           
            if (jsonwrap.privatePhone != null && jsonwrap.privatePhone!='') {
                 if(filterString==''){
                  filterString += ' HomePhone LIKE \'' + jsonwrap.privatePhone+'%\'';
                }
                else{
                    filterString+=' and HomePhone LIKE \'' + jsonwrap.privatePhone+'%\'';
                }
            }           
            if (jsonwrap.addressId != null) {
                 if(filterString==''){
                  filterString += ' Street_P__r.External_Id__c =\''+jsonwrap.addressId+'\'';
                }
                else{
                    filterString+=' and Street_P__r.External_Id__c =\''+jsonwrap.addressId+'\'';
                }              
            } 
            
            
            if(filterString!='')
            {
                sqlQuery = sqlQuery + ' where ' +filterString + ' and IsPersonAccount = false and RecordTypeId=:ysContactRecordType and IsConferenceContact__c = false';
            }else{
                sqlQuery = sqlQuery + ' where IsPersonAccount = false and RecordTypeId=:ysContactRecordType and IsConferenceContact__c = false';
            } 
            
             
                     
            sqlQuery+=' limit 100';
            
            List<Contact> contactList = Database.query(sqlQuery);
            if(jsonwrap.roleId != null && jsonwrap.roleId != '' && idfList.size() == 0){
                    return new List<ContactWrapper>();
            }else{
                if(contactList != null && contactList .size() > 0){
                    return getMapToContactList(contactList);
                }else{
                    return new List<ContactWrapper>();
                }
            }     
    }    
    global class ContactWrapper{
        public String name;
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
        public String streetName;
        public String floor;
        public String doorNo;
        public String entrance;
        public String houseNo;
        public String postCode;
        public String town;
        public String POBoxNr;
        public String locality;
    }
    
    global class Jsondata2{
        public Long addressId;
        public String email;
        public String firstName;
        public String lastName;
        public String mobilePhone;
        public String organizationName;
        public String privatePhone;
        public String roleId;
        public String title;
        public String workPhone;
        public String[] contactIds;
    }
}