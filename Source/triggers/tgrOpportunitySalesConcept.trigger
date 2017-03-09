trigger tgrOpportunitySalesConcept on Opportunity (before insert, before update) {
    List<Opportunity> opportunityList = new List<Opportunity>();
    List<SalesConcept__c> salesConceptList = new List<SalesConcept__c>();
    List<String> idList = new List<String>();
    if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            
            for(Opportunity opportunity : Trigger.new){ 
              if(opportunity.KISS_Sales_Concept_Id__c != null){
                    idList.add(opportunity.KISS_Sales_Concept_Id__c);
                    opportunityList.add(opportunity);
              }
            }
            
            for(SalesConcept__c salesConcept : [Select id, sc_code__c, Solution__c, SC_Source_Id__c from SalesConcept__c where SC_Source_Id__c IN : idList]){
                salesConceptList.add(salesConcept);
            }
            
            for(Opportunity opList : opportunityList){
                if(opList.KISS_Sales_Concept_Id__c != null && opList.Sales_Concept__c != null && opList.Sales_Concept__c.contains('-')){
                    String code = '', head = '';                          
                    String[] codeHeadPair = opList.Sales_Concept__c.split('-');
                    if(codeHeadPair.size() > 1){
                       code = codeHeadPair[0];
                       for(Integer i = 1; i < codeHeadPair.size(); i++){
                        if(head == ''){
                          head = codeHeadPair[i];      
                        }else{
                          head = head +  '-' + codeHeadPair[i];      
                        }  
                       }
                       head = head.trim();
                       for(SalesConcept__c salesConcept : salesConceptList){
                          if(salesConcept.sc_code__c.equals(code) && salesConcept.Solution__c.equals(head) && salesConcept.SC_Source_Id__c == opList.KISS_Sales_Concept_Id__c){
                            opList.Sales_Concept_Lookup__c = salesConcept.id;
                            //opportunityList.add(opportunity);
                          }         
                       }
                    }
                }
                
              }                                                         
            }
            //if(opportunityList.size() > 0)
            //  update opportunityList;
        }
    }