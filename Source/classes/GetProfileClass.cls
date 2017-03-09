public class GetProfileClass
{
    private final Double cNumber;

    public GetProfileClass(ManageContactsController controller) {
        cNumber=getcNumber();
            }


   
    public GetProfileClass(CableUnitDetailsController controller) {
//        cNumber=controller.getCableUnitNumber();
           }


  public static String getUserProfile()
  {
   Profile profileName = [Select name from Profile where Id in (select profileId from User where id =:  UserInfo.getUserId())];
   return profileName.name;
  }
 
 public Double getCNumber()
  {
      return cNumber;
  }
   
}