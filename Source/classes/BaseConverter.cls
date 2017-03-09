public class BaseConverter {
    
public static String generateBase32Number(Decimal decimalValue, Integer contractNumberLength)
{
    try
    {
        Integer inputBase = 32;
        Integer outputBase = 2;
        String outputValue = ''; 
        String numericBaseData = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        Integer x;
        Integer maxBase = NumericBaseData.length();
        if(DecimalValue == 0)
        {
        return '0';
        }
        else
        {
            while(decimalValue > 0)
            {
                  X = (Integer)(((DecimalValue/outputBase) - (Integer)(DecimalValue/OutputBase))* OutputBase + 1.5);
                  System.debug('x' + x);
                  OutputValue = NumericBaseData.subString(X - 1,X)+OutputValue;
                  DecimalValue = Integer.valueOf(DecimalValue/OutputBase);
            }
        }
        //We want to ensure all characters have a value. So if the Base 32 number is 10, and our Contract Number lenght is 5, we want to make the output String "00010"
        while(OutputValue.length() < contractNumberLength)
        {
            OutputValue = '0' + OutputValue;
        }
        return OutputValue;
    }catch(Exception e)
    {
        throw new Custom_Exception('There was an error converting the base values:' + e.getMessage());
    }
    
}

public static integer stringByteToInteger(string strbinary){

 // '76543210' -> 128-64-32-16-8-4-2-1

        try{

            double result = 0.0;

            integer i = 4;
            integer x = 0;

            while(i>=0){
                result += math.pow(double.valueof(2.0),double.valueof(i)) * integer.valueof(strbinary.substring(x,x+1));
                x++;
                i--;
            }
            return Integer.valueOf(result);
        }catch(Exception x){
            throw new CustomErrorException('Invalid Byte String: '+ strbinary);
        }
    }
    
    public class CustomErrorException extends Exception {}

}