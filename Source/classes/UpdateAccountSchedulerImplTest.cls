@isTest

class UpdateAccountSchedulerImplTest {

    public static testMethod void testScheduler() {
        
        String customerNumber = '67891';
        Account customer = new Account(Customer_No__c = customerNumber, Name = 'Test');
        customer.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();
        insert customer;
        
        Scheduled_Update__c  scheduled_Update = new Scheduled_Update__c(Id__c = customer.Id);
        insert scheduled_Update;
        
        List<Scheduled_Update__c> items = [select id from Scheduled_Update__c];
        System.assert(items.size() == 1); 
        
        Test.startTest();

        UpdateAccountSchedulerImpl updateAccountSchedulerImpl = new UpdateAccountSchedulerImpl();
        updateAccountSchedulerImpl.runJob();
        
        Account customerNew = [select id, Survey_sent_date__c from Account where id = :customer.id]; 
        System.assert(customerNew.Survey_sent_date__c == Date.Today());
        
        items = [select id from Scheduled_Update__c];
        System.assert(items.size() == 0); 

        Test.stopTest();
    }
}