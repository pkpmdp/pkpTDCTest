/*
 * callback booking slot
 * DateOn     - day of booking slot
 * HourFrom   - start of interval of booking slot
 * HourTill   - end of interval of booking slot
 * Available  - number of operators/users available 
 */
public class CallbackBookingSlot {
  public Date DateOn {get; set;}
  public Integer HourFrom {get; set;}
  public Integer HourTill {get; set;}
  public Integer Available {get; set;}
  public String CaseType {get; set;}
  
  public string Debug {get; set;}
    
  public CallbackBookingSlot(Date dateOn, Integer hourFrom, Integer hourTill, Integer available, String ct){
    this.DateOn = dateOn;
    this.HourFrom = hourFrom;
    this.HourTill = hourTill;
    this.Available = available;
    this.CaseType = ct;
  }
  
  public String getMD5(){
  	Blob md5 = Crypto.generateDigest('MD5', Blob.valueof(string.format('{0} {1}-{2} {3}', new String[]{this.DateOn.format() + string.valueOf(this.HourFrom) + string.valueOf(this.HourTill), this.CaseType})));
    return EncodingUtil.convertToHex(md5);
  }
  
  public String getInterval(){
  	return this.HourTill > this.HourFrom ? string.valueOf(this.HourTill - this.HourFrom) : '';
  }
}