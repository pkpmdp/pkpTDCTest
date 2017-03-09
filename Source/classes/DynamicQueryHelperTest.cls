@istest
public class DynamicQueryHelperTest {
    static testmethod void  testmethodDynamicQueryHelperTest(){
         String condition;
         String value='1';
        String operation;
        string lowerValue='12';
        String UpperValue='15';
       String op;
        String soql;
        String conditionValue='';
       Map < String,object > mapCondition =new Map< String,object >();
        DynamicQueryHelper dyp =new DynamicQueryHelper();
        DynamicQueryHelper dyp1 =new DynamicQueryHelper(soql);
        
         System.assertEquals(DynamicQueryHelper.OP_EQUAL,DynamicQueryHelper.OP_EQUAL);
         dyp.addCondition(  condition, value,  operation);
        dyp.addConditionRange(condition, lowerValue, UpperValue);
        //dyp.evalOperation(op);
        dyp.addConditionMap(mapCondition);
        
    }

}