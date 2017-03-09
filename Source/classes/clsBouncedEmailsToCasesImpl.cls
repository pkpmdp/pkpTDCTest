public with sharing class clsBouncedEmailsToCasesImpl {

    // The only method which is called by clsBouncedEmailsToCasesScheduler
    public void runJob() {
        // Determine the CreatedDate of the most recent 'Bounced FM' or 'YKRB Visitering' Case
        Datetime dtFrom = Datetime.newInstance(0); // January 1, 1970, 00:00:00 GMT
        List<Case> cases = [
            SELECT CreatedDate FROM Case
                WHERE (Department__c = 'YKRB' AND Product_2__c = 'Telephony YKRB'
                        AND Type_Task__c = 'Bounced FM' AND Subject = 'Fuldmagt Returneret')
                      OR (Department__c = 'YKRB' AND Product_2__c = 'Visitering'
                        AND Subject = 'Returneret e-mail - til behandling')
                ORDER BY CreatedDate DESC LIMIT 1
        ];
        if (!cases.isEmpty()) {
            dtFrom = cases[0].CreatedDate;
        }
        System.debug('### The most recent CreatedDate: ' + dtFrom);

        cases = new List<Case>();
        Group fGroup = [SELECT Id FROM Group WHERE Name = 'YKRB Telefoni Bounced FM' AND Type = 'Queue'];
        Group vGroup = [SELECT Id FROM Group WHERE Name = 'YKRB Visitering' AND Type = 'Queue'];

        List<Account> accs = [SELECT Id, Name, PersonEmail, Customer_No__c FROM Account
            WHERE IsPersonAccount = True AND PersonEmailBouncedDate > :dtFrom
        ];

        Map<Id,Id> acc2Case = new Map<Id,Id>(); // Account.Id, Case.Id
        for (Account acc: accs) {
            acc2Case.put(acc.Id, null);
        }
        for (Case c : [
            SELECT AccountId, NP_Status__c FROM Case
            WHERE AccountId IN :acc2Case.keySet() AND NP_Status__c = 'NP fuldmagt sendt til kunden'
        ]) {
            if (acc2Case.get(c.AccountId) == null) {
                // Found an NP Case waiting for the given Customer's authorization
                acc2Case.put(c.AccountId, c.Id);
            }
        }

        Integer cntF = 0;
        Integer cntV = 0;
        for (Account acc : accs) {
            String dscr = 'Kundens e-mail adresse er ikke gyldig\n\nId: ' + acc.Id;
            dscr += '\nNavn: ' + acc.Name;
            dscr += '\nE-mail: ' + acc.PersonEmail;
            dscr += '\nKunde nr.: ' + acc.Customer_No__c;
            Case c = new Case();
            c.Origin = 'Email - kundeservice@yousee.dk';
            c.Description = dscr;
            c.AccountId = acc.Id;
            if (acc2Case.get(acc.Id) != null) {
                // 'Bounced FM' Case
                cntF++;
                c.Subject = 'Fuldmagt Returneret';
                c.Department__c = 'YKRB';
                c.Product_2__c = 'Telephony YKRB';
                c.Type_Task__c = 'Bounced FM';
                c.OwnerId = fGroup.Id;
            } else {
                // 'YKRB Visitering' Case
                cntV++;
                c.Subject = 'Returneret e-mail - til behandling';
                c.Department__c = 'YKRB';
                c.Product_2__c = 'Visitering';
                c.OwnerId = vGroup.Id;
            }
            cases.add(c);
        }
        if (!cases.isEmpty()) {
            insert cases;
            System.debug('### ' + cntF + ' \'Bounced FM\' Case(s) created.');
            System.debug('### ' + cntV + ' \'YKRB Visitering\' Case(s) created.');
        } else {
            System.debug('### No Cases created.');
        }
    }
}