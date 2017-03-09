@isTest
public class AddressPrePopulateCasperTest {
    public static testMethod void AddressPrePopulateCasperTest()
    {
        
      	ApexPages.StandardController controller = new ApexPages.StandardController(new Address__c());
        Address__c app=(Address__c)controller.getRecord();
        AddressPrePopulateCasper ap=new AddressPrePopulateCasper();
        AddressPrePopulateCasper apc=new AddressPrePopulateCasper(controller);
        ap.sendToCasper();
        ap.redirectPageToStandard();
            
       
       
    }
	

}