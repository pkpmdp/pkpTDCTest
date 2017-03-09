public class CTIAdministrationController {

    public Call_Registration_Job__c callRegJob {get; set;}
    private List<Jobs_Users__c> jobUsersDb;
    public List<Jobs_Users__c> jobUsersDisplay {get; set;}
    public Jobs_Users__c userLookup {get;set;}
    public List<String> selectedGroupsIDs {get; set;}
    public List<Group> groupsDisplay {get; set;}
    private List<Group> groupsDb;
    private List<Jobs_Groups__c> jobGroupsDb;
    public Boolean jobTypeTime {get; private set;}
    public Boolean jobTypeCoverage {get; private set;}
    public Boolean jobTypeCDN {get; private set;}
    public String selectedJobType {get; set;}
    private Map<Id, Group> allGroupsMap;
    public CTI_CallRegistration__c callRegistration {get; set;} // temporary object for Taxonomy picklist
    public Integer hourFrom {get; set;}
    public Integer hourTo {get; set;}
    public static Date DEFAULT_DATE = Date.newInstance(2000, 1, 1);
    public static final String JOB_TYPE_REQUIRED = 'Required';
    public static final String JOB_TYPE_COVERAGE = 'Coverage';
    public static final String JOB_TYPE_TIME = 'Time based';
    public static final String JOB_TYPE_CDN = 'CDN';
    public static final String GROUP_TYPE = 'Regular';
    
    
    public CTIAdministrationController(ApexPages.StandardController controller) {
        callRegJob = (Call_Registration_Job__c) controller.getRecord();
        if (callRegJob == null || callRegJob.Id == null) {
            callRegJob = new Call_Registration_Job__c();
            callRegistration = new CTI_CallRegistration__c();
        } else {
            callRegJob = [SELECT Valid_To__c, Valid_From__c, Time_To__c, Time_From__c, Taksonomy_Set__c, Id, Coverage__c, CDN__c, Job_Type__c FROM Call_Registration_Job__c WHERE Id = :callRegJob.Id];
            callRegistration = new CTI_CallRegistration__c(TaksonomySet__c = callRegJob.Taksonomy_Set__c);
        }
        userLookup = new Jobs_Users__c();
        if (callRegJob.Id == null) {
            jobUsersDb = new List<Jobs_Users__c>();
            jobUsersDisplay = new List<Jobs_Users__c>();
            groupsDisplay = new List<Group>();
            groupsDb = new List<Group>();
            setJobTypeVisibility(false, false, false);
        } else {
            // populate job users and job groups
            jobUsersDb = [SELECT Id, User__c, Call_Registration_Job__c  From Jobs_Users__c WHERE Call_Registration_Job__c = :callRegJob.Id];
            jobUsersDisplay = jobUsersDb.clone();
            jobGroupsDb = [SELECT Group_ID__c FROM Jobs_Groups__c WHERE Call_Registration_Job__c = :callRegJob.Id];
            List<Id> groupIDs = new List<Id>();
            for (Jobs_Groups__c jobGroup : jobGroupsDb) {
                groupIDs.add(jobGroup.Group_ID__c);
            }
            groupsDisplay = [SELECT Name, Id FROM Group WHERE Id IN :groupIDs ORDER BY Name];
            groupsDb = groupsDisplay.clone();
            // set correct visibility
            selectedJobType = callRegJob.Job_Type__c;
            jobTypeVisible();
            if (selectedJobType == JOB_TYPE_TIME) {
                hourFrom = callRegJob.Time_From__c.hour();
                hourTo = callRegJob.Time_To__c.hour();
            }
        }
        allGroupsMap = new Map<Id, Group>();
        List<Group> allGroups = [SELECT Name, Id FROM Group WHERE Type = :GROUP_TYPE ORDER BY Name];
        for (Group dbGroup : allGroups) {
            allGroupsMap.put(dbGroup.Id, dbGroup);
        }
        selectedGroupsIDs = new List<String>();
    }
    
    public PageReference jobTypeVisible() {
        if (selectedJobType == JOB_TYPE_COVERAGE) {
            setJobTypeVisibility(false, true, false);
        } else if (selectedJobType == JOB_TYPE_TIME) {
            setJobTypeVisibility(true, false, false);
        } else if (selectedJobType == JOB_TYPE_CDN) {
            setJobTypeVisibility(false, false, true);
        } else {
            setJobTypeVisibility(false, false, false);
        }
        return null;
    }
    
    public PageReference addUser() {
        System.debug('addUserToList: ' + userLookup.User__c + ' Id ' + userLookup.User__r.Id);
        if (userLookup != null && userLookup.User__c != null) {
            // check if user was already added to the list
            Boolean newUser = true;
            for (Jobs_Users__c jobUser : jobUsersDisplay) {
                if (jobUser.User__c == userLookup.User__c) {
                    newUser = false;
                    break;
                }
            }
            if (newUser) {
                jobUsersDisplay.add(userLookup.clone());
                userLookup = new Jobs_Users__c();
            }
        }
        return null;
    }
    
    public PageReference addGroup() {
        System.debug('Group in List: ' + selectedGroupsIDs);
        for (String groupId : selectedGroupsIDs) {
            Group selectedGroup = allGroupsMap.get(groupId);
            if (selectedGroup != null && isGroupNew(groupId))
                groupsDisplay.add(selectedGroup);
        }
        selectedGroupsIDs = new List<String>();
        return null;
    }
    
    public PageReference removeUser() {
        System.debug('Param: ' + ApexPages.currentPage().getParameters().get('userId'));
        Id userId = ApexPages.currentPage().getParameters().get('userId');
        for (Integer i = 0; i < jobUsersDisplay.size(); i++) {
            if (jobUsersDisplay[i].User__c == userId) {
                jobUsersDisplay.remove(i);
                break;
            }
        }
        return null;
    }
    
    public PageReference removeGroup() {
        Id groupId = ApexPages.currentPage().getParameters().get('groupId');
        for (Integer i = 0; i < groupsDisplay.size(); i++) {
            if (groupsDisplay[i].Id == groupId) {
                groupsDisplay.remove(i);
                break;
            }
        }
        return null;
    }
    
    public List<SelectOption> getGroupItems() {
        List<SelectOption> options = new List<SelectOption>();
        for (Group userGroup : allGroupsMap.values()) {
            options.add(new SelectOption(userGroup.Id, userGroup.Name));
        }
        return SortOptionList(options);
    }
    
    public PageReference save() {
        callRegJob.Taksonomy_Set__c = callRegistration.TaksonomySet__c;
        if (selectedJobType == JOB_TYPE_TIME) {
            callRegJob.Time_From__c = DateTime.newInstance(DEFAULT_DATE, Time.newInstance(hourFrom, 0, 0, 0));
            callRegJob.Time_To__c = DateTime.newInstance(DEFAULT_DATE, Time.newInstance(hourTo, 0, 0, 0));
        }
        if (callRegJob.Id == null) {
            insert callRegJob;
            addCallRegJobIdToUsers(jobUsersDisplay);
            insert jobUsersDisplay;
            List<Jobs_Groups__c> jobGroupsInsert = getJobsGroups(groupsDisplay);
            insert jobGroupsInsert;
        }
        else {
            update callRegJob;
            insertDeleteJobsUsers();
            insertDeleteJobsGroups();
        }
        return new PageReference('/a1a/o');
    }
    
    public PageReference cancel() {
        return new PageReference('/a1a/o');
    }
    
    private List<Jobs_Groups__c> getJobsGroups(List<Group> groups) {
        List<Jobs_Groups__c> jobGroups = new List<Jobs_Groups__c>();
        for (Group selectedGroup : groups) {
            Jobs_Groups__c jobGroup = new Jobs_Groups__c(Call_Registration_Job__c = callRegJob.Id);
            jobGroup.Group_ID__c = selectedGroup.Id;
            jobGroups.add(jobGroup);
        }
        return jobGroups;
    }
    
    private void addCallRegJobIdToUsers(List<Jobs_Users__c> jobUsers) {
        for (Jobs_Users__c jobUser : jobUsers) {
            jobUser.Call_Registration_Job__c = callRegJob.Id;
        }
    }
            
    private void insertDeleteJobsUsers() {
        Set<Jobs_Users__c> jobUsersInsert = new Set<Jobs_Users__c>(jobUsersDisplay); 
        Set<Jobs_Users__c> jobUsersDelete = new Set<Jobs_Users__c>(jobUsersDb);
        jobUsersInsert.removeAll(jobUsersDb);
        jobUsersDelete.removeAll(jobUsersDisplay);
        System.debug('To Insert Users: ' + jobUsersInsert);
        System.debug('To Delete Users: ' + jobUsersDelete);
        if (jobUsersInsert.size() > 0) {
            List<Jobs_Users__c> toInsert = new List<Jobs_Users__c>(jobUsersInsert);
            addCallRegJobIdToUsers(toInsert);
            System.debug('Inserting Users: ' + toInsert.size());
            insert toInsert;
        }
        if (jobUsersDelete.size() > 0) {
            List<Jobs_Users__c> toDelete = new List<Jobs_Users__c>(jobUsersDelete);
            System.debug('Deleting Users: ' + toDelete.size());
            delete toDelete;
        }
    }
    
    private void insertDeleteJobsGroups() {
        Set<Group> groupsInsert = new Set<Group>(groupsDisplay); 
        Set<Group> groupsDelete = new Set<Group>(groupsDb);
        groupsInsert.removeAll(groupsDb);
        groupsDelete.removeAll(groupsDisplay);
        System.debug('To Insert Groups: ' + groupsInsert);
        System.debug('To Delete Groups: ' + groupsDelete);
        List<Group> groupsToInsert = new List<Group>(groupsInsert);
        List<Jobs_Groups__c> jobGroupsInsert = getJobsGroups(groupsToInsert);
        List<Jobs_Groups__c> jobGroupsDelete = new List<Jobs_Groups__c>();
        for (Jobs_Groups__c jobGroup : jobGroupsDb) {
            for (Group thisGroup : groupsDelete) {
                if (jobGroup.Group_ID__c == thisGroup.Id) {
                    jobGroupsDelete.add(jobGroup);
                    break;
                }
            }
        }
        if (jobGroupsInsert.size() > 0)
            insert jobGroupsInsert;
        if (jobGroupsDelete.size() > 0)
            delete jobGroupsDelete;
    }
    
    private void setJobTypeVisibility(Boolean jobTypeTime, Boolean jobTypeCoverage, Boolean jobTypeCDN) {
        this.jobTypeTime = jobTypeTime;
        this.jobTypeCoverage = jobTypeCoverage;
        this.jobTypeCDN = jobTypeCDN;
    }
    
    private Boolean isGroupNew(String groupId) {
        Boolean newGroup = true;
        for (Group thisGroup : groupsDisplay) {
            if (thisGroup.Id == groupId) {
                newGroup = false;
                break;
            }
        }
        return newGroup;
    }
    
     //  This is a simple quicksort algorithm to sort a SelectOption list (dropdown) by label alphabetically.
    private static List<SelectOption> SortOptionList(List<SelectOption> ListToSort) {
        if (ListToSort == null || ListToSort.size() <= 1)
            return ListToSort;
            
        List<SelectOption> Less = new List<SelectOption>();
        List<SelectOption> Greater = new List<SelectOption>();
        integer pivot = 0;
        
        // save the pivot and remove it from the list
        SelectOption pivotValue = ListToSort[pivot];
        ListToSort.remove(pivot);
        
        for(SelectOption x : ListToSort) {
            if(x.getLabel() <= pivotValue.getLabel())
                Less.add(x);
            else if(x.getLabel() > pivotValue.getLabel()) Greater.add(x);   
        }
        List<SelectOption> returnList = new List<SelectOption> ();
        returnList.addAll(SortOptionList(Less));
        returnList.add(pivotValue);
        returnList.addAll(SortOptionList(Greater));
        return returnList; 
    }
}