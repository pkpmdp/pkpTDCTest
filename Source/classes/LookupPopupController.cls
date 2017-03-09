//
// Custom controller for lookup example popup page
//
Global class LookupPopupController 
{
    public String query {get; set;}
    public List<Address__c> addresses {get; set;}
    
    public PageReference runQuery()
    {
        List<List<Address__c>> searchResults=[FIND :query IN ALL FIELDS RETURNING Address__c (id,name, Door_No__c,Entrance__c,Side__c,Floor__c,Street__c,House_No__c, Postcode__c )];
        addresses=searchResults[0];
        return null;
    }
}