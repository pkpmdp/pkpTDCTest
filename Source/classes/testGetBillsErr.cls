@isTest
public class testGetBillsErr {
    public static testmethod void testGetBillsErrfun()
    {
        GetBillsErr geterr = new GetBillsErr();
        geterr.code='abc';
        geterr.message='xyz'; 
        geterr.stacktrace='pqr';
    }
}