public class clsCustomInteractionLog {
    private Account myAccount;
    private String defaultSubject = 'Call';
    

    public String accountId { 
        get {
            if(accountId == null) {
                accountId = ApexPages.currentPage().getParameters().get('id');
            }
            return accountId;
        }
        set; 
    }

    public void updateWhoWhatId() {           
//        Integer caseCount = [Select COUNT() from Case where id = :caseId];
        Integer accountCount = [Select COUNT() from Account where id = :accountId];
        
        if (accountCount==0) {
            statusMessage = 'This log is not associated with a Account or Contact! Please save the account.';
            return;
        }
//        Case myCase = [Select id, contactId from Case where id = :caseId];
        myAccount = [Select id from Account where id = :accountId];

//        task.whoId = myAccount.contactId;
        task.whatId = myAccount.id;
    }

    private void initializeTask() {
        updateWhoWhatId();
        task.subject = defaultSubject;    
    }
    
    public clsCustomInteractionLog(ApexPages.StandardController controller) {
        initializeTask();
    }       

    public String ANI { get; set;}
    public String CallObject { get; set;} 
    public Integer CallDurationInSeconds { get; set;} 
    public String CallType { get; set;}  
    public String CallDisposition { get; set;}        
    
    public String statusMessage { get; set; }

    public Task task { 
        get {
            if(task == null) {
                task = new Task();
            }
            return task;
        }
        set;  
    }
    
    public void setCallAttachedData() {
        task.CallObject = CallObject;
        //task.ANI__c = ANI;
    }   
     
    public void setCallType() {
        task.CallType = CallType;   
    }  

    public void setCallEndData() {
        task.CallDurationInSeconds = CallDurationInSeconds;   //call duration 
        task.CallDisposition = CallDisposition;               //call result 
        task.ActivityDate = DateTime.now().date();            //due date
        //task.PersonEmail = myAccount.Email__c;                       //email
        //task.Name = ???                                     //Name who 
        task.Status = 'Completed';
        task.Priority = 'Normal';
        task.Subject=task.Subject+' '+calculateCallStartDateTime();
        save();   
    }
    
    private String calculateCallStartDateTime(){
        Long currentTimestamp = Datetime.now().getTime();
        Long callStartTimestamp = currentTimestamp - (CallDurationInSeconds*1000);
        return String.valueOf(Datetime.newInstance(callStartTimestamp));
    }

    
    public void save() {
        upsert task;
        statusMessage = 'Last save at ' + DateTime.now().format();
    }
    
     public void saveAndNew() {
        save();
        task = null;
        initializeTask();
        //task.ANI__c= ANI;
        task.CallObject = CallObject;
    }        

    public List<SelectOption> getSubjectItems() {
        List<SelectOption> options = new List<SelectOption>();
        //String subjectCallDtTm = 'Call ' + DateTime.now();        
        //options.add(new SelectOption(subjectCallDtTm,subjectCallDtTm));        
        options.add(new SelectOption(defaultSubject,defaultSubject));                
        
        options.add(new SelectOption('Telefonopkald','Telefonopkald'));
        options.add(new SelectOption('Informationsmøde','Informationsmøde'));
        options.add(new SelectOption('Møde','Møde'));        
        options.add(new SelectOption('Telefonmøde','Telefonmøde'));
        options.add(new SelectOption('Opfølgning','Opfølgning'));
        return options;        
    }
            
}