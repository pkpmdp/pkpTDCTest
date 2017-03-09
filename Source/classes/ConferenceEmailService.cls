/**********************************************************************************
************************************************************************************

* @class: ConferenceEmailService
* @author: Capgemini Consulting India Pvt. Ltd.
* @version History : 1.0
* @date: 07/12/2012
* @description: Class is used to send email to Dealer Employee for youSee 13 Conference

************************************************************************************ 
***********************************************************************************/
global class ConferenceEmailService {
	
	/**
    * @description: sends email to Contact for youSee 13 conference
    * @return: String: Success/Failure message
    */   
	WebService static String sendEmailYouseeConference(String contactId, String contactEmail){
		try{
			ApexPages.StandardController std = new ApexPages.StandardController(new Contact());
			DealerWebConferenceRegisterController dwcrController = new DealerWebConferenceRegisterController(std);
			return dwcrController.sendEmailToAttendees(contactId, contactEmail);
		}
		catch(Exception e){
			return e.getMessage(); 
		}
	} 
}