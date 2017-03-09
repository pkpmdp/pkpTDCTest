@isTest(seeAlldata=true)
public class tgrOEndCustAccountTest {
  public  static testMethod void  test_Trigger(){
       
      	Account acc = new Account();
      	RecordType recordType = [Select r.Name, r.Id From RecordType r where r.Name = 'YK Customer Account'];
      	acc.FirstName='tttt';
        acc.LastName='trial'; 
        acc.Customer_type__c='Enkel';
      	acc.Email__c='test45@abc.com';
      	acc.PersonEmail='test456@abc.com';
      	acc.CustomerSubType__c ='O-Slutkunde';
        insert acc;
}
    

}