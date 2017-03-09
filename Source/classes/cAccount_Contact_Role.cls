public with sharing class cAccount_Contact_Role{

				public Account_Contact_Role__c acr {get; set;}
                public Boolean selected {get; set;}
                public string  viewContact {get; set;}
                public string editContact {get; set;}
                public string deleteContact {get; set;}
                public string space {get; set;}
                public string firstName {get; set;}
                public string FName {get; set;}
                public string LName {get; set;}
                public string roleName {get; set;}
                public string contactName {get; set;}
                public string contactFName{get; set;}
                public string contactLName{get; set;}
                public string alternateEmail {get; set;}
                public string email {get; set;}
                public ID acrId {get; set;}
                public string accountId{get; set;}
                
                 //Added for Jira issue 106
                public string homePhone {get;set;} //newly added
                public Address__c address {get;set;} //newly added
                public string mobilePhone {get;set;} //newly added
                public string phone {get; set;} //newly added
               
                public string totalInsightRoles {get;set;} 
                /*This is the contructor method. When we create a new cContact object we pass a 
                Contact that is set to the con property. We also set the selected value to false */
                public cAccount_Contact_Role(Account_Contact_Role__c a){
                    acr=new Account_Contact_Role__c();
                    acr = a;
                    selected = false;
                    viewContact = contactConstClass.VIEW;
                    editContact = contactConstClass.EDIT;
                    deleteContact = contactConstClass.DELETED;
                    space = contactConstClass.SPACE;                
                }
                
                public cAccount_Contact_Role(){
                	
                }
}