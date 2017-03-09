public global class commonClass{
    
//Dealer details variables
public Id userId;
public Contact userContact {get;set;}
public Account dealerAccount {get;set;}
public string dealerAccountList{get;set;}
//Variable to prevent recursive trigger call
public static boolean isRecursiveTrigger=false;
public string streetNo {get{return (dealerAccount.House_No__c==null?'':dealerAccount.House_No__c);}set;}
public string street {get{return (dealerAccount.Street_YK__r.Street__c==null?'':dealerAccount.Street_YK__r.Street__c);}set;}
public string door {get{return (dealerAccount.Door_No_YK__c==null?'':dealerAccount.Door_No_YK__c);}set;}
public string floor {get{return (dealerAccount.Floor_No__c==null?'':dealerAccount.Floor_No__c);}set;}
public string entrance {get{return (dealerAccount.Entrance_YK__c==null?'':dealerAccount.Entrance_YK__c);}set;}

public string streetName {get{return (dealerAccount.Street_YK__r.Street__c==null?'':dealerAccount.Street_YK__r.Street__c);}set;}
public string side {get{return (dealerAccount.Side_YK__c==null?'':dealerAccount.Side_YK__c);}set;}
public string city {get{return (dealerAccount.Town_YK__c==null?'':dealerAccount.Town_YK__c);}set;}
public string town {get{return (dealerAccount.Town_YK__c==null?'':dealerAccount.Town_YK__c);}set;}
public string postCode {get{return (dealerAccount.Post_Code__c==null?'':dealerAccount.Post_Code__c);}set;}
public string dealerNumber{get{return (dealerAccount.Dealer_Number__c==null?'T7006':dealerAccount.Dealer_Number__c);}set;}
public string house {get{return (dealerAccount.House_No__c==null?'':dealerAccount.House_No__c);}set;}
public Set<String> productsDealerCanSell{get;set;}

public commonClass(){
    setDealerInfo();

}

    public void setDealerInfo()
    {
        try
        {
            userId = Userinfo.getUserId();
            system.debug('logged in user id is------'+userId);
           
            if([select contactid from User where id = :userId].contactid == null && userInfo.getProfileId().Contains(System.Label.ParellelDealerProfile)&& !test.isRunningTest()){
                userContact = [Select Id,accountId ,FirstName,LastName,Name,Email From Contact  where id = : System.Label.ParallelDealerContactId];
            }else
            	userContact = [Select Id,accountId ,FirstName,LastName,Name,Email From Contact  where id in (select contactid from User where id = :userId) LIMIT 1];     
            //For testing Start
                     
           System.Debug('userContact.accountId-->'+ userContact.accountId);
         //  dealerAccount=[select id,Dealer_Number__c,DealerProducts__c,Post_Code__c,Street_YK__r.Street__c from Account where id =:userContact.accountId];
            dealerAccount=[select name,id,Dealer_Number__c,DealerProducts__c,Door_no_Yk__c,floor_no__C,house_no__C,entrance_yk__c,Street_yk__r.name,town_yk__c,post_code__C,Street_YK__r.Street__c,Side_YK__c from Account where id =:userContact.accountId];
            
           system.debug('dealerAccount-------list---------------------------'+dealerAccount); 
            dealerAccountList = dealerAccount.DealerProducts__c;
             system.debug('dealerAccount------- dealerAccountList dealerAccountList ---------------------------'+dealerAccountList);
             //system.debug('dealerAccount------- selectedProduct__c selectedProduct__c ---------------------------'+dealerAccount.selectedProduct__c);
             List<String> dealerProds = dealerAccount.DealerProducts__c.split(';');
             system.debug('dealerProds ******* '+dealerProds);
             productsDealerCanSell = new Set<String>();
             for(String prod : dealerProds){
             	
             	if(prod.contains('Bredbånd')){
             		productsDealerCanSell.add('Bredbånd'); 
             	} else if(prod.contains('Ekstrakanaler')){
             		productsDealerCanSell.add('Ekstrakanaler'); 
             	}else if(prod.contains('Telefoni')){
             		productsDealerCanSell.add('Telefoni'); 
             	}
             	else if(prod.contains('YouBio')){
             		productsDealerCanSell.add('YouBio'); 
             	}
             	// DW-869
             	else if(prod.contains('Yousee Tv')){
             		productsDealerCanSell.add('Yousee Tv'); 
             	}
             	// DW-869
             	else if(prod.contains('YouSee Tv –')){
             		productsDealerCanSell.add('YouSee Tv –'); 
             	}
             	else {
             		productsDealerCanSell.add(prod.trim());
             	}
             }
             System.debug('productsDealerCanSell ---  '+productsDealerCanSell);
        }
        catch(Exception ex)
        {
            
        }
    }

}