public class clsContactInfoWarningController {

    private String contactInfoWarning;
    private Boolean marketingPermission;
    private Date marketPermUpdatedDate;

    public clsContactInfoWarningController(ApexPages.StandardController controller) {
        Account dbAccount = [SELECT PersonEmail, PersonMobilePhone, No_Email__c,X34_Mobile_Number__c,X34_Fixed_line__c,Home_Phone__c,(Select Marketing_Permission__c,Marketing_permission_Opdateret_Dato__c from Permissions__r limit 1) FROM Account WHERE Id = :controller.getRecord().Id];
        contactInfoWarning = null;
        marketingPermission = null;
        marketPermUpdatedDate = null;
         if(dbAccount.permissions__r!=null && dbAccount.permissions__r.size()>0){
        marketingPermission = dbAccount.permissions__r[0].marketing_permission__c;
        marketPermUpdatedDate = dbAccount.permissions__r[0].Marketing_permission_Opdateret_Dato__c;
        }
        system.debug('marketingPermission: '+marketingPermission+' marketPermUpdatedDate: '+marketPermUpdatedDate);
        
        if (dbAccount.PersonMobilePhone == null) {
            if (dbAccount.PersonEmail == null && !dbAccount.No_Email__c) {
              //  if ((marketingPermission == null || !marketingPermission) && marketPermUpdated) {
                if (marketingPermission == null || !marketingPermission) {
                    contactInfoWarning = System.Label.No_Mobile_Phone_And_Email_Address_And_Permission;
                } else {
                    contactInfoWarning = System.Label.No_Mobile_Phone_And_Email_Address;
                }
            } else {
               // if ((marketingPermission == null || !marketingPermission) && marketPermUpdatedDate==null) {
                if (marketingPermission == null || !marketingPermission) {
                    contactInfoWarning = System.Label.No_Mobile_Phone_And_Permission;
                } else {
                    contactInfoWarning = System.Label.No_Mobile_Phone;  
                }
            }
        } else { 
            if (dbAccount.PersonEmail == null && !dbAccount.No_Email__c) {
                if (marketingPermission == null || !marketingPermission) {
                    contactInfoWarning = System.Label.No_Email_Address_And_Permission;
                } else {
                    contactInfoWarning = System.Label.No_Email_Address;
                }
            } else if (marketingPermission == null || !marketingPermission) {
                    contactInfoWarning = System.Label.No_Permission;
            }
        }
        
   
      /*  if(dbAccount.PersonEmail == null){
            if(dbAccount.PersonMobilePhone == null){
                    if(dbAccount.Home_Phone__c!=null && dbAccount.X34_Mobile_Number__c==null && dbAccount.X34_Fixed_line__c==null){
                                if (marketingPermission == null || !marketingPermission){
                                    contactInfoWarning = System.Label.No_Mobile_Phone_And_Permission; // condition 6  no permission
                                }else{
                                    contactInfoWarning = System.Label.No_Mobile_Phone; // condition 6  
                                }
                    }else if(dbAccount.Home_Phone__c!=null && dbAccount.X34_Mobile_Number__c!=null && dbAccount.X34_Fixed_line__c==null){
                                if (marketingPermission == null || !marketingPermission){
                                    contactInfoWarning = System.Label.Confirm_Mobile_Email_and_Marketing_Permission; // condition 7  no permission
                                }else{
                                    contactInfoWarning = System.Label.Confirm_Mobile_and_Email; // condition 7   
                                }
                    }else if(dbAccount.Home_Phone__c!=null && dbAccount.X34_Mobile_Number__c!=null && dbAccount.X34_Fixed_line__c!=null){
                                if (marketingPermission == null || !marketingPermission){
                                    contactInfoWarning = System.Label.Confirm_Mobile_Email_and_Marketing_Permission; // condition 8  no permission
                                }else{
                                    contactInfoWarning = System.Label.Confirm_Mobile_and_Email; // condition 8   
                                }
                    }else if( dbAccount.Home_Phone__c==null && dbAccount.X34_Mobile_Number__c != null && dbAccount.X34_Fixed_line__c ==null){
                                if (marketingPermission == null || !marketingPermission){
                                    contactInfoWarning = System.Label.No_Mobile_Phone_And_Email_Address_And_Permission; // condition 10  no permission
                                }else{
                                    contactInfoWarning = System.Label.No_Mobile_Phone_And_Email_Address; // condition 10    
                                }
                    }else if(dbAccount.Home_Phone__c==null && dbAccount.X34_Mobile_Number__c != null && dbAccount.X34_Fixed_line__c !=null){
                                if (marketingPermission == null || !marketingPermission){
                                    contactInfoWarning = System.Label.Update_Contact_Numbers_and_Marketing_Permission; // condition 11  no permission
                                }else{
                                    contactInfoWarning = System.Label.Update_Contact_Numbers; // condition 11    
                                }
                    }else if(dbAccount.Home_Phone__c==null && dbAccount.X34_Mobile_Number__c == null && dbAccount.X34_Fixed_line__c !=null){
                                if (marketingPermission == null || !marketingPermission){
                                    contactInfoWarning = System.Label.No_Mobile_Phone_And_Email_Address_And_Permission; // condition 13  no permission
                                }else{
                                    contactInfoWarning = System.Label.No_Mobile_Phone_And_Email_Address; // condition 13   
                                }
                    }else if(dbAccount.Home_Phone__c==null && dbAccount.X34_Mobile_Number__c == null && dbAccount.X34_Fixed_line__c ==null){
                                if (marketingPermission == null || !marketingPermission){
                                    contactInfoWarning = System.Label.No_Mobile_Phone_And_Email_Address_And_Permission; // condition 16  no permission
                                }else{
                                    contactInfoWarning = System.Label.No_Mobile_Phone_And_Email_Address; // condition 16  
                                }
                    }
                    
            }else{
                    if(dbAccount.Home_Phone__c==null && dbAccount.X34_Mobile_Number__c==null && dbAccount.X34_Fixed_line__c==null){
                            if (marketingPermission == null || !marketingPermission){
                                contactInfoWarning = System.Label.Confirm_Fixed_Number_Email_and_Marketing_Permission; // condition 1  no permission
                            }else{
                                contactInfoWarning = System.Label.Confirm_Fixed_Number_and_Email; // condition 1 permission    
                            }
                    }else if(dbAccount.Home_Phone__c != null && dbAccount.X34_Mobile_Number__c==null && dbAccount.X34_Fixed_line__c==null ){
                            if (marketingPermission == null || !marketingPermission){
                                contactInfoWarning = System.Label.No_Email_Address_And_Permission; // condition 2  no permission
                            }else{
                                contactInfoWarning = System.Label.No_Email_Address; // condition 2 permission    
                            }
                    }else if(dbAccount.Home_Phone__c != null && dbAccount.X34_Mobile_Number__c!=null && dbAccount.X34_Fixed_line__c==null){
                            if (marketingPermission == null || !marketingPermission){
                                contactInfoWarning = System.Label.No_Email_Address_And_Permission; // condition 3  no permission
                            }else{
                                contactInfoWarning = System.Label.No_Email_Address; // condition 3 permission    
                            }
                    }else if(dbAccount.Home_Phone__c != null && dbAccount.X34_Mobile_Number__c!=null && dbAccount.X34_Fixed_line__c!=null){
                            if (marketingPermission == null || !marketingPermission){
                                contactInfoWarning = System.Label.No_Email_Address_And_Permission; // condition 4  no permission
                            }else{
                                contactInfoWarning = System.Label.No_Email_Address; // condition 4 permission    
                            }
                    }       
            }
        }else{
            if(dbAccount.PersonMobilePhone == null){                
                    if(dbAccount.Home_Phone__c!=null && dbAccount.X34_Mobile_Number__c!=null && dbAccount.X34_Fixed_line__c!=null ){
                        if(marketingPermission == null || !marketingPermission){
                            contactInfoWarning = System.Label.Confirm_Mobile_and_Marketing_Permission; // condition 9  no permission
                        }else{
                            contactInfoWarning = System.Label.Confirm_Mobile; // condition 9 permission    
                        }
                    }else if(dbAccount.Home_Phone__c==null && dbAccount.X34_Mobile_Number__c!=null && dbAccount.X34_Fixed_line__c!=null){
                        if(marketingPermission == null || !marketingPermission){
                            contactInfoWarning = System.Label.Confirm_Phone_Numbers_and_Marketing_Permission; // condition 12 no permission
                        }else{
                            contactInfoWarning = System.Label.Confirm_Phone_Numbers; // condition 12 permission    
                        }
                    }else if(dbAccount.Home_Phone__c==null && dbAccount.X34_Mobile_Number__c==null && dbAccount.X34_Fixed_line__c!=null){
                        if(marketingPermission == null || !marketingPermission){
                            contactInfoWarning = System.Label.No_Mobile_Phone_And_Email_Address_And_Permission; // condition 14 no permission
                        }else{
                            contactInfoWarning = System.Label.No_Mobile_Phone_And_Email_Address; // condition 14 permission    
                        }
                    }else if(dbAccount.Home_Phone__c==null && dbAccount.X34_Mobile_Number__c==null && dbAccount.X34_Fixed_line__c==null){
                        if(marketingPermission == null || !marketingPermission){
                            contactInfoWarning = System.Label.No_Mobile_Phone_And_Email_Address_And_Permission; // condition 15 no permission
                        }else{
                            contactInfoWarning = System.Label.No_Mobile_Phone_And_Email_Address; // condition 15 permission    
                        }
                }
            }else{
                if(dbAccount.Home_Phone__c!=null && dbAccount.X34_Mobile_Number__c!=null && dbAccount.X34_Fixed_line__c!=null){    
                    if (marketingPermission == null || !marketingPermission){
                        contactInfoWarning = System.Label.No_Permission;
                    }
                }
            }
        }*/
    }

    public Boolean getShowWarning() {
        return contactInfoWarning != null;
    }

    public String getContactInfoWarning() {
        return contactInfoWarning;
    }

    @isTest(SeeAllData=true)
    static void testAll() {
        // No mobile phone & no email address & no permission
        Account acc = new Account(FirstName='John', LastName='Doe');
        acc.PersonEmail = null;
        acc.PersonMobilePhone = null;
        //acc.Permission__c = null;
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'YK Customer Account'].Id;
              insert acc;
        clsContactInfoWarningController ctrl =
            new clsContactInfoWarningController(new ApexPages.standardController(acc))
        ;
        //System.assert(ctrl.getShowWarning());
        //System.assertEquals(ctrl.getContactInfoWarning(), System.Label.No_Mobile_Phone_And_Email_Address_And_Permission);

        // No mobile phone and permission
        acc.PersonEmail = 'a@b.c';
        acc.PersonMobilePhone = null;
      /*  acc.Home_Phone__c ='4778 4900';
        acc.X34_Mobile_Number__c='';
        acc.X34_Fixed_line__c='';
        //acc.Permission__c = null;
        insert acc;*/
        update acc;
        ctrl = new clsContactInfoWarningController(new ApexPages.standardController(acc));
        //System.assert(ctrl.getShowWarning());
        //System.assertEquals(ctrl.getContactInfoWarning(), System.Label.No_Mobile_Phone_And_Permission);

        // No email address and permission
        acc.PersonEmail = null;
        acc.PersonMobilePhone = '911';
        acc.Permission__c = null;
        update acc;
        ctrl = new clsContactInfoWarningController(new ApexPages.standardController(acc));
        //System.assert(ctrl.getShowWarning());
        //System.assertEquals(ctrl.getContactInfoWarning(), System.Label.No_Email_Address_And_Permission);

        // No permission, email address & mobil phone present
        acc.PersonEmail = 'a@b.c';
        acc.PersonMobilePhone = '911';
        acc.Permission__c = null;
        update acc;
        ctrl = new clsContactInfoWarningController(new ApexPages.standardController(acc));
        //System.assert(ctrl.getShowWarning());
        //System.assertEquals(ctrl.getContactInfoWarning(), System.Label.No_Permission);
        
        // No mobile phone & no email address
        acc.PersonEmail = null;
        acc.PersonMobilePhone = null;
        acc.Permission__c = 'Nej';
        update acc;
        ctrl = new clsContactInfoWarningController(new ApexPages.standardController(acc));
        //System.assert(ctrl.getShowWarning());
        //System.assertEquals(ctrl.getContactInfoWarning(), System.Label.No_Mobile_Phone_And_Email_Address);
        
        // No mobile phone
        acc.PersonEmail = 'a@b.c';
        acc.PersonMobilePhone = null;
        acc.Permission__c = 'Nej';
        update acc;
        ctrl = new clsContactInfoWarningController(new ApexPages.standardController(acc));
        //System.assert(ctrl.getShowWarning());
        //System.assertEquals(ctrl.getContactInfoWarning(), System.Label.No_Mobile_Phone);

        // No email address
        acc.PersonEmail = null;
        acc.PersonMobilePhone = '911';
        acc.Permission__c = 'Nej';
        update acc;
        ctrl = new clsContactInfoWarningController(new ApexPages.standardController(acc));
        //System.assert(ctrl.getShowWarning());
        //System.assertEquals(ctrl.getContactInfoWarning(), System.Label.No_Email_Address);

        // Email address, mobil phone & permision present
        acc.PersonEmail = 'a@b.c';
        acc.PersonMobilePhone = '911';
        acc.Permission__c = 'Nej';
        update acc;
        ctrl = new clsContactInfoWarningController(new ApexPages.standardController(acc));
        //System.assert(!ctrl.getShowWarning());
       // System.assertEquals(ctrl.getContactInfoWarning(), null);
        
    } 
}