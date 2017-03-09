trigger tgrAccountBeforeInsertSetBillingAdress on Account (before insert) {
	// If Billing Address is not specified, this triger sets it to the Legal adress.  
    for (Account a:Trigger.new) {
        if(a.IsPersonAccount && a.Street_YK__c != null && a.Billing_Address__c == null ) {
            a.Billing_Address__c = a.Street_YK__c;
        }
    }
}