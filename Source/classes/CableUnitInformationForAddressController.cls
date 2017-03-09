public class CableUnitInformationForAddressController {
    //SPOC-2272
    public Address__c address = new Address__c();
    public List<Net_Installations__c> netInstList{get; set;}
    public List<String> nic{get; set;}
    public List<Links__C> linkList{get; set;}
    public integer listSize{get; set;}
	public Map<String,List<Links__c>>  cbleUnitLinkMap{get;set;}
    public boolean errorflag {get; set;}
    public CableUnitInformationForAddressController(ApexPages.StandardController controller) {
        address = (Address__c)controller.getRecord();
        //address = [Select id, Cableunit_number__c From Address__c where Id =:address.Id];
        System.debug('****Adress***'+address);
		cbleUnitLinkMap =  new Map<String,List<Links__c>>();
        errorflag=true;
    }
    
    public PageReference getCableUnitInformation()
    {
      	   linkList=  new List<Links__C>();
        nic = new List<String>();
        netInstList = new List<Net_Installations__c>();
        List<Net_Installations__c> tempNetInstList = new List<Net_Installations__c>();
        tempNetInstList = [SELECT Id, Cable_Unit__c, Cable_Unit_No__c, Cable_Unit__r.CableUnit_Lock__c, Cable_Unit__r.Lock_Date__c, Cable_Unit__r.Cableunit_UnLockDate__c,
                       Cable_Unit__r.CableUnit_Lock_Date__c, Cable_Unit__r.CableUnitLocked__c, Cable_Unit__r.Cable_Type__c, Cable_Unit__r.Cable_Unit_No__c,
                       Cable_Unit__r.Package_Choice__c, Cable_Unit__r.Package_Selection_Enddate__c,Cable_Unit__r.Cabel_Unit_lock__c, Cable_Unit__r.Pr_installeret_udstyr_p_anl_g__c, Address__c 
                       FROM Net_Installations__c WHERE Address__c =:Address.Id ORDER BY Cable_Unit__r.Pr_installeret_udstyr_p_anl_g__c ASC NULLS LAST];
        System.debug('****tempNetInstList***'+tempNetInstList);
						//SPOC-2388 Used Map to get URL from Links object

						cbleUnitLinkMap = new Map<String,List<Links__c>>();
						for(Net_Installations__c l : tempNetInstList){
                            linkList=[SELECT Category__c,URL__c,Cable_Unit__c from Links__c WHERE Cable_Unit__c =:l.Cable_Unit__c ];
                            if(!linkList.isEmpty()){
                                if(!cbleUnitLinkMap.containsKey(l.Cable_Unit__c)){
                                   cbleUnitLinkMap.put(l.Cable_Unit__c, linkList);
                                   netInstList.add(l);
                                }
                            }else
                                if(!cbleUnitLinkMap.containsKey(l.Cable_Unit__c)){
                                    cbleUnitLinkMap.put(l.Cable_Unit__c, new list<Links__c>());
                            		netInstList.add(l);
                                }
						     }
						
       					//SPOC -2388 end
       if(!netInstList.isEmpty()){
            listSize = netInstList.size();
        }
        else{
            listSize = 0;
        }
         
        return null;
    }

}