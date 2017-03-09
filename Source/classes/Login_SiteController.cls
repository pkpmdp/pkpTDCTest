public class Login_SiteController {
    
    public String siteUrl{get; set;}
    ServiceCenter_CustomSettings__c testDomain{get; set;}
    
    public Login_SiteController(){
        testDomain = ServiceCenter_CustomSettings__c.getValues('SiteLoginUrl');
        if(testDomain.Value__c != null){
            siteUrl = testDomain.Value__c;
        }
        //siteUrl = 'http://yousee.test.cs7.force.com/selvbetjening';

    }
    
     static testMethod void testLogin_SiteController(){ 
        ServiceCenter_CustomSettings__c obj = new ServiceCenter_CustomSettings__c();
       obj.Name = 'SiteLoginUrl';
            obj.value__c = 'http://yousee.test.cs7.force.com/selvbetjening';
            insert obj;
            
           Login_SiteController lsc = new Login_SiteController(); 

    }
    
}