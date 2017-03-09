public class CallbackCaseController {
    // current callback Case
    private Case objCase;
    
    // public get property
    public Case getCase(){
    return this.objCase;
  }
    
    // constructor
  public CallbackCaseController() {
    // select Case from db by Id
    Map<String, String> mapParams = ApexPages.currentPage().getParameters();       
    if (mapParams.containsKey('Id')){
      this.objCase = [SELECT Id, Status, AccountId, CaseNumber, Department__c, Product_2__c, Type_Task__c, Call_Back__r.CB_time__c, CB_phone_number__c, Subject, Description FROM Case WHERE Id = :mapParams.get('Id')];
    }
  }
  
  // save changes from page
  public PageReference save(){

    if (!validate()){
        return null;
    }
    if (this.objCase == null){
        return null;
    }
    try{
        update this.objCase;
    } catch (DmlException ex){
        ApexPages.addMessages(ex);
        return null;
    }
    // when OK go back to customer
    return new PageReference('/' + this.objCase.AccountId);
  }
  
  /*
   * return true if it is valid.
   */

  private boolean validate(){
    if (this.objCase!=null && this.objCase.CB_phone_number__c!=null && this.objCase.CB_phone_number__c.length() < 8){
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CB_Case_Phone_Length));
        return false;
    }
    return true;
  }
  // cancel callback Case -> set status to Cancelled
  public PageReference cancelCase(){
    if (this.objCase == null){
      return null;
    }
    try{
        this.objCase.Status = 'Cancelled';
      update this.objCase;
    } catch (DmlException ex){
      ApexPages.addMessages(ex);
      return null;
    }
    // when OK go back to customer
    return new PageReference('/' + this.objCase.AccountId);
  }
  
  // update callback Case (all changes from page) and redirect to booking calendar to reschedule callback Case
  public PageReference updateCase(){
    if (this.objCase == null){
      return null;
    }
    try{
      Map<String, String> mapParams = ApexPages.currentPage().getParameters();       
      if (mapParams.containsKey('CB_phone_number__c')){
       this.objCase.CB_phone_number__c = mapParams.get('CB_phone_number__c');
      }
      if (mapParams.containsKey('Subject')){
       this.objCase.Subject = mapParams.get('Subject');
      }
      if (mapParams.containsKey('Description')){
       this.objCase.Description = mapParams.get('Description');
      }
      
        update this.objCase;
    } catch (DmlException ex){
      ApexPages.addMessages(ex);
      return null;      
    }
    // go to booking calendar to reschedule callback Case
    return new PageReference('/apex/CallbackBooking?CaseId=' + this.objCase.Id + '&action=reschedule&retUrl=/apex/CallbackCase?Id=' + this.objCase.Id);
    
  }
  
  // unit test method
  static testMethod void testCallbackCaseController(){
    CB_Case__c cbCase1 = new CB_Case__c(CB_time_from__c = DateTime.newInstance(Date.today() + 1, Time.newInstance(10, 0, 0, 0)), CB_time_to__c = DateTime.newInstance(Date.today() + 1, Time.newInstance(12, 0, 0, 0)), CB_type__c = 'Dummy');
    CB_Case__c cbCase2 = new CB_Case__c(CB_time_from__c = DateTime.newInstance(Date.today() + 1, Time.newInstance(10, 0, 0, 0)), CB_time_to__c = DateTime.newInstance(Date.today() + 1, Time.newInstance(12, 0, 0, 0)), CB_type__c = 'Dummy');
    insert cbCase1;
    insert cbCase2;
    
    Case case1 = new Case(Department__c = 'YOT', Product_2__c = 'YOT Call Back', Type_Task__c = 'Dummy', Status = 'New', Call_Back__c = cbCase1.Id);
    Case case2 = new Case(Department__c = 'YOT', Product_2__c = 'YOT Call Back', Type_Task__c = 'Dummy', Status = 'New', Call_Back__c = cbCase2.Id);
    insert case1;
    insert case2;
    
    //
    CallbackCaseController cbcBad = new CallbackCaseController();
    system.debug(cbcBad.getCase() == null);
    system.debug(cbcBad.save() == null);
    system.debug(cbcBad.cancelCase() == null);
    system.debug(cbcBad.updateCase() == null);
    
    PageReference pageRef = Page.CallbackCase;
    Test.setCurrentPage(pageRef);
    
    // initial parameters, first Case should succeed
    ApexPages.currentPage().getParameters().clear();
    ApexPages.currentPage().getParameters().put('Id', case1.Id);
    
    CallbackCaseController cbc = new CallbackCaseController();
    system.debug(cbc.getCase() == case1);
    
    PageReference prSave = cbc.save();
    system.debug(prSave != null);
    
    ApexPages.currentPage().getParameters().clear();    
    ApexPages.currentPage().getParameters().put('CB_phone_number__c', 'CB_phone_number__c');
    ApexPages.currentPage().getParameters().put('Subject', 'Subject');
    ApexPages.currentPage().getParameters().put('Description', 'Description');
    
    PageReference prUpdate = cbc.updateCase();
    system.debug(prUpdate != null);
    
    PageReference prCancel = cbc.cancelCase();
    system.debug(prCancel != null);
    
    ApexPages.currentPage().getParameters().clear();
    ApexPages.currentPage().getParameters().put('Id', case2.Id);
    
    CallbackCaseController cbcCancelled = new CallbackCaseController();    
    system.debug(cbcCancelled.getCase() == case2);
    
    delete case2;
    
    system.debug(cbcCancelled.getCase() == case2);
        
    prSave = cbcCancelled.save();
    system.debug(prSave == null);
    prUpdate = cbcCancelled.updateCase();
    system.debug(prUpdate == null);
    prCancel = cbcCancelled.cancelCase();
    system.debug(prCancel == null);
  }
}