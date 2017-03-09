public class DynamicQueryHelper{
    public String soql {get; set;}
    
    // static operators
    public static String OP_EQUAL = 'OP_EQUAL';
    public static String OP_GREATER = 'OP_GREATER';
    public static String OP_LESS = 'OP_LESS';
    
    // default constructor
    public DynamicQueryHelper()
    {}
    
    public DynamicQueryHelper(String startQuery)
    {
       soql = startQuery; 
    }
    
    public String addCondition(String condition, String value, String operation)
    {
        if (!String.isBlank(value))
        {
          soql = soql + ' and ' +  condition + ' ' +  evalOperation(operation)  + '\'' +  value + '\''; 
        }
        return soql;
    }
    
    // for appending a range where condition
    public String addConditionRange(String condition, string lowerValue, String UpperValue)
    {
     	if(!String.isBlank(lowerValue) && !String.isBlank(UpperValue))
        {
            soql = soql + ' and ' +  condition + ' >= ' +   lowerValue + ' and ' + condition + ' <= ' + UpperValue;
        }
        return soql;
    }
    
    // returns the operator for operation
    private String evalOperation(String op)
    {
        if(op == OP_EQUAL)
            return '=';
        if(op == OP_GREATER)
            return '>';
        if(op == OP_LESS)
            return '<';
        return null;
    }  
    
    public String addConditionMap(Map<String, Object> mapCondition)
    {
     	for(String condition : mapCondition.keySet())
        {
            String conditionValue = String.valueOf(mapCondition.get(condition));
            if(!String.isBlank(conditionValue))
            {
               soql = soql + ' and ' +  condition + ' = \'' +  conditionValue + '\''; 
            }
        }
        return soql;
    }
}