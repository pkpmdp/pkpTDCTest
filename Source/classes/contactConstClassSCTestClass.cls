@isTest(SeeAllData = true)
private class contactConstClassSCTestClass{
    
    public static string ACCOUNTID = 'a100045612000';
    public static string ROLEVALIDATIONMSG = 'Vælg kontaktrolle';
   
    public static string PHONEVALIDATIONMSG = 'Indtast telefonnummer';
    public static string CABLEUNITNUMBER = '000003719';
    public static string MANAGECONTACTURL = '/apex/ManageContactsPage';
    public static string STATUS = 'Aktiv';
    public static string CREATEMSG = 'Addedsuccessfully';
    public static string PASSWORDCHANGED = 'PasswordChangedSuccessfully';
    public static string PASSWORDFAILED = 'SC_PasswordFailed';
    public static string SELECTVALUE= '----Select----';
    public static string SELECTLABEL='----------- Vælg -------------';
    public static string PORTALUSER = 'Portal User';
    public static string PORTALMANAGER = 'Portal Manager';
    public static string EDITMSG= 'Edited Successfully';
    
    public static string CONTACTID = 'c0001245';
    public static string VIEW = 'View';
    public static string EDIT = 'Edit';
    public static string DELETED = 'Delete';
    public static string SPACE = '    ';
    public static string INITIALSTATUS = 'initial';
    public static string UPDATEDMSG = 'Updated Successfully';
    public static string CREATEDMSG = 'Created Successfully';
    
    public static string DELETEALLMSG = 'Deleted Successfully';
    public static string ACTIVE = 'Aktiv';
    
    public static string INACTIVE = 'InAktiv';
    
    public static string DELETESTATUS = 'Deletedsuccessfully';

    public static string DELETEMSG = 'Delete Contact';
    
    public static string EDITCONTACTURL ='/apex/EditContactDetailsPage';
    public static string CABLEUNITDETAILURL ='/apex/CableUnitDetailsPage';
    public static string CREATECONTACTURL ='/apex/CreateContactPage';
    public static string ANTALVALIDATIONMSG =Label.SC_AntalValidationMsg;

    // added for extra check
    public static string CHECKACTIVE = 'Ja'; 
    static testMethod void unitTest(){
        Test.startTest();
        contactConstClass testCls = new contactConstClass();
        Test.stopTest();
    
    }

}