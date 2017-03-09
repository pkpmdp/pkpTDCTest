@isTest
public class cInstallationHistoryTest{

    public static testMethod void tocomparetest(){
    
    date myDate1 = date.newInstance(2001, 3, 21);
    String dayString1 = myDate1.format();
    
    date myDate2 = date.newInstance(2001, 5, 21);
    String dayString2 = myDate2.format();
    
    date myDate3 = date.newInstance(2001, 5, 21);
    String dayString3 = myDate3.format();
    
    cInstallationHistory obj= new cInstallationHistory();
    cInstallationHistory obj2= new cInstallationHistory();
    cInstallationHistory obj3= new cInstallationHistory();
    
    obj.EndDate=dayString1 ;
    obj2.EndDate=dayString2 ;
    obj3.EndDate=dayString3;
    
    obj.compareTo(obj2);
    obj2.compareTo(obj3);
    obj3.compareTo(obj);
    
    System.debug('date 1'+ obj.compareTo(obj2));



}
}