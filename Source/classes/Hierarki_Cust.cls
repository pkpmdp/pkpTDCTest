public with sharing class Hierarki_Cust {

	public List <Account> lstAcc{get;set;}
    private transient Map<Id,Account> mapIdToAcc{get;set;}
    public id kundeParentid;  
    public boolean showSearch{get;set;}
    public List<Account> lstAccPage{get;set;}
    
    public Hierarki_Cust()
    {
        try
        {
            strKundeId = System.currentPageReference().getParameters().get('likeString');  
            KundeParent = System.currentPageReference().getParameters().get('KundePar');           
  
        	if(KundeParent!=null)
        		kundeParentid = KundeParent;
            
            showHierakiAcc();  
            if(!lstAcc.isEmpty()){
        	lstAccPage = new List<Account>();
        	for(Integer i=lstAcc.size()-1;i>=0;i--){
        		lstAccPage.add(lstAcc[i]);
        	}
        		system.debug('=========lstAcc========'+lstAccPage);
        	showSearch = true;
        }
        	
        else
        	showSearch = false;                       
        }
        catch(exception ex)
        {
            // DO NOTHING
        }
    }
      
    public String strKundeId
    {
        set
        {
           strKundeId = value;
        }
        get
        {
          return strKundeId; 
        }
    }
    
    public String KundeParent
    {
        set
        {
           KundeParent = value;
        }
        get
        {
          return KundeParent; 
        }
    }
       

    public list <Account> showHierakiAcc()
    {        
		lstAcc = new List<Account>();
        
        do{	
        	mapIdToAcc = new map<ID,Account>([select IsPersonAccount,Name,parentid ,Type, Customer_No__c,id, parent.name from account where RecordTypeId = '012200000000o7Z' and id=:kundeParentid]);
    		if(mapIdToAcc.containsKey(kundeParentid))
    		{
    			lstAcc.add(mapIdToAcc.get(kundeParentid));
    			if(mapIdToAcc.get(kundeParentid).parentid !=null)
    				kundeParentid = mapIdToAcc.get(kundeParentid).parentid;
    			else
    				break;
    		}	
        }while((!mapIdToAcc.isempty()));
        system.debug('=========lstAcc========'+lstAcc.size());
        return lstAcc; 
    }         
    
    public PageReference findAcc()
    {
        showHierakiAcc();
        
        if(!lstAcc.isEmpty()){
        	lstAccPage = new List<Account>();
        	for(Integer i=lstAcc.size()-1;i>=0;i--)
        		lstAccPage.add(lstAcc[i]);
        		system.debug('=========lstAcc========'+lstAccPage);
        	showSearch = true;
        }
        	
        else
        	showSearch = false;
        return null;
    }

}