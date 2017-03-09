@RestResource(urlMapping='/contactrole/*')
global class ContactRoleDetails {
    
    @HttpGet
    global static List<ContactRoleWrapper> getAction(){
        //Map<String , String> tmap = new Map<String, String>();
       // tmap = RestContext.request.params;
       // List<String> tlist=tmap.values();
        
        String action = RestContext.request.params.get('action');
        if(action == null || action == ''){
            return new List<ContactRoleWrapper>();
           // return tlist;
        }
        
        if('getroleId'.equalsIgnoreCase(action)){
            return getSingleContactRoleDetails();
            //return tlist;
        }
        if('all'.equalsIgnoreCase(action)){
            //return tlist;
            return getAllContactRoleDetails();
        }
        if('active'.equalsIgnoreCase(action)){
            return getActiveContactRoleDetails();
            // return tlist;
        }
            return null;
    }
    
    @HttpPost
    global static List<ContactRoleWrapper> doPostAction(){
        String action = RestContext.request.params.get('action');
        if(action == null || action == ''){
            return new List<ContactRoleWrapper>();
        }
        if('all'.equalsIgnoreCase(action)){
            return getContactRoleDetail(); 
        }
            return null;
    }
    
    
    global static List<ContactRoleWrapper> getContactRoleDetail() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Blob body = req.requestBody;
        String bodyString = body.toString();
        String[] jsonwrap =(String[])JSON.deserialize(bodyString,String[].class);
        List<Id> idList = new List<Id>();
        if(jsonwrap != null && jsonwrap.size() > 0){
            for(String id1 : jsonwrap){
                idList.add(id1);
            }
        }    
        if(jsonwrap == null){
            return new List<ContactRoleWrapper>();
        }
        List<Lookup_Contact_Roles__c> roleList = [SELECT Code__c,Id,Name,Vis_i_kontrakt__c,Active__c,Start_Date__c,End_Date__c,Visible_in_Service_Centre__c,Portal_Description__c FROM Lookup_Contact_Roles__c WHERE ID IN :idList];
        if(roleList != null && roleList.size() > 0){
            return getMapToContactRoleList(roleList);
            
        }else{
            return new List<ContactRoleWrapper>();
        }  
    }
    
    global static List<ContactRoleWrapper> getSingleContactRoleDetails() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String roleId =  req.params.get('roleid'); 
        
        if(roleId == null && roleId == ''){
            return new List<ContactRoleWrapper>();
        }
        List<Lookup_Contact_Roles__c> contactRoleList = [SELECT Code__c,Id,Name,Vis_i_kontrakt__c,Active__c,Start_Date__c,End_Date__c,Visible_in_Service_Centre__c,Portal_Description__c FROM Lookup_Contact_Roles__c WHERE ID =: roleId];
        if(contactRoleList != null && contactRoleList.size() > 0){
            return getMapToContactRoleList(contactRoleList);
        }else{
            return new List<ContactRoleWrapper>();
        }
    
        
    }
    
    public static List<ContactRoleWrapper> getMapToContactRoleList(List<Lookup_Contact_Roles__c> contactRoleList){
    List<ContactRoleWrapper> listWrapper = new List<ContactRoleWrapper>();
    for(Lookup_Contact_Roles__c lcr : contactRoleList){
        ContactRoleWrapper lcrWrapper = new ContactRoleWrapper();
        lcrWrapper.roleName = lcr.Name;
        lcrWrapper.roleCode = lcr.Code__c;
        lcrWrapper.roleId = lcr.Id;
        if(lcr.Active__c == 'Ja')
            lcrWrapper.aktiv = Boolean.valueOf('True');
        else
            lcrWrapper.aktiv = Boolean.valueOf('False');
            
            lcrWrapper.visKontrakt = lcr.Vis_i_kontrakt__c;
            lcrWrapper.startDate = lcr.Start_Date__c;
            lcrWrapper.endDate = lcr.End_Date__c;
            lcrWrapper.showInPortal = lcr.Visible_in_Service_Centre__c;
            lcrWrapper.portalDescription = lcr.Portal_Description__c;
            listWrapper.add(lcrWrapper);
    }
    return listWrapper;
}

    global static List<ContactRoleWrapper> getAllContactRoleDetails() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        //commented existing
        //List<Lookup_Contact_Roles__c> contactRoleList = [SELECT Code__c,Id,Name,Active__c FROM Lookup_Contact_Roles__c WHERE Active__c ='Ja'];
        
        List<Lookup_Contact_Roles__c> contactRoleList = [SELECT Code__c,Id,Name,Active__c,Vis_i_kontrakt__c,Start_Date__c,End_Date__c,Visible_in_Service_Centre__c,Portal_Description__c FROM Lookup_Contact_Roles__c];
        if(contactRoleList != null && contactRoleList.size() > 0){
            return getMapToContactRoleList(contactRoleList);
        }else{
            return new List<ContactRoleWrapper>();
        }
    }
    
    global static List<ContactRoleWrapper> getActiveContactRoleDetails(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<Lookup_Contact_Roles__c> contactRoleList = [SELECT Code__c,Id,Name,Active__c,Vis_i_kontrakt__c,Start_Date__c,End_Date__c,Visible_in_Service_Centre__c,Portal_Description__c FROM Lookup_Contact_Roles__c WHERE Active__c ='Ja'];
        if(contactRoleList != null && contactRoleList.size() > 0){
            return getMapToContactRoleList(contactRoleList);
        }else{
            return new List<ContactRoleWrapper>();
        }
    }

    

global class ContactRoleWrapper {
   public String roleName;
   public String roleCode;
   public String roleId;
   public Boolean aktiv;
   public Boolean visKontrakt;
   public Date startDate;
   public Date endDate;
   public Boolean showInPortal;
   public String portalDescription;
   }

}