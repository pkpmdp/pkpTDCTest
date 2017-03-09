public class FastEditCaseController {
  private Case caseToSave;  
 
  public FastEditCaseController() {
    String id = ApexPages.currentPage().getParameters().get('id');
    caseToSave = [Select CaseNumber, Department__c, Product_2__c, Type_Task__c, Status, Internal_Comments_Close_Reason__c, Violation_of_SLA__c,                
                     Reserve_Until__c, Reservation_Reason__c, Number_of_task_in_this_case__c, Anlaeg_No_New__c, Postpone_Until__c from Case where id=:id];
  }
  
  public Case getCaseToSave() {
    return this.caseToSave;
  }

  public PageReference cancel() {
    return new PageReference('/' + caseToSave.Id);
  }


  public PageReference save() {
    try {
      update caseToSave;
    }catch (System.DMLException e) {
      System.debug('DML error: ' + e);
    }
    return new PageReference('/' + caseToSave.Id);
  }

  public PageReference saveGoToQueue() {
    PageReference pageRef;
    
    try {
      update caseToSave;
      pageRef=Page.CasesTab;
    }
    catch(DmlException ex) {
      ApexPages.addMessages(ex);
      pageRef=null;
    }

    return pageRef;
  }  

  public PageReference retrieveNextCase() {
    PageReference pageRef;
    
    try{
      update caseToSave;
      pageRef = new PageReference('/apex/CasesNextCase');
    }
    catch (DmlException ex) {
      ApexPages.addMessages(ex); 
      pageRef=null;
    }
    
    return pageRef;
  }
  
  public void setReserveUntil(Datetime reserveUntil) {
    caseToSave.Reserve_Until__c = reserveUntil; 
  }

  public void setReservationReason(String reservationReason) {
    caseToSave.Reservation_Reason__c = reservationReason; 
  }

  public void setNumberOftaskInThisCase(Decimal numberOfTaskInThisCase) {
    caseToSave.Number_of_task_in_this_case__c = numberOfTaskInThisCase; 
  }

  public void setStatus(String newStatus) {
    caseToSave.Status = newStatus; 
  }
  
}