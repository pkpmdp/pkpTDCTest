trigger tgrcheckEcomPermission on Permission__c (before insert, before update) {

   System.debug('$$$Inside Triger Permission');
  
  /*static Boolean checkTelYouBio;
  if( Trigger.isUpdate && Trigger.isAfter){
    for(Permission__c perm : [Select Id,E_kommunikation__c,Customer__c,customerID__c from Permission__c where Id IN :Trigger.new]){
      System.debug('$$$Inside'+perm.E_kommunikation__c+'###Old Value####'+trigger.oldMap.get(perm.id).E_kommunikation__c+'$$$Customer__c$$'+perm.customerID__c);
      if(!perm.E_kommunikation__c && trigger.oldMap.get(perm.id).E_kommunikation__c){
        System.debug('$$$Inside check Value');
        //checkTelYouBio = clsProductsYKController_V3.getYouBioAndTelefoniProducts(perm.customerID__c);
        if(checkTelYouBio == true){
          System.debug('%%%%%Inside Error');
        }
      }
    }
  }*/
  
  if(Trigger.isUpdate){
    System.debug('####NEWEEE'+Trigger.new);
    for(Permission__c perm : Trigger.new){
        System.debug('####a aaa'+perm.id+'####perm.E_kommunikation__c##'+perm.E_kommunikation__c);
        //perm.Old_E_kommunikation_c__c = perm.E_kommunikation__c;
        //System.debug('######perm.Old_E_kommunikation_c__c#########'+perm.Old_E_kommunikation_c__c);
    }
  }
}