public class clsCBSchedCustValsController {
    
    //default constructor
    public clsCBSchedCustValsController(){
    
        day=clsCallBackUtil.parseDate(ApexPages.currentPage().getParameters().get('date'));
        cbType=ApexPages.currentPage().getParameters().get('type');
        Date nextDay = day.addDays(1);
        
        //custom values
        custVals = new List<CB_Custom_Schedule__c>();
        List<clsCallBackCustomDay> custDays = clsCallBackCustomDay.populateList([select ID,Name,CB_type__c, CB_time_from__c, CB_time_to__c, Max_slots__c from CB_Custom_Schedule__c where CB_time_from__c>=:day and CB_time_from__c<:nextDay and CB_type__c=:cbType order by CB_time_from__c]);
        if (!custDays.isEmpty()){
            custDay = custDays[0];
            custVals=custDay.custVals;
        }
        
        //default values
        defVals = clsCallBackUtil.findDefVals(day,cbType);
        
        //default and custom values together
        defAndCustVals = new List<DisplayDefAndCustVals>();
        for(clsCallBackDefaultInterval defVal:defVals){
            DisplayDefAndCustVals defAndCustVal = new DisplayDefAndCustVals(defVal,custVals);
            defAndCustVals.add(defAndCustVal);
        }
    }
    
    //constructor
    public clsCBSchedCustValsController(ApexPages.StandardController controller) {
        this();
    }

    public Date day{get;set;}
    public String cbType{get;set;}
    public clsCallBackCustomDay custDay {get;set;}
    public List<CB_Custom_Schedule__c> custVals {get;set;}
    public List<clsCallBackDefaultInterval> defVals {get;set;}
    public List<DisplayDefAndCustVals > defAndCustVals {get;set;}

    public String getFormatedDay(){
        return day.format();
    }

    //inner class
    public class DisplayDefAndCustVals {
    
        //constructor
        public DisplayDefAndCustVals(clsCallBackDefaultInterval defVal,List<CB_Custom_Schedule__c> custVals){
            this.timeFrom=defVal.timeFrom;
            this.timeTo=defVal.timeTo;
            this.defVal=defVal.maxSlots;
            this.usedSlots=defVal.usedSlots;
            this.custValObj = findCustVal(defVal,custVals);
            if(this.custValObj!=null){
                this.custVal=custValObj.Max_slots__c.toPlainString();
            }
        }
        
        public Integer timeFrom {get;set;}
        public Integer timeTo {get;set;}
        public Integer defVal {get;set;}
        public Integer usedSlots {get;set;}
        public String custVal {get;set;}
        public CB_Custom_Schedule__c custValObj {get;set;}
        
        public CB_Custom_Schedule__c findCustVal(clsCallBackDefaultInterval defVal,List<CB_Custom_Schedule__c> custVals){
            for(CB_Custom_Schedule__c custVal:custVals){
                if(custVal.CB_time_from__c.hour()==defVal.timeFrom && custVal.CB_time_to__c.hour()==defVal.timeTo ){
                    return custVal;
                }
            }
            return null;
        }
    }
    public void quicksaveCustom(){
        saveAll();
    }
    public PageReference saveCustom(){
        saveAll();
        return new PageReference(ApexPages.currentPage().getParameters().get('retURL'));
    }
    public void saveAll(){
        for(DisplayDefAndCustVals defAndCustVal:defAndCustVals){
            //empty input
            if (defAndCustVal.custVal==null || defAndCustVal.custVal.trim()==''){
                //object exists
                if(defAndCustVal.custValObj!=null){
                    delete defAndCustVal.custValObj;
                    defAndCustVal.custValObj = null;
                }
            }
            //filled input
            else{
                try{
                    Integer val = Integer.valueOf(defAndCustVal.custVal.trim());
                    //object not exists
                    if(defAndCustVal.custValObj==null){
                        defAndCustVal.custValObj = new CB_Custom_Schedule__c();
                        defAndCustVal.custValObj.CB_type__c=this.cbType;
                        defAndCustVal.custValObj.CB_date__c=this.day;
                        defAndCustVal.custValObj.CB_time_from__c = Datetime.newInstance(this.day,Time.newInstance(defAndCustVal.timeFrom,0,0,0));
                        defAndCustVal.custValObj.CB_time_to__c = Datetime.newInstance(this.day,Time.newInstance(defAndCustVal.timeTo,0,0,0));
                    }
                    defAndCustVal.custValObj.Max_slots__c=Decimal.valueOf(defAndCustVal.custVal.trim());
                    upsert defAndCustVal.custValObj;
                }
                catch(TypeException e){
                    String errorMessage = String.format(Label.CB_Error_Parsing_Manual_value,new String[]{defAndCustVal.custVal.trim()});
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
                }
            }
        }
    }
    
}