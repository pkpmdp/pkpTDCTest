public class DispatcherForAccountAssignmentController {
    //add an instance variable for the standard controller
  
   public Contact contact;
   public boolean hierarchyAccount;
   public List<User> userId;

   public DispatcherForAccountAssignmentController (ApexPages.StandardController stdController){ 
        contact = (Contact)stdController.getRecord();
        hierarchyAccount = false;
   }

    
    
    
  public PageReference redirectEditPage(){ 
        PageReference customPage;
        Contact con = [Select id, HierarchyAccount__c From Contact  where id = :contact.Id LIMIT 1];
        System.debug('con HierarchyAccount__c---'+con.HierarchyAccount__c);
        if(con.HierarchyAccount__c != null){
             userId = [select Id,IsActive from user where contactId =: con.Id];
             if(userId.size() > 0){
                System.debug('Inside One');
             customPage= new PageReference('/apex/AccountAssignmentContactPage');
             customPage.getParameters().put('contactId', con.id);
             }
             else{
                System.debug('Inside Two');
             customPage= new PageReference('/apex/AccountAssignmentContactPage');
             customPage.getParameters().put('contactId', con.id);
             } 
        }else {
             userId = [select Id,IsActive from user where contactId =: con.Id];
             if(userId.size() > 0){
                System.debug('Inside Three');
             customPage= new PageReference('/apex/AccountAssignmentErrorPage');
             customPage.getParameters().put('contactId', con.id);  // added
             }
             else{
                System.debug('Inside Four');
             customPage= new PageReference('/apex/AccountAssignmentErrorPageNoUser');
             customPage.getParameters().put('contactId', con.id);   
             } 
        }
        customPage.setRedirect(true);
        return customPage;
   }  
   
}