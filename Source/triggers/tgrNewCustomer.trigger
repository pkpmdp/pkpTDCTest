Trigger tgrNewCustomer on Account (before insert) {
    List <LastCustomer__c> lastCustomers = new List<LastCustomer__c>();  
    List <Account> accounts = new List <Account>();

    // Old customer importing exception code begin
    CustomerNumberSeq__c custSeq_temp = null;
    Boolean checkCustNum = false;
    for (Account row:Trigger.new) {
        if (row.Type != 'Hierarki' &&
            (row.RecordTypeName__c == 'YF O-Customer' || 
             row.RecordTypeName__c == 'YK Customer Account' ||
             row.RecordTypeName__c == 'YK Pending Account' ||
             row.RecordTypeName__c == 'YK Prospect Account' ||
         row.RecordTypeName__c == 'Blockbuster Customer Account'))
         {
            checkCustNum = true;
        }
    }
    if (checkCustNum) {
        CustomerNumberSeq__c[] custSeq_temps = [SELECT lastNumber__c FROM CustomerNumberSeq__c];
        custSeq_temp = (custSeq_temps.size() > 0) ? custSeq_temps[0] : null;
    }
    // Old customer importing exception code end

    for (Account row:Trigger.new) {
        if(row.Type != 'Hierarki'){
            if (row.RecordTypeName__c == 'YF O-Customer' || 
            row.RecordTypeName__c == 'YK Customer Account' ||
            row.RecordTypeName__c == 'YK Pending Account' ||
            row.RecordTypeName__c == 'YK Prospect Account' ||
        row.RecordTypeName__c == 'Blockbuster Customer Account'){
                // Old customer importing exception code begin
                if (row.Customer_No__c != null) {
                    try {
                        if (custSeq_temp == null) {
                            row.addError('\n\nTrigger.tgrNewCustomer.CUSTOMER_NUMBER_ERROR: CustomerNumberSeq__c has not been initialized in database.');
                        } else if(Decimal.valueOf(row.Customer_No__c) > custSeq_temp.lastNumber__c * 10) {
                            // Filter out value '987654321' which is used as Customer_No in several tests
                            if (row.Customer_No__c != '987654321')
                               row.addError('\n\nTrigger.tgrNewCustomer.CUSTOMER_NUMBER_ERROR: Invalid number inserted: Value is above CustomerNumberSeq__c.lastNumber__c: ' + row.Customer_No__c);
                        }
                    } catch (System.TypeException e) {
                        row.addError('\n\nTrigger.tgrNewCustomer.CUSTOMER_NUMBER_ERROR: Invalid number inserted. Caused by: ' + e);
                    }
                } else {
                // Old customer importing exception code end
                    accounts.add(row);
                    lastCustomers.add(new LastCustomer__c());
                // Old customer importing exception code begin
                }
                // Old customer importing exception code end
            }
        }
    }

    if (lastCustomers.size()>0){
        insert lastCustomers;
        List <LastCustomer__c> lastCust = [Select Name from LastCustomer__c where Id IN :lastCustomers]; 
        CustomerNumberSeq__c custSeq = [ Select lastNumber__c from  CustomerNumberSeq__c ];
        clsCustomerNumber cNum;
        Integer i = 0;
        for (Account row: accounts) {           
            cNum = new clsCustomerNumber();            
            row.Customer_No__c = cNum.getNewCustomerNumber(custSeq.lastNumber__c +
                Decimal.valueOf(((LastCustomer__c)lastCust.get(i)).Name));          
            i++;                
        }
        //delete lastCustomers;   
    }
}