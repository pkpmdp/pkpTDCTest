public with sharing class CompetitorMassEditController {
    
    public SelectOption[] leftOptions {get; set;}
    public SelectOption[] rightOptions {get; set;}
    public string listfrom {get; set;}
    public SelectOption[] selectedRoles {get; set;}
    public Set<String> previousSelectedRoles {get; set;}
    public SelectOption[] availableRoles {get; set;}
    private String accountId, cmpId;
    public Competitor__c cmp {get; set;}
    public String competitor {get; set;}
    public Account acc {get; set;}  
    public boolean isNewCmp {get; set;}
    public boolean isEditCmp {get; set;}
    public boolean firstEdit {get; set;}
    
    public CompetitorMassEditController(){

    }
    
    public CompetitorMassEditController(ApexPages.StandardController controller){
        
        isEditCmp=false;
        isNewCmp=false;
        firstEdit=true;
        
        cmpId = ApexPages.currentPage().getParameters().get('id');
        accountId = (ApexPages.currentPage().getParameters().get('retURL'));
        
        if(String.isNotBlank(accountId)){
            accountId=accountId.subString(1,16); 
            acc=[Select Name from Account where ID=:accountId];
        }        
        
        cmp=new Competitor__c();       
        prepareSelectBoxes();        
    } 
    
    public PageReference prepareSelectBoxes(){
        
      system.debug('##competitor:'+competitor);
      system.debug('##competitor2:'+cmp.Competitor__c);
      system.debug('##firstEdit:'+firstEdit);
      
      if(String.isNotBlank(cmpID)&&firstEdit==true){
            cmp=[Select Name,further_information__c,Customer__c,Competitor__c,Competitor_role__c,contract_expired_at_competitor__c  from Competitor__c where Id=: cmpId];
            isEditCmp=true;
            accountId=cmp.Customer__c;
            firstEdit=false;
            competitor=cmp.Competitor__c;
       }else{
            isNewCmp=true;              
       }       

       Set<String> set_selected=new Set<String>();  
       List<Competitor__c> cmpList=new List<Competitor__c>();
      
       system.debug('#cmp.Competitor__c:'+cmp.Competitor__c);
       system.debug('#cmp.Customer__c:'+accountId);
       
      
       cmpList=[Select Name,Customer__c,Competitor__c,Competitor_role__c,contract_expired_at_competitor__c from Competitor__c where Competitor__c=:cmp.Competitor__c and Customer__c=: accountId];
           
       system.debug('#cmpList:'+cmpList);
       
       for(Competitor__c c : cmpList){   
                if(String.isNotBlank(c.Competitor_role__c)){            
                    set_selected.add(c.Competitor_role__c);
                }       
        }
        
        system.debug('#set_selected:'+set_selected);
        
        availableRoles=new List<SelectOption>();    
        List<SelectOption> lst_allRoles=getAllRoles();
        
        for(SelectOption a : lst_allRoles) {
            if(!set_selected.contains(a.getValue())){
                availableRoles.add(new SelectOption(a.getLabel(), a.getValue()));   
            }   
        }
        
        system.debug('#availableRoles:'+availableRoles);
        
        selectedRoles=new List<SelectOption>();
        for (String str : set_selected) {
            selectedRoles.add(new SelectOption(str, str));      
        }  
        
        previousSelectedRoles=set_selected;
        
        system.debug('##previousSelectedRoles:'+previousSelectedRoles);
        
        return null;
    }    
    
    public List<SelectOption> getAllRoles(){
        
        Schema.DescribeFieldResult fieldResult = Competitor__c.Competitor_role__c.getDescribe();
        list<schema.picklistentry> values = fieldResult.getPickListValues();
        List<SelectOption> lst_allRoles = new List<SelectOption>();
        for(Schema.PicklistEntry a : values) {
            lst_allRoles.add(new SelectOption(a.getLabel(), a.getValue())); 
        }
        return lst_allRoles;
    }
    
    public PageReference save(){
        
        List<Competitor__c> lst_cmpToDelete=new List<Competitor__c>();
        List<Competitor__c> lst_cmpToCreate=new List<Competitor__c>();
        List<Competitor__c> lst_cmpToUpdate=new List<Competitor__c>();
        
        Set<String> set_ToBeAdded=new Set<String>();
        Set<String> set_ToBeDeleted=new Set<String>();
        Set<String> set_ToBeUpdated=new Set<String>();
                
        Set<String> set_preSelectedRole = new Set<String>();
        Set<String> set_newSelectedRoles = new Set<String>();       
        
        for(SelectOption so : selectedRoles)
        {
            set_newSelectedRoles.add(so.getValue());    
        }
        
        for(String so : previousSelectedRoles)
        {
            set_preSelectedRole.add(so);
        }
        
        for(String strNew : set_newSelectedRoles)
        {
            if(!set_preSelectedRole.contains(strNew))
            {
                set_ToBeAdded.add(strNew);
            }
        }
        
        system.debug('#set_ToBeAdded:'+set_ToBeAdded);
        
        for(String strPre : set_preSelectedRole)
        {
            if(!set_newSelectedRoles.contains(strPre))
            {
                set_ToBeDeleted.add(strPre);
            }
        }
        system.debug('#set_ToBeDeleted:'+set_ToBeDeleted);
        
        for(String strPre : set_preSelectedRole)
        {
            if(set_newSelectedRoles.contains(strPre))
            {
                set_ToBeUpdated.add(strPre);
            }
        }
        
        system.debug('#set_ToBeUpdated:'+set_ToBeUpdated);
        
        if(String.isNotBlank(cmpId)){
            accountId=cmp.Customer__c;
        }
        
        for(String cmpRoleName : set_ToBeAdded){
            
            Competitor__c cmpObj=new Competitor__c();
            cmpObj.Customer__c=accountId;
            cmpObj.Competitor__c=cmp.Competitor__c;
            cmpObj.Competitor_role__c=cmpRoleName;
            cmpObj.contract_expired_at_competitor__c=cmp.contract_expired_at_competitor__c;
            cmpObj.further_information__c=cmp.further_information__c;
            lst_cmpToCreate.add(cmpObj);
        }
        
        system.debug('#lst_cmpToCreate:'+lst_cmpToCreate);
        
        lst_cmpToUpdate=[Select Id from Competitor__c where Competitor_role__c IN :set_ToBeUpdated and Customer__c =:accountId and Competitor__c=:cmp.Competitor__c];   
        system.debug('#lst_cmpToUpdate:'+lst_cmpToUpdate);
        
        lst_cmpToDelete=[Select Id from Competitor__c where Competitor_role__c IN :set_ToBeDeleted and Customer__c =:accountId and Competitor__c=:cmp.Competitor__c];   
        system.debug('#lst_cmpToDelete:'+lst_cmpToDelete);
        
        if(lst_cmpToCreate.size()>0)
        insert lst_cmpToCreate; 
        
        if(lst_cmpToDelete.size()>0) 
        delete lst_cmpToDelete;
    
        system.debug('#cmp:'+cmp);
        system.debug('#cmp.contract_expired_at_competitor__c:'+cmp.contract_expired_at_competitor__c);
        
        if(set_ToBeAdded.size()==0){
                system.debug('#set_ToBeAdded.size()==0');
                if(!set_ToBeDeleted.contains(cmp.Competitor_role__c)){
                    system.debug('#!set_ToBeDeleted.contains(cmp.Competitor_role__c)');
                    cmp.contract_expired_at_competitor__c=cmp.contract_expired_at_competitor__c;
                    update cmp;
                }
        }
        //update lst_cmpToUpdate;
        
        if(String.isNotBlank(cmpId)){
            accountId=cmp.Customer__c;
        }       
        
        PageReference pageRef=new PageReference('/'+accountId);
        String accId = String.valueOf(accountId).subString(0, 15); 
        pageRef.setAnchor(accId+'_00N20000001Wsjn_target');
        return  pageRef;
    }
   
    public PageReference Cancel()
    {
        if(String.isNotBlank(cmpId)){
            accountId= cmp.Customer__c;   
        }
            
        PageReference pageRef=new PageReference('/'+accountId);
        String accId = String.valueOf(accountId).subString(0, 15); 
        pageRef.setAnchor(accId+'_00N20000001Wsjn_target');
        
        return  pageRef;
    }
    
    public PageReference MoveDown() {
        return null;
    }
    
    public PageReference MoveUp() {
        return null;
    }
    
    public PageReference DoUnselect() {
        return null;
    }
    
    public PageReference DoSelect() {
        return null;
    }
    
//*****************CODE OF COMPONENT CONTROLLER********************************//
    //******** Parse &-separated values and labels from value and*********// 
    //************************ put them in option*************************//
    
    private void setOptions(SelectOption[] options, String value) {
        options.clear();
        String[] parts = value.split('&');
        for (Integer i=0; i<parts.size()/2; i++) {
            options.add(new SelectOption(EncodingUtil.urlDecode(parts[i*2], 'UTF-8'), 
              EncodingUtil.urlDecode(parts[(i*2)+1], 'UTF-8')));
        }
    }
    
    // Backing for hidden text field containing the options from the
    // left list
    public String leftOptionsHidden { get; set {
           leftOptionsHidden = value;
           setOptions(leftOptions, value);
            system.debug('#leftOptions:'+leftOptions);
            system.debug('#value:'+value);
            system.debug('#leftOptionsHidden:'+leftOptionsHidden);
            
        }
    }
    
    // Backing for hidden text field containing the options from the
    // right list
    public String rightOptionsHidden { get; set {
           rightOptionsHidden = value;
           setOptions(rightOptions, value);
            system.debug('#rightOptions:'+rightOptions);
            system.debug('#value:'+value);
            system.debug('#rightOptionsHidden:'+rightOptionsHidden);
        }
    }
//****************************END OF COMPONENT CODE*********************************//
}