/**
    This is the controller class for KnowledgeHome Visualforce page (custom Home Page for YK and YO Users)
    It checks if the logged in user/Admin is YO or YK
**/

public with sharing class KnowledgeHome_Controller {
    public String userType  {get;set;}  // determines if user is YK or YO
    public String tabType   {get;set;}
    YouSeeChatterGroups__c groupIds;
    public String chatterGroupId    {get;set;}
    public String test   {get;set;}
    
              
    
    public KnowledgeHome_Controller(){
        try{
            if(ApexPages.currentPage().getParameters().containsKey('tab') && ApexPages.currentPage().getParameters().get('tab') != NULL){
                    tabType = ApexPages.currentPage().getParameters().get('tab');     
                     system.debug('tab type=if=='+tabType);      
                }
                
                else
                {
                    Set<String> setYKProfiles = new Set<String>();
                    Set<String> setYOProfiles = new Set<String>();
                    Set<String> setSPOC1876Profiles = new Set<String>();
                    //tabType = 'YK';//YK
                    String profileName = [Select Name From Profile Where Id = :Userinfo.getProfileId()].Name;
                    system.debug('profilename='+profileName);
                    
                    Map<String, YOProfilesNew__c> mapYOserProfs = YOProfilesNew__c.getAll();
                    setYOProfiles.addAll(mapYOserProfs.keySet());
                    
                    Map<string,YKAdminProfiles__c> mapYKAdminProfs =YKAdminProfiles__c.getAll();   
                    setYKProfiles.addAll(mapYKAdminProfs.keySet());
                    
                    Map<String, YKProfilesNew__c> mapYKUserProfs = YKProfilesNew__c.getAll();
                    setYKProfiles.addAll(mapYKUserProfs.keySet());
                    
                    Map<String, SPOC1876_Profiles_New__c> mapSPOC1876UserProfs = SPOC1876_Profiles_New__c.getAll();
                    setSPOC1876Profiles.addAll(mapSPOC1876UserProfs.keySet());

                    if(setSPOC1876Profiles.contains(profileName))
                    {
                        tabType = 'YO';
                        userType = 'YO';        
                    }
                    else if(setYKProfiles.contains(profileName)){
                        
                        tabType = 'YK';
                        userType = 'YK';                         
                    }
                    else if(setYOProfiles.contains(profileName))
                    {        
                        tabType='YO';
                        usertype='YO';              
                    }    
                   /* Boolean b = Boolean.valueOf(usertype);*/
                                       
                }
                
                // fetch chatter group Id
                if(tabType == 'YO'){
                    groupIds = YouSeeChatterGroups__c.getValues('YO Business');
                    if(groupIds != NULL && groupIds.GroupId__c != NULL){
                        chatterGroupId = groupIds.GroupId__c;  
                    }
                }
            
                else if(tabType == 'YK'){
                    groupIds = YouSeeChatterGroups__c.getValues('YK Business');
                    if(groupIds != NULL && groupIds.GroupId__c != NULL){
                        chatterGroupId = groupIds.GroupId__c;
                    }
                }
                    
           //       String test = System.Label.URL_Link;
           }
           
        
        catch(Exception e){
            system.debug('##### Exception in KnowledgeHome_Controller constructor: ' + e);
            }
        
       }
    }