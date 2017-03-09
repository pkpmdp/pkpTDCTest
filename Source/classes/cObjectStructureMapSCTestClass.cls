@isTest(SeeAllData = true)
private class cObjectStructureMapSCTestClass{
    static testMethod void unitTest(){
           Test.startTest();
           ObjectStructureMap tempMap = new ObjectStructureMap();
           Boolean tempSelected;
           Boolean tempPrevSelected;
           cObjectStructureMap tempMap1 = new cObjectStructureMap(tempMap);
           Test.stopTest(); 
    }
}