public with sharing class ConsoleKundeInfo_CT{
    
    public Id currentId1{get;set;}
    public String queryString{get;set;}
    //public List<Account> accList{get;set;}
    public ID strid{get;set;}
    public String strColumnNo{get;set;}
    public String strColumnNoSitel{get;set;}//SPOC-2294 added 
    public List<Account> lstData{get;set;}
    //public List<IFieldSetMember> fieldSet;
    public ConsoleKundeInfo_CT(){
        
        system.debug('==in here 1===='+currentId1);
        strColumnNo = Label.YK_Kunde_Columns;
        strColumnNoSitel = Label.YK_Kunde_Columns_Sitel; //SPOC-2294 added 
    }
    public List<Account> getaccList() {
        
        system.debug('==in here 3===='+currentId1);
        queryString = 'select id';      
        for(Schema.FieldSetMember fld :SObjectType.Account.FieldSets.Console_Highlights_Panel.getFields()) {
         queryString += ', ' + fld.getFieldPath();
        }
        queryString += ' from Account where Id =\''+currentId1+'\'';         
        system.debug('=======queryString======='+queryString);
        lstData = new List<Account>();
        lstData = Database.query(queryString);
        return lstData;   
    }//SPOC-2294 START
    public List<Account> getaccListSitel() {
        system.debug('==in here 3===='+currentId1);
        queryString = 'select id';      
        for(Schema.FieldSetMember fld :SObjectType.Account.FieldSets.Sitel_Console_Fieldsets.getFields()) {
         queryString += ', ' + fld.getFieldPath();
        }
        queryString += ' from Account where Id =\''+currentId1+'\'';         
        system.debug('=======queryString======='+queryString);
        lstData = new List<Account>();
        lstData = Database.query(queryString);
        return lstData;
    }//SPOC-2294 END
    /*public pagereference invoke()
    {
        system.debug('==in here 4===='+currentId1);
        strid = ID.valueOf(currentId1);
        system.debug('accountId in constr: '+strid);
        
        //InitializeConstruction();
        return null;
    }*/
}