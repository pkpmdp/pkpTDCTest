public with sharing class RunOnceKontraktKundeTrigg {

	private static boolean IsFirstRun = true;
	private static boolean IsUpdateKundeHier = true;
	private static boolean IsKundeUpdateOnHierDel = true;
  
    public static boolean getIsFirstRun() {
        return IsFirstRun;
    }

    public static void setIsFirstRun() {
        IsFirstRun = false;
    }
    
    public static boolean getIsUpdateKundeHier() {
        return IsUpdateKundeHier;
    }

    public static void setIsUpdateKundeHier() {
        IsUpdateKundeHier = false;
    }
    
    public static boolean getIsKundeUpdateOnHierDel() {
        return IsKundeUpdateOnHierDel;
    }

    public static void setIsKundeUpdateOnHierDel() {
        IsKundeUpdateOnHierDel = false;
    }
}