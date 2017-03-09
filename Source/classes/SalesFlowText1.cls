public class SalesFlowText1
{
    List<SalesFlow_Informationer__c> salesFlowTextList;    
    public List<String> messages{get; set;}
    Map<String,Integer> pageFieldsMap;
    public SalesFlowText1() {        
        pageFieldsMap = new Map<String,Integer>();
        createFieldsMap();  
    }
    
    /**
    * @description: Create a map of page name and number of configurable fields.
    */  
    private void createFieldsMap(){
        pageFieldsMap.put('dealercustomersearch1',2);
        pageFieldsMap.put('dealerproductselectionpage1',1);
        pageFieldsMap.put('dtvhardwareselection1',1);
        pageFieldsMap.put('freechoice1',1);
        pageFieldsMap.put('clearproductspage1',2);
        // DW-861
        pageFieldsMap.put('dealerbsprods1',2);
        pageFieldsMap.put('serialnumberentrypage1',4);
        pageFieldsMap.put('customerinfopage1',3);
        pageFieldsMap.put('broadbandproductpage1',1);
        pageFieldsMap.put('broadbandmodempage1',2);
        pageFieldsMap.put('telefoniproductspage1',1);  
        pageFieldsMap.put('telefoniproductsforphone1',1);     
        pageFieldsMap.put('clearkravet1',1);     
        pageFieldsMap.put('dtvchannelselectionpage1',1);     
        pageFieldsMap.put('dealeryoubioproductselection1',1);                  
    }
    
    /**
    * @description: Retrieve list of messages to be displayed on the page
    * @param: url from DealerProductController3 class
    */
    public void retrieveSalesForceInfoText(String url)
    {
        system.debug('url from controller ' +url);
        Integer index = url.lastIndexOf('/');
        url = url.substring(index+1);    
        if(url.contains('?')){
            index = url.indexOf('?');
            url = url.substring(0,index); 
        }   
        url = url.toLowerCase();             
        system.debug('url in salesFlow : ' +url);
        salesFlowTextList = new List<SalesFlow_Informationer__c>();
        messages = new List<String>();
        salesFlowTextList = [Select SubGroup_Information__c, Start_Date__c, Page_Name__c, Sequence_Number__c, Page_Type__c, Name, Id, Group_Information__c, End_Date__c, Description__c From SalesFlow_Informationer__c where Page_Name__c =: url and Group_Information__c = 'General Information' order by Sequence_Number__c];                
        Integer sizeOfFields = pageFieldsMap.get(url);
        for(SalesFlow_Informationer__c pageText : salesFlowTextList){
            messages.add(pageText.Description__c);         
        }
        if(messages.size()<sizeOfFields){
            for(integer count = 0; count < sizeOfFields - messages.size(); count++){
                messages.add('');
            }   
        }
        system.debug('messages in SalesFlowText ' +messages);
    }   

}