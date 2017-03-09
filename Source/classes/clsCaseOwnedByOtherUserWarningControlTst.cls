@isTest
public class clsCaseOwnedByOtherUserWarningControlTst {
    public static testMethod void clsCaseOwnedByOtherUserWarningControlTst(){
    
		YouSeeCustomSettings__c setting = new YouSeeCustomSettings__c();
		setting.Name = 'No_case_assignment_customerinformation';
		setting.Setting_Value__c = '00e20000001UQ6D,00e20000000vfam';
		insert setting;
		    
        Case c2 = new Case();
        insert c2;   
    	  	
        ApexPages.StandardController sc=new ApexPages.StandardController(c2);
        clsCaseOwnedByOtherUserWarningController cw=new clsCaseOwnedByOtherUserWarningController(sc);
        cw.checkOwner();
        
        
    }

}