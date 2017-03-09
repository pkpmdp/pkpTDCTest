public class clsKissCaseContractDurationYasu {
    public Opportunity kiss_case {get;set;}
    
    public clsKissCaseContractDurationYasu(ApexPages.StandardController controller) {        
        SObject obj = controller.getRecord();
        if (obj.getsObjectType() == Schema.Opportunity.SObjectType) {
            kiss_case = [Select Id, Contract_Duration__c, Deploy_Date__c, StageName from Opportunity where id = : obj.id limit 1];  
        }        
    }
    
    public String getContractDurationView(){
        if( (kiss_case.Contract_Duration__c != null) &&
            (kiss_case.StageName == 'Idrift') &&
            (kiss_case.Deploy_Date__c != null) )  {
                if(kiss_case.Contract_Duration__c == 0)
                    return kiss_case.Deploy_Date__c.format();
                else{
                    //return kiss_case.Exp_Deploy_Date__c.AddMonths(Integer.valueOf(kiss_case.Contract_Duration__c)).format();
                    Date dateObj = kiss_case.Deploy_Date__c.AddMonths(Integer.valueOf(kiss_case.Contract_Duration__c));
                    Date calculatedDateObj = 
                        Date.newInstance(dateObj.year(), 
                        dateObj.month(), 
                        Date.daysInMonth(dateObj.year(),
                        dateObj.month()));
                    return calculatedDateObj.format(); 
                }
          }
          else
            return '';
    }
    
    public static testmethod void testController(){

 profile ysp=[select id,name from profile where name='YouSee Sales User' limit 1];
        User YSSalesUser = [Select Id from User where Isactive=true and profileId=:ysp.id limit 1];
    
        //Test create action
        System.runAs(YSSalesUser) {
            Opportunity opport = new Opportunity();
            opport.Name = 'TestKissCase';
            opport.Deploy_Date__c = Date.today();
            opport.CloseDate = Date.today();
            opport.Contract_Duration__c = 12;
            opport.StageName = 'Idrift';  
            insert opport;          
            
            ApexPages.StandardController sc = new ApexPages.StandardController(opport);
            clsKissCaseContractDurationYasu controller = new clsKissCaseContractDurationYasu(sc);
            Test.setCurrentPageReference(Page.KissCaseContractDurationYasuView);
            controller.kiss_case = opport;
            sc.save();
            system.debug('Testing Yasu rule for Contract Duration:'); 
            Date tmp = opport.Deploy_Date__c.AddMonths(Integer.valueOf(opport.Contract_Duration__c));
            Date correctDate = Date.newInstance(tmp.year(), 
                               tmp.month(), 
                               Date.daysInMonth(tmp.year(),tmp.month())); 
            controller.getContractDurationView();                           
            System.assertEquals(correctDate.format(), controller.getContractDurationView());
        }       
    } 
}