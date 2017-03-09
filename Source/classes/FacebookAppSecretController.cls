public with sharing class FacebookAppSecretController {
	ApexPages.StandardController controller;
    private FacebookApp__c app;
    private String secret;
    
    public FacebookAppSecretController(ApexPages.StandardController controller) {
    	this.controller = controller;
        this.app = (FacebookApp__c)controller.getRecord();
    }   

    public String getSecret() {
        return null;
    }
    
    public void setSecret(String secret) {
        this.secret = secret;
    }
    
    public PageReference save() {
    	app.clientSecret__c = FacebookCrypto.encrypt(secret);
    	return controller.save();
    }
    static testmethod void testFacebookAppSecretController()
    {
        FacebookApp__c fbap = new FacebookApp__c(); 
        ApexPages.StandardController fbapp =  new ApexPages.StandardController(fbap);
		FacebookAppSecretController fb = new FacebookAppSecretController(fbapp);
        fb.secret = 'sbc';
        string a = fb.getSecret();
        PageReference pgref = fb.save();
        fb.setSecret(fb.secret);
        
    }
}