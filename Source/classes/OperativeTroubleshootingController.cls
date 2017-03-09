public with sharing class OperativeTroubleshootingController {
    // BIER system hyperlink
    public static string BIER_URL_BASE = 'https://biersys.dk';
    // BIER system hyperlink for detail page
    public static string BIER_URL_FN = BIER_URL_BASE + '/fejl_melder/show.cgi?id=';
    // BIER system hyperlink for active activities
    public static string BIER_URL_AA = BIER_URL_BASE + '/casp_readonly/c_light.cgi?id=';
    // BIER system hyperlink for active errors
    public static string BIER_URL_AE = BIER_URL_BASE + '/fejl_melder/show.cgi?id=';
    // # of Active Activities
    public Integer ActiveActivitiesCount {get; private set;}
    // url for BIER for Active Activity detail
    public String ActiveActivitiesUrl {get; private set;}
    // # of Active Errors
    public Integer ActiveErrorsCount {get; private set;}
    // url for BIER for Active Error detail
    public String ActiveErrorsUrl {get; private set;}
    // current customer juridical address code. it's just juridical, maybe it should work for all zip codes
    //private string ZipCode;
    // list of all customer's installations zip codes
    private List<String> zipCodeList;

    // All Operative Troubleshooting records for given Account from DB
    private List<Operative_Troubleshooting__c> lst;
    // Current Operative Troubleshooting records for given Account from DB
    private List<Operative_Troubleshooting__c> lstCur;
    // Coming Operative Troubleshooting records for given Account from DB
    private List<Operative_Troubleshooting__c> lstCom;

    // constructor
    public OperativeTroubleshootingController(ApexPages.StandardController controller) {
        if (controller != null && controller.getRecord() instanceOf Account) {
            Account account = (Account) controller.getRecord();
            this.lst = this.lstCur = this.lstCom = null;
            if (account != null) {
                //account = [SELECT Id, Customer_No__c, Post_Code__c FROM Account WHERE Id = : account.Id];//this.ZipCode = account.Post_Code__c;
                /*
                List<Installation__c> installations = [Select Address__r.Postcode__c FROM Installation__c WHERE Customer__c = : account.Id];*/
                /* Commented for SF-1478 Installation Merge
                List<Installation__c> installations = [SELECT Address__r.Postcode__c FROM Installation__c WHERE Address__c  =: account.Street_YK__c];*/
                
				List<Net_Installations__c> installations = [Select Id, Address__r.Postcode__c,Address__c From Net_Installations__c where Address__c =: account.Street_YK__c];
                Map<String,String> distinctZipCodes = new Map<String,String>();
                for (Net_Installations__c i : installations) {
                    distinctZipCodes.put(i.Address__r.Postcode__c, i.Address__r.Postcode__c);
                }
                this.zipCodeList = new List<String>(distinctZipCodes.keySet());
    
                List<ActiveActivities__c> lstAA = [
                    SELECT Id, Name, ActiveActivityID__c, Transferred_to_Bier__c
                    FROM ActiveActivities__c WHERE Customer__c = :account.Id
                ];
                this.ActiveActivitiesCount = lstAA == null ? 0 : lstAA.size();
                this.ActiveActivitiesUrl =
                    (lstAA != null && lstAA.size() == 1) ?
                    (lstAA[0].Transferred_to_Bier__c == False ? '#' : BIER_URL_AA + lstAA[0].ActiveActivityID__c)
                    : '/apex/ActiveActivitiesPage?CustomerId=' + account.Id
                ;
                
                List<ActiveErrors__c> lstAE = [
                    SELECT Id, Name, ActiveErrorId__c FROM ActiveErrors__c WHERE Customer__c =: account.Id
                ];
                this.ActiveErrorsCount = lstAE == null ? 0 : lstAE.size();
                this.ActiveErrorsUrl = (lstAE != null && lstAE.size() == 1) ?
                    BIER_URL_AE + lstAE[0].ActiveErrorId__c
                    : '/apex/ActiveErrorsPage?CustomerId=' + account.Id
                ;
            }
        }
    }

    // Initialize setCon and return a list of records
    public List<Operative_Troubleshooting__c> getOperatives() {
        if (this.lst == null) {
            //select Operative Troubleshooting Ids according post nrs.
            List<OperativeTroubleshootingPostcodes__c> lstOtpc = [
                SELECT Operative_Troubleshooting__c
                FROM OperativeTroubleshootingPostcodes__c WHERE PostCode__c IN :this.zipCodeList
            ];
            List<Id> lstOtIds = new List<Id>();
            for (OperativeTroubleshootingPostcodes__c otpc : lstOtpc) {
                lstOtIds.add(otpc.Operative_Troubleshooting__c);
            }

            //select region names
            List<Bier_Reg2Post__c> lstReg2Post = [
                SELECT Region__c FROM Bier_Reg2Post__c WHERE Postcode__c IN :this.zipCodeList
            ];
            List<String> regionIds = new List<String>();
            for (Bier_Reg2Post__c reg2Post : lstReg2Post) {
                regionIds.add(reg2Post.Region__c);
            }
            List<Bier_Region__c> lstBierRegion = [
                SELECT Name FROM Bier_Region__c WHERE Bier_ID__c IN :regionIds
            ];
            List<String> regionNames = new List<String>();
            for (Bier_Region__c region : lstBierRegion) {
                regionNames.add(region.Name);
            }

            //postnr and region records together order by Updated date desc
            this.lst = [
                SELECT Id, Name, Updated_date__c, Status__c, Status_Short__c, Area__c, BIER_number__c,
                    Category__c, HF_number__c, DriftInfo_Id__c, Network_number__c, Type__c, Start_date__c
                FROM Operative_Troubleshooting__c
                WHERE Status__c !='Lukket' AND Status__c !='Afvist' AND (Id IN :lstOtIds OR Area__c IN :regionNames)
                ORDER BY Updated_date__c DESC
            ];
            if (this.lst != null) {
                this.lstCur = new List<Operative_Troubleshooting__c>();
                this.lstCom = new List<Operative_Troubleshooting__c>();
                Datetime dt = Datetime.now();
                for (Operative_Troubleshooting__c ot : this.lst) {
                    if (ot.Start_date__c <= dt) {
                        this.lstCur.add(ot); // Start Date <= NOW
                    } else {
                        this.lstCom.add(ot); // Start Date > NOW
                    }
                }
            }
        }
        return this.lst;
    }

    // Return a list of curent records (Start Date <= NOW)
    public List<Operative_Troubleshooting__c> getCurrent() {
        return (NumberOfRecords > 0) ? this.lstCur : new List<Operative_Troubleshooting__c>();
    }

    // Return a list of coming records (Start Date > NOW)
    public List<Operative_Troubleshooting__c> getComing() {
        return (NumberOfRecords > 0) ? this.lstCom : new List<Operative_Troubleshooting__c>();
    }

    public Integer NumberOfRecords {
        get {
            return (this.getOperatives() == null) ? 0 : this.getOperatives().size();
        }
    }

    // returns BIER system url for detail page
    public string getOperativesUrl() {
        return BIER_URL_FN;
    }
}