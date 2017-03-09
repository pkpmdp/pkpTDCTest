public with sharing class clsNpCustomersWithDuplicatesImpl {

    public static final String csName = 'NpCustDuplicates.TO_ADDRESSES';
    public static final String waitAuthStatus = 'NP fuldmagt sendt til kunden';

    // The only method which is called by clsNpCustomersWithDuplicatesScheduler
    public String runJob() {
        String[] toAddresses; // Email addresses
        YouSeeCustomSettings__c cs = YouSeeCustomSettings__c.getValues(csName);
        if (cs != null && cs.Setting_Value__c != null) {
            toAddresses = cs.Setting_Value__c.split(',');
        }
        String sandboxName = ''; // Sandbox name
        cs = YouSeeCustomSettings__c.getValues('Sandbox');
        if (cs != null && cs.Setting_Value__c != null) {
            sandboxName = cs.Setting_Value__c;
        }
        System.debug('toAddresses: ' + toAddresses);

        // Identify customers with duplicate NP in-port cases:
        // Customers whose related in-port flows are waiting for an authorization
        List<String> allCusts = new List<String>();
        /* SOQL on Cases took too long. Frequently.
        for (Case c : [
            SELECT Customer_Number__c FROM Case
            WHERE Type_Task__c = 'NP in-port' AND NP_Status__c = :waitAuthStatus
        ]) {
            if (c.Customer_Number__c != null) {
                allCusts.add(c.Customer_Number__c);
            }
        }
        */
        for (NP_Order__c o : [
            SELECT Customer_Number__c FROM NP_Order__c
            WHERE Customer_Number__c != null
                AND Status__c = :clsCasesNpHandlerController.NPO_STATUS_NPREQUESTCONFIRMATION
        ]) {
            allCusts.add(o.Customer_Number__c);
        }
        System.debug('allCusts.size: ' + allCusts.size());
        // Customers whose related in-port flows (at least one) were accepted
        // and others (at least one) are still waiting for an authorization
        Set<String> dupCusts = new Set<String>();
        for (NP_Order__c o : [
            SELECT Customer_Number__c, Notify_Kasia_Flag__c FROM NP_Order__c
            WHERE Customer_Number__c IN :allCusts
        ]) {
            if (o.Notify_Kasia_Flag__c != null &&
                o.Notify_Kasia_Flag__c.trim().endsWith('NP Request Accepted, Success')
            ) {
                dupCusts.add(o.Customer_Number__c);
            }
        }
        System.debug('dupCusts.size: ' + dupCusts.size());

        Integer count = dupCusts.size();
        String txtCount =
            (count == 0 ? 'NO customers' : (count == 1 ? count + ' customer' : count + ' customers')) +
            ' with duplicate NP in-port cases found'
        ;
        String emSubject = 'NP-124: ' + txtCount;

        String result = '';
        if (toAddresses == null) {
            result = 'No recipients found. Emails can NOT be sent out!';
            System.debug(result);
        } else {
            // Create email
            String emBody = txtCount;
            if (count > 0) {
                emBody += ':\n';
                for (String s : dupCusts) {
                    emBody += '\n' + s;
                }
            }
            Messaging.SingleEmailMessage sem = new Messaging.SingleEmailMessage();
            sem.setUseSignature(false);
            sem.setToAddresses(toAddresses);
            if (sandboxName != '') {
                // A sandbox
                emBody += '\n\n' + 'This email has been generated from sandbox: ' + sandboxName;
                sem.setSubject('[' + sandboxName + '] ' + emSubject);
            } else {
                // Production (maybe)
                sem.setSubject(emSubject);
            }
            sem.setPlainTextBody(emBody);

            // Send email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { sem });
            result = emBody;
            System.debug('Sent: ' + result);
        }
        return result;
    }
}