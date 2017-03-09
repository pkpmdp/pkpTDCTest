/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@IsTest(SeeAllData=true)
public class clsTestDataForYS {

    //public YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');    
    //String contactRecordType = ysRecords.YS_Contact_Record_Type__c;
    //String hierarchyCustomerRecordType = ysRecords.YS_Hierarchy_Account__c;
    //String cableUnitCustomerRecordType = ysRecords.YS_Customer_Account__c;
    //String personAccountRecordType = ysRecords.YK_Customer_Account__c;
    //public static clsTestDataForYS instance = null;
    public static Lookup_Building_Type__c buildingType;
    public static Lookup_Housing_Type__c housingType;
    public static Lookup_Housing_Ownership__c housingOwnerShip; 
    public static Lookup_Customer_Segment__c customerSegmentObj;
    public static Lookup_Customer_Segment__c customerSegmentObjKunde;
    public YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes'); 
    String cableUnitCustomerRecordType = ysRecords.YS_Customer_Account__c;
    /*public static clsTestDataForYS getTestFactoryInstance(){
        if (instance == null){
            instance = new clsTestDataForYS();            
            return instance;                    
        }
        else
            return instance;                            
    }*/
    
    public static ID createLookupBuildingType(){      
        buildingType = new Lookup_Building_Type__c();               
        buildingType.name ='Private bunglow';
        buildingType.Code__c='12121';
        buildingType.End_Date__c = date.today().addMonths(1);
        buildingType.Start_Date__c= date.today();
        buildingType.SourceId__c='Private bunglow34'; 
        insert buildingType;
        return buildingType.Id;
    }
    
    public static ID createLookupBuildingType1(){      
        buildingType = new Lookup_Building_Type__c();               
        buildingType.name ='Private bunglow2';
        buildingType.Code__c='12129';
        buildingType.End_Date__c = date.today().addMonths(1);
        buildingType.Start_Date__c= date.today();
        buildingType.SourceId__c='Private bunglow35'; 
        insert buildingType;
        return buildingType.Id;
    }
    
    public static ID createLookupBuildingType2(){      
        buildingType = new Lookup_Building_Type__c();               
        buildingType.name ='Private bunglow7';
        buildingType.Code__c='12127';
        buildingType.End_Date__c = date.today().addMonths(1);
        buildingType.Start_Date__c= date.today();
        buildingType.SourceId__c='Private bunglow36'; 
        insert buildingType;
        return buildingType.Id;
    }
    
    public static ID createLookupBuildingType3(){      
        buildingType = new Lookup_Building_Type__c();               
        buildingType.name ='Private bunglow766';
        buildingType.Code__c='12741';
        buildingType.End_Date__c = date.today().addMonths(1);
        buildingType.Start_Date__c= date.today();
        buildingType.SourceId__c='Private bunglow37'; 
        insert buildingType;
        return buildingType.Id;
    }
    
    public static ID createLookupHousingType(){        
        housingType = new Lookup_Housing_Type__c(); 
        housingType.name = 'Private andelstype';
        housingType.Code__c = '12123';
        housingType.End_Date__c = date.today().addMonths(1);
        housingType.Start_Date__c = date.today();
        housingType.SourceId__c = 'Private bunglow38';
        insert housingType;
        return housingType.Id;
    }
    
    public static ID createLookupHousingType1(){        
        housingType = new Lookup_Housing_Type__c(); 
        housingType.name = 'Private andelstype11';
        housingType.Code__c = '12127';
        housingType.End_Date__c = date.today().addMonths(1);
        housingType.Start_Date__c = date.today();
        housingType.SourceId__c = 'Private bunglow39';
        insert housingType;
        return housingType.Id;
    }
    
    public static ID createLookupHousingType2(){        
        housingType = new Lookup_Housing_Type__c(); 
        housingType.name = 'Private andelstype1188';
        housingType.Code__c = '12128';
        housingType.End_Date__c = date.today().addMonths(1);
        housingType.Start_Date__c = date.today();
        housingType.SourceId__c = 'Private bunglow40';
        insert housingType;
        return housingType.Id;
    }
    
    public static ID createLookupHousingType3(){        
        housingType = new Lookup_Housing_Type__c(); 
        housingType.name = 'Private andelstype11741';
        housingType.Code__c = '12758';
        housingType.End_Date__c = date.today().addMonths(1);
        housingType.Start_Date__c = date.today();
        housingType.SourceId__c = 'Private bunglow41';
        insert housingType;
        return housingType.Id;
    }
    
    public static ID createLookupHousingOwnership(){
        housingOwnerShip = new Lookup_Housing_Ownership__c();
        housingOwnerShip.name = 'Andel';
        housingOwnerShip.Code__c = '12128';
        housingOwnerShip.End_Date__c = date.today().addMonths(1);
        housingOwnerShip.Start_Date__c = date.today();
        housingOwnerShip.SourceId__c = 'Private bunglow42';
        insert housingOwnerShip;
        return housingOwnerShip.Id;    
    }
    
    public static ID createLookupHousingOwnership1(){
        housingOwnerShip = new Lookup_Housing_Ownership__c();
        housingOwnerShip.name = 'Andel22222';
        housingOwnerShip.Code__c = '1212675';
        housingOwnerShip.End_Date__c = date.today().addMonths(1);
        housingOwnerShip.Start_Date__c = date.today();
        housingOwnerShip.SourceId__c = 'Private bunglow43';
        insert housingOwnerShip;
        return housingOwnerShip.Id;    
    }
    
     public static ID createLookupHousingOwnership2(){
        housingOwnerShip = new Lookup_Housing_Ownership__c();
        housingOwnerShip.name = 'Andel2222211111';
        housingOwnerShip.Code__c = '12143';
        housingOwnerShip.End_Date__c = date.today().addMonths(1);
        housingOwnerShip.Start_Date__c = date.today();
        housingOwnerShip.SourceId__c = 'Private bunglow44';
        insert housingOwnerShip;
        return housingOwnerShip.Id;    
     }
    
    public static ID createLookupHousingOwnership3(){
        housingOwnerShip = new Lookup_Housing_Ownership__c();
        housingOwnerShip.name = 'Andel2222211115551';
        housingOwnerShip.Code__c = '12785';
        housingOwnerShip.End_Date__c = date.today().addMonths(1);
        housingOwnerShip.Start_Date__c = date.today();
        housingOwnerShip.SourceId__c = 'Private bunglow45';
        insert housingOwnerShip;
        return housingOwnerShip.Id;    
    }
    
    public static ID createLookupCustomerSegment(){
        customerSegmentObj = new Lookup_Customer_Segment__c(); 
        customerSegmentObj.Start_Date__c=date.today();
        customerSegmentObj.End_Date__c=date.today().addMonths(1);
        customerSegmentObj.Name='pisse guard';
        customerSegmentObj.code__c='1212';         
        customerSegmentObj.SourceId__c='DCRM 1211';
        insert customerSegmentObj;
        return customerSegmentObj.id;          
    }
    
    public static ID createLookupCustomerSegment2(){
        customerSegmentObj = new Lookup_Customer_Segment__c(); 
        customerSegmentObj.Start_Date__c=date.today();
        customerSegmentObj.End_Date__c=date.today().addMonths(1);
        customerSegmentObj.Name='pisse guard';
        customerSegmentObj.code__c='12163';         
        customerSegmentObj.SourceId__c='DCRM 1212';
        insert customerSegmentObj;
        return customerSegmentObj.id;          
    }
    
    public static ID createLookupCustomerSegment3(){
        customerSegmentObj = new Lookup_Customer_Segment__c(); 
        customerSegmentObj.Start_Date__c=date.today();
        customerSegmentObj.End_Date__c=date.today().addMonths(1);
        customerSegmentObj.Name='pisse guard';
        customerSegmentObj.code__c='121234';         
        customerSegmentObj.SourceId__c='DCRM 1213';
        insert customerSegmentObj;
        return customerSegmentObj.id;          
    }
    
     public static ID createLookupCustomerSegment4(){
        customerSegmentObj = new Lookup_Customer_Segment__c(); 
        customerSegmentObj.Start_Date__c=date.today();
        customerSegmentObj.End_Date__c=date.today().addMonths(1);
        customerSegmentObj.Name='pisse guard';
        customerSegmentObj.code__c='121572';         
        customerSegmentObj.SourceId__c='DCRM 1214';
        insert customerSegmentObj;
        return customerSegmentObj.id;          
    }
    
    public static ID createLookupCustomerSegmentKunde(){
        customerSegmentObjKunde = new Lookup_Customer_Segment__c(); 
        customerSegmentObjKunde.Start_Date__c=date.today();
        customerSegmentObjKunde.End_Date__c=date.today().addMonths(1);
        customerSegmentObjKunde.Name='pisse guard';
        customerSegmentObjKunde.code__c='1214';        
        customerSegmentObjKunde.SourceId__c='DCRM 1215';
        insert customerSegmentObjKunde;
        return customerSegmentObjKunde.id;          
    }
    
    public static ID createLookupCustomerSegmentKunde1(){
        customerSegmentObjKunde = new Lookup_Customer_Segment__c(); 
        customerSegmentObjKunde.Start_Date__c=date.today();
        customerSegmentObjKunde.End_Date__c=date.today().addMonths(1);
        customerSegmentObjKunde.Name='pisse guard';
        customerSegmentObjKunde.code__c='1218';        
        customerSegmentObjKunde.SourceId__c='DCRM 1218';
        insert customerSegmentObjKunde;
        return customerSegmentObjKunde.id;          
    }
    
    public static ID createLookupCustomerSegmentKunde2(){
        customerSegmentObjKunde = new Lookup_Customer_Segment__c(); 
        customerSegmentObjKunde.Start_Date__c=date.today();
        customerSegmentObjKunde.End_Date__c=date.today().addMonths(1);
        customerSegmentObjKunde.Name='pisse guard';
        customerSegmentObjKunde.code__c='1219';        
        customerSegmentObjKunde.SourceId__c='DCRM 1219';
        insert customerSegmentObjKunde;
        return customerSegmentObjKunde.id;          
    }
    
    
    public static ID createLookupCustomerSegmentKunde3(){
        customerSegmentObjKunde = new Lookup_Customer_Segment__c(); 
        customerSegmentObjKunde.Start_Date__c=date.today();
        customerSegmentObjKunde.End_Date__c=date.today().addMonths(1);
        customerSegmentObjKunde.Name='pisse guard5';
        customerSegmentObjKunde.code__c='1285';        
        customerSegmentObjKunde.SourceId__c='DCRM 1285';
        insert customerSegmentObjKunde;
        return customerSegmentObjKunde.id;          
    }
    
    public static ID createLookupCustomerSegmentKundeDY(){
    	customerSegmentObjKunde = new Lookup_Customer_Segment__c(); 
    	customerSegmentObjKunde.Start_Date__c=date.today();
        customerSegmentObjKunde.End_Date__c=date.today().addMonths(1);
        customerSegmentObjKunde.Name='pisse guard';
        for(Integer i = 0; i<=15; i++){
        	customerSegmentObjKunde.code__c='1219' + i;        
        	customerSegmentObjKunde.SourceId__c='DCRM 1219' + i;
        }
        insert customerSegmentObjKunde;
        return customerSegmentObjKunde.id;   
    }
    
    public static String getMunicipaly(){
        String municipaly = '223 Hørsholm';
        return municipaly; 
    }
    
    public static String getCableUnitPostCode(){
        String postClsCode = '7400';
        return postClsCode; 
    }
    
    public static Double getPotentialInstallation(){
        Double potInst = 10.0;
        return potInst;
    }
    
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
    }
    
    public Account createYSCableUnitCustomer(){ 
    	
    	Cable_Unit__c cable_unit = new Cable_Unit__c();
        cable_unit.Cable_Unit_No__c = String.valueOf(Crypto.getRandomInteger());
        cable_unit.Name = 'TestCustomerAccountRoleTrigger';
        cable_unit.Municipaly__c = '1599 Gentofte';
        cable_unit.Cable_Unit_Post_Code__c = '4000';
        cable_unit.CA_Sales_Concept__c = 'SERVICE';        
        cable_unit.Housing_Ownership__c = createLookupHousingOwnership3();              
        cable_unit.Housing_Type__c = createLookupHousingType3();               
        cable_unit.Building_Type__c = createLookupBuildingType3();
        cable_unit.Potential_Installations__c = 79.0;
        insert cable_unit;
        
        Account account = new Account( Name = 'TestCableUnitCustomer', RecordTypeID = cableUnitCustomerRecordType);
        account.Cable_Unit__c = cable_unit.Id;  
       	account.Customer_Segment_Lookup__c =  createLookupCustomerSegmentKunde3();
       	insert account;
       	return account;
    }
}