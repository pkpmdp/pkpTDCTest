public class contactConstClass {
	  public static string ACCOUNTID = Label.SC_AccountId;
	  public static string ROLEVALIDATIONMSG = Label.SC_RoleValidationMsg;
	 
	  public static string PHONEVALIDATIONMSG = Label.SC_PhoneValidationMsg;
	  public static string CABLEUNITNUMBER = Label.SC_CableUnitNoText;
	  
	  public static string MANAGECONTACTURL = '/apex/ManageContactsPage';
      public static string STATUS = Label.SC_Status;
	  public static string CREATEMSG = Label.SC_Addedsuccessfully;
	  public static string PASSWORDCHANGED = Label.SC_PasswordChangedSuccessfully;
	  public static string PASSWORDFAILED = Label.SC_PasswordFailed;
	  public static string SELECTVALUE= Label.SC_SelectText;
	  public static string SELECTLABEL='----------- Vælg -------------';
	  //public static string SELECTLABEL='----------- Select -------------';
	  public static string PORTALUSER ='Portal User';
	  public static string PORTALMANAGER ='Portal Manager';
	  public static string EDITMSG=Label.SC_EditMsg;
	  
	  public static string CONTACTID='contactId';
	  public static string VIEW='View';
	  public static string EDIT='Edit';
	  public static string DELETED='Delete';
	  public static string SPACE='    ';
	  public static string INITIALSTATUS='initial';
	  public static string UPDATEDMSG=Label.SC_UpdatedMsg;
	  public static string CREATEDMSG=Label.SC_CreatedMsg;
	  
	  public static string DELETEALLMSG=Label.SC_DeletedContactsMsg;
	  public static string ACTIVE=Label.SC_ActiveStatus;
	  
	  public static string INACTIVE=Label.SC_InAktivStatus;
	  
	  public static string DELETESTATUS=Label.SC_Deletedsuccessfully;

	  public static string DELETEMSG=Label.SC_DeletedContact;
	  
	  public static string EDITCONTACTURL='/apex/EditContactDetailsPage';
	  public static string CABLEUNITDETAILURL='/apex/CableUnitDetailsPage';
	  public static string CREATECONTACTURL='/apex/CreateContactPage';
	  public static string ANTALVALIDATIONMSG=Label.SC_AntalValidationMsg;
	
	  // added for extra check
	  public static string CHECKACTIVE = 'Ja';
	  
	  //added for SC-505
	  public static String ContactRecordType = YSRecordTypes__c.getInstance('YSRecordTypes').YS_Contact_Record_Type__c;	  
}