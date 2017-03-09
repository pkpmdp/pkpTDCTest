/*
 * Calendar component controller - weekly calendar with slots
 * Input parameters are set in <apex:> code
 * BaseDate       - starting date for the week
 * StartHour      - starting (working) hour (e.g. 6.00)
 * EndHour        - ending (working) hour (e.g. 23.00)
 * NumberOfDays   - number of days to be shown
 * CallbackSlots  - list of slots, slot keeps info about free intervals for assigning callback case 
 */
public class CalendarController{
  public Date BaseDate {get; set;}
  public Integer StartHour {get; set;}
  public Integer EndHour {get; set;}
  public Integer NumberOfDays {get; set;}
  public CallbackBookingSlot[] CallbackSlots {get; set;}
  
  private static Integer WeekOffset = 0;
  private static string[] DayLabels = new string[]{System.Label.Weekday_Monday, System.Label.Weekday_Tuesday, System.Label.Weekday_Wednesday, System.Label.Weekday_Thursday, System.Label.Weekday_Friday, System.Label.Weekday_Saturday, System.Label.Weekday_Sunday};
  
  static {
  	Date dtBase = Date.valueOf('2011-01-01');
  	Date dtTmp = dtBase.toStartofWeek();
    WeekOffset = dtTmp.daysBetween(dtBase) == 5 ? 0 : -1;
  }
  
  public static Integer getWeekOffset(){
  	return WeekOffset;
  }
    
  public CalendarController(){
  	this.BaseDate = Date.today();
    this.StartHour = 6;
    this.EndHour = 23;
    this.NumberOfDays = 7;
  }
  
  public Week getWeek(){    
    return new Week(this.BaseDate, this.StartHour, this.EndHour, this.NumberOfDays, this.CallbackSlots);
  }
  
  public static string GetDayLabelString(integer num){
    Integer index = Math.Mod(num + 7,7);
    if (index < 0){
    	index += 7;
    }
    return DayLabels[index];
  }

  /* 
   * Collection of days (usually 7 or 14 days)
   * listDays       - collection of days
   * workingHours   - interval of working hours (for <apex:> limitation is collection of Integers)
   */
  public class Week{
    private List<Day> listDays;
    private List<Integer> workingHours;
    
    public Week(Date bsDate, Integer startHour, Integer endHour, Integer numberOfDays, CallbackBookingSlot[] slots){
      this.listDays = new List<Day>();      
      for (integer i = 0; i < numberOfDays; ++i){
        this.listDays.add(new Day(bsDate + i, startHour, endHour, slots));
      }
      
      this.workingHours = new List<Integer>();
      for(integer i = startHour; i<=endHour; ++i){
        this.workingHours.add(i);
      }
    }

    /*
     * get collection of days
     */
    public List<Day> getDays(){
      return this.listDays;
    }
    
    /*
     * get collection of working hours
     */
    public List<Integer> getWorkingHours(){
      return this.workingHours;
    }       
  }
  
  /* 
   * Day - single day
   * 
   */
  public class Day{
    public Date BaseDate;
    public List<Hour> workingHours;

    public Day(Date bsDate, Integer startHour, Integer endHour, CallbackBookingSlot[] slots){
      this.BaseDate = bsDate;      
      
      this.workingHours = new List<Hour>();
      for(integer i = startHour; i<=endHour; ++i){
        List<CallbackBookingSlot> daySlots = null;
        if (slots != null){
          for (CallbackBookingSlot slt : slots) {
            if (slt.DateOn == bsDate && i == slt.HourFrom){
              if (daySlots == null){
                daySlots = new List<CallbackBookingSlot>();
                daySlots.add(slt);
              }
            }
          }
        }

        this.workingHours.add(new Hour(daySlots));
      }
    }

    /*
     * get day of the week number
     */
    public integer dayOfWeek(){
      Date bg = this.BaseDate.toStartofWeek();
      return bg.daysBetween(this.BaseDate) + CalendarController.WeekOffset;
    }
    
    /*
     * get day's label
     */
    public string getDayLabel(){
      return CalendarController.GetDayLabelString(this.dayOfWeek());
    }
    
    /*
     * get day of the month number
     */
    public integer getDayOfMonth(){
      return this.BaseDate.day();
    }
    
    /*
     * get working hours collection (with slots)
     */
    public List<Hour> getWorkingHours(){
      return this.workingHours;
    }
    
    /*
     * 
     */
    public string getFormatted(){
      return this.BaseDate.format();
    }
  }
  
  /*
   * Hour - working hour. 
   * Wrapper of slots. The initial intent was to provide some extended functionality, but it was not need in the end :-)
   */
  public class Hour{
    private List<CallbackBookingSlot> slots;
  
    public Hour(List<CallbackBookingSlot> slots){
      this.slots = slots;
    }
    
    /*
     * get collection of available/occupied slots
     */
    public List<CallbackBookingSlot> getSlots(){
      return this.slots;
    }
  }
}