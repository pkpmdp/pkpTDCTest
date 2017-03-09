/*
 * Data structure for custom values grouped by day and CB_type
 */
public class clsCallBackCustomDay{
    public List<CB_Custom_Schedule__c> custVals {get; set;}
    public Date day {get; set;}
    public String CB_type {get; set;}
    public String intervalsAndSlots;
    
    public clsCallBackCustomDay(List<CB_Custom_Schedule__c> custVals){
        if (custVals.size()>0){
            this(custVals[0].CB_type__c,custVals[0].CB_time_from__c.date(),custVals);
        }
    }
    public clsCallBackCustomDay(String CB_type,Date day, List<CB_Custom_Schedule__c> custVals){
        this.CB_type = CB_type;
        this.day = day;
        this.custVals = custVals;
    }
    
    public String getIntervalsAndSlots(){
        String result='';
        for(Integer i=0;i<custVals.size();i++){
            CB_Custom_Schedule__c item = custVals[i];
            if (i>0) result=result+', ';
            result = result + item.CB_time_from__c.format('HH:mm') + '-' + item.CB_time_to__c.format('HH:mm') + ' (' + item.Max_slots__c + ')';
        }
        return result;
    }
    
    public String getFormatedDay(){
        return day.format();
    }

    public String getUrlFormatedDay(){
        return clsCallBackUtil.formatDate(day);
    }
    
    /*
     * Methot for populating list of clsCallBackCustomDay objects grouped by day and CB_type
     * Input is list of CB_Custom_Schedule__c. It can be directly result of select from CB_Custom_Schedule__c.
     */
    public static List<clsCallBackCustomDay> populateList(List<CB_Custom_Schedule__c> param){
        List<clsCallBackCustomDay> result = new List<clsCallBackCustomDay>();
        
        //map of Dates and Map of types and list of values
        Map<Date,Map<String,List<CB_Custom_Schedule__c>>> custMap = new Map<Date,Map<String,List<CB_Custom_Schedule__c>>>();
        //map of types and list of values
        Map<String,List<CB_Custom_Schedule__c>> typeMap;
        //list of values
        List<CB_Custom_Schedule__c> custDayList;
        
        for(CB_Custom_Schedule__c item: param){
            Date itemDay = item.CB_time_from__c.date();
            String itemType = item.CB_type__c;
            
            typeMap = custMap.get(itemDay);
            if (typeMap == null){
                typeMap = new Map<String,List<CB_Custom_Schedule__c>>();
                custMap.put(itemDay,typeMap);
            }
            
            custDayList = typeMap.get(itemType);
            if (custDayList ==null){
                custDayList = new List<CB_Custom_Schedule__c>();
                typeMap.put(itemType,custDayList);
            }
            custDayList.add(item);
        }
        List<Date> sortList = new List<Date>();
        sortList.addAll(custMap.keySet());
        sortList.sort();
        for(Date key:sortList){
            Map<String,List<CB_Custom_Schedule__c>> itemMap = custMap.get(key);
            for(List<CB_Custom_Schedule__c> itemList:itemMap.values()){
                result.add(new clsCallBackCustomDay(itemList));
            }
        }
        
        return result;
    }
    
}