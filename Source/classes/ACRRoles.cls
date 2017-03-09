public with sharing class ACRRoles{

   public Contact contact {get; set;}
   public string roleName {get; set;}
   public string name{get; set;}
   public string homephone{get; set;}
   public string mobilephone{get; set;}
   public string phone{get; set;}
   public Address__c address {get; set;}
    public String UserType {get;set;} 
   
   public ACRRoles(){
 	
   }
   public ACRRoles(Contact a){
 	contact= new Contact();
 	contact = a;
   }
 
}