/*******************************************************************************************************
* @Class 		DealerwebKasiaServices_Util1
* @author      	Capgemini India Pvt.Ltd
* @date      	22 October 2013
* @description: This is the utility class which is used to call different Kasia services used in the dealerweb. 
*				
* @Version:		Version 1.0
* @Invocation:	The class methods are invocated from DealerProductPageController3. 			
********************************************************************************************************/
public with sharing class DealerwebKasiaServices_Util1 {
	// following code is use to get end point from salesflow custom link
    public END_POINT__c castIronEndPoint = END_POINT__c.getInstance('END_POINT');
    private final String END_POINT = castIronEndPoint.END_POINT__c;
    
	// I have replaced callout2 with afsaetningKasiaService
	/**
	* @method 	  : afsaetningKasiaService
	* @Inputs	  :	String endpoint, String body, String serviceMethod, String serviceUrl, String etag,string application
    * @Return 	  : String cityName
    * @Description: This method is used to find the name of the city for a given postal code.
    * 				The city is then displayed on a visual force page namely DealerCustomerSearch.
    * @Version 1.0:	Implemented the above mentioned task.	
	* @Invocation :	The method is invocated from DealerProductPageController3.
    */
	public String afsaetningKasiaService(String endpoint, String body, String serviceMethod, String serviceUrl, String etag,string application, 
											Map<String,Net_Installations__c> netInstallMap, boolean broadbandTelephonyCommonFlag,
											boolean telefoniFlag, boolean isYouBioSelected, boolean placeOrderCall,String netInstallationNr, 
											boolean createKundeCall, boolean testMode) {
        System.debug('endpoint: ' + endpoint);
        System.debug('body: ' + body);
        System.debug('serviceMethod: ' + serviceMethod);
        System.debug('serviceUrl: ' + serviceUrl);
        System.debug('etag: ' + etag+' createKundeCall-------------'+createKundeCall+'  testMode --------'+testMode);
        System.debug('application: '+application);
        // Make the callout and check the response 
        System.debug('*********call out general method begin'); 
        
          System.debug('netInstallMap :' + netInstallMap);                                       
                                                
                                                
        Http http = new Http(); 
        HttpRequest req = new HttpRequest(); 
        req.setMethod(INTEGRATION__c.getInstance('Kasia20').HttpMethod__c); 
        req.setEndpoint(endpoint); 
        req.setHeader('charset', 'utf-8'); 
        req.setHeader('accept-encoding', 'gzip'); 
        req.setHeader('accept', 'application/vnd.yousee.kasia2.'+application+'+json;version=1;charset=UTF-8'); 
        req.setHeader('content_type','application/vnd.yousee.kasia2.kunde+json;version=1');
        req.setHeader('if_match', etag); 
        req.setHeader('serviceUrl', serviceUrl); 
        req.setheader('serviceMethod', serviceMethod); //put, get, post etc.
        req.setHeader('salesChannel', 'F');  
        system.debug('placeOrderCall ' +placeOrderCall);
        //Added for Carrie-805, to pass x-aria switch in header for telephony orders
        //Added isYouBioSelected for 689
        if(System.Label.DealerWebEnvironment == 'Test' && (broadbandTelephonyCommonFlag==true || telefoniFlag==true || isYouBioSelected == true) && placeOrderCall){
          req.setHeader('x-aria-switch','carrie1');
          system.debug('added header for x-aria switch');
        }
        system.debug(netInstallationNr + ' ' +createKundeCall);
        //Added for Multiple Installations scenario : DW-755
	    if(netInstallMap.size() >0 && netInstallationNr != '' && netInstallationNr != null && createKundeCall){
	      req.setHeader('Net_Installation_Id ', netInstallationNr);
	      system.debug('added header for Net Installation Id ' + netInstallationNr);
		}
        req.setBody((body == null ? '' : body)); //equal to the requestBody before, the real body that is sent to kasia2 service
        req.setCompressed(true); 
        req.setTimeout(40000);         
        HttpResponse res; 
        try { 
            System.debug('request in callout2->'+req);
            if(!(testMode)){
            	res = http.send(req); 
            }
	        System.debug('res: ' + res);
	        if (res != null) {                 
            	if (res.getStatusCode() == 200 ||res.getStatusCode()==201) {                        
	                // Good response || res.getStatusCode() == 201
	                String response = res.getBody();
	                System.debug('response Testing' + response);
	                return response;
             	}else{
	                    ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error,'Incorrect JSON Response.');
	                    ApexPages.addMessage(m); 
	                    return null; 
	                  }
	         }else{
	                ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error,'JSON Response is null.');
	                ApexPages.addMessage(m);  
	                return null; 
	               }
       		 }catch (Exception e) { 
		            System.debug('****call castiron error'); 
		            ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error, e.getMessage(), e.getMessage()); 
		            ApexPages.addMessage(m);   
		            return null;                          
        		}   
    } 
    
 	public String secondCallToCasia(String url,String arrayInit,String kundeData,String etag,Map<String,Net_Installations__c> netInstallMap){
        try{
	        String body = '{"kunde-data":'+kundeData+',"array-init":"'+arrayInit+'"}';
	        //String request ='PUT /afsaetning/opdater/dummy-1/1301123  !#$  -900150296  !#$ ' + body; 
	        system.debug('-----------prepare body for making secong call--------------------------------'+body);
            System.debug('arrayInit: ' +arrayInit);  
          System.debug('kundeData: ' +kundeData);
	        String response  = afsaetningKasiaService(END_POINT+'/Kasia20', body, 'PUT', url,etag,'afsaetning',netInstallMap,false,false,false,false,'',false,false);
	        system.debug('---------second call response --------@@@@@@@@@@@@@@--------------'+response);
            System.debug('Endpoint::'+END_POINT);
	        return response;
        }
        catch(exception ex){
	        ApexPages.Message m = new ApexPages.Message(ApexPages.severity.Error,  ex.getMessage());
	        ApexPages.addMessage(m); 
	        return null;
    	}
	}    
   
}