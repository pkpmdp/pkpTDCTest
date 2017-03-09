/**********************************************************************************
************************************************************************************

* @class: DealerWebConferenceTicketController
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 10/12/2012
* @description: Class is controller for the PDF Attachment for youSee 13 Conference Email

************************************************************************************ 
***********************************************************************************/
public class DealerWebConferenceTicketController{
    public String dayProgram    {get;set;} 
    public String transportInfo {get;set;}
    public String youseeConferenceInfo{get;set;}
    public String registerText {get; set;}
    public String ticketHeaderText	{get;set;}
    
    /**  
    * @description: Constructor: fetches forhandlerInfo to be displayed in the Attachment
    */  
    public DealerWebConferenceTicketController(Apexpages.StandardController std){
        initialize();
        
        List<ForhandlerInformations__c> tempListInfo = new List<ForhandlerInformations__c>();
        tempListInfo = [Select Description__c From ForhandlerInformations__c 
                        WHERE Page_Type__c = 'DealerWebConferenceRegister' ORDER BY Sequence_Number__c ASC];
        
        if(tempListInfo.size() > 0){                            
            dayProgram = tempListInfo[0].Description__c;
            dayProgram = dayProgram.replaceAll('<p', '<span');
            dayProgram = dayProgram.replaceAll('/p>','/span>');
            transportInfo = tempListInfo[1].Description__c;
            youseeConferenceInfo = tempListInfo[2].Description__c;
            registerText = tempListInfo[3].Description__c;   
        }
        
        tempListInfo = new List<ForhandlerInformations__c>();  
        tempListInfo = [Select Description__c From ForhandlerInformations__c
        				WHERE Page_Type__c = 'DealerWebConferenceTicket' ORDER BY Sequence_Number__c ASC];
        if(tempListInfo.size() > 0){
        	ticketHeaderText = tempListInfo[0].Description__c;
        }
    }
    
    /**
    * @description: initializes the page variables
    * @return:   
    */  
    private void initialize(){
        dayProgram = transportInfo = registerText = youseeConferenceInfo = ticketHeaderText = '';   
    }
    
    @isTest(SeeAllData = true)
    private static void DealerWebConferenceTicketTest(){
    	ForhandlerInformations__c info = new ForhandlerInformations__c();
    	info.Description__c = 'test1';
    	info.Page_Type__c = 'DealerWebConferenceRegister';
    	info.Sequence_Number__c = 1;
    	insert info;
    	info = new ForhandlerInformations__c();
    	info.Description__c = 'test2';
    	info.Page_Type__c = 'DealerWebConferenceRegister';
    	info.Sequence_Number__c = 2;
    	insert info;
    	info = new ForhandlerInformations__c();
    	info.Description__c = 'test3';
    	info.Page_Type__c = 'DealerWebConferenceRegister';
    	info.Sequence_Number__c = 3;
    	insert info;
    	info = new ForhandlerInformations__c();
    	info.Description__c = 'test4';
    	info.Page_Type__c = 'DealerWebConferenceRegister';
    	info.Sequence_Number__c = 4;
    	insert info;
    	info = new ForhandlerInformations__c();
    	info.Description__c = 'test5';
    	info.Page_Type__c = 'DealerWebConferenceTicket';
    	info.Sequence_Number__c = 1;
    	insert info;
    	ApexPages.StandardController std = new ApexPages.StandardController(new Contact());
    	DealerWebConferenceTicketController ticketCtrlr = new DealerWebConferenceTicketController(std);
    }
}