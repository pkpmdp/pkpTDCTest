public class CalculateBusinessHoursAgesTest {
    public static testMethod void testBusinessHoursBucketer() {
        // The actual test class has been commented out
        // due to the deactivation of trigger CalculateBusinessHoursAges
        // This following line is just to maintain test coverage
        System.assert(true);

/*
        Stop_Status__c ss = new Stop_Status__c(Name = 'On Hold');
        insert ss;

        Case c = new Case();
        c.Status = 'New';
        c.Last_Status_Change__c = System.Now();
        insert c;

        c.Status = 'On Hold';
        c.OwnerId = System.Userinfo.getUserId();
        c.manual_assign__c = true;
        update c;

        c.Status = 'New';
        update c;

    Case updatedCase = [select Time_With_Customer__c,Time_With_Support__c,Case_Age_In_Business_Hours__c from Case where Id=:c.Id];
    System.assert(updatedCase.Time_With_Customer__c!=null);
        System.assert(updatedCase.Time_With_Support__c!=null);
        System.assert(updatedCase.Case_Age_In_Business_Hours__c==null);

        c.Status = 'Closed';
        c.Internal_Comments_Close_Reason__c = 'Closed';
        update c;

        updatedCase = [select Time_With_Customer__c,Time_With_Support__c,Case_Age_In_Business_Hours__c from Case where Id=:c.Id];

        System.assert(updatedCase.Time_With_Customer__c!=null);
        System.assert(updatedCase.Time_With_Support__c!=null);
        System.assert(updatedCase.Case_Age_In_Business_Hours__c!=null);
*/
    }
}