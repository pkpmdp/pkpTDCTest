@isTest(seeAllData=true)
private class CustomerLogTestClass {

	
    static testMethod void accountTeamDetailsTest1() {
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/custlog';
        RestContext.request.addParameter('action','all');
        RestContext.request.addParameter('datalimit','5');
        RestContext.request.addParameter('CreatedById1','005D0000001BuD3IAK');
        RestContext.request.addParameter('CreatedDate1','2013-01-16T03:52:38.000Z');
        RestContext.request.addParameter('Creation_Date1','2012-01-02T16:30:18.000Z');     
        RestContext.request.addParameter('Customer_Number1', '605811076');   
        RestContext.request.addParameter('Customer1','0012000000PV94aAAD');
        RestContext.request.addParameter('Date1','2012-01-01');
        RestContext.request.addParameter('Id1','a1sD0000001IcBYIA0');
        RestContext.request.addParameter('Inquiry_Form1', 'Supplerende tekst');   
        RestContext.request.addParameter('Inquiry_Type1','Telefonisk');
        RestContext.request.addParameter('IsDeleted1','false');
        RestContext.request.addParameter('LastModifiedById1','005D0000001BuD3IAK');
        RestContext.request.addParameter('LastModifiedDate1', '2013-10-09T12:50:05.000Z');   
        RestContext.request.addParameter('Name1','8089361');
        RestContext.request.addParameter('OwnerId1','005200000012Dn3AAE');
        RestContext.request.addParameter('SystemModstamp1','2013-10-26T08:07:38.000Z');         
        RestContext.request.addParameter('Text1','TEST');    
        RestContext.request.addParameter('User_MID1','M36317');    
        RestContext.request.addParameter('User_Name1','TEST NAME');      
        clsInsertCustomerLog.doAction();
        clsInsertCustomerLog.getSingleContactRoleDetails();                             
    }
     
}