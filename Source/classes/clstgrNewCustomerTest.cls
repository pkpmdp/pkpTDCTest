public class clstgrNewCustomerTest {
    //public static Decimal TESTNUM = 69991776;
    public static Decimal TESTNUM = 68999998;
    public static String EXPNUM = '689999999';
    //public static Decimal TESTNUM = 60559032;
    
    static testMethod CustomerNumberSeq__c getPreparedData() {
        List<CustomerNumberSeq__c> custSeqList = [ Select lastNumber__c from  CustomerNumberSeq__c ];
        CustomerNumberSeq__c custSeq; 
        if (custSeqList.size() > 0 ){
            custSeq = (CustomerNumberSeq__c)custSeqList.get(0);
            custSeq.lastNumber__c = TESTNUM;
            update custSeq;  
        }else {
            custSeq = new  CustomerNumberSeq__c();
            custSeq.lastNumber__c = TESTNUM;              
            insert custSeq;
        }
        return custSeq;
    }

    static testMethod void testCreateCustomerOne() {
        Test.startTest();
        CustomerNumberSeq__c custSeq = getPreparedData();
        Address__c add = new Address__c(Street__c = 'Main Street', 
            Town__c = 'Leeds', Postcode__c = 'LS1');
        insert add;
        
        Account acc = new Account(FirstName = 'Robert', LastName = 'John', 
            Street_YK__c = add.Id
            );
        
       
        insert acc;
        LastCustomer__c lastCust = [Select Name from LastCustomer__c order by Name desc limit 1 ];
        Decimal tNum = Decimal.valueOf(lastCust.Name) + TESTNUM;
        Account expAcc = [ Select id , Customer_No__c from  Account where id=:acc.id];
        system.debug('>>>>>'+expAcc.Customer_No__c);
        //lastCust = [Select Name from LastCustomer__c order by Name desc limit 1 ];
        //It is hard to test  
        system.assert(expAcc.Customer_No__c == new clsCustomerNumber().getNewCustomerNumber(tNum));    
        Test.stopTest();                        
    }
    
    static testMethod void testCreateCustomerHieraki() {
        Test.startTest();
        CustomerNumberSeq__c custSeq = getPreparedData();
        Address__c add = new Address__c(Street__c = 'Main Street', 
            Town__c = 'Leeds', Postcode__c = 'LS1');
        insert add;
        
        Account acc = new Account(FirstName = 'Robert', LastName = 'John', 
            Street_YK__c = add.Id,
            Type='Hierarki' 
            );           
        insert acc;
        Account expAcc = [ Select id , Customer_No__c from  Account where id=:acc.id];
        system.assert(expAcc.Customer_No__c!=EXPNUM);        
        Test.stopTest();                        
    }

    // Old customer importing exception code begin    
    static testMethod void testCreateCustomerWithCustNumber() {
        Test.startTest();
        CustomerNumberSeq__c custSeq = getPreparedData();
        
        Account acc = new Account(FirstName = 'Robert', LastName = 'John', Customer_No__c='123456');           
        insert acc;
        Account expAcc = [ Select id , Customer_No__c from  Account where id=:acc.id];
        system.assertEquals('123456', expAcc.Customer_No__c);
        Test.stopTest();
    }

    static testMethod void testCreateCustomerWithTooHighCustNumber() {
        Test.startTest();
        CustomerNumberSeq__c custSeq = getPreparedData();
        Boolean excp = false;
        
        Account acc = new Account(FirstName = 'Robert', LastName = 'John', Customer_No__c='712345678');           
        try {
            insert acc;
        } catch (DMLException e) {
            excp = true;
        }
        system.assert(excp);
        Integer i = [ Select count() from  Account where id=:acc.id];
        system.assertEquals(0, i);
        Test.stopTest();
    }
    // Old customer importing exception code end

    /*
    static testMethod void testCreateCustomerMore() {
        Test.startTest();
        CustomerNumberSeq__c custSeq = getPreparedData();
        Address__c add = new Address__c(Street__c = 'Main Street', 
            Town__c = 'Leeds', Postcode__c = 'LS1');
        insert add;
        //clsCustomerNumber custNum;        
        //custNum = new clsCustomerNumber(64448888);
        //String newNum;
        List<Account> accList = new List<Account>(); 
        //Map <String , Integer> numbers = new Map <String , Integer>();        
        for (Integer i=0 ; i<1000 ;i++){
            accList.add(new Account(FirstName = 'Robert', LastName = 'John', 
                Street_YK__c = add.Id            
            ));
        
        }
        insert accList;
        Test.stopTest();
        //system.assert(1000 == numbers.size());
    }
    */  
        
}