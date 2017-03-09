// Common functions used between all the YOSpoc classes will be housed here
//
global class YOSpocUtils {
    
 // check if the logged in user is a YO Admin
 public static Boolean isYOAdmin(Id loggedInUserId){
        Map<String,YOAdminProfiles__c> mapAdminProfs = YOAdminProfiles__c.getAll();
        Set<String> setAdminProfiles = mapAdminProfs.keySet();
        Map<String,YOAdminUsers__c> mapAdminUsers = YOAdminUsers__c.getAll();
        Set<String> setAdminUsers = mapAdminUsers.keySet();
                
        User loginUsr = [SELECT Id, ProfileId, Profile.Name FROM User
                        WHERE Id =:loggedInUserId];
                        
        if(setAdminProfiles.contains(loginUsr.Profile.Name)){
             return true;
        }    
        if(setAdminUsers.contains(loggedInUserId)){
             return true;
        } 
        return false;       
    }
}