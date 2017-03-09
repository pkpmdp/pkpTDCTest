public class clsCasesTabController{
    private static Integer maxQuerySize = 100;
    private static Integer YKSmaxQuerySize = 200;
    private List<Case> cases;
    private Case caseFields;
    private Boolean disableNextButton;
    public String recordCounter{get; set;}
    public String workOnCaseIdResult{get;set;}
    public String workOnCaseId1Result{get;set;}
    public String workOnCaseId{get;set;}
    Public String closeCaseId{get;set;}
    public String newAccountTabID{get; set;}
    public String newCaseTabID{get; set;}
    public String CloseCaseAccId {get;set;}
    //CB part start
    public class ShowCbCasesStatus {
        /* Switcher for setting visibility fields */
        private boolean showCbCaseCol;
        private boolean showCaseCol;
        public ShowCbCasesStatus(boolean showCbCaseCol){
            this.setShowCbCaseCol(showCbCaseCol);
        }
        public boolean getShowCbCaseCol(){
            return showCbCaseCol;
        }
        public boolean getShowCaseCol (){
            return showCaseCol;
        }
        public void setShowCbCaseCol (boolean showCbCaseCol ){
            this.showCbCaseCol = showCbCaseCol;
            this.showCaseCol = !this.showCbCaseCol;
        }
    }
    //CB part end
    public class CaseCM{
        // Extended Case - includes CaseMilestone info
        ID Id;// Case.Id
        public String CaseNumber;// Case.CaseNumber
        public String Subject;// Case.Subject
        public String Origin;// Case.Origin
        public String Description;// Case.Description
        public ID AccountId;// Case.AccountId
        public String AccountName;// Case.Account.Name
        public String CreatedDate;// Case.CreatedDate
        public Id ContactId;// Case.contactId sf-1146
        public String ContactName;//Case.ContactName sf-1146
        public String TypeTask;// Case.Type_Task__c sf-1146
        public String TargetDate;// CaseMilestone.TargetDate
        public String CallBackTime;// Case.Call_Back__r.CB_time__c
		public Id CreatedBy;// Case.CreatedById sf-2682
		public String CreatedByName;//Case.ContactName sf-2682
      public CaseCM( 
            ID Id, String CaseNumber, String Subject, String Origin,String TypeTask,Id ContactId,String ContactName,
            String Description, ID AccountId,String AccountName,
            Datetime CreatedDate, Datetime TargetDate, String CallBackTime,Id CreatedBy,String CreatedByName
        ) {
             this.Id = Id;
             this.CaseNumber = CaseNumber;
             this.Subject = Subject;
             this.Origin = Origin;
             this.Description = Description;
             this.AccountId = AccountId;
             this.AccountName = AccountName;
             this.ContactId = ContactId;
             this.ContactName = ContactName;
             this.TypeTask = TypeTask;
             this.CreatedDate = CreatedDate != null ? CreatedDate.format() : null;
             this.TargetDate = TargetDate != null ? TargetDate.format() : null;
             this.CallBackTime = CallBackTime;
             this.CreatedBy = CreatedBy;
             this.CreatedByName = CreatedByName;
        }
        public ID getId() { return Id; }
        public String getCaseNumber() { return CaseNumber; }
        public String getSubject() { return Subject; }
        public String getOrigin() { return Origin; }
        public String getDescription() { return Description; }
        public ID getAccountId() { return AccountId; }
        public ID getContactId() { return ContactId; }
        public String getContactName() { return ContactName; }
        public String getTypeTask() { return TypeTask; }
        public String getAccountName() { return AccountName; }
        public String getCreatedDate() { return CreatedDate; }
        public String getTargetDate() { return TargetDate; }
        public String getCallBackTime() { return CallBackTime; }
        public Id getCreatedBy() {return CreatedBy; }
        public String getCreatedByName() {return CreatedByName;}
    }
    private List<CaseCM> casesCM;
    public String CaseId{get;set;}
    public String strCaseNumber{get;set;}
    private Map<String, String> label2valueMap = new Map<String, String>();
    private Map<String,String> recordTypeMap = new Map<String, String>();
    public clsCasesTabController() {
        /*
        List <Schema.PicklistEntry> items = Case.Product_2__c.getDescribe().getPicklistValues();
        for(Schema.PicklistEntry entry : items) {          
            if(entry.isActive()){             
                label2valueMap.put(entry.getLabel(), entry.getValue());
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'value=' + entry.getValue()));
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'label=' + entry.getLabel()));
            }
        }
        */ 
        CaseId = ApexPages.currentPage().getParameters().get('id');
        List<Case>lstcaseAc = [Select id,AccountId,CaseNumber from Case where id =:CaseId];
        	if(!lstcaseAc.isEmpty()){
        	strCaseNumber = lstcaseAc[0].CaseNumber;
        		if(lstcaseAc[0].AccountId!=null)     
        			CloseCaseAccId = lstcaseAc[0].AccountId; 		
        	}
        system.debug('==CloseCaseAccId==='+CloseCaseAccId);
        recordCounter = '0';
        caseFields = new Case();
        List<User_Queue__c> uq = [Select Department__c, Product__c, Type_Task__c From User_Queue__c Where User__c = : UserInfo.getUserId()];
        if (uq.size() == 1) {
            if(uq.get(0).Department__c == '--None--' || uq.get(0).Department__c == null){
                User user = [Select Department From User Where Id = : UserInfo.getUserId()];
                if(user.Department != null)
                    caseFields.Department__c = user.Department;
            }
            else{
                caseFields.Department__c = uq.get(0).Department__c;
                caseFields.Product_2__c = uq.get(0).Product__c;
                caseFields.Type_Task__c = uq.get(0).Type_Task__c;
            }
        }
        else{
            User user = [Select Department From User Where Id = : UserInfo.getUserId()];
            if(user.Department != null)
                caseFields.Department__c = user.Department;
        }
//initialize recordType map;
        List<RecordType> rtList = [select Id,Name from RecordType where SobjectType='Case'];
        for(RecordType rtItem:rtList){
            recordTypeMap.put(rtItem.Name,rtItem.Id);
        }
	}
    public Case getCaseFields(){
        return caseFields;
    }
    public void setCaseFields(Case c){
        caseFields = c;
    }
    public Boolean getDisableNextButton() {
        return disableNextButton;
    }

/*
    // Returns a collection of Cases
    public List<Case> getCases() {
        if (cases == null) queryForCases();
        System.debug('getter ' + cases.size());
        return cases;
    }
*/
// Returns a collection of extended Cases
    public List<CaseCM> getCases(){
        if (casesCM == null){
            casesCM = new List<CaseCM>();
        }
        if (cases == null) queryForCases();
        System.debug('getter ' + cases.size());
// Prepare the collection of extended Cases
        List<ID> caseIds = new List<ID>();
        for (Case c : cases) {
            caseIds.add(c.Id);
        }
        // collect target dates from related CaseMilestone records
        Map<Id, Datetime> caseIdTgDate = new Map<Id, Datetime>();
        for (CaseMilestone cm : [SELECT CaseId, TargetDate FROM CaseMilestone WHERE CaseId IN :caseIds]) {
            caseIdTgDate.put(cm.CaseId, cm.TargetDate);
        }
        // populate a list of extended Cases to show
        if (casesCM.isEmpty()){
            Boolean showCB = getShowCbCasesStatus().getShowCbCaseCol();
            for (Case c : cases) {
                CaseCM cCM = new CaseCM(
                    c.Id, c.CaseNumber, c.Subject, c.Origin,c.Type_Task__c,c.ContactId,c.Contact.name,
                    showCB ? c.Description : null, // queried only for CallBacks
                    c.AccountId, c.Account.Name,
                    c.CreatedDate, caseIdTgDate.get(c.Id),
                    showCB ? c.Call_Back__r.CB_time__c : null,
                    c.CreatedById ,// queried only for CallBacks 
                    c.CreatedBy.Name
                );
                casesCM.add(cCM);
            }
        }
        return casesCM;
    }
	public PageReference refreshCaseList(){
        return null;
    }
    public PageReference updateQueueCount() {       
        upsertUserQueue();
        queryForCases();
        System.debug('size of the queue is ' + cases.size());
        return null;        
    }
    public void upsertUserQueue() {
        User_Queue__c uq = new User_Queue__c();
        uq.User__c = UserInfo.getUserId();
        uq.Department__c = caseFields.Department__c;
        uq.Product__c = caseFields.Product_2__c;
        uq.Type_Task__c = caseFields.Type_Task__c;
        Database.UpsertResult result = Database.upsert(uq, User_Queue__c.User__c);  
    }
    public void queryForCases() {       
        cases = doQuery();
        if (cases.size() == 0) {
            disableNextButton = true;
        } else {
            disableNextButton = false;
        }
    }
    private List<Case> doQuery() {
        // retrieve those cases that are open and not owned by the current user
// empty the collection of extended Cases
        if (casesCM == null) {
            casesCM = new List<CaseCM>();
        } else {
            casesCM.clear();
        }
		String cols = ' Id, CaseNumber, Subject, Origin, AccountId, Account.Name, ContactId , Contact.Name,Type_Task__c,CreatedDate, Deadline__c,createdByID,CreatedBy.name ';
        String orderByString = ' Order By Urgent__c desc, Deadline__c ASC ';
        String whereClause = 'Where (Status = \'New\' OR Status = \'Re-Opened\') ';
        /* SPOC-489
        whereClause += 'And (RecordTypeId = \''+recordTypeMap.get('NP Queue Owned Case')+'\' OR RecordTypeId = \''+recordTypeMap.get('Queue Owned Case')+'\' OR';
        whereClause += ' RecordTypeId = \''+recordTypeMap.get('YB Complaints Case')+'\' OR RecordTypeId = \''+recordTypeMap.get('YKS Sag')+'\' ';
        whereClause += ' OR RecordTypeId = \''+recordTypeMap.get('Call Back Queue Owned Case')+'\' OR RecordTypeId = \''+recordTypeMap.get('Call Back YKS Sag Case')+'\' ';
        whereClause += ' OR RecordTypeId = \''+recordTypeMap.get('YKR IVR Closed Case')+'\' ';
        whereClause += ' OR RecordTypeId = \''+recordTypeMap.get('Outbound Queue Owned Case')+'\') ';
        */
        //whereClause += 'And OwnerId != \'' + UserInfo.getUserId() + '\'';
        whereClause += 'And isQueueCase__c = \'True\'';
        // also match on department, product and type/task if appropriate
        if ((caseFields.Department__c != null) && (caseFields.Department__c != '--None--')){
        	/*  if(caseFields.Department__c == 'PYSF'){ //Satarupa for Sf-2369
        		whereClause += ' And (Department__c = \'YFF\' or Department__c = \'POF\' or Department__c = \'' + caseFields.Department__c + '\')';
        	}
        	else*/
            	whereClause += ' And Department__c = \'' + caseFields.Department__c + '\'';
        }
        if ((caseFields.Product_2__c != null) && (caseFields.Product_2__c != '--None--')) {
            /*if(caseFields.Product_2__c == 'PYSF Kø'){ //Satarupa for Sf-2369
            	whereClause += ' And (Product_2__c = \'YFF Kø\' or Product_2__c = \'POF Kø\' or Product_2__c = \'' + caseFields.Product_2__c + '\')';
            }
            else*/
            	whereClause += ' And Product_2__c = \'' + caseFields.Product_2__c + '\'';
            
            if (caseFields.Type_Task__c == 'Outbound Call back bookings' || caseFields.Product_2__c == 'YOT Call Back' ) {
                system.debug('martin1');
                cols += ' , Description , Call_Back__r.CB_time__c ';
                orderByString = ' Order By Urgent__c desc, Call_Back__r.CB_time_from__c ASC ';
            }
        }
        if ((caseFields.Type_Task__c != null) && (caseFields.Type_Task__c != '--None--')) {
            whereClause += ' And Type_Task__c = \'' + caseFields.Type_Task__c + '\'';
        }
		String countQueryString = 'Select count() From Case ' + whereClause;
        Integer recordCounterInt = Database.countQuery(countQueryString); 
        recordCounter = recordCounterInt.format();
        String queryString = 'Select ' + cols + ' From Case ' + whereClause + orderByString;
        if (caseFields.Department__c == 'YKS') {
            queryString += ' LIMIT ' + YKSmaxQuerySize;
        } else {
            queryString += ' LIMIT ' + maxQuerySize;
        }
        System.debug('here is the querystring ' + queryString);
        return Database.query(queryString);
        
    }
    public void editCaseId(){
        workOnCaseIdResult = workOnCase(workOnCaseId);
        updateQueueCount();
    }
	public PageReference editCase() {
        String caseId = ApexPages.currentPage().getParameters().get('caseId'); 
        String result = workOnCase(caseId);
        if (result!=null){
            return new PageReference('/' + result + '?retURL=/' + result);
        }
        return null;
    }
	public String workOnCase(String caseId){
        //Case editCase = new Case(id=caseId);
        Case editCase = [Select Id, OwnerId, Owner.Name, Contact.Id, AccountId, manual_assign__c from Case where Id = :caseId for update];
        String caseOwner = editCase.OwnerId;
        if(!caseOwner.startsWith('005') || editCase.Owner.Name == 'API User'){
            // change the owner
            editCase.OwnerId = UserInfo.getUserId();
            editCase.manual_assign__c = true;
            //editCase.Contact = editCase.Contact;
            try {
                Database.SaveResult result = Database.update(editCase);
                //ApexPages.Message m = new ApexPages.Message(ApexPages.severity.INFO, 'Case Updated Successfully!');
                //ApexPages.addMessage(m);
                //return null;
            } catch (Exception e) {
                ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'An error occured Updating the Case: ' + e.getMessage(), e.getMessage());
                ApexPages.addMessage(m);
                return null;
            }
            return editCase.Id;
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'This Case is already taken by another user. Please refresh the list and select another Case.'));
            return null;
        }
    }
/* Replaced with a new version (see SPOC-1246 issue in Jira for details)    
    public PageReference retrieveNextCase() {
    
        Case nextCase = doQuery2();
        String nextCaseOwnerId='';
        String nextCaseOwnerName='';
        
        if (nextCase != null) {
            
            nextCase = [Select Id, OwnerId, Owner.Name from Case where Id = :nextCase.Id limit 1 for update];
            nextCaseOwnerId=nextCase.OwnerId;
            nextCaseOwnerName=nextCase.Owner.Name;
            
            While(nextCaseOwnerId.startsWith('005') && nextCaseOwnerName != 'API USer'){
                
                nextCase = doQuery2();
                if(nextCase != null){
                    
                    nextCase = [Select Id, OwnerId, Owner.Name from Case where Id = :nextCase.Id limit 1 for update];
                    nextCaseOwnerId=nextCase.OwnerId;
                    nextCaseOwnerName=nextCase.Owner.Name;
                }
                else{
                    
                    break;
                }
                    
            }
            
            if(nextCase != null){
                
                //System.debug('User ' + UserInfo.getUserName() + ' is taking Case ' + nextCase.CaseNumber);
                // change the owner
                nextCase.OwnerId = UserInfo.getUserId();
                // flag the case as taken the correct way
                nextCase.Taken_Using_Next_Button__c = true;
                nextCase.manual_assign__c = true;
                try {
                
                    Database.SaveResult result = Database.update(nextCase);
                    
                } catch (Exception e) {
                    ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'An error occured Updating the Case [' + nextCase.CaseNumber + ']: ' + e.getMessage(), e.getMessage());
                    ApexPages.addMessage(m);
                    return null;
                }
                
                return new PageReference('/' + nextCase.Id);
                
            }
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No cases left in this queue'));
        return Page.CasesTab;
    }    
*/
	public String newcasenumber{get;set;}
    public String findNextCaseId() {
        // Retrieve the most urgent case which is open and queue owned
        String queryString = 'SELECT Id, CaseNumber, Subject, Origin, AccountId, Account.Name, CreatedDate,ContactId ,CreatedById, Contact.Name,Type_Task__c, Deadline__c FROM Case ';
        String orderByString = ' ORDER BY Urgent__c DESC, Deadline__c ASC ';
        String whereClause = 'WHERE (Status = \'New\' OR Status = \'Re-Opened\') ';
        whereClause += 'AND isQueueCase__c = \'True\'';
        // also match on department, product and type/task if appropriate
        if ((caseFields.Department__c != null) && (caseFields.Department__c != '--None--')) {
            
		/*  if(caseFields.Department__c == 'PYSF'){ //Satarupa for Sf-2369
            	whereClause += ' AND (Department__c = \'YFF\' or Department__c = \'POF' + caseFields.Department__c + '\')';
            }
            else*/
            whereClause += ' AND Department__c = \'' + caseFields.Department__c + '\'';
        }
        if ((caseFields.Product_2__c != null) && (caseFields.Product_2__c != '--None--')) {
            
            /*if(caseFields.Product_2__c == 'PYSF Kø'){ //Satarupa for Sf-2369
            	whereClause += ' And (Product_2__c = \'YFF Kø\' or Product_2__c = \'POF Kø\' or Product_2__c = \'' + caseFields.Product_2__c + '\')';
            }
            else*/
            	whereClause += ' And Product_2__c = \'' + caseFields.Product_2__c + '\'';
            //whereClause += ' AND Product_2__c = \'' + caseFields.Product_2__c + '\'';
            if (caseFields.Type_Task__c == 'Outbound Call back bookings' || caseFields.Product_2__c == 'YOT Call Back' ) {
                orderByString = ' ORDER BY Urgent__c DESC, Call_Back__r.CB_time_from__c ASC ';
            }
        }
        if ((caseFields.Type_Task__c != null) && (caseFields.Type_Task__c != '--None--')) {
            whereClause += ' AND Type_Task__c = \'' + caseFields.Type_Task__c + '\'';
        }
		queryString += whereClause + orderByString;
		if (caseFields.Department__c == 'YKS') {
            queryString += ' LIMIT ' + YKSmaxQuerySize;
        } else {
            queryString += ' LIMIT ' + maxQuerySize;
        }
        List<Case> casesOnFocus = new List<Case>();
		if(!Test.isRunningTest())
		{
	        casesOnFocus = Database.query(queryString);
	        System.debug('--------------- qUERY sTRING ' +queryString);
        }
        if(Test.isRunningTest())
        {
        	casesOnFocus = [SELECT Id, CaseNumber, Subject, Origin, AccountId, Account.Name, ContactId , Contact.Name, Type_Task__c,CreatedDate, Deadline__c FROM Case WHERE (Status = 'New' OR Status = 'Re-Opened') limit 1];
        }
        Case nextCase = casesOnFocus.size() > 0 ? casesOnFocus[0] : null;
		if (nextCase != null) {
            //System.debug('User ' + UserInfo.getUserName() + ' is taking Case ' + nextCase.CaseNumber);
            // change the owner
            nextCase = [SELECT Id, OwnerId, Taken_Using_Next_Button__c, manual_assign__c FROM Case WHERE Id = :nextCase.Id LIMIT 1 FOR UPDATE];
            nextCase.OwnerId = UserInfo.getUserId();
            // flag the case as taken the correct way
            nextCase.Taken_Using_Next_Button__c = true;
            nextCase.manual_assign__c = true;
            try {
                Database.SaveResult result = Database.update(nextCase);
            } catch (Exception e) {
                ApexPages.Message m = new ApexPages.Message(
                    ApexPages.severity.Error,
                    'An error occured Updating the Case [' + nextCase.CaseNumber + ']: ' + e.getMessage(),
                    e.getMessage()
                );
                ApexPages.addMessage(m);
                return null;
            }
            return nextCase.Id;
        }
        ApexPages.addMessage(
            new ApexPages.Message(ApexPages.Severity.INFO,
            'No cases left in this queue')
        );
        return null;
	}
    public void retrieveNextCaseId() {
        workOnCaseIdResult = findNextCaseId();
        updateQueueCount();
    }
	public PageReference retrieveNextCase() { // fetches next case from current users department and queue
        String nextCid = findNextCaseId();
        if(nextCid!=null){
            return new PageReference('/' + nextCid);
        }
        return null;
    }
    public PageReference retrieveNextCaseInConsoleLukOgnaeste() { // fetches next case from current users department and queue in Console - spoc 1717
        String nextCid = findNextCaseIdConsole();
        system.debug('==nextCid===='+nextCid);
        if(nextCid!=null){
            return new PageReference('/' + nextCid);
        }
        return null;
    }
    public void retrieveNextCaseConsole() { 
        String nextCid = findNextCaseId();
        if(nextCid!=null){
            PageReference pr = new PageReference('/' + nextCid);
            workOnCaseId1Result = pr.getUrl();
            updateQueueCount();            
        }
    }
	public void retrieveNextCase2Id() { // called from NextCaseConsole page for Naeste button
        PageReference pr = retrieveNextCase2(); //Method to fetch Next Cases of Cases not Closed
        workOnCaseId1Result = pr.getUrl();
        updateQueueCount();
    }    
	public ShowCbCasesStatus getShowCbCasesStatus (){
        // return visibility settings for caseList according choosing Product picklist  
        if ((caseFields.Product_2__c !=null && caseFields.Product_2__c !='--None--') &&
           (caseFields.Product_2__c =='YOT Call Back' || caseFields.Type_Task__c =='Outbound Call back bookings' )) {
           system.debug('martin2');
            return new ShowCbCasesStatus(true);                      
        } else {
            return new ShowCbCasesStatus(false);
        }
    }
/* Moved inside the retrieveNextCase() method (see SPOC-1246 issue in Jira for details)
    private Case doQuery2() {
        
        // retrieve those cases that are open and not owned by the current user
        String queryString = 'Select Id, CaseNumber, Subject, Origin, AccountId, Account.Name, CreatedDate, Deadline__c  From Case ';
        String orderByString = ' Order By Urgent__c desc, Deadline__c ASC ';
        
        String whereClause = 'Where (Status = \'New\' OR Status = \'Re-Opened\') ';
        // SPOC-489
        //whereClause += 'And (RecordTypeId = \''+recordTypeMap.get('NP Queue Owned Case')+'\' OR RecordTypeId = \''+recordTypeMap.get('Queue Owned Case')+'\' OR';
        //whereClause += ' RecordTypeId = \''+recordTypeMap.get('YB Complaints Case')+'\' OR RecordTypeId = \''+recordTypeMap.get('YKS Sag')+'\' ';
        //whereClause += ' OR RecordTypeId = \''+recordTypeMap.get('Call Back Queue Owned Case')+'\' OR RecordTypeId = \''+recordTypeMap.get('Call Back YKS Sag Case')+'\' ';
        //whereClause += ' OR RecordTypeId = \''+recordTypeMap.get('YKR IVR Closed Case')+'\' ';
        //whereClause += ' OR RecordTypeId = \''+recordTypeMap.get('Outbound Queue Owned Case')+'\') '; 
        //
        //whereClause += 'And OwnerId != \'' + UserInfo.getUserId() + '\'';
        whereClause += 'And isQueueCase__c = \'True\'';
        // also match on department, product and type/task if appropriate
        if ((caseFields.Department__c != null) && (caseFields.Department__c != '--None--')) {
            whereClause += ' And Department__c = \'' + caseFields.Department__c + '\'';
        }
        if ((caseFields.Product_2__c != null) && (caseFields.Product_2__c != '--None--')) {
            whereClause += ' And Product_2__c = \'' + caseFields.Product_2__c + '\'';
            if (caseFields.Type_Task__c == 'Outbound Call back bookings' || caseFields.Product_2__c == 'YOT Call Back' ) {
            system.debug('martin3');
            orderByString = ' Order By Urgent__c desc, Call_Back__r.CB_time_from__c ASC ';
            }
        }
        if ((caseFields.Type_Task__c != null) && (caseFields.Type_Task__c != '--None--')) {
            whereClause += ' And Type_Task__c = \'' + caseFields.Type_Task__c + '\'';
        }

        queryString += whereClause + orderByString;

        if(caseFields.Department__c == 'YKS') {
            queryString += ' LIMIT ' + YKSmaxQuerySize;
        } else {
            queryString += ' LIMIT ' + maxQuerySize;
        }
        
        List<Case> casesOnFocus = Database.query(queryString); 
        
    System.debug('--------------- qUERY sTRING ' +queryString);
        
        if(casesOnFocus.size() > 0)
            return casesOnFocus[0];
        else
            return null;
        
    }
*/
//This new function is for the Next Button of Cases not Closed
    public String AccID{get;set;}
    public PageReference retrieveNextCase2() {
        List<Case> theCases = [Select Id, manual_assign__c, Last_Queue_Owner_ID__c from Case where Id = :CaseId];
        //System.debug('Last Queue Owner ID is - ' +theCases[0].Last_Queue_Owner_ID__c);
        if(theCases.size() > 0){
            if(theCases[0].Last_Queue_Owner_ID__c != null){
                Case nextCase = doQuery2(theCases[0].Last_Queue_Owner_ID__c);
                String nextCaseId = '';
                String nextCaseOwnerId='';
                String nextCaseOwnerName='';
                if (nextCase != null) {
                    newcasenumber = nextCase.CaseNumber;
                    AccID = nextCase.AccountId;
                    nextCaseId = nextCase.Id;
                    nextCase = [Select Id, OwnerId, Owner.Name from Case where Id = :nextCaseId limit 1 for update];
                    nextCaseOwnerId=nextCase.OwnerId;
                    nextCaseOwnerName=nextCase.Owner.Name;
                    While(nextCaseOwnerId.startsWith('005') && nextCaseOwnerName != 'API USer'){
                        nextCase = doQuery2(theCases[0].Last_Queue_Owner_ID__c);
                        if(nextCase != null){
                            nextCaseId = nextCase.Id;
                            nextCase = [Select Id, OwnerId, Owner.Name from Case where Id = :nextCaseId limit 1 for update];
                            nextCaseOwnerId=nextCase.OwnerId;
                            nextCaseOwnerName=nextCase.Owner.Name;
                        }
                        else{
                            break;
                        }     
                    }
                    if(nextCase != null){
                        // change the owner
                        nextCase.OwnerId = UserInfo.getUserId();
                        // flag the case as taken the correct way
                        nextCase.Taken_Using_Next_Button__c = true;
                        nextCase.manual_assign__c = true;
                       try {
                        Database.SaveResult result = Database.update(nextCase);
                            //ApexPages.Message m = new ApexPages.Message(ApexPages.severity.INFO, 'Case Updated Successfully!');
                            //ApexPages.addMessage(m);
                            //return null;
                        } catch (Exception e) {
                            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, 'An error occured Updating the Case [' + nextCase.CaseNumber + ']: ' + e.getMessage(), e.getMessage());
                            ApexPages.addMessage(m);
                            return null;
                        }
                        return new PageReference('/' + nextCase.Id);
                    }
                        
                }
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No cases left in this queue'));
            }
        }
         return Page.CasesTab;
    }    
    //This second versio of this function is to support the query req for retrieveNextCase2()
    private Case doQuery2(String lastQueueOwnerID) {
        // retrieve those cases that are open and not owned by the current user
        String queryString = 'Select Id, CaseNumber, Subject, Origin, AccountId, Account.Name, ContactId , Contact.Name, Type_Task__c,CreatedDate, Deadline__c  From Case ';
        queryString += 'Where (Status = \'New\' OR Status = \'Re-Opened\') ';
        /* SPOC-489
        queryString += 'And (RecordTypeId = \''+recordTypeMap.get('NP Queue Owned Case')+'\' OR RecordTypeId = \''+recordTypeMap.get('Queue Owned Case')+'\' OR';
        queryString += ' RecordTypeId = \''+recordTypeMap.get('YB Complaints Case')+'\' ';
        queryString += ' OR RecordTypeId = \''+recordTypeMap.get('Call Back Queue Owned Case')+'\' OR RecordTypeId = \''+recordTypeMap.get('Call Back YKS Sag Case')+'\' ';
        queryString += ' OR RecordTypeId = \''+recordTypeMap.get('YKR IVR Closed Case')+'\' ';
        queryString += ' OR RecordTypeId = \''+recordTypeMap.get('Outbound Queue Owned Case')+'\') ';  
        */
        queryString += 'And Id != \'' + CaseId + '\'';
        //We modify the condition here to filter owner by the previous queue
        if(lastQueueOwnerID != null)
            queryString += 'And OwnerId = \'' + lastQueueOwnerID + '\'';
        queryString += ' Order By Urgent__c desc, Deadline__c ASC LIMIT 1';
        System.debug('here is the querystring ' + queryString);
        List<Case> result = Database.query(queryString);
        System.debug('Result in Case is - ' + result);
        if(result.size() > 0)
            return result[0];
        else
            return null;
    }
    public PageReference viewEnhancedList() {
        PageReference pg = new PageReference('/500');
        //return Page.CasesEnhancedList;
    	return pg;
    }
/* NP in-port BEGIN: Method called from the 'New NP In-port' action button */
    public PageReference newNpInPort() {
        return Page.CasesNpImportCreate;
    }
/* NP in-port END: Method called from the 'New NP In-port' action button */
/* NP out-port BEGIN: Method called from the 'New NP Out-port' action button */
    public PageReference newNpOutPort() {
        return Page.CasesNpOutPortCreate;
    }
/* NP out-port END: Method called from the 'New NP Out-port' action button */
/* NP out-port BEGIN: Method called from the 'New NP Authorization' action button */
    public PageReference newNpAuthorization() {
        return Page.CasesNpAuthorizationCreate;
    }
/* NP out-port END: Method called from the 'New NP Authorization' action button */
/*SPOC-502 start*/
    public class CasePopup{
        public CasePopup(String cn,String s, String rr,Datetime ru){
            caseNumber=cn;
            status=s;
            reservationReason=rr;
            if (ru!=null){
                reservedUntil = ru.format();
            }
        }
        public String caseNumber {get;set;}
        public String status {get;set;}
        public String reservationReason {get;set;}
        public String reservedUntil {get;set;}
    }
	private String reservationReasonsJson;
    private String popupCaseIds;
    private Map<String,CasePopup> reservationReasonsMap = new Map<String,CasePopup>();
    public String getPopupCaseIds(){
        return popupCaseIds;
    }
	public void setPopupCaseIds(String value){
        popupCaseIds=value;
    }
    public void initReservationReasons(){
        List<String> caseIdsList = new  List<String>();
        reservationReasonsMap.clear();
        if (popupCaseIds!=null){
            caseIdsList = popupCaseIds.split(',');
        }
        List<Case> popupCases = [select Id, Reservation_Reason__c,Reserve_Until__c, CaseNumber, Status  from Case where id IN:caseIdsList];
        for (Case popupCase:popupCases){
            String shortId=popupCase.Id;
            shortId = shortId.substring(0, 15);
            reservationReasonsMap.put(shortId, new CasePopup(popupCase.CaseNumber,popupCase.Status,popupCase.Reservation_Reason__c,popupCase.Reserve_Until__c));
        }       
    }
    public String getReservationReasonsJson(){
        return JSON.serialize(reservationReasonsMap);
    }
    public void setReservationReasonsJson(String value){
        //do not update
    }
	/*For Console in Lug Og Naeste Button*/
    public String findNextCaseIdConsole() {
    	closeCaseId = CaseId;
        newAccountTabID = '';
        newCaseTabID = '';
        // Retrieve the most urgent case which is open and queue owned
        String queryString = 'SELECT Id, CaseNumber, Subject, Origin, AccountId, Account.Name, ContactId , Contact.Name, Type_Task__c,CreatedDate, Deadline__c FROM Case ';
        String orderByString = ' ORDER BY Urgent__c DESC, Deadline__c ASC ';
        String whereClause = 'WHERE (Status = \'New\' OR Status = \'Re-Opened\') ';
        whereClause += 'AND isQueueCase__c = \'True\'';
        // also match on department, product and type/task if appropriate
        if ((caseFields.Department__c != null) && (caseFields.Department__c != '--None--')) {
           /* if(caseFields.Department__c == 'PYSF'){ //Satarupa for Sf-2369
            	whereClause += ' AND (Department__c = \'YFF\' or Department__c = \'POF' + caseFields.Department__c + '\')';
            }
            else*/
            	whereClause += ' AND Department__c = \'' + caseFields.Department__c + '\'';
            //whereClause += ' AND Department__c = \'' + caseFields.Department__c + '\'';
        }
        if ((caseFields.Product_2__c != null) && (caseFields.Product_2__c != '--None--')) {
            
           /* if(caseFields.Product_2__c == 'PYSF Kø'){ //Satarupa for Sf-2369
            	whereClause += ' And (Product_2__c = \'YFF Kø\' or Product_2__c = \'POF Kø\' or Product_2__c = \'' + caseFields.Product_2__c + '\')';
            }
            else*/
            	whereClause += ' And Product_2__c = \'' + caseFields.Product_2__c + '\'';
            //whereClause += ' AND Product_2__c = \'' + caseFields.Product_2__c + '\'';
            if (caseFields.Type_Task__c == 'Outbound Call back bookings' || caseFields.Product_2__c == 'YOT Call Back' ) {
                orderByString = ' ORDER BY Urgent__c DESC, Call_Back__r.CB_time_from__c ASC ';
            }
        }
        if ((caseFields.Type_Task__c != null) && (caseFields.Type_Task__c != '--None--')) {
            whereClause += ' AND Type_Task__c = \'' + caseFields.Type_Task__c + '\'';
        }
		queryString += whereClause + orderByString;
		if (caseFields.Department__c == 'YKS') {
            queryString += ' LIMIT ' + YKSmaxQuerySize;
        } else {
            queryString += ' LIMIT ' + maxQuerySize;
        }
		List<Case> casesOnFocus = Database.query(queryString);
        System.debug('--------------- qUERY sTRING ' +queryString);
        Case nextCase = casesOnFocus.size() > 0 ? casesOnFocus[0] : null;
		if (nextCase != null) {
            //System.debug('User ' + UserInfo.getUserName() + ' is taking Case ' + nextCase.CaseNumber);
            // change the owner
            nextCase = [
                SELECT Id, OwnerId, AccountId,Taken_Using_Next_Button__c, manual_assign__c
                FROM Case WHERE Id = :nextCase.Id LIMIT 1 FOR UPDATE
            ];
            nextCase.OwnerId = UserInfo.getUserId();
            // flag the case as taken the correct way
            nextCase.Taken_Using_Next_Button__c = true;
            nextCase.manual_assign__c = true;
            if(nextCase.AccountId != null)
                 newAccountTabID = nextCase.AccountId;                        
             newCaseTabID = nextCase.Id;   
            try {
                Database.SaveResult result = Database.update(nextCase);
            } catch (Exception e) {
                ApexPages.Message m = new ApexPages.Message(
                    ApexPages.severity.Error,
                    'An error occured Updating the Case [' + nextCase.CaseNumber + ']: ' + e.getMessage(),
                    e.getMessage()
                );
                ApexPages.addMessage(m);
                return null;
            }
           // return nextCase.Id; 
        }
        ApexPages.addMessage(
            new ApexPages.Message(ApexPages.Severity.INFO,
            'No cases left in this queue')
        );
        return null;
	}
}