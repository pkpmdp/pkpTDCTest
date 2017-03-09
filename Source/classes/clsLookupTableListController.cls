public class clsLookupTableListController
{ 
       
    //Account Team roles
    //Account Team members
    //Account Contact roles
    //Housing Type
    //Housing Ownership
    //Building Type   
    //Customer Statisfation
    
    
    public List<Lookup_Account_Team_Member__c> getCustomerTeamMembers(){
       return [Select l.Name From Lookup_Account_Team_Member__c l ];
    }
    
    
    public List<Lookup_Account_Team_Role__c> getCustomerTeamRoles(){
        return [Select l.Name From Lookup_Account_Team_Role__c l where l.Active__c = 'Ja'];
    }
     
    public List <Lookup_Housing_Type__c> getHousingTypes(){
        return [Select l.Name From Lookup_Housing_Type__c l where l.Active__c = 'Ja'];    
    }
     public List <Lookup_Housing_Ownership__c> getHousingOwnership(){
        return [Select l.Name From Lookup_Housing_Ownership__c l where l.Active__c = 'Ja'];    
    }  
    public List <Lookup_Building_Type__c> getBuildingTypes(){
        return [Select l.Name From Lookup_Building_Type__c l where l.Active__c = 'Ja'];    
    } 
    public List <Lookup_Customer_Satisfaction__c> getCustomerSatisfaction(){
        return [Select l.Name From Lookup_Customer_Satisfaction__c l where l.Active__c = 'Ja'];    
    }
    
    public List <Lookup_Customer_Segment__c> getCustomerSegments(){
        return [Select l.Name From Lookup_Customer_Segment__c l where l.Active__c = 'Ja'];    
    }
    
}