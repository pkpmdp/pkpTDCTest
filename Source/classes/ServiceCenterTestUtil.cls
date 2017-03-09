/*Class to create a test data for Contact Section*/

public class ServiceCenterTestUtil
{
      public static String[] sourceArr = new String[]{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};   
	  public static String[] alphanumer = new String[]{'a','0','b','1','c','2','d','3','e','4','f','5','g','6','h','7','i','8','j','9','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};
      public static String[] phoneArr= new String[]{'0', '1', '2', '3', '4', '5', '6', '7', '8', '9','','-','+',' '};   
      public static String[] NumberArr = new String[]{'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'};   
      
      public static ID cAccId;
      public static ID cntId;
  
      // gets account id randomly  
      public static ID getRandomAccountId()
      {
            List<Account> accountList = [Select a.Name, a.Id From Account a limit 100];
            return accountList[getRandomNumber(accountList .size())].id;
      }

     // gets account id list randomly  
      public static List<Account> getRandomAccountIdList()
      {
            List<Account> accountList = [Select a.Name, a.Id From Account a limit 100];
            Integer listSize = accountList.size();
            Integer randomListSize = getRandomNumber(listSize);
            List<Account> randomAccountList = new List<Account>();
            for(Account account : accountList ){
                randomAccountList.add(account);
            }
            return randomAccountList;
       }
      
      // gets role id randomly  
      public static ID getRandomRoleId()
      {
            List<Lookup_Contact_Roles__c> rolesList = [Select l.Id, l.Name from Lookup_Contact_Roles__c l where l.Visible_in_Service_Centre__c = true];
            return rolesList [getRandomNumber(rolesList.size())].id;
      }
      
      // gets list of roles randomly  
      public static ID[] getRandomRoles()
      {
            List<Lookup_Contact_Roles__c> rolesList = [Select l.Id, l.Name from Lookup_Contact_Roles__c l where l.Visible_in_Service_Centre__c = true];
            Integer listSize = rolesList.size();
            Integer randomListSize = getRandomNumber(listSize);
            ID[] roleIds = new ID[randomListSize];
            for(Integer i=0; i<randomListSize; i++)
            {
                roleIds[i] = rolesList [i].id;
            }
            return roleIds;
      }
      
       // gets list of roles randomly  in a sing string with comma seperated
      public static String getRandomRolesName()
      {
            List<Lookup_Contact_Roles__c> rolesList = [Select l.Id, l.Name from Lookup_Contact_Roles__c l where l.Visible_in_Service_Centre__c = true];
            Integer listSize = rolesList.size();
            Integer randomListSize = getRandomNumber(listSize);
            String roleNames;
            for(Integer i=0; i<randomListSize; i++) {
                if(i==0){
                    roleNames  = rolesList[i].Name;
                }else{
                    roleNames  = roleNames + ', ' + rolesList[i].Name;
                }    
            }
            return roleNames ;
      }
      
      // picks characters from sourcearr and generates a random name which is returned
      public static String getRandomName()
      {
            Integer randomKey;
            String randomCode = '';
            Integer size = getRandomNumber(1, 20);
            for (Integer i=0; i<size; i++) {
                randomKey = Math.round(Math.floor(Math.random()*sourceArr.size()));
                if(i==0){
                   randomCode = sourceArr[randomKey].toUpperCase();
                }else{
                   randomCode = randomCode + sourceArr[randomKey];
                } 
            }
            return randomCode;
      }
    
     // picks characters from phoneArr and generates a random alphanumeric number which is returned
      
     public static String getRandomAlphaNumeric()
     {
            Integer randomKey;
            String randomCode = '';
            Integer size = getRandomNumber(5, 15);
            for (Integer i=0; i<size; i++) {
                randomKey = Math.round(Math.floor(Math.random()*phoneArr.size()));
                if(i==0){
                   randomCode = phoneArr[randomKey];
                }else{
                   randomCode = randomCode + phoneArr[randomKey];
                } 
            }
            return randomCode;
      }

      // gets contact randomly  
      public static Contact getRandomContact()
      {
          //string cntId=getRandomAlphaNumeric();
          Contact cnt = [Select Id From Contact LIMIT 1];
          return cnt;
      }
      
      // generates a domain name which can be used in email
      public static String getDomainName()
      {
            Integer randomKey;
            String randomCode = '';
            Integer size = getRandomNumber(3, 10);
            for (Integer i=0; i<size; i++) {
                randomKey = Math.round(Math.floor(Math.random()*sourceArr.size()));
                if(i==0){
                   randomCode = sourceArr[randomKey];
                }else{
                   randomCode = randomCode + sourceArr[randomKey];
                } 
            }
            return randomCode;
      }
    
      // generates a email randomly each time
      public static String getRandomEmail()
      {
             return getRandomName().toLowerCase() + '.' + getRandomName().toLowerCase() + '@' + getDomainName() + '.com';
      }
      
      // generates a random number
      public static Integer getRandomNumber(Integer frm, Integer to)
      {
           return Math.round(Math.floor((math.random() * (to - 1)) + frm) );
      }
      
      // generates a random number
      public static Integer getRandomNumber(Integer listSize)
      {
           return Math.round(Math.floor((math.random() * (listSize -1)) + 0) );
      }
      
      //Creating cableUnitNumber
      public static string setTestCableUnitNumber()
      {
        setContact();
        Account uAcc2=[select id, name,parentId from Account limit 1 ]; 
        cAccId = uAcc2.Id;  
        
        Cable_Unit__c cu =new Cable_Unit__c(name='testCableUnit', Customer__c=uAcc2.id, Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(), Municipaly__c = clsTestDataForYS.getMunicipaly(), Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode(), Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership(), Housing_Type__c = clsTestDataForYS.createLookupHousingType(), Building_Type__c = clsTestDataForYS.createLookupBuildingType());
        insert cu;
        
        Cable_Unit__c cUTest = [select id,name from Cable_Unit__c where name='testCableUnit'];
        return cUTest.name;
      }
      
      //Creating Contact
      public static void setContact()
      {
        accountTestData();
        Account uAcc1  =[select id, name,parentId from Account where name = 'childG'];     
        String portalUserProfile = ServiceCenter_CustomSettings__c.getInstance('ServiceCenter Portal User').Value__c;
        Profile prf=[select name,id from profile where name=:portalUserProfile];    
      
        Contact cnt1 = new Contact(Firstname='testContact1',
                       AccountId=uAcc1.Id,
                       phone='3223',
                       LastName='testContact1',
                       Status__c='Aktiv');    
        insert cnt1; 
        
        User usr = new User(alias = 'standt1', 
                  email='standarduser1@testorg.com', 
                  emailencodingkey='UTF-8', 
                  lastname='Testing1',
                  languagelocalekey='en_US',
                  localesidkey='en_US',
                  ContactId=cnt1.Id,
                  profileid = prf.Id, 
                  timezonesidkey='America/Los_Angeles', 
                  username='standarduser1@testorg.com');            
        insert usr ;       
      
        //List<Lookup_Contact_Roles__c> userRoleList = [Select id,name from Lookup_Contact_Roles__c where Name != 'Portal User'] ;    
      
        List<Lookup_Contact_Roles__c> userRoleList = [Select id,Name from Lookup_Contact_Roles__c where id =: ServiceCenterSingleton.getInstance().getUserRoleId()];    
      
      
        Account_Contact_Role__c acr=new Account_Contact_Role__c(Contact__c=cnt1.Id,
                                    Customer__c=uAcc1.Id,
                                    Role__c = userRoleList[0].id);    
        insert acr;
        cntId =  cnt1.Id;
        
      }
      
      //Creating Account
      
      //private static void accountTestData()
      public static void accountTestData()
      {    
        Account masterAcc=new Account(name = 'MasterAccount',Anlaeg_No__c ='testCableUnitMaster',type='Hierarki', Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment());    
        insert masterAcc;    
        Account parentC = new Account(name='parentC',Anlaeg_No__c = 'testCableUnit1',type='Hierarki',ParentId=masterAcc.Id, Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde());    
        insert parentC;  
        Account childG = new Account(name='childG',Anlaeg_No__c = 'testCableUnit',type='Hierarki',ParentId=parentC.Id, Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegmentKunde1());    
        insert childG; 
      }
      
      
      public static String getRandomAlphaNumericParam(Integer length){
            Integer randomKey;
            String randomCode = '';
            
            for (Integer i = 0; i< length; i++) {
                randomKey = Math.round(Math.floor(Math.random()* alphanumer.size()));
                if(i == 0){
                   randomCode = alphanumer[randomKey];
                }else{
                   randomCode = randomCode + alphanumer[randomKey];
                } 
            }
            //txtKey2 = randomCode;
            return randomCode;
      }
      
      public static String getRandomNumeric(Integer length1){
            Integer randomKey;
            String randomCode = '';
            
            for (Integer i=0; i<length1; i++) {
                randomKey = Math.round(Math.floor(Math.random()* NumberArr.size()));
                if(i==0){
                   randomCode = NumberArr[randomKey];
                }else{
                   randomCode = randomCode + NumberArr[randomKey];
                } 
            }
            
            System.debug('###Password22222222222222####'+randomCode);
            return randomCode;
      }
      
    public static String getRandomCharsName(Integer length2){
            Integer randomKey;
            String randomCode = '';
            
            for (Integer i = 0; i< length2; i++) {
                randomKey = Math.round(Math.floor(Math.random()* sourceArr.size()));
                if(i == 0){
                   randomCode = sourceArr[randomKey];
                }else{
                   randomCode = randomCode + sourceArr[randomKey];
                } 
            }
            
            System.debug('###Password33333333333####'+randomCode);
            return randomCode;
      }        
}