public class ViewNetInstallationHistory {

    public List<InstWrapper> instwpaList{get; set;}
    public Net_Installations__c netInst{get; set;}
    public String instID;
  	public InstWrapper iw;
  	public Boolean displayFlag{get; set;}
    public ViewNetInstallationHistory(ApexPages.StandardController stdController){
    	netInst = (Net_Installations__c)stdController.getRecord();
    	displayFlag = false;
    	if(netInst != null){
    		instID = [Select Id,INSTALLATION_ID__c From Net_Installations__c where Id =: netInst.Id limit 1].INSTALLATION_ID__c;
    	}	
    	System.debug('%%instID%%%'+instID);
    	//if(!String.isBlank(instID)){
    	instwpaList = new List<InstWrapper>();
        iw = new InstWrapper();
        instwpaList=getInstallationList(instID);
    	//}
    }
    
    public List<InstWrapper> getInstallationList(String instId1){
    	List<Net_Installations__c> netInstList = [Select Id,Cable_Unit__c,Cable_Unit_No__c ,Move_Flag__c,Start_Date__c,INSTALLATION_ID__c,Status__c,AddressId_InstLbnr__c,Address_Merge_Field__c From Net_Installations__c where INSTALLATION_ID__c =: instID Order by Start_Date__c ASC];
    	if(netInstList.size() > 0){
    		if(netInstList.size() >= 2){	
	    		iw=new InstWrapper();
	    		iw.netObj=netInstList[netInstList.size()-2];
	    		iw.instDestination='SRC';
	    		instwpaList.add(iw);
	    	
	    		iw=new InstWrapper();
	    		iw.netObj=netInstList[netInstList.size()-1];
	    		iw.instDestination='TARGET';
	    		instwpaList.add(iw);
	    		displayFlag = true;
	    	}
	    	
	    	/*else if(netInstList.size() == 1){
	    		ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Movement of Installations Doesnt Exists');
    			ApexPages.addMessage(errorMsg);	
    			displayFlag = false;
	    	}*/
	    	
	    	/*else{
	    		iw=new InstWrapper();
	    		iw.netObj=netInstList[netInstList.size()-1];
	    		iw.instDestination='SRC';
				instwpaList.add(iw);
	    	}*/
    	} else{
    		ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.INFO,'No Installations Exists');
    		ApexPages.addMessage(errorMsg);
    		displayFlag = false;
    	}   
    	
    /*	for(Net_Installations__c nList : netInstList){
    			iw.recordId = nList.Id;
    			iw.cableUnitNo = nList.Cable_Unit_No__c;
    			iw.strDate = nList.Start_Date__c;
    			iw.status = nList.Status__c;
    			iw.instId = nList.INSTALLATION_ID__c;
    			iw.netObj=nList;
    			//instwpaList.add(new InstWrapper(nList));
    			instwpaList.add(iw);
    		}*/
    	return instwpaList;
    }
    
    
    public class InstWrapper{
    	public Net_Installations__c netObj{get; set;}
    	public String instDestination{get; set;}
    	public InstWrapper(){
    		
    	}
    	
    	/*public InstWrapper(String s1, Id rec1, String cu1, DateTime stDate1, String sts1, String instId1){
    		s1 = instDestination;
    		recordId = rec1;
    		cableUnitNo = cu1;
    		strDate = stDate1;
    		status = sts1;
    		instId = instId1;
    	}*/
    }
}