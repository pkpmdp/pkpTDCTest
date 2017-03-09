public class spoc2019cmp_cls 
{
    public String department{get; set;}
    public String description{get; set;}
    public String selectBrowser{get;set;}
    public String selectOpSys{get;set;}
    public String selectProduct{get;set;}
    public String strEmail{get;set;}
    public String subject{get;set;}
    public String filebody{get;set;}
    public String filename{get;set;}
    public String Device{get;set;}
    public String BBType{get;set;}
    public String selectMovie{get;set;}
    public String selectVidAud{get;set;}
    public String strPostnr{get;set;}
    public String strInterSupp{get;set;}
    public String strBBSpeed{get;set;}
    public String TimeOfInciMv{get;set;}
    public String TimeOfInciday{get;set;}
    public String strIp{get;set;}
    public String selectIntCnType{get;set;}
    public String selectSmtTVUpd{get; set;}
    public String selectedAccount;
    public List<SelectOption> listAudVidMac{get;set;}
    public List<SelectOption> listIntSupplMac{get;set;}
    public List<SelectOption> listIntConTypeMac{get;set;}
    public List<SelectOption> listSmtTVUpd{get; set;}
    public spoc2019cmp_cls()
    {
       listAudVidMac = new List<SelectOption>();
       listIntSupplMac = new List<SelectOption>();
       listIntConTypeMac = new List<SelectOption>();
    }
    
    public PageReference caseSave()
    {
        System.debug('***-->'+selectedAccount);
        return Null;
    }
    
}