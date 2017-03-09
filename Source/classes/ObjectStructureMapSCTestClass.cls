@isTest(SeeAllData = true)
private class ObjectStructureMapSCTestClass{

    static testMethod void unitTest(){
        Test.startTest();
        String tempNodeId;
        String tempNodeType;
        Boolean[] tempLevelFlag;
        Boolean[] tempCloseFlag;
        Boolean tempFlag;
        Boolean tempFlag1;
        Boolean tempCrNode;
        Boolean tempLastNode;
        Boolean tempSel;
        Account account;
        ObjectStructureMap obj = new ObjectStructureMap();
        obj.setnodeId(tempNodeId);
        obj.setlevelFlag(tempFlag);
        obj.setlcloseFlag(tempFlag1);
        obj.setnodeType(tempNodeType);
        obj.setcurrentNode(tempCrNode);
        obj.setselected(tempSel);
        obj.setaccount(account);
        obj.getlevelFlag();
        obj.getcloseFlag();
        obj.getnodeType();
        obj.getaccount();
        obj.getnodeId();
        obj.getcurrentNode();
        obj.getselected();
        Test.stopTest();
    
    }
    
    static TestMethod void withConst(){
        Test.startTest();
        String nodeId;
        Boolean[]levelFlag;
        Boolean[]closeFlag;
        String nodeType;
        Boolean lastNode;
        Boolean currentNode;
        Account acc;
        ObjectStructureMap tempObj = new ObjectStructureMap(nodeId,levelFlag,closeFlag,nodeType,lastNode,currentNode,acc);
        Test.stopTest();
    
    }
    
    static TestMethod void withConst1(){
        Test.startTest();
        String nodeId1;
        Boolean[]levelFlag1;
        Boolean[]closeFlag1;
        String nodeType1;
        Boolean lastNode1;
        Boolean currentNode1;
        Account acc1;
        Boolean selected1;
        ObjectStructureMap tempObj2 = new ObjectStructureMap(nodeId1,levelFlag1,closeFlag1,nodeType1,lastNode1,currentNode1,acc1,selected1);
        Test.stopTest();
    }
}