public with sharing class Links {
    private Account account;
  //  private List<DisplayAddress> addresses;
    public Account acc{get;set;}
    //SPOC-2294 START
    public Id currentId{get; set;}
    //SPOC-2294 END
    //constructor
    public Links(ApexPages.StandardController controller) {
        this.account = (Account) controller.getRecord();
        System.debug('#####account'+this.account);
    }
    //SPOC-2294 START
    public Links(){}
    //SPOC-2294 END
    public String getAccountId() {
        return account.Id;
    }
    
    public list<links__c> getLinks(){
        system.debug('<<<<<<<<currentId'+currentId);
        if(currentId != null){
           
            this.account = [SELECT Id,Name FROM Account WHERE Id=: currentId];
        } 
        Set<String> s1 = new Set<String>();
        Account acct = [select id,Street_YK__c, Street_YK__r.Cableunit_number__c From Account where Id=:account.Id];
        system.debug('<<<<<<<acct'+acct);
        for (Customer_Installation_Address__c a : [select Installation_ID__c from  Customer_Installation_Address__c where Customer__c =: account.id]) 
        {
            s1.add(a.Installation_ID__c );
        }
        System.Debug('<<<<<<<<<<<<<S1'+ s1);
        Set<ID> s2 = new Set<ID>();
        for (Net_Installations__c a : [select Cable_Unit__c from  Net_Installations__c where INSTALLATION_ID__c IN :s1]) 
        {
            s2.add(a.Cable_Unit__c);
            
        }
        System.Debug('<<<<<<<<<<<<<<S2'+ s2);
        list<Links__c> lnk=new list<links__c>();
        lnk = [select id,url__c,Category__c ,Cable_Unit__r.Cable_Unit_No__c,Cable_Unit__r.id,Cable_Unit__r.Name from  Links__c  where Cable_Unit__c IN : s2];
        system.debug('<<<<<<<<<<<lnk'+lnk);
        return lnk;
    }
    
    public list<links__c> getLinks2(string currentId){
        system.debug('<<<<<<<<currentId'+currentId);
        if(currentId != null){
           
            this.account = [SELECT Id,Name FROM Account WHERE Id=: currentId];
        } 
        Set<String> s1 = new Set<String>();
        Account acct = [select id,Street_YK__c, Street_YK__r.Cableunit_number__c From Account where Id=:account.Id];
        system.debug('<<<<<<<acct'+acct);
        for (Customer_Installation_Address__c a : [select Installation_ID__c from  Customer_Installation_Address__c where Customer__c =: account.id]) 
        {
            s1.add(a.Installation_ID__c );
        }
        System.Debug('<<<<<<<<<<<<<S1'+ s1);
        Set<ID> s2 = new Set<ID>();
        for (Net_Installations__c a : [select Cable_Unit__c from  Net_Installations__c where INSTALLATION_ID__c IN :s1]) 
        {
            s2.add(a.Cable_Unit__c);
            
        }
        System.Debug('<<<<<<<<<<<<<<S2'+ s2);
        list<Links__c> lnk=new list<links__c>();
        lnk = [select id,url__c,Category__c,Comment__c from  Links__c  where Cable_Unit__c IN : s2];
        system.debug('<<<<<<<<<<<lnk'+lnk);
        return lnk;
    }
   
}