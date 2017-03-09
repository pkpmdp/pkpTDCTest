@isTest(SeeAllData=true)
public class Yousee_View_o_customersTest
{     
    static testmethod void testGetOCustomer()
    {
        
      	String cuNumber = '0000000059';
        PageReference form = new PageReference('Page.YouSee_O_customers_form');
      	Test.setCurrentPageReference(form);  
        ApexPages.currentPage().getParameters().put('cableunitnumber',cuNumber);
   
        Yousee_View_o_customers viewOCustomers = new Yousee_View_o_customers();
            
        Yousee_View_o_customers.OCustomer inn = new Yousee_View_o_customers.OCustomer();
        inn.lastName = 'Test';
        inn.address = '';
        inn.firstName = 'test';
        inn.email = 'abc@test.com';
        inn.phone = '123456';
            
        viewOCustomers.getOCustomers();
       
        
    }
    
    
    

}