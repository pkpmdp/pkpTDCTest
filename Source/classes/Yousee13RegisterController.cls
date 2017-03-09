public class Yousee13RegisterController {
   
   /*
   Requirements : 
   Task 1 : Once QR Code is scanned, the status should be changed to ‘deltog'
   Task 2 : Webpage with name card information, and render the page as a pdf file. 
   Task 3 : After some settings on pdf, it can be printed as a label. 
   Task 4 : Campaign Member account name to be dispplayed on the card.
   Task 5 : Campaign Member First name & Last Name to be displayed on the card 
   Task 6 : Show time should be shown for each show based on region.  
   Task 7 : Member Type : Indication (L, R or N) 
   			L - Guest	R - Ordre or Idrift	else N   
   			Hierarchy
   Task 8 : In case if the member is already registed then a message has to displayed.
   Task 9 : Logo to be displayed at the bottom of the card.
   */
   
   public ID campaignId{get;set;}  
   public CampaignMember campaignMember{get;set;}  
   public String accountNumber{get;set;}
   public String accountName{get;set;}
   
   public String errorStatus{get;set;}
   public String schedule{get;set;}
   
   public boolean showTime{get;set;}
   public String memberType{get;set;} 	
   public String campaignMemberName{get;set;}
   public String campaignName{get;set;}
   
   public Yousee13RegisterController () {
      	campaignId = ApexPages.currentPage().getParameters().get('cmid');
   }
   
   public Map<String, String> conferenceScehdule{get;set;}
   public PageReference updateCampaignStatus(){
   		List<CampaignMember> campaignMemberList = [Select contactid, c.Status, Account_Number__c, c.Spor__c, Leadid, c.show__c,
        Lead.Name, Contact.Name, lead.title, Campaign.Name From CampaignMember c where c.id=:campaignId ];
        if(campaignMemberList.size() > 0){
        	campaignMember = campaignMemberList.get(0);
        	if(campaignMember.contactid != null){
        		campaignMemberName = campaignMember.Contact.Name;
        	}else if(campaignMember.leadid != null){
        		campaignMemberName = campaignMember.Lead.Name;
        	}
        	campaignName = campaignMember.Campaign.Name;
      		accountNumber = campaignMember.Account_Number__c;
        //	showTime = campaignMember.show__c;
        	
        	if('Deltog'.equals(campaignMember.Status)){
        		 errorStatus = campaignMemberName + ' er allerede registeret';
        		 PageReference newPage = new PageReference('/apex/Yousee13RegisterError');
	  	         newPage.setRedirect(false);
	  	         return newPage;
        	}else{
        		campaignMember.Status = 'Deltog'; 
        		update campaignMember;
        	}	
        }	 
        
        
        System.debug(' Inside the updateCampaignStatus 4 ');
        
        String existingPhase = null;
        String accountType = null;
        String salesType = null;
        String latestPhase = null;
        System.debug(' Inside the accountNumber ' +accountNumber);
        List<Account> accountList = [Select a.Name, a.Latest_Phase__c, a.Latest_Sales_Type__c,a.Existing_Phase__c, a.Type, a.Cable_Unit_Name__c  From Account a where a.Customer_No__c=:accountNumber];
        if(accountList.size() > 0){
        	Account account =  accountList.get(0);
        	if('Kunde'.equals(account.Type)){
        		accountName = account.Cable_Unit_Name__c;
        	}else if('Hierarki'.equals(account.Type)){
        		accountName = account.Name;	
        	}
        	accountType = account.Type;
        	latestPhase =  account.Latest_Phase__c; //account.Existing_Phase__c;
        	salesType = account.Latest_Sales_Type__c;
        }
        if(campaignMember.Leadid != null && 'Guest'.equals(campaignMember.lead.title)){
        	memberType = 'Ledsager';
        }	
        else if( accountType != null && 'Hierarki'.equals(accountType)){ 
        	memberType = 'Kunde';
        }
        else if('Kontraktændring'.equals(salesType)){
        	memberType = 'Kunde';
        }
        else if('NySalg'.equals(salesType)){
        	if(latestPhase != null && ('Ordre'.equals(latestPhase) || 'Idrift'.equals(latestPhase))){
        		memberType = 'Kunde';
        	}	
        } 
        else {
        	memberType = '';
        }
       // if(showTime){
        	
        	if(campaignMember.Spor__c != null){
        		generateSporTime();
        		schedule = 'LIVE tv-show kl. ' + conferenceScehdule.get(String.valueOf(campaignMember.Spor__c));
        	}else{
        		generateShowTime();
        		schedule = 'LIVE tv-show kl. ' + conferenceScehdule.get(campaignName);
        	}
        		
        		
       // }
        return null;
   }
   
   public Yousee13Campaign__c yousee13 = Yousee13Campaign__c.getInstance('Registration');
   public String jyllandFynLive13ShowTime = yousee13.JyllandFynLive13ShowTime__c;
   public String sjaellandLive13ShowTime = yousee13.SjaellandLive13ShowTime__c;
   public String storkobenhavnLive13ShowTime = yousee13.StorkobenhavnLive13ShowTime__c;
   
   // used to show time for each region based on Spor field
   public void generateSporTime(){
   		conferenceScehdule = new Map<String, String> {};
   		conferenceScehdule.put('Spor3-Jylland/Fyn-kl 16:30', '16:30');
		conferenceScehdule.put('Spor2-Sjælland-kl 14:30', '14:30');
		conferenceScehdule.put('Spor1-Storkøbenhavn-kl 12:30', '12:30');
		conferenceScehdule.put('3', '16:30');
		conferenceScehdule.put('2', '14:30');
		conferenceScehdule.put('1', '12:30');
   }
   
   // used to show time for each region based on Campaign Member field
   public void generateShowTime(){
   		conferenceScehdule = new Map<String, String> {};
   		conferenceScehdule.put('Invitation Jylland/Fyn Live 13', jyllandFynLive13ShowTime);
		conferenceScehdule.put('Billet/voucher Fyn/Jylland Live 13', jyllandFynLive13ShowTime);
		conferenceScehdule.put('Busafgang Live 13', jyllandFynLive13ShowTime);
		conferenceScehdule.put('Reminder Fyn/Jylland Live 13', jyllandFynLive13ShowTime);
		conferenceScehdule.put('Show 3 Live 13', jyllandFynLive13ShowTime);
		conferenceScehdule.put('Invitation Sjælland Live 13', sjaellandLive13ShowTime);
		conferenceScehdule.put('Billet/voucher Sjælland Live 13', sjaellandLive13ShowTime);
		conferenceScehdule.put('Reminder Sjælland YouSee Live 13', sjaellandLive13ShowTime);
		conferenceScehdule.put('Show 2 Live 13', sjaellandLive13ShowTime);
		conferenceScehdule.put('Invitation Storkøbenhavn Live 13', storkobenhavnLive13ShowTime);
		conferenceScehdule.put('Billet/voucher Storkøbenhavn Live 13', storkobenhavnLive13ShowTime);
		conferenceScehdule.put('Reminder Storkøbenhavn YouSee Live 13', storkobenhavnLive13ShowTime);
		conferenceScehdule.put('Show 1 Live 13', storkobenhavnLive13ShowTime);
   }
   
}