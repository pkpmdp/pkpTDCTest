public class InvoiceDetailController {
    String accountNumber;
    String InvoiceNo;
    String cableunitnumber;
    public String str{get; set;}
    public String invData{get; set;}
    public Boolean flag{get; set;}
    public Map<String,String> map_mockResponse{get;set;}
    // public static final String endPoint = System.label.NetsFeeBCEndPoint;
    public static final String endPoint = 'https://itsg.tdc.dk:8443/bc/secure/';
    //SPOC 2091 Start
    String InvoiceType; 
    //SPOC 2091 END
    //Contains a map of RAS pages.
    Map<String,XmlDom.Element> RasNodeMap = new Map<String,XmlDom.Element>();
    // Map of Invoice Lines
    Map<String,InvoiceDetailStore> invoiceMap = new Map<String,InvoiceDetailStore>();
    List<String> paging = new List<String>();
    public Boolean renderSection{get;set;}
    public List<String> calloutParameter = new List<String>();
    public List<String> calloutvalue = new List<String>();
    public InvoiceDetailController(){
        map_mockResponse=new Map<String,String>();
        accountNumber = Apexpages.currentpage().getparameters().get('accountNumber');
        
        // Support-5377 --------START
        Boolean cableUnitMatch = true;  // Support-5377 
        renderSection = true; // Support-5377
        String cableUnitNumber = ApexPages.CurrentPage().getParameters().get('cableunitnumber');
        
        InvoiceNo = Apexpages.currentpage().getparameters().get('InvoiceNo');
        InvoiceType = Apexpages.currentpage().getparameters().get('InvoiceType'); // Added For SPOC 2091
        cableunitnumber = Apexpages.currentpage().getparameters().get('cableunitnumber');
        list<Account> accList = new list<Account>();
        if(String.isNotBlank(accountNumber)){
            
            accList = [SELECT Id, Cable_Unit__r.Cable_Unit_No__c FROM Account where Customer_No__c =:accountNumber ];
        }
        
        if(!accList.isEmpty() ){
            if(accList[0].Cable_Unit__c != null){
                system.debug('***cableUnitMatch***1*renderSection****'+cableUnitMatch + '    ' + renderSection);
                if(cableUnitNumber != null && accList[0].Cable_Unit__r.Cable_Unit_No__c != cableUnitNumber){
                    system.debug('***cableUnitMatch***2*renderSection****'+cableUnitMatch + '    ' + renderSection);
                    renderSection = false;
                    cableUnitMatch = false;
                    /* ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Cable Unit Not matched with Account');
ApexPages.addMessage(errorMsg); */ 
                }
                
            }
            
        }
        else 
        {
            renderSection = false;
            cableUnitMatch = false;
            
            system.debug('***cableUnitMatch****renderSection****'+cableUnitMatch + '    ' + renderSection);
        }
        System.debug('InvoiceDetailController account no->'+accountNumber+'...InvoiceNo->'+InvoiceNo+'*****InvoiceType*****'+InvoiceType);
        
    }
    
    /**
* This is the action which is called when the server evaluates the apex:page - action attribute. 
* HttpCallout is done in the action instead of constructor so as to make it possible to write testmethod.
*/  
    public Pagereference fetchInvoiceXMLHttpCallout(){
        //SPOC 2091 Start
        // FOR Testing of new Service
        /*   InvoiceType = 'RF';
accountNumber = '610030371';//604717234 – 31 //616538984
InvoiceNo = '43';//'604717234,31' //*/
        try{
           /* if(System.label.Is_SC_View_Invoice_Type_New_Service_ON == 'ON'){ //Commented for SUPPORT-5728
                if(InvoiceType != null && InvoiceType.substring(1, 2) == 'F'){
                   */ 
                    Http httpProtocol=new Http();
                    HttpRequest request=new HttpRequest(); 
                    request.setClientCertificateName(Label.NetsFeeCert);
                    // request.setClientCertificateName('YouSee_Nets_fee_BusinessCore_to_accept_YouSee_calls');
                    String strMid = NetsFeeCallOut.GetUserMid();
                    String strIp = NetsFeeCallOut.GetUserIPAddress();
                    String endpoint2=endPoint+'account/'+accountNumber+'/bill/'+InvoiceNo +'/pdf?billSpecificationIndicator=true';
                    //String endpoint2=endPoint+'account/610030371/bill/23/pdf?billSpecificationIndicator=true';
                    request.setEndPoint(endpoint2);
                    request.setHeader('x-tdc-userid','M61833');
                    request.setHeader('x-tdc-remote-addr',strIp!=null?strIp:'203.191.35.23');
                    request.setHeader('x-tdc-imp-userid',UserInfo.getUserId());
                    request.setHeader('Content-Type', 'application/x-pdf');
                    request.setTimeout(120000);
                    request.setMethod('GET');
                    HttpResponse response=new HttpResponse();
                    if(Test.isRunningTest()){
                        response.setBody('{"file":"JVBERi0xLjQK+CnN0YXJ0eHJlZgoxNDYzOQolJUVPRgo=","mimeType":"PDF","filename":"42"}');
                    }else{    
                        response=httpProtocol.send(request);
                        system.debug('response++++++++++'+response);
                    }
                    System.debug('****response****'+response.getBody());
                    //strPdfUrl = '';
                    // bData = '';
                    try{
                        if(response!=null){
                            system.debug('+++++++++++++'+response);
                            if(response.getStatusCode() != 500 && response.getStatus() != 'Error'){
                                Map<String,String> responseMap =(Map<String,String>)JSON.deSerialize(response.getBody(),Map<String,String>.class);        
                                system.debug('response for attachment===='+responseMap);                        
                                if(responseMap.containsKey('file')){
                                    invData = responseMap.get('file');
                                    String strMimeType = responseMap.get('mimeType');
                                    String filename = responseMap.get('filename');
                                    //strPdfUrl = insertAttachment(bData,strMimeType);  
                                    str = insertAttachment(invData ,strMimeType);            
                                }
                                else
                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.NetsFeeInvoiceMessage));
                            }else{
                                 flag = true;
                                        ApexPages.Message debugMsg = new ApexPages.Message(ApexPages.Severity.INFO,System.Label.FakturaArkiveret);
                						ApexPages.addMessage(debugMsg);
                            }       
                        }
                        else if(response.getStatusCode() == 500 && response.getStatus() == 'Error'){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.NetsFeeInvoiceMessage));
                            //return null;
                        }
                    } catch(Exception e){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.NetsFeeInvoiceMessage));
                        
                    }
                    /*  Http http = new Http();
HTTPResponse res = new HTTPResponse();
HttpRequest req = new HttpRequest();
String endpt = System.label.DbtCalloutEndpoint;
req.setHeader('charset','utf-8');
req.setHeader('content-type', 'application/x-pdf');
req.setMethod('POST');
req.setEndpoint(endpt);
String BodyText=accountNumber+','+InvoiceNo;//'604717234,31'
req.setBody(BodyText);
req.setTimeout(120000);
if(test.isRunningTest()){
String str1 = '<n:StreamServeTransfer xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:n="http://interfaces.far.strs.tdc.dk" Version="3.1415926535897932384626433832795">'
+'<StreamServeHeader><DateTime>2015-07-15T02:03:06.058</DateTime><SessionID>10000005:0</SessionID><Status>0</Status><StatusText>Success</StatusText>'
+'</StreamServeHeader><Response type="get"><AccountNumber>604717234</AccountNumber><InvoiceNumber>31</InvoiceNumber><BinaryData>JVBERi0xLjQNCiX15Pb8DQoNCjkgMCBvYmoNCjw8IC9UeXBlIC9YT2JqZWN0DQovU3VidHlwZSAv'
+'==</BinaryData></Response></n:StreamServeTransfer>';
res.setBody(str1);
}else{
res = http.send(req);
}

System.debug('Request = '+req);
System.debug('Response-->'+res.getBody());
flag = false;
List<InvoiceDetailWrapper> inv = new List<InvoiceDetailWrapper>(); 
inv = XMLPaeser(res);
System.debug('***inv***'+inv);
if(!inv.isEmpty()){
/*  Blob b = EncodingUtil.base64Decode(inv[0].BinaryData);
invData = EncodingUtil.base64Encode(b);*/
                    /* invData = inv[0].BinaryData;
str =  insertAttachment(invData,'PDF');
}
System.debug(' is now encoded as: ' + str+'*****size****'+str.length());*/
                /*}else{
                    flag = true;
                    //EDM-637 start
                    //createRasNodeMap(HttpRequestUtil.makeHttpCall('YSSCInvoiceDetail',InvoiceNo+','+accountNumber));
                    calloutParameter.add('null');
                    //calloutvalue.add(InvoiceNo+','+accountNumber);
                    //calloutvalue.add('53,601304391');
                	calloutValue.add('23,610030371');
                    string res= clsConnectionUtils_Admin.callout1('YSSCInvoiceDetail',calloutParameter,calloutvalue);
                    system.debug('res>>+++'+res);
                    createRasNodeMap(res);
                    calloutParameter = new List<String>();
                    calloutvalue = new List<String>();
                    //EDM-637 end
                }
            }else{
                flag = true;
                //EDM-637 start
                //createRasNodeMap(HttpRequestUtil.makeHttpCall('YSSCInvoiceDetail',InvoiceNo+','+accountNumber));
                calloutParameter.add('null');
                //calloutvaclsConnectionUtils_Adminlue.add(InvoiceNo+','+accountNumber);
                calloutvalue.add('53,601304391');
                string res= clsConnectionUtils_Admin.callout1('YSSCInvoiceDetail',calloutParameter,calloutvalue);
                system.debug('res'+res);
                createRasNodeMap(res);
                calloutParameter = new List<String>();
                calloutvalue = new List<String>();
                //EDM-637 end
            }*/
        }catch(Exception e){
            System.debug(e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return null;
        }
        // SPOC 2091 End
        /* Commented for SPOC 2091
createRasNodeMap(HttpRequestUtil.makeHttpCall('YSSCInvoiceDetail',InvoiceNo+','+accountNumber));*/
        return null;
    }
    
    
    /*public void createRasNodeMap(String cxml){ commented for SUPPORT-5728
        xmldom xmldomObj;
       // System.debug('****cxml***'+cxml);
        try{
            xmldomObj = new xmldom(cxml);
            //List<XmlDom.Element> RasPagelist = xmldomObj.getElementsByTagName('RasPage');
            List<XmlDom.Element> RasPagelist = xmldomObj.getElementsByTagName('ns1:RasPage'); //EDM-637 ns1 used because new response contains namespace prefix
            //Dom.XMLNode address = xmldomObj.getRootElement();//>edited
            //system.debug('***pages****'+Pagelist);
            system.debug('RasPagelist>>>'+RasPagelist);
            if(RasPagelist != null && RasPagelist.size() > 0){
                for(Integer i=0;i<RasPagelist.size();i++){
                    RasNodeMap.put(i+1+'',RasPagelist[i]);
                    
                    paging.add(i+1+'');
                }
            }
            if(RasPagelist.size() > 0){
                ApexPages.CurrentPage().getParameters().put('pageNum','1');          
                populateDetailObj();
            }else {
                ApexPages.Message debugMsg = new ApexPages.Message(ApexPages.Severity.INFO,System.Label.FakturaArkiveret);
                ApexPages.addMessage(debugMsg);
            }
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    */
    /**
This method is used to load the Subsequent invoice Pages Data which corrospond to the Ras Node.
Each XML RasPage element contains BillingLineItems that are used to populate the invoice data. 
*/
   /* private void populateDetailObj(){ commented for SUPPORT-5728
        String pageNum =ApexPages.CurrentPage().getParameters().get('pageNum');
        System.debug('PageNumber outside ###   '+pageNum);
        if(!invoiceMap.containsKey(pageNum)){ 
            System.debug('PageNumber inside ###   '+pageNum);          
            XmlDom.Element RasElement = RasNodeMap.get(pageNum);
            System.debug('****RasElement****'+RasElement);
            // TODO -- check for condition if billingLines size is 0
            InvoiceDetailStore invStore = new InvoiceDetailStore();
            List<XmlDom.Element> billingLines = RasElement.getElementsByTagName('ns:string'); // EDM-637
            System.debug('*****billingLines***'+billingLines);
            //List<XmlDom.Element> billingLines = RasElement.getElementsByTagName('string');
            
            createHeader(invStore,billingLines);
            setLinesThreeColPreformatted(invStore,billingLines);
            invoiceMap.put(pageNum,invStore);
            RasNodeMap.remove(pageNum);
        }
    }
    */
    /**
This method is called when user selects the subsequent Page Numbers to view Invoices. 
*/  
    public PageReference jumpNextPage(){
        System.debug('###### method getting called');
        //populateDetailObj(); Commented for SUPPORT-5728
        return null;
    }
    
    /**
* This method is used to get all the data related to a Invoice. 
*/
    public InvoiceDetailStore getInvoiceDetailStore(){
        return invoiceMap.get(ApexPages.CurrentPage().getParameters().get('pageNum'));
    }
    
    /**
* This method is used to create the Header on the Invoice Detail Page.
* This method is utilizes the first 13 BillingLineItems from the XML to create the header.   
* @param invoiceDetail
* @param billingLines
*//* coomented for SUPPORT-5728
    private void createHeader(InvoiceDetailStore invoiceDetail, List<XmlDom.Element> billingLines) {
        // ------------ "Header" ------------------------------------
        for (Integer j = 0; j < 13; j++) {
            String line = billingLines[j].nodeValue;
           // System.debug('****line***'+line);
            // gets the Invoice type
            if (j == 1) {
                invoiceDetail.setInvoiceType(danishCharFix(line.trim()));
            }
            // gets the Invoice period
            if (j == 2) {
                invoiceDetail.setFakturaPeriode(line.trim());
            }
            // gets the BetalingsFrist
            if (j == 6) {
                invoiceDetail.setBetalingsFrist(line.trim());
            }
            // gets the Kontonr
            if (j == 7) {
                invoiceDetail.setKontonr(line.trim());
            }// gets the cableUnit Name
            if (j == 8) {
                invoiceDetail.setNavn(danishCharFix(line.trim()));
            }// gets the address info,GiroKonto
            if (j == 9) {
                String gade = line.substring(0, 67);
                String giroNr = line.substring(67, line.length());
                invoiceDetail.setGade(danishCharFix(gade.trim()));
                invoiceDetail.setGirokonto(giroNr.trim());
            }// gets the PostBox Number if available and the Invoice Date
            if (j == 10) {
                String byOgPostNr = line.substring(0, 67);
                String fakturaDato = line.substring(67, line.length());
                // POBoxNumber is present
                invoiceDetail.setByOgPostnr(danishCharFix(byOgPostNr.trim()));
                invoiceDetail.setFakturaDato(fakturaDato.trim());
                invoiceDetail.setSted('');
            }// gets the Invoice Number,
            if (j == 11) {
                String byOgPostNr = line.substring(0, 67);
                String fakturaNr = line.substring(67, line.length());
                byOgPostNr = byOgPostNr.trim();
                // if Line10 contains the location instead of POBOX number.
                if (byOgPostNr.length() != 0) {
                    invoiceDetail.setSted(danishCharFix(invoiceDetail
                                                        .getByOgPostnr()));
                    invoiceDetail.setByOgPostnr(danishCharFix(byOgPostNr));
                }
                invoiceDetail.setFakturanr(fakturaNr.trim());
            }// gets the Page side.
            if (j == 12) {
                invoiceDetail.setSide(line.trim());
            }
            System.debug('******invoiceDetail****'+invoiceDetail);
        }
    }
    */
    /**
* This method uses the RAS data.The data set in the xml is formatted by RAS.
*
* @param invoiceDetail
* @param billingLines
*//* Commented for SUPPORT-5728
    private void setLinesThreeColPreformatted(InvoiceDetailStore invoiceDetail, List<XmlDom.Element> billingLines) {
        //---------- Lines---------------
       system.debug('billing lines>>>>'+ billingLines + '>>>billinglines');
        List<InvoiceDetailRowStore> rows = new List<InvoiceDetailRowStore>();
        for (Integer j = 13; j < billingLines.size(); j++) {
            String line = billingLines[j].nodeValue;
        }
        for (Integer j = 13; j < billingLines.size(); j++) {
            
            boolean bflag=false;
            String line = billingLines[j].nodeValue;
            InvoiceDetailRowStore row = new InvoiceDetailRowStore();
            // If it is a horizontal line replace it with stroke
            boolean invoiceRowtype = line.startsWith('Æ');
            boolean invoiceRowtype2 = line.startsWith('Å');
            
            if (invoiceRowtype) {
                
                row.setInvoiceRowtype('streg');
                // Check a blank line and replace it with spaces
            } else if (line.trim().length() == 0|| invoiceRowtype2) {
                row.setInvoiceRowtype('tom');
                row.setTekst('');
                // Check if line starts with Betalings_id
            } else if (line.startsWith('Betalings-Id')) {
                row.setInvoiceRowtype('betalings-id');
                // do nothing
            } else {
                row.setInvoiceRowtype('tekst');
                // Text part
                
                String tekst = line.substring(0, 57);
                if(tekst.lastIndexOf('.')==tekst.length()-1){
                    tekst=line.substring(0,55);
                    bflag=true;
                }
                
                
                
                String tempTekst=line.trim();
                system.debug('$$$$ tempTekst:'+tempTekst+'  tempTekstlenght:'+tempTekst.length());
                
                system.debug('$$$$$$$tempTekst.substring(tempTekst.length()-3,tempTekst.length()-2):'+tempTekst.substring(tempTekst.length()-2,tempTekst.length()-1));
                if(line.substring(58,59)!='' && j==25 && tempTekst.substring(tempTekst.length()-3,tempTekst.length()-2)=='.'){
                    tekst=line.trim();
                }
                if(line.trim().length() > 0){
                    row.setTekst(danishCharFix(tekst));     // (danishCharFix(tekst));
                    
                }
                // faktura_beloeb part
                String fakturaBeloeb = line.substring(57, 71);
                if(bflag){
                    fakturaBeloeb=line.substring(55,71); 
                }
                
                if(line.substring(58,59)!='' && j==25 &&  tempTekst.substring(tempTekst.length()-3,tempTekst.length()-2)=='.'){
                    fakturaBeloeb='';
                }
                fakturaBeloeb = fakturaBeloeb.trim();
                // Replace ÅÅ
                if (fakturaBeloeb.startsWith('ÅÅ')) {
                    fakturaBeloeb = 'image';
                }
                row.setFakturaBeloeb(fakturaBeloeb.trim());
                
                // saldo part
                
                String saldo = line.substring(71, 84);
                if(line.substring(58,59)!='' && j==25 && tempTekst.substring(tempTekst.length()-3,tempTekst.length()-2)=='.'){
                    saldo='';
                }              
                row.setSaldo(saldo.trim());
                
            }
            // adds the row
            
            rows.add(row);
        }
        invoiceDetail.setInvoiceRows(rows);
    }
    
    */
    /**
* danishCharFix -  A Utility method that is used to render the following danish chars æ å ø Æ Å Ø correctly.
*
* @param line
* @return String
*//* Commented for SUPPORT-5728 
    private String danishCharFix(String line) {
        // check for the danish Chars - "æ å ø Æ Å Ø"
        line = line.replace('|', 'ø');
        line = line.replace('\\', 'Ø');
        line = line.replace('[', 'Æ');
        line = line.replace('{', 'æ');
        line = line.replace(']', 'Å');
        line = line.replace('}', 'å');
        return line;
    }
  */  
    /**
* This method makes a Http call to cast iron to fetch the Invoice xml.

public String GetInvoiceXML(String accountNumber, String InvNo){
System.debug('### GetInvoiceXML : AccId , InvNo  ### ' + accountNumber + ' , ' + InvNo) ;
String requestBody = InvNo+','+ accountNumber;
String Result = HttpRequestUtil.makeHttpCall('YSSCInvoiceDetail', requestBody);
return result;
} */
    
    /**
* getter for the Paging.
*/
    public List<String> getPaging(){
        return paging;
    } 
    // SPOC 2091 Start
    /*  public List<InvoiceDetailWrapper> XMLPaeser(HttpResponse res)
{
List<InvoiceDetailWrapper> invInfo = new List<InvoiceDetailWrapper>();
Dom.Document doc = new Dom.Document();
doc.load(res.getBody());
Dom.XMLNode Envelope = doc.getRootElement();
for (Dom.XMLNode child : Envelope.getChildElements())   
{
system.debug(child.getName());
if (child.getName() == 'Response') 
{
InvoiceDetailWrapper obj = new InvoiceDetailWrapper();
parseReport(child,obj);
if(obj!=null)
invInfo.add(obj);
}
}   
return invInfo;
}
public void parseReport(Dom.XMLNode child1, InvoiceDetailWrapper obj)
{
for (Dom.XMLNode child : child1.getChildElements()) 
{
if(child.getName() == 'AccountNumber')
{
obj.AccountNumber = child.getText().trim();
}
else if(child.getName() == 'InvoiceNumber') 
{
obj.InvoiceNumber = child.getText().trim();
}
else if(child.getName() == 'BinaryData')
{
obj.BinaryData = child.getText().replace('\r\n', ' ').replace('\n',' ');//.replace('==','');
//obj.BinaryData[0]=  obj.BinaryData[0]+' ';
// obj.BinaryData[1]=  obj.BinaryData[1]+' ';
// obj.BinaryData =  obj.BinaryData+'==';
// System.debug('*******obj.BinaryData****'+obj.BinaryData);
}
}
}*/
    public String insertAttachment(String encodeData,String strMimeType){
        Cable_Unit__c cu = [SELECT Id, Cable_Unit_No__c FROM Cable_Unit__c WHERE Cable_Unit_No__c = :cableunitnumber LIMIT 1];
        List<Attachment> lstAttach = new List<Attachment>(); 
        lstAttach = [SELECT id from Attachment WHERE ParentId =:cu.Id AND Description ='Service Center Invoice'];
        if(!lstAttach.isEmpty())
            delete lstAttach;
        
        Attachment att=new Attachment();
        //att.Body = EncodingUtil.base64Decode(encodeData); 
        att.Body = EncodingUtil.base64Decode(encodeData);
        att.parentId = cu.Id;
        att.Name = InvoiceNo+'.'+strMimeType;
        att.Description = 'Service Center Invoice';
        att.ContentType = 'application/x-pdf';
        insert att;
        System.debug('****AttId***'+att.Id);
        return att.id;
        
        
    } 
    /*  public Class InvoiceDetailWrapper{
public String AccountNumber;
public String InvoiceNumber;
public String BinaryData;
}*/
    //SPOC 2091 END
    
}