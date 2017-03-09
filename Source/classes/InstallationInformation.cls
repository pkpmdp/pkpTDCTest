public class InstallationInformation {

    public boolean isRenderBiar{get; set;}// SPOC-2283
    public boolean isRenderCIP{get; set;} // SPOC-2283
    public static final String COMPETITOR_ROLE = 'Service leverandør';

    Account account;

    public class InstData { 
        // Extended Installation - includes info from Cable Unit & Competitor
        ID Id;                   // Installation.Id
        ID Address;              // Installation.Address__c
        String AddressName;      // Installation.Address__c.Name
        String AddressExternalId;// Installation.Address__c.External_Id__c
        String CableUnit_no;     // Installation.Cable_Unit_no__c
        //String CableUnitNoLink;  // Installation.Cable_Unit_No_Link__c
        String Competitor;       // Installation.Cable_Unit_no__c -> Competitor.Competitor__c
        String HF_no;            // Installation.HF_no__c
        String Name;             // Installation.Name
        //String Note_field;       // Installation.Note_field__c (SPOC-729 No more populated)
        String Sales_concept;    // Installation.Sales_concept__c
        String Service;          // Installation.Cable_Unit_no__c -> CableUnit.Service__c
        Id cuId;
		String linkURL;          // SPOC-2283   
		String linkTEXT;         // SPOC-2283 
        InstData(
            ID Id, ID Address, String AddressName, String AddressExternalId, String CableUnit_no,
            String Competitor, String HF_no, String Name,
            String Sales_concept, String Service, Id cuId, String linkURL,String linkTEXT // SPOC-2283
        ) {
             this.Id = Id;
             this.Address = Address;
             this.AddressName = AddressName;
             this.AddressExternalId = AddressExternalId;
             this.CableUnit_no = CableUnit_no;
             //this.CableUnitNoLink = CableUnitNoLink;
             this.Competitor = Competitor;
             this.HF_no = HF_no;
             this.Name = Name;
             //this.Note_field = Note_field;
             this.Sales_concept = Sales_concept;
             this.Service = Service;
             this.cuId = cuId;
             this.linkURL = linkURL; // SPOC-2283
             this.linkTEXT = linkTEXT; // SPOC-2283
             system.debug('****'+this.Competitor);
        }
        public ID getId() { return Id; }
        public ID getAddress() { return Address; }
        public String getAddressName() { return AddressName; }
        public String getAddressExternalId() { return AddressExternalId; }
        public String getCableUnit_no() { return CableUnit_no; }
        //public String getCableUnitNoLink() { return CableUnitNoLink; }
        public String getCompetitor() { return Competitor; }
        public String getHF_no() { return HF_no; }
        public String getName() { return Name; }
        //public String getNote_field() { return Note_field; }
        public String getSales_concept() { return Sales_concept; }
        public String getService() { return Service; }
        public Id getCuId(){ return cuId; }
        public String getLinkURL(){return linkURL; } // SPOC-2283
        public String getLinkTEXT(){return linkTEXT; } // SPOC-2283
    }
    private List<InstData> instRows;

    public InstallationInformation(ApexPages.StandardController controller) {
        account = (Account) controller.getRecord();
        Account acc = [select id,Customer_No__c from Account where id =: account.id];
       List<Net_Installations__c> installations = [Select Id,Cable_Unit__r.Cable_Type__c, Address__c, Address__r.External_Id__c, Cable_Unit__r.HF_no__c, Name, Cable_Unit_No__c,Cable_Unit__c,Cable_Unit__r.CA_Sales_Concept__c, Cable_Unit__r.Service__c FROM Net_Installations__c WHERE Address__c = :account.Street_YK__c];
      /* List<Account> acc=[Select Id,Cable_Type__c from account where account=:account.Id];
       system.debug('******'+acc);*/
        
        //List<Installation__c> installations = [SELECT Id, Address__c, Address__r.External_Id__c, Cable_Unit_no__c, Cable_Unit_No_Link__c, HF_no__c, Name, Note_field__c, Sales_concept__c FROM Installation__c WHERE Address__c = :account.Street_YK__c ];
        // Collect CableUnit.Service values by CableUnitNo value
        // Collect Competitor.Competitor values by CableUnit.Id and CompetitorRole='Service leverandør' values
        
        //Map<String,String> CU_NoToService = new Map<String,String>(); // <CableUnit.CableUnitNo,CableUnit.Service>
        Map<String,String> CU_NoToCompetitor = new Map<String,String>(); // <CableUnit.CableUnitNo,Competitor.Competitor>
        Map<ID,String> CU_IdToNo = new Map<ID,String>(); // <CableUnit.Id,CableUnit.CableUnitNo>
        //Map<ID,String> CU_SalesConcept = new Map<ID,String>();
        Set<String> CU_Nos = new Set<String>();
        for (Net_Installations__c inst : installations) {
            CU_Nos.add(inst.Cable_Unit_No__c);
        }
        for (Cable_Unit__c cu : [SELECT Id, Cable_Unit_No__c, Service__c,CA_Sales_Concept__c FROM Cable_Unit__c WHERE Cable_Unit_No__c IN :CU_Nos]) {
            CU_IdToNo.put(cu.Id, cu.Cable_Unit_No__c);
            //CU_NoToService.put(cu.Cable_Unit_No__c, cu.Service__c ? System.Label.Yes : System.Label.No);
            //CU_SalesConcept.put(cu.Id,cu.CA_Sales_Concept__c);
            //System.debug('#####CU_SalesConcept'+CU_SalesConcept);
        }
        System.debug('******'+CU_IdToNo.keySet());
        for (Competitor__c comp : [SELECT Cable_Unit__c, Competitor__c FROM Competitor__c WHERE Cable_Unit__c IN :CU_IdToNo.keySet() AND Competitor_role__c = :COMPETITOR_ROLE] ) {
            CU_NoToCompetitor.put(CU_IdToNo.get(comp.Cable_Unit__c), comp.Competitor__c);
        }

        // There is the same address for all instances
        Address__c[] addr = [SELECT Name FROM Address__c WHERE Id = :account.Street_YK__c LIMIT 1];
        String addrName = (addr.size() == 1) ? addr[0].Name : null;

        instRows = new List<InstData>();
        
        /*for (Net_Installations__c inst : installations) { inst.Cable_Unit_No_Link__c, CU_NoToCompetitor.get(inst.Cable_Unit_no__c), inst.HF_no__c, inst.Name, inst.Sales_concept__c, CU_NoToService.get(inst.Cable_Unit_no__c));
            instRows.add(instData);
        }*/
        
        
        for (Net_Installations__c inst : installations) {
        	system.debug('inst **** '+inst); 
            // SPOC-2283
            String trfrType = 'TREFOR';
            System.debug('inst.Cable_Unit__r.Cable_Type__c.toUpperCase() '+inst.Cable_Unit__r.Cable_Type__c.toUpperCase());
            /*if(inst.Cable_Unit__r.Cable_Type__c.toUpperCase().deleteWhitespace() == trfrType.toUpperCase().deleteWhitespace())
            {
                System.debug('In IF *************** ');
                isRenderBiar = false;
                isRenderCIP = true;
            }
            else
            {
                System.debug('Else ********* ');
                isRenderBiar = true;
                isRenderCIP = false;
            }  */  
            //'/apex/UrlEncoding?id='+inst.Id+'&cus='+acc.Customer_No__c;
            //'http://wsftst01.tdk.dk:8080/_layouts/TPCIP.Web/default.aspx?portalId=CIP&loadLid='+acc.Customer_No__c;
            //System.Label.BIER_Link +'?id='+inst.Id+'&cus='+acc.Customer_No__c;
            //System.Label.CIP_URL+'&loadLid='+acc.Customer_No__c;
            String createBIREURL = System.Label.BIER_Link +'?id='+inst.Id+'&cus='+acc.Customer_No__c;
            String creatCIPURL = System.Label.CIP_URL+'&loadLid='+acc.Customer_No__c;
            InstData instData = new InstData (
                inst.Id, inst.Address__c, addrName, inst.Address__r.External_Id__c, inst.Cable_Unit_no__c,
                CU_NoToCompetitor.get(inst.Cable_Unit_no__c), inst.Cable_Unit__r.HF_no__c,
                inst.Name, inst.Cable_Unit__r.CA_Sales_Concept__c, (inst.Cable_Unit__r.Service__c ? System.Label.Yes : System.Label.No), inst.Cable_Unit__c,
                (inst.Cable_Unit__r.Cable_Type__c.toUpperCase().deleteWhitespace()== trfrType) ? creatCIPURL :createBIREURL
                ,(inst.Cable_Unit__r.Cable_Type__c.toUpperCase().deleteWhitespace()== trfrType) ? 'CIP' : 'BIER'
            );
            instRows.add(instData);
        }
    }

    public List <InstData> getInstRows() {
        return instRows;
    }

    static testMethod void testAll() {
        Address__c addr = new Address__c();
        addr.Town__c = 'AH';
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        addr.Side__c = 'A';
        addr.Floor__c ='Third';
        addr.House_No__c = 'test';
        addr.Street__c = 'ATEST';
        addr.Entrance__c = 'A';
        addr.Name = addr.Street__c;
        addr.External_Id__c = 'AMS123456';
        insert addr;

        Account acc = new Account();
        acc.Name ='test78';
        acc.Street_YK__c = addr.Id;
        acc.Customer_No__c = '123356';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
        insert acc;

        
        Cable_Unit__c cableUnitTest1 = new Cable_Unit__c();
        cableUnitTest1.Name = 'cu_kundeCust_testing'; 
        cableUnitTest1.HF_no__c = '1234';
        cableUnitTest1.Key_Box__c = '1';
        cableUnitTest1.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cableUnitTest1.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cableUnitTest1.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cableUnitTest1.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership();
        cableUnitTest1.Housing_Type__c = clsTestDataForYS.createLookupHousingType();
        cableUnitTest1.Building_Type__c = clsTestDataForYS.createLookupBuildingType();
        insert cableUnitTest1;

        Cable_Unit__c cu1 = new Cable_Unit__c();
        cu1.Cable_Unit_No__c = '001';
        cu1.Service__c = true;
        cu1.Name = 'cu_kundeCust_testing'; 
        cu1.Municipaly__c = '223 Hørsholm'; 
        cu1.Cable_Unit_Post_Code__c = '7400';
        cu1.HF_no__c = '1234';
        cu1.Key_Box__c = '1';
        cu1.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cu1.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cu1.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cu1.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership1();
        cu1.Housing_Type__c = clsTestDataForYS.createLookupHousingType1();
        cu1.Building_Type__c = clsTestDataForYS.createLookupBuildingType1();
        insert cu1;

        Cable_Unit__c cu3 = new Cable_Unit__c();
        cu3.Cable_Unit_No__c = '003';
        cu3.Name = 'cu_kundeCust_testing'; 
        cu3.Municipaly__c = '223 Hørsholm'; 
        cu3.HF_no__c = '1234';
        cu3.Key_Box__c = '1';
        cu3.Potential_Installations__c = clsTestDataForYS.getPotentialInstallation(); 
        cu3.Municipaly__c = clsTestDataForYS.getMunicipaly();
        cu3.Cable_Unit_Post_Code__c = clsTestDataForYS.getCableUnitPostCode();
        cu3.Housing_Ownership__c = clsTestDataForYS.createLookupHousingOwnership2();
        cu3.Housing_Type__c = clsTestDataForYS.createLookupHousingType2();
        cu3.Building_Type__c = clsTestDataForYS.createLookupBuildingType2();
        insert cu3;
        
        Competitor__c comp1 = new Competitor__c();
        comp1.Competitor_role__c = COMPETITOR_ROLE;
        comp1.Cable_Unit__c = cableUnitTest1.Id;
        comp1.Customer__c = acc.id;
        insert comp1;
        
        Net_Installations__c inst1 = new Net_Installations__c(Address__c = addr.Id, Cable_Unit__c = cableUnitTest1.Id,Package_selection__c = 'GP');
        insert inst1;

        /*Installation__c inst1 = new Installation__c (
            Address__c = addr.Id,
            Cable_Unit_no__c = cu1.Cable_Unit_No__c,
            Customer__c = acc.id,
            HF_no__c = '1234',
            Note_field__c = 'Note field',
            Sales_concept__c = 'Sales concept'
        );
        Installation__c inst2 = new Installation__c (
            Address__c = addr.Id,
            Customer__c = acc.id,
            HF_no__c = '1234'
        );
        Installation__c inst3 = new Installation__c (
            Address__c = addr.Id,
            Customer__c = acc.id,
            HF_no__c = '22552255',
            Cable_Unit_no__c = cu3.Cable_Unit_No__c
        );
        insert new Installation__c[] {inst1, inst2, inst3};*/

/*
        Customer_Installation_Address__c CIA = new Customer_Installation_Address__c();
        CIA.Address__c = addr.Id;
        CIA.Customer__c = acc.Id;
        CIA.Installation_Address_External_ID__c = '10';
        insert CIA;
*/

        InstallationInformation ctrl = new InstallationInformation(new ApexPages.standardController(acc));
        List<InstData> rows = ctrl.getInstRows();
        Boolean isOK = false;
        System.assert(1 <= rows.size());
        Net_Installations__c dbInst = [Select Id, Address__c, Address__r.External_Id__c, Cable_Unit__r.HF_no__c, Name, Cable_Unit_No__c,Cable_Unit__c,Cable_Unit__r.CA_Sales_Concept__c, Cable_Unit__r.Service__c FROM Net_Installations__c WHERE Id =: inst1.Id];
        
        //Net_Installations__c dbInst = [ SELECT Id, Address__c, Cable_Unit_no__c, Cable_Unit_No_Link__c, HF_no__c, Name, Sales_concept__c FROM Installation__c WHERE Id = :inst1.Id ];
        
        for (InstData row : rows) {
            if (row.getId() == dbInst.id) {
                isOK = true;
                System.assertEquals(row.getAddress(), addr.Id);
                System.assertEquals(row.getAddressName(), addr.Name);
                System.assertEquals(row.getAddressExternalId(), addr.External_Id__c);
                System.assertEquals(row.getCableUnit_no(), dbInst.Cable_Unit_no__c);
                //System.assertEquals(row.getCableUnitNoLink(), dbInst.Cable_Unit_No_Link__c);
                System.assertEquals(row.getCompetitor(), comp1.Competitor__c);
                System.assertEquals(row.getHF_no(), dbInst.Cable_Unit__r.HF_no__c);
                System.assertEquals(row.getName(), dbInst.Name);
                //System.assertEquals(row.getNote_field(), dbInst.Note_field__c);
                System.assertEquals(row.getSales_concept(), dbInst.Cable_Unit__r.CA_Sales_Concept__c);
                System.assertEquals(row.getService(), dbInst.Cable_Unit__r.Service__c ? System.Label.Yes : System.Label.No);
            }
        }
        System.assert(isOK);
     }
}