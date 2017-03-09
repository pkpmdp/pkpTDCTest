public class clsSmiloMeterController {
    
    //Result from today
    public double SmiloMeterRatingAverageToday {get;set;}
    public Integer SmiloMeterRatingNumberToday {get;set;}

    //Result from yesterday
    public double SmiloMeterRatingAverageYesterday {get;set;}
    public Integer SmiloMeterRatingNumberYesterday {get;set;}

    public Smilometer__c smiloMeter{get;set;}
    public String mode {get;set;}
    public String validationMsg {get;set;}
	public clsSmiloMeterController()
    {
        try {
            smiloMeter = [
                SELECT Id, Name, Comment__c, Mood__c, SmilOmeter_conversion_to_number__c, CreatedDate, CreatedById
                FROM Smilometer__c WHERE CreatedDate = TODAY and CreatedById = :UserInfo.getUserId() LIMIT 1
            ];
            mode = 'View';
            validationMsg = '';
        } catch(Exception e) {
            mode = 'Create';
            smiloMeter = new Smilometer__c();
    }
    }
    public clsSmiloMeterController(ApexPages.StandardController controller) {
        
        }
        /* SPOC-1129
        if (mode == 'View') {
            getRatingYesterday();
            getRatingToday();
        }
        */
    

    public void saveSmiloMeter() {
        // Validate first
        if (smiloMeter.Mood__c == null || smiloMeter.Mood__c == '') {
            // Mood is required
            validationMsg = Label.Mood_required;
        } else if ((smiloMeter.Mood__c.indexOf('1 ') == 0 || smiloMeter.Mood__c == '2') && (smiloMeter.Comment__c == null || smiloMeter.Comment__c == '')) {
            // Comment is required
            validationMsg = Label.Comment_required;
        } else {
            validationMsg = '';
            // Load SmiloMeter results from yesterday
            List<Smilometer__c> items = [
                SELECT Id, Name, Comment__c, Mood__c, SmilOmeter_conversion_to_number__c, CreatedDate, CreatedById
                FROM Smilometer__c WHERE CreatedDate = TODAY and CreatedById = :UserInfo.getUserId()
            ];
            if (items != null && items.size() > 0) {
                smiloMeter = items[0];
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Det er ikke tilladt at tilføje mere end én post om dagen.'));
            } else {
                insert smiloMeter;
            }
            mode = 'View';
            /* SPOC-1129
            getRatingYesterday();
            getRatingToday();
            */
        }
    }

    public String getSmileyToday() {
        if (SmiloMeterRatingAverageToday > 4) {
            return '/Smilometer_Smileys/30x30_Smiley_01.png';
        } else if (SmiloMeterRatingAverageToday > 3) {
            return '/Smilometer_Smileys/30x30_Smiley_02.png';
        } else if(SmiloMeterRatingAverageToday > 2) {
            return '/Smilometer_Smileys/30x30_Smiley_03.png';
        } else if(SmiloMeterRatingAverageToday > 1) {
            return '/Smilometer_Smileys/30x30_Smiley_04.png';
        } else {
            return '/Smilometer_Smileys/30x30_Smiley_05.png';
        }
    }

    public String getSmileyYesterday() {
        if (SmiloMeterRatingAverageYesterday > 4) {
            return '/Smilometer_Smileys/30x30_Smiley_01.png';
        } else if((SmiloMeterRatingAverageYesterday > 3)) {
            return '/Smilometer_Smileys/30x30_Smiley_02.png';
        } else if((SmiloMeterRatingAverageYesterday > 2)) {
            return '/Smilometer_Smileys/30x30_Smiley_03.png';
        } else if((SmiloMeterRatingAverageYesterday > 1)) {
            return '/Smilometer_Smileys/30x30_Smiley_04.png';
        } else if(SmiloMeterRatingAverageYesterday > 0) {
            return '/Smilometer_Smileys/30x30_Smiley_05.png';
        } else {
            //If yesterdays result is not available we display a happy smiley
            return '/Smilometer_Smileys/30x30_Smiley_01.png';
        }
    }  

    private void getRatingToday() {
        AggregateResult[] ratingtoday;
        try {
            ratingtoday = [
                SELECT Count(Id) SUM, AVG(SmilOmeter_conversion_to_number__c) AVG
                FROM Smilometer__c WHERE CreatedDate = today
            ];
            SmiloMeterRatingAverageToday = Double.valueOf(ratingtoday[0].get('AVG'));
            SmiloMeterRatingNumberToday = Integer.valueOf(ratingtoday[0].get('SUM'));
        } catch(Exception e) {
            SmiloMeterRatingAverageToday = 0.0;
            SmiloMeterRatingNumberToday = 0;
        }
    }

    private void getRatingYesterday() {
        SmilOmeter_analytic_snaphot__c ratingYesterday;
        try {
            /* If today is Monday, then we display the result from Friday last week. Currently, this is not used
            if (date.today().toStartOfWeek().isSameDay(date.today())) {
                ratingYesterday = [
                    SELECT Yesterday_SmilOmeter_result__c FROM SmilOmeter_analytic_snaphot__c
                    WHERE CreatedDate = LAST_N_DAYS:3 ORDER BY CreatedDate DESC LIMIT 1
                ];
            } else {
                ratingYesterday = [
                    SELECT Yesterday_SmilOmeter_result__c FROM SmilOmeter_analytic_snaphot__c
                    WHERE CreatedDate = yesterday LIMIT 1
                ];
            }*/

            ratingYesterday = [
                SELECT Yesterday_SmilOmeter_result__c, Number_of_answers__c
                FROM SmilOmeter_analytic_snaphot__c WHERE CreatedDate = yesterday LIMIT 1
            ];
            SmiloMeterRatingAverageYesterday =
                ratingYesterday.Yesterday_SmilOmeter_result__c != null ? ratingYesterday.Yesterday_SmilOmeter_result__c: 0.0
            ;
            SmiloMeterRatingNumberYesterday =
                Integer.valueOf(ratingYesterday.Number_of_answers__c) != null? Integer.valueOf(ratingYesterday.Number_of_answers__c): 0
            ;
        } catch(Exception e) {
            SmiloMeterRatingAverageYesterday = 0.0;
            SmiloMeterRatingNumberYesterday = 0;
        }
    }

    static testMethod void testCreateYSAccount() {
        Smilometer__c test = new Smilometer__c(Mood__c='4', Comment__c='Test');

        ApexPages.StandardController sc = new ApexPages.StandardController(test);
        clsSmiloMeterController controller = new clsSmiloMeterController(sc);

        controller.smiloMeter = test;
        controller.smiloMeter.mood__c = '4';
        controller.saveSmiloMeter();
        System.assertNotEquals(controller.getSmileyToday(), null);
        System.assertNotEquals(controller.getSmileyYesterday(), null);

       /* clsSmiloMeterController controller1 = new clsSmiloMeterController(sc);
        controller.smiloMeter = test;
        controller1.saveSmiloMeter();

        for(Integer i=1; i<=5; i++) {
            controller1.SmiloMeterRatingAverageToday = i;
            controller1.SmiloMeterRatingAverageYesterday = i;
            controller1.getSmileyToday();
            controller1.getSmileyYesterday();
        }*/
        controller.getRatingYesterday();
        controller.getRatingToday(); 
        
    }

    static testMethod void testValidation() {
        Smilometer__c test = new Smilometer__c(Mood__c=null, Comment__c='A comment');

        ApexPages.StandardController sc = new ApexPages.StandardController(test);
        clsSmiloMeterController ctrl = new clsSmiloMeterController(sc);

        ctrl.smiloMeter = test;
        ctrl.saveSmiloMeter();
        System.assertEquals(ctrl.validationMsg, Label.Mood_required);

        test = new Smilometer__c(Mood__c='2', Comment__c=null);
        ctrl.smiloMeter = test;
        ctrl.saveSmiloMeter();
        System.assertEquals(ctrl.validationMsg, Label.Comment_required);
        
    }
}