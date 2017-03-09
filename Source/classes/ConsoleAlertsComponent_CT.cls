public class ConsoleAlertsComponent_CT {
    
    public String currentId2{get;set;}
    public List<Links__c> currentLinks{get;set;}
    public String contactInfoWarning;
    public Integer countOfCases = 0;
    public Boolean marketingPermission;
    public Date marketPermUpdatedDate;
    public Boolean showWarning;
    public String imageDisplay;
    public Integer testCount;
    public String trimmedcomment{get;set;}//added for spoc-1838
    public String commenttext{get; set;} //added for spoc-1838
    public String categorytext{get; set;}//added for SPOC-2388
    public Boolean iscommenttextblank; //added for spoc-1838
    public boolean iscategorytextRegler;//added for SPOC-2388
    public String BillingRatingWarning;//Spoc-2294
    public string Special_Bland_Selv_rules;//added for SPOC-2388
    public String MarketingPermissionsitel;
    public Integer taskCount{get; set;} // SPOC-2294
    
    public Boolean getShowWarning() {
        return showWarning;
    }
    
    public ConsoleAlertsComponent_CT(){
        System.debug('####default');
        taskCount = 0;
        //getImageDisplay();
    }
    
    //Changes for Spoc-1838
    public Boolean getIscommenttextblank(){ 
        commenttext =[SELECT Comment__c FROM Account WHERE Id =:currentId2].Comment__c;
        System.debug('$$$$ Commenttext' + commenttext );
        if(commenttext == '' || commenttext == null){
            iscommenttextblank = true;
            
        }else{
            iscommenttextblank = false;
            
            if(commenttext.length() > 50 ){
                trimmedcomment =commenttext.substring(0,50) + '...';
            }else{
                trimmedcomment = commenttext ;
            }
        }
        return iscommenttextblank;
    }
    
    //method for SPOC-2388
    //start
    public string getSpecial_Bland_Selv_rules(){
        Links scPage= new Links();
        system.debug('<<<<<<<<<<<<<<<<<<<currentId2'+currentId2);
        try{
            currentLinks=scPage.getLinks2(currentId2);
            system.debug('<<<<<<<<<<<<<<<<<<<currentLinks'+currentLinks);
            for(links__c currLink:currentLinks )
            {
                if(currLink.Category__c=='Regler for Bland Selv Tv')
                    system.debug('<<<<<<<<<<<<currLink.Category__c'+currLink.Category__c);
                Special_Bland_Selv_rules= System.label.Special_Bland_Selv_rules;
            }
            
            
            /*categorytext =[SELECT Id,Category__c ,Account__c,Payer_Customer_Number__c FROM Links__c WHERE Category__c=:'Regler for Bland Selv Tv' and Person_Account__c =:currentId2 ].Category__c;            
            if(categorytext != null){
                Special_Bland_Selv_rules= System.label.Special_Bland_Selv_rules;
            }*/
        }
        catch(Exception ex){
            system.debug('currentLinks'+currentLinks);
            
           system.debug('error');
        }
        return Special_Bland_Selv_rules;
    }
    //end SPOC-2388
    
    public String getImageDisplay(){
        System.debug('######currentId2$$$$$$$'+currentId2);
        testCount = [Select count() from Case where AccountId =:currentId2 AND IsClosed = false];
        if(testCount > 0) {
            imageDisplay = 'Present';
        }else{
            imageDisplay = 'Blank';
        }
        return imageDisplay;
    }
    
    public Integer getCountOfCases(){
        System.debug('######currentId2$$$$$$$'+currentId2);
        if(currentId2 != null && currentId2 != ''){
            /* previous query
countOfCases = [Select count() from Case where AccountId =:currentId2 AND IsClosed = false AND isQueueCase__c = 'True'];*/
            countOfCases = [Select count() from Case where AccountId =:currentId2 AND IsClosed = false];
            System.debug('####countOfCases ###'+countOfCases );
            showWarning = countOfCases > 0;
            getShowWarning();
            System.debug('##showWarning###'+showWarning);
        }
        return countOfCases;
    }
    public String getBillingRatingWarning(){ //SPOC-2294 get billing rating info
        System.debug('in get billing');
        List<Account> dbAccountlst=[select Billing_Rating_Text__c FROM Account WHERE Id =:currentId2];
        if(dbAccountlst.size() > 0){
            Account dbAccount = dbAccountlst[0];
            if(dbAccount.Billing_Rating_Text__c=='I NIS'){
                BillingRatingWarning= System.label.BillingRating; 
            }
        }
        return BillingRatingWarning;
    }// SPOC-2294 END
    
    /*public string getMarketingPermissionsitel()
{
List<Permission__c> permlst=[select Marketing_Permission__c from Permission__c where Id =:currentId2];
if(permlst.size()>0)
Permission__c perm =permlst[0];
if(perm.Marketing_Permission__c==false)
{
MarketingPermissionsitel=system.label.Marketing_permission;
}
return MarketingPermissionsitel;
}*/
    
    public List<Task> getActivityList(){//SPOC-2294 START get activity history where calltype=inbound
        List<Task> taskList = new List<Task>();
        taskList = [SELECT AccountId,ActivityDate,CallDurationInSeconds,CallType,Id,Status,Subject,What.Name,Who.Name,WhatId,WhoId FROM Task WHERE Accountid=:currentId2 AND CallType=:'Inbound' Order By CreatedDate DESC LIMIT 3];
        taskCount = taskList.size();
        return taskList;
    }
    public String getContactInfoWarning(){
        List<Account> dbAccountlst = [SELECT PersonEmail, PersonMobilePhone, No_Email__c,X34_Mobile_Number__c,X34_Fixed_line__c,Home_Phone__c,(Select Marketing_Permission__c,Marketing_permission_Opdateret_Dato__c from Permissions__r limit 1) FROM Account WHERE Id = :currentId2];
        if(dbAccountlst.size() > 0){
            Account dbAccount = dbAccountlst[0];
            marketingPermission = null;
            marketPermUpdatedDate = null;
            if(dbAccount.permissions__r!=null && dbAccount.permissions__r.size()>0){
                marketingPermission = dbAccount.permissions__r[0].marketing_permission__c;
                marketPermUpdatedDate = dbAccount.permissions__r[0].Marketing_permission_Opdateret_Dato__c;
            }
            if(dbAccount.PersonEmail == null){
                if(dbAccount.PersonMobilePhone == null){
                    if(dbAccount.Home_Phone__c!=null && dbAccount.X34_Mobile_Number__c==null && dbAccount.X34_Fixed_line__c==null){
                        if (marketingPermission == null || !marketingPermission){
                            contactInfoWarning = System.Label.No_Mobile_Phone_And_Permission; // condition 6  no permission
                        }else{
                            contactInfoWarning = System.Label.No_Mobile_Phone; // condition 6  
                        }
                    }else if(dbAccount.Home_Phone__c!=null && dbAccount.X34_Mobile_Number__c!=null && dbAccount.X34_Fixed_line__c==null){
                        if (marketingPermission == null || !marketingPermission){
                            contactInfoWarning = System.Label.Confirm_Mobile_Email_and_Marketing_Permission; // condition 7  no permission
                        }else{
                            contactInfoWarning = System.Label.Confirm_Mobile_and_Email; // condition 7   
                        }
                    }else if(dbAccount.Home_Phone__c!=null && dbAccount.X34_Mobile_Number__c!=null && dbAccount.X34_Fixed_line__c!=null){
                        if (marketingPermission == null || !marketingPermission){
                            contactInfoWarning = System.Label.Confirm_Mobile_Email_and_Marketing_Permission; // condition 8  no permission
                        }else{
                            contactInfoWarning = System.Label.Confirm_Mobile_and_Email; // condition 8   
                        }
                    }else if( dbAccount.Home_Phone__c==null && dbAccount.X34_Mobile_Number__c != null && dbAccount.X34_Fixed_line__c ==null){
                        if (marketingPermission == null || !marketingPermission){
                            contactInfoWarning = System.Label.No_Mobile_Phone_And_Email_Address_And_Permission; // condition 10  no permission
                        }else{
                            contactInfoWarning = System.Label.No_Mobile_Phone_And_Email_Address; // condition 10    
                        }
                    }else if(dbAccount.Home_Phone__c==null && dbAccount.X34_Mobile_Number__c != null && dbAccount.X34_Fixed_line__c !=null){
                        if (marketingPermission == null || !marketingPermission){
                            contactInfoWarning = System.Label.Update_Contact_Numbers_and_Marketing_Permission; // condition 11  no permission
                        }else{
                            contactInfoWarning = System.Label.Update_Contact_Numbers; // condition 11    
                        }
                    }else if(dbAccount.Home_Phone__c==null && dbAccount.X34_Mobile_Number__c == null && dbAccount.X34_Fixed_line__c !=null){
                        if (marketingPermission == null || !marketingPermission){
                            contactInfoWarning = System.Label.No_Mobile_Phone_And_Email_Address_And_Permission; // condition 13  no permission
                        }else{
                            contactInfoWarning = System.Label.No_Mobile_Phone_And_Email_Address; // condition 13   
                        }
                    }else if(dbAccount.Home_Phone__c==null && dbAccount.X34_Mobile_Number__c == null && dbAccount.X34_Fixed_line__c ==null){
                        if (marketingPermission == null || !marketingPermission){
                            contactInfoWarning = System.Label.No_Mobile_Phone_And_Email_Address_And_Permission; // condition 16  no permission
                        }else{
                            contactInfoWarning = System.Label.No_Mobile_Phone_And_Email_Address; // condition 16  
                        }
                    }
                    /*SPOC-2294 START*/ else if (marketingPermission == null || !marketingPermission){ //added to give only marketing permission error
                        contactInfoWarning = System.Label.No_Permission;   
                    }//SPOC-2294 END
                }else{
                    if(dbAccount.Home_Phone__c==null && dbAccount.X34_Mobile_Number__c==null && dbAccount.X34_Fixed_line__c==null){
                        if (marketingPermission == null || !marketingPermission){
                            contactInfoWarning = System.Label.Confirm_Fixed_Number_Email_and_Marketing_Permission; // condition 1  no permission
                        }else{
                            contactInfoWarning = System.Label.Confirm_Fixed_Number_and_Email; // condition 1 permission    
                        }
                    }else if(dbAccount.Home_Phone__c != null && dbAccount.X34_Mobile_Number__c==null && dbAccount.X34_Fixed_line__c==null ){
                        if (marketingPermission == null || !marketingPermission){
                            contactInfoWarning = System.Label.No_Email_Address_And_Permission; // condition 2  no permission
                        }else{
                            contactInfoWarning = System.Label.No_Email_Address; // condition 2 permission    
                        }
                    }else if(dbAccount.Home_Phone__c != null && dbAccount.X34_Mobile_Number__c!=null && dbAccount.X34_Fixed_line__c==null){
                        if (marketingPermission == null || !marketingPermission){
                            contactInfoWarning = System.Label.No_Email_Address_And_Permission; // condition 3  no permission
                        }else{
                            contactInfoWarning = System.Label.No_Email_Address; // condition 3 permission    
                        }
                    }else if(dbAccount.Home_Phone__c != null && dbAccount.X34_Mobile_Number__c!=null && dbAccount.X34_Fixed_line__c!=null){
                        if (marketingPermission == null || !marketingPermission){
                            contactInfoWarning = System.Label.No_Email_Address_And_Permission; // condition 4  no permission
                        }else{
                            contactInfoWarning = System.Label.No_Email_Address; // condition 4 permission    
                        }
                    }
                    /*SPOC-2294 START*/ else if (marketingPermission == null || !marketingPermission){ //added to give only marketing permission error
                        contactInfoWarning = System.Label.No_Permission;   
                    }//SPOC-2294 END
                }
            }
            else{
                if(dbAccount.PersonMobilePhone == null){                
                    if(dbAccount.Home_Phone__c!=null && dbAccount.X34_Mobile_Number__c!=null && dbAccount.X34_Fixed_line__c!=null ){
                        if(marketingPermission == null || !marketingPermission){
                            contactInfoWarning = System.Label.Confirm_Mobile_and_Marketing_Permission; // condition 9  no permission
                        }else{
                            contactInfoWarning = System.Label.Confirm_Mobile; // condition 9 permission    
                        }
                    }else if(dbAccount.Home_Phone__c==null && dbAccount.X34_Mobile_Number__c!=null && dbAccount.X34_Fixed_line__c!=null){
                        if(marketingPermission == null || !marketingPermission){
                            contactInfoWarning = System.Label.Confirm_Phone_Numbers_and_Marketing_Permission; // condition 12 no permission
                        }else{
                            contactInfoWarning = System.Label.Confirm_Phone_Numbers; // condition 12 permission    
                        }
                    }else if(dbAccount.Home_Phone__c==null && dbAccount.X34_Mobile_Number__c==null && dbAccount.X34_Fixed_line__c!=null){
                        if(marketingPermission == null || !marketingPermission){
                            contactInfoWarning = System.Label.No_Mobile_Phone_And_Email_Address_And_Permission; // condition 14 no permission
                        }else{
                            contactInfoWarning = System.Label.No_Mobile_Phone_And_Email_Address; // condition 14 permission    
                        }
                    }else if(dbAccount.Home_Phone__c==null && dbAccount.X34_Mobile_Number__c==null && dbAccount.X34_Fixed_line__c==null){
                        if(marketingPermission == null || !marketingPermission){
                            contactInfoWarning = System.Label.No_Mobile_Phone_And_Email_Address_And_Permission; // condition 15 no permission
                        }else{
                            contactInfoWarning = System.Label.No_Mobile_Phone_And_Email_Address; // condition 15 permission    
                        }
                    }
                    /*SPOC-2294 START*/ else if (marketingPermission == null || !marketingPermission){ //added to give only marketing permission error
                        contactInfoWarning = System.Label.No_Permission;   
                    }//SPOC-2294 END
                }else{
                    if(dbAccount.Home_Phone__c!=null && dbAccount.X34_Mobile_Number__c!=null && dbAccount.X34_Fixed_line__c!=null){
                        if (marketingPermission == null || !marketingPermission){
                            contactInfoWarning = System.Label.No_Permission;
                        }
                    }
                    /*SPOC-2294 START*/ else if (marketingPermission == null || !marketingPermission){ //added to give only marketing permission error
                        contactInfoWarning = System.Label.No_Permission;   
                    }//SPOC-2294 END
                }
            }
        }
        return contactInfoWarning;   
    }
    /*public String getContactInfoWarning(){
List<Account> dbAccountlst = [SELECT PersonEmail, PersonMobilePhone, No_Email__c,Home_Phone__c,(Select Marketing_Permission__c,Marketing_permission_Opdateret_Dato__c from Permissions__r limit 1) FROM Account WHERE Id = :currentId2];
if(dbAccountlst.size() > 0){
Account dbAccount = dbAccountlst[0];
marketingPermission = null;
marketPermUpdatedDate = null;
if(dbAccount.permissions__r!=null && dbAccount.permissions__r.size()>0){
marketingPermission = dbAccount.permissions__r[0].marketing_permission__c;
marketPermUpdatedDate = dbAccount.permissions__r[0].Marketing_permission_Opdateret_Dato__c;
}
if (dbAccount.PersonMobilePhone == null) {
if (dbAccount.PersonEmail == null && !dbAccount.No_Email__c) {
if ((marketingPermission == null || !marketingPermission) && marketPermUpdatedDate==null) {
contactInfoWarning = System.Label.No_Mobile_Phone_And_Email_Address_And_Permission;
} else {
contactInfoWarning = System.Label.No_Mobile_Phone_And_Email_Address;
}
} else {
if ((marketingPermission == null || !marketingPermission) && marketPermUpdatedDate==null) {
contactInfoWarning = System.Label.No_Mobile_Phone_And_Permission;
} else {
contactInfoWarning = System.Label.No_Mobile_Phone;  
}
}
} else { 
if (dbAccount.PersonEmail == null && !dbAccount.No_Email__c) {
if ((marketingPermission == null || !marketingPermission) && marketPermUpdatedDate==null) {
contactInfoWarning = System.Label.No_Email_Address_And_Permission;
} else {
contactInfoWarning = System.Label.No_Email_Address;
}
} else if ((marketingPermission == null || !marketingPermission) && marketPermUpdatedDate==null) {
contactInfoWarning = System.Label.No_Permission;
}
}

}
return contactInfoWarning;  
}*/
}