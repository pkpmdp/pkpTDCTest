public class clsCallBackDefaultInterval{
    public clsCallBackDefaultInterval(Integer timeFrom,Integer timeTo,Integer maxSlots,Integer usedSlots){
        this.timeFrom=timeFrom;
        this.timeTo=timeTo;
        this.maxSlots=maxSlots;
        this.usedSlots=usedSlots;
    }
    public Integer timeFrom {get;set;}
    public Integer timeTo {get;set;}
    public Integer maxSlots {get;set;}
    public Integer usedSlots {get;set;}
}