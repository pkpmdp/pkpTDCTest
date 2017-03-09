public class HelpSupportProductTabController{
    
    public String productType{get;set;}
    public string productURL{get;set;}
    
    public HelpSupportProductTabController(){
            productType = ApexPages.CurrentPage().getParameters().get('productType');
            if('Clear'.equals(productType)){
                productURL='https://yousee.dk/sitecore/content/data/export/export.aspx?itemguid={5849D28D-5321-4DC3-AB98-198450B7C590}&functions=true';
                productType = 'YouSee Clear';
            }
            else if('Broadband'.equals(productType)){
                productURL='https://yousee.dk/sitecore/content/data/export/export.aspx?itemguid={DF59A046-621B-4A80-9E5D-BBD9AC2DA49A}&functions=true';
                productType = 'YouSee Bredbånd';
            }else if('Digital'.equals(productType)){
                productURL='https://yousee.dk/sitecore/content/data/export/export.aspx?itemguid={F1768748-62CB-4C23-A8DB-78EBC215C71B}&functions=true';
                productType = 'YouSee Plus';
            }else if('Telephony'.equals(productType)){
                productURL='https://yousee.dk/sitecore/content/data/export/export.aspx?itemguid={2CB4BA4D-2A1B-423F-82DD-D903F19D4B2E}&functions=true';
                productType = 'YouSee Telefoni';
            }else if('Ekstrakanaler'.equals(productType)){
                productURL='https://yousee.dk/sitecore/content/data/export/export.aspx?itemguid={D78EC8F6-2CF3-454E-9964-70BCB506FE9C}&functions=true';
                productType = 'Ekstrakanaler';
            }
            
            
            getInformation();    
    }

    public List<ForhandlerInformations__c> getInformation(){
            
            List<ForhandlerInformations__c> informationList = [Select info.Description__c, info.EndDate__c, info.Group_Information__c, info.Dealer__r.Name, info.SubGroup_Information__c From ForhandlerInformations__c info where info.Page_Type__c ='Hjælp og support' 
            and info.Group_Information__c = 'Produkt Tab Information' and  info.SubGroup_Information__c =: productType order by Sequence_Number__c];
            
            List<ForhandlerInformations__c> filteredInformationList = new List<ForhandlerInformations__c>(); 
            Date todayDate = date.today();
            integer days;
              for(ForhandlerInformations__c info : informationList) {
                 
                 if(info.EndDate__c != null){ 
                     days = todayDate.daysBetween(info.EndDate__c);
                 }    
                 
                 if((info.EndDate__c == null) ||  (info.EndDate__c != null && days > 0)) {
                        filteredInformationList.add(info); 
                 }                             
              }     
                
                  
            return filteredInformationList;        
     }
}