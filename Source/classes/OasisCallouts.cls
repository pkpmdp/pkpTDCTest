public class OasisCallouts {

    // OASIS-84  Digital filter callout test endpoint - https://TDCGroupTRIAL79207.jitterbit.eu/devtdcapi/1/digital_filter?cableunitid=5004547  
    public List<digitalFilterWrapper> digitalFltrParsedXML;
    public class digitalFilterWrapper
    {
        public string ANLAEGS_NR;
        public string INSTAL_SEQ_NR;
        public string AMS_ADR_NR;
        public string TV_PAKKE;
    }
    //OASIS-84 START
    //OASIS-75
    public class CasperActivityWrapper
    {
        public string AMSID;
        public string AKTIVITET;
        public string DATOUDSKREVETARBORDRE;
        public string BIERREVSPOR;
        public string BIERREVDATO;
        public string AKTIV;
        public string OPHXRS_XRSAG;
        public string SPOC24ACTIVITY;
        public string CABLEUNIT;
    }//OASIS-75 END
    //OASIS-84
    public static Map<String, String> digitalXMLPaeser(String resBody)
    {
        List<digitalFilterWrapper> listdigitals = new List<digitalFilterWrapper>();
        Map<String, String> dIInstallation = new Map<String, String>();
        Map<String, String> OSInstallation = new Map<String, String>();
        Dom.Document doc = new Dom.Document();
        doc.load(resBody);
        Dom.XMLNode Envelope = doc.getRootElement();
        for (Dom.XMLNode child : Envelope.getChildElements()) 	
        {
            if (child.getName() == 'Digitalfilter') 
            {
                digitalFilterWrapper obj = new digitalFilterWrapper();
                parseReportDigitalFilter(child, obj); 
                if(obj!=null){
                    //EDM-810 START
                    //listdigitals.add(obj);
                    if(obj.TV_PAKKE == 'DI'){
							dIInstallation.put(obj.INSTAL_SEQ_NR,'DI' );
   					}
                    else if(obj.TV_PAKKE =='OS'){
							dIInstallation.put(obj.INSTAL_SEQ_NR, 'OS');
   					}
                    else{
                        dIInstallation.put(obj.INSTAL_SEQ_NR, 'DI,OS');
                    }
                //EDM-810 END
                }
             }
        }
        return dIInstallation;
    }
    
   
    public static void parseReportDigitalFilter(Dom.XMLNode child1,digitalFilterWrapper obj)
    {
        for (Dom.XMLNode child : child1.getChildElements()) 
        {
            if(child.getName() == 'ANLAEGS_NR')
            {
                obj.ANLAEGS_NR = child.getText().trim();
            }
            else if(child.getName() == 'INSTAL_SEQ_NR')	
            {
                obj.INSTAL_SEQ_NR = child.getText().trim();
            }
            else if(child.getName() == 'AMS_ADR_NR')
            {
                obj.AMS_ADR_NR = child.getText().trim();
            }
            else if(child.getName() == 'TV_PAKKE')
            {
                obj.TV_PAKKE = child.getText().trim();
            }
        }
    }//OASIS-84 END
    
    //OASIS-75
    public static List<CasperActivityWrapper> XMLPaeser(String res)
    {
        List<CasperActivityWrapper> addrInfo = new List<CasperActivityWrapper>();
        Dom.Document doc = new Dom.Document();
        doc.load(res);
        Dom.XMLNode Envelope = doc.getRootElement();
        for (Dom.XMLNode child : Envelope.getChildElements())   
        {
            system.debug(child.getName());
            if (child.getName() == 'row') 
            {
                CasperActivityWrapper obj = new CasperActivityWrapper();
                parseReport(child, obj);
                if(obj!=null)
                    addrInfo.add(obj);
            }
        }   
        return addrInfo;
    }
    
    public static void parseReport(Dom.XMLNode child1,CasperActivityWrapper obj)
    {
        for (Dom.XMLNode child : child1.getChildElements()) 
        {
            if(child.getName() == 'AMSID')
            {
                obj.AMSID = child.getText().trim();
            }
            else if(child.getName() == 'AKTIVITET') 
            {
                obj.AKTIVITET = child.getText().trim();
            }
            else if(child.getName() == 'DATOUDSKREVETARBORDRE')
            {
                obj.DATOUDSKREVETARBORDRE = child.getText().trim();
            }
            else if(child.getName() == 'BIERREVSPOR')
            {
                obj.BIERREVSPOR = child.getText().trim();
            }
            else if(child.getName() == 'BIERREVDATO')
            {
                obj.BIERREVDATO = child.getText().trim();
            }
            else if(child.getName() == 'AKTIV')
            {
                obj.AKTIV = child.getText().trim();
            }
            else if(child.getName() == 'OPHXRS_XRSAG')
            {
                obj.OPHXRS_XRSAG = child.getText().trim();
            }
            else if(child.getName() == 'SPOC24ACTIVITY')
            {
                obj.SPOC24ACTIVITY = child.getText().trim();
            }
            else if(child.getName() == 'CABLEUNIT')
            {
                obj.SPOC24ACTIVITY = child.getText().trim();
            }
        }
    }
    // ------ End OASIS-75
}