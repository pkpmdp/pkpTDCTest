public with sharing class clsCustomerNumber {
    /**
    Exampel:                   
    Number without controldigit 602 735 88.

    Digit no.   6   0   2   7   3   5   8   8
    weight      9   8   7   6   5   4   3   2

    The productamount here is : 185. (6*9 + 0*8 + 2*7 + 3*5 etc..)
    The productamount, 185 divided by 11, is 16.

    The rest is 185 – (11*16) = 9.

    The Controldigit is  9, and the final ”kundenummer” is 602 735 889. 
    CUSTNUM = 9 digit - starting with 6 and "modulus 11-calculation
    */
    String lastNumber;
    Decimal declastNumber;
    static final Integer DIGITS_COUNT = 9;
    
    public clsCustomerNumber(String lastNumber){
        this.lastNumber = lastNumber;
        this.declastNumber = convertCNumberToDec();
    }
    
    public clsCustomerNumber(Decimal declastNumber){
        this.declastNumber = declastNumber;
        this.lastNumber = String.valueOf(declastNumber);
    }
    
    public clsCustomerNumber(){
        this.lastNumber = '0';
        this.declastNumber = 0;
    }
    
    String convertCNumberToString(Integer custNum ){
        return String.valueOf(declastNumber) + String.valueOf(custNum);
    }
    
    Decimal convertCNumberToDec(){      
        return Decimal.valueOf(lastNumber);
    }
           
    public String getNewCustomerNumber(){
        declastNumber ++;
        return getNewCustomerNumber(declastNumber);
    }
    
    public String getNewCustomerNumber(Decimal declastNumber){
        this.declastNumber = declastNumber;
        Decimal decNum = declastNumber; 
        Decimal dec10 = 10;
        Decimal decRes = decNum;
        Integer weight = 2;
        Integer custNum = 0;
        for (Integer i=1; i<=DIGITS_COUNT; i++){
            custNum = custNum + (math.mod(decRes.intValue(),10) * weight);
            decRes = decNum.divide(dec10.pow(i),1,System.RoundingMode.DOWN);
            weight ++;
        }
        custNum = math.mod(custNum,11);
        lastNumber = convertCNumberToString(custNum==10? 1:custNum);  
        return lastNumber;
    }   
        
        
    public String getLastNumber(){      
        return lastNumber;
    }
    
    public Decimal getLastNumberAsDec(){        
        return declastNumber;
    }
    
    
    static testMethod void testCustomerNumber(){
        clsCustomerNumber custNum;      
        custNum = new clsCustomerNumber();
        Decimal dec = 60273587;
        dec = dec +1;
        String Num = custNum.getNewCustomerNumber(dec);
        system.assert('602735889' == Num);
    }
    
    static testMethod void testCustomerNumberAsString(){
        clsCustomerNumber custNum;      
        custNum = new clsCustomerNumber('60273587');
        system.assert('602735889' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber('60645125');
        system.assert('606451262' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber('60123004');
        system.assert('601230051' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber('60728274');
        system.assert('607282757' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber('61445777');
        system.assert('614457786' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber('60559032');
        system.assert('605590333' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber('60087396');        
        system.assert('600873973' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber('60641008');        
        system.assert('606410090' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber('60349666');        
        system.assert('603496672' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber('60991301');        
        system.assert('609913025' == custNum.getNewCustomerNumber());       
        custNum = new clsCustomerNumber('60099776');        
        system.assert('600997777'== custNum.getNewCustomerNumber());            
        custNum = new clsCustomerNumber('60039594');        
        system.assert('600395959' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber('60080989');        
        system.assert('600809900' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber('60890694');        
        system.assert('608906955' == custNum.getNewCustomerNumber());       
        custNum = new clsCustomerNumber('60838898');        
        system.assert('608388993' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber('61163895');        
        system.assert('611638964' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber('61099567');        
        system.assert('610995686' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber('60019339');        
        system.assert('600193408' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber('60091031');        
        system.assert('600910325' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber('60200859');        
        system.assert('602008608' == custNum.getNewCustomerNumber());       
    }
    
    static testMethod void testCustomerNumberAsInt(){
        clsCustomerNumber custNum;      
        custNum = new clsCustomerNumber(60273587);
        system.assert('602735889' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber(60645125);
        system.assert('606451262' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber(60123004);
        system.assert('601230051' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber(60728274);
        system.assert('607282757' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber(61445777);
        system.assert('614457786' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber(60559032);
        system.assert('605590333' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber(60087396);      
        system.assert('600873973' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber(60641008);      
        system.assert('606410090' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber(60349666);      
        system.assert('603496672' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber(60991301);      
        system.assert('609913025' == custNum.getNewCustomerNumber());       
        custNum = new clsCustomerNumber(60099776);      
        system.assert('600997777'== custNum.getNewCustomerNumber());            
        custNum = new clsCustomerNumber(60039594);      
        system.assert('600395959' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber(60080989);      
        system.assert('600809900' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber(60890694);      
        system.assert('608906955' == custNum.getNewCustomerNumber());       
        custNum = new clsCustomerNumber(60838898);      
        system.assert('608388993' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber(61163895);      
        system.assert('611638964' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber(61099567);      
        system.assert('610995686' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber(60019339);      
        system.assert('600193408' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber(60091031);      
        system.assert('600910325' == custNum.getNewCustomerNumber());
        custNum = new clsCustomerNumber(60200859);      
        system.assert('602008608' == custNum.getNewCustomerNumber());
        system.assert(60200860 == custNum.getLastNumberAsDec());                
    }
    
    
    static testMethod void testDuplicityCustomerNumberAsString(){
        clsCustomerNumber custNum;      
        custNum = new clsCustomerNumber('60270000');
        String newNum;
        Map <String , Integer> numbers = new Map <String , Integer>();      
        for (Integer i=0 ; i<1000 ;i++){
            newNum = custNum.getNewCustomerNumber();
            system.assert(!numbers.containsKey(newNum));
            numbers.put(newNum,1);          
        }
        system.assert(1000 == numbers.size());
    }
    
    static testMethod void testDuplicityCustomerNumberAsInt(){
        clsCustomerNumber custNum;      
        custNum = new clsCustomerNumber(60099776);
        String newNum;
        Map <String , Integer> numbers = new Map <String , Integer>();      
        for (Integer i=0 ; i<1000 ;i++){
            newNum = custNum.getNewCustomerNumber();
            system.assert(!numbers.containsKey(newNum));
            numbers.put(newNum,1);          
        }
        system.assert(1000 == numbers.size());
    }
       
}