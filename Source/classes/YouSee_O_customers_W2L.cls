public class YouSee_O_customers_W2L {
    private final Lead weblead;
   // public String title{get; set;}
    public String firstName{get; set;}
    public String lastName{get; set;}
    public String email{get; set;}
    public String telephone{get; set;} 
    public String siteCoreUrl{get; set;}
    public string cableUnitName{get; set;}
    public String portalBrugerRole {get; set;}
    public String cableUnitNumber {get; set;}
    public String accountId{get;set;} //support-5377
    public boolean rendersection{get;set;}//support-5377
    public String successmsg{get; set;}
    public boolean errormsg {get; set;}
    public boolean resend{get; set;}
    public boolean check {get; set;}
    Final String emailregex ='^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
    //public Cable_Unit__c cableUnit = new Cable_unit__C();
    public String leadownerId ;
    public List<Lead> registerLeadlst = new List<Lead>();
    public List<Cable_Unit__c>cableUnit=new List<Cable_Unit__c>();
    /*public YouSee_O_customers_W2L(ApexPages.StandardController stdController) {

       weblead = (Lead)stdController.getRecord();
       weblead.RecordTypeId='012M00000004rfU';

    } */
    public YouSee_O_customers_W2L() {
        siteCoreUrl = ServiceCenter_CustomSettings__c.getInstance('Service_Center_SiteCoreURL').Value__c;
        portalBrugerRole = ServiceCenter_CustomSettings__c.getInstance('Contact Roles Bruger').Value__c;
        cableUnitNumber = ApexPages.CurrentPage().getParameters().get('cableunitnumber');
        leadownerId= UserInfo.getUserId();
        accountId = ApexPages.CurrentPage().getParameters().get('accountId');
        Boolean cableUnitNotMatch = false;
        renderSection = true;
        cableUnit = [Select c.Id,c.name, c.Current_Kiss_Case__r.Sales_Concept_Lookup__r.id from Cable_Unit__c c where  c.Cable_Unit_No__c =:cableUnitNumber limit 1];
         if(!cableUnit.isEmpty())
        cableunitName = cableUnit[0].name;
        //cableunitName = cableUnit.name;
        System.debug('Cableunit object' + cableUnit);
       // System.debug('Cableunit Id constructor' + cableUnit.Id);
        check= false;
        //successmsg='Email sendt til medlem';
        errormsg= false;
        resend= false;
        list<Account> accList = new list<Account>();//start-5377
        accList = [SELECT Id, Cable_Unit__r.Cable_Unit_No__c FROM Account where id =:accountId ];
        if(!accList.isEmpty()){

            system.debug('*****accList*********' + accList[0].Cable_Unit__r.Cable_Unit_No__c);
            if(cableUnitNumber != null && accList[0].Cable_Unit__r.Cable_Unit_No__c != cableUnitNumber){
                renderSection = false;
            }
               
    }
        else
            {
              renderSection = false;  
            } 
    }
    //end support-5377
    public void validate(){
         System.debug('Errormsg  ***'+ errormsg);
         if(String.IsBlank(firstName)){
            System.debug('Firstname is blank');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.Yousee_O_customerFornavn));
            errormsg=true;
        } else if(String.IsBlank(lastName)) {
            System.debug('Lastname is blank');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.Yousee_O_customerEfternavn));
            errormsg=true;
        } else if(String.IsBlank(email)){
            System.debug('Email is blank');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.Yousee_O_customerEmail));
            errormsg=true;
        }
        
        if(!errormsg){
            if(Pattern.matches(emailregex,email)){
            errormsg=false;
            }
            else{
            errormsg=true;
            System.debug('Email is not valid');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.Yousee_O_customerEmailerror));
            }
           
        }
        
        if(!errormsg){
            
            System.debug('Cableunit Id save method' + cableUnit[0].Id);
            System.debug(' cableUnitNumber@@@ '+ cableUnitNumber);
            registerLeadlst =[Select id,ResendFlag__c, Unsubscribed__c from Lead where Email=:email and LeadSource = :System.Label.Yousee_O_customerLeadSource and Cable_Unit_1__r.Cable_Unit_No__c=:cableUnitNumber and OwnerId =:leadownerId];
            System.debug('Leads list ' + registerLeadlst.size());
            if(registerLeadlst.size() > 0){
            System.debug('Leads list size ' + registerLeadlst.size());
             for(Lead ld: registerLeadlst)
             {
                 if(ld.Unsubscribed__c == true)
                 {
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Medlem '+ email +' er allerede registreret og har afvist medlemsregistrering. Vil du gensende?'));
                 }
                 else
                 {
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Medlem '+ email +' allerede registreret. Vil du gensende?'));
                 }
             }
            
            errormsg=true;
            resend=true;
            } 
            
        }
    }
     public void saveLead() {
        errormsg=false;
        resend=false;
        validate();
       try {
        if(!errormsg){
        Lead weblead = new Lead();
       // weblead.Title=title;
        weblead.FirstName=firstName;
        weblead.LastName=lastName;
        weblead.Email=email;
        weblead.MobilePhone=telephone;
        weblead.Cable_Unit_1__c=cableUnit[0].Id;
        weblead.LeadSource=System.Label.Yousee_O_customerLeadSource;
        weblead.ResendFlag__c=true;
        weblead.RecordTypeId=[select id from recordtype where DeveloperName like :system.label.Yousee_O_customerLeadRecordType].id;
        errormsg= false;
        insert(weblead);
        successmsg='Email sendt til medlem: '+email;
       // title='';
        firstName='';
        lastname='';
        email='';
        telephone=''; 
        resend= false;       
        check =true;
        System.debug('Weblead '+ weblead);
        }
       }
        catch(System.DMLException e) {
           ApexPages.addMessages(e);
           System.debug('Exception message' + e.getMessage());
           //return null;

       }
        }
       //return null;
     public void Resendemail(){
        System.debug('Register list ' + registerLeadlst);
         List<Lead> regLeadLst = new List<Lead>();
         for(Lead ld: registerLeadlst)
         {
                ld.ResendFlag__c = true;
                regLeadLst.add(ld);
         }
        update regLeadLst;
        errormsg=false;
        resend=false;
        successmsg='Email sendt til medlem: '+email;
        // title='';
        firstName='';
        lastname='';
        email='';
        telephone='';
     }
    public void clearForm(){
       // title='';
        firstName='';
        lastname='';
        email='';
        telephone='';
        errormsg= false;
        successmsg = '';
        resend= false;
    }
}