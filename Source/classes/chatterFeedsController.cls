/**
    This is the controller for SocialFeeds and BusinessFeeds visualforce components.
    It only retreives the group id's for Social and Business Chatter groups and assigns them to variables
**/
public with sharing class chatterFeedsController {
    public String socialGroupId     {get;set;}
    public String businessGroupId   {get;set;}
    
    YouSeeChatterGroups__c groupIds;
    
    public chatterFeedsController(){
        try{
            // fetching all the YO Profiles from custom settings
            Map<string,YOProfilesNew__c> mapYOProfs =YOProfilesNew__c.getAll();
            Set<String> setYOProfiles = mapYOProfs.keySet();
    
            // fetching all the YK Profiles from custom settings
            Map<string,YkProfilesNew__c> mapYKProfs =YkProfilesNew__c.getAll();
            Set<String> setYKProfiles = mapYKProfs.keySet();
            
            User loginUsr=[SELECT ID,ProfileId,Profile.Name FROM User WHERE id=:Userinfo.getUserId()];
            
            if(setYOProfiles.contains(loginUsr.Profile.Name)){
                // fetch YO business Group Id
                groupIds = YouSeeChatterGroups__c.getValues('YO Business');
                if(groupIds != NULL && groupIds.GroupId__c != NULL){
                    businessGroupId = groupIds.GroupId__c;
                }
            }
            
            else if(setYKProfiles.contains(loginUsr.Profile.Name)){
                // fetch YK business Group Id
                groupIds = YouSeeChatterGroups__c.getValues('YK Business');
                if(groupIds != NULL && groupIds.GroupId__c != NULL){
                    businessGroupId = groupIds.GroupId__c;
                }
            }
            
            // fetch Social Group Id
            groupIds = YouSeeChatterGroups__c.getValues('Social'); 
            if(groupIds != NULL && groupIds.GroupId__c != NULL){
                socialGroupId = groupIds.GroupId__c; 
            } 
        }
        catch(Exception e){
            system.debug(' ### Exception in chatterFeedsController:   ' + e.getMessage());
        }
    }
}