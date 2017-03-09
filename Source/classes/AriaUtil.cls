public with sharing class AriaUtil {
    // return null if no configs found.
    public static Aria_API_Configuration__c getLatestConfig() {
        Aria_API_Configuration__c[] configs = [select Id, Name, Client_No__c, Auth_Key__c, Promo_Code__c,
                                               Aria_Admin_Tool_URL__c, Failure_Notification_Emails__c,
                                               Aria_Remote_Site_URL__c, Batch_Email_Service_Address__c,
                                               Supplemental_Plan_Assignment_Directive__c
                                               from Aria_API_Configuration__c 
                                               order by CreatedDate desc
                                               limit 1
                                               ];
                                               
        Aria_API_Configuration__c res = null;
        
        if(configs.size() == 1)
            res = configs[0];
            
        return res;
    }
    
 /*   public static Boolean quantityIn(Decimal quantity, Aria_Opportunity_Rate_Tier__c rateTier) {
        return (quantity >= rateTier.From_Unit__c && rateTier.To_Unit__c == null) ||(quantity >= rateTier.From_Unit__c && quantity <= rateTier.To_Unit__c);
    }
    */
    public static String quote(String input) {
        return '\'' + input + '\'';
    }
    
  /*  public static AriaConfiguration getLatestConfigWithMappings() {
        Aria_API_Configuration__c config = getLatestConfig();
        if(config == null) {
            return null;
        }
        
     //   return new AriaConfiguration(config);
     return null;
    }*/
    
    public static String strList(List<ID> input) {
        String res = input[0];
        
        for(Integer i = 1; i < input.size(); i++) {
            res += ',' + input[i];
        }
        
        return res;
    }
    
    // TESTS //////////////////////////////////////////////////////////////////
    private static Aria_API_Configuration__c testConfig;
    
    private static void insertDefaultConfig() {
        testConfig = new Aria_API_Configuration__c(Client_No__c = 999999, Aria_Admin_Tool_URL__c =  'https://admintools.future.stage.ariasystems.net', Aria_Remote_Site_URL__c = 'https://secure.future.stage.ariasystems.net');
        insert testConfig;
    }
    
    static testMethod void testGetLatestConfig() {
        insertDefaultConfig();
        
        Aria_API_Configuration__c config = AriaUtil.getLatestConfig();
        list<ID> strInput = new list<ID>();
        List<Account> listacc = [select id from account limit 5]; 
        for(Account acc:listacc)
        {
            strInput.add(acc.id);
        }
        AriaUtil.strList(strInput);
        System.assertEquals(999999, config.Client_No__c);
        
    }
    
    static testMethod void testQuote() {
        System.assertEquals('\'Test\'', quote('Test')); 
    }
    
 /*   static testMethod void testgetLatestConfigWithMappings() {
        insertDefaultConfig();
        
        System.assertNotEquals(null, getLatestConfigWithMappings());
        
        for(Aria_API_Configuration__c configs : [select Id from Aria_API_Configuration__c]) {
            delete configs;
        }
        
        System.assertEquals(null, getLatestConfigWithMappings());
    } 
    
    static testMethod void testQuantityIn() {
        Aria_Opportunity_Rate_Tier__c rt = new Aria_Opportunity_Rate_Tier__c(
            From_Unit__c = 1,
            To_Unit__c = 3
        );
        
        System.assert(quantityIn(2, rt));
        System.assert(!quantityIn(4, rt));
        
        rt.To_Unit__c = null;
        System.assert(quantityIn(200, rt));
    }*/
}