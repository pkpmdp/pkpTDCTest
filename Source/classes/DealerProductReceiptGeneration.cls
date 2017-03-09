/**********************************************************************************
************************************************************************************

* @class: DealerProductReceiptGeneration
* @author: Capgemini Consulting India Pvt. Ltd.
* @date Created: 2 Feb 2014
* @description: This Class is used to create data for DealerProductReceipt page.

************************************************************************************ 
***********************************************************************************/
public class DealerProductReceiptGeneration {

	Map<String,Object> priceObjectNodes = new  Map<String,Object>();
	public List<Abonnementers> abonometers = new List<Abonnementers>();
	public List<Abonnementers> abonnementerProducts = new List<Abonnementers>();
	public List<Abonnementers> installationProducts = new List<Abonnementers>();
	public Decimal totalInsPrice =0.0;
	boolean summaryFlag{get;set;}{summaryFlag=false;}
	List<Abonnementers> abonnementerProductsTest{get;set;}
	public Decimal totalAbnPrice =0.0;
	//String telePhoneDirectoryName{get;set;}
	//String selectedNumberForNP{get;set;}
	public List<Abonnementers> installationProductsAndTlfInfo = new List<Abonnementers>();
	String oneTimeChargeForBbTlf {get; set;}
	boolean installations = false;
	Integer Oneprice = 0;
	Integer clearOnetimeCharge = 0;
	Integer TlfNpOnetimeCharge = 0;
	Integer oneTimePriceForBoxingEvent = 0;
	boolean isYouBioAbnSelected {get ; set ;}{isYouBioAbnSelected = false;}
	boolean isYouBioBoxSelected {get ; set ;}{isYouBioBoxSelected = false;}
	
	/**
    * @method     : dynamicReceiptPageGeneration
    * @Description: create a Data for the receipt page.
    * @Version 1.0: Implemented the above mentioned task.   
    * @Invocation:  The method is invocated from DealerProductPageController3.
    */
	public void dynamicReceiptPageGeneration(String priceJsonResponse, String receiptValgtResponse,Map<String,String> productSummaryMap, Boolean telephoniFlag, String selectedNumber,String NPFutureDate, String NPCurrentDate, Boolean broadbandTelephonyCommonFlag, Boolean onlyBroadbandFlag, Boolean plusFlag, Boolean ekstrakanalerFlag, Boolean broadbandUpgradationFlag, Boolean telefoniFlag, String telePhoneDirectoryName, String selectedNumberForNP){ 
  		abonnementerProductsTest = new List<Abonnementers>();
		Map<String, Object> firstJsonResponse = (Map<String, Object>)JSON.deserializeUntyped(priceJsonResponse);
		Map<String,Object> valgtResponseMap = (Map<String, Object>)JSON.deserializeUntyped(receiptValgtResponse);
		List<Object> valgt = (List<Object>) valgtResponseMap.get('valgt');
	 	for(integer i=0;i<valgt.size();i++){
			Map<String, Object> valgtNode= (Map<String, Object>)valgt[i];               
		    String aftaletype ='';
		    String aftalenr = (String)valgtNode.get('aftalenr');
		    System.debug('value of  aftalenr is -------->'+aftalenr);
		    String aftaletypeValue = (String)valgtNode.get('aftaletype');
		    if(aftaletypeValue =='bb'){
		        aftaletype ='bredbånd';
		    }else if(aftaletypeValue =='clear'){
		        aftaletype = 'Kable TV';
		    }else if(aftaletypeValue =='dtv'){
		        aftaletype = 'Yousee Plus';  
		    }else if(aftaletypeValue =='tlf'){
		        aftaletype = 'Telefoni';
		    }else if(aftaletypeValue =='youbio'){
		        aftaletype = 'YouBio';
		    }
		    else{
		        aftaletype = aftaletypeValue;
		    } 
		    System.debug('aftaletype is -------->'+aftaletype);
		    List<Object> varer = (List<Object>)valgtNode.get('varer');		   
		    System.debug('value of  varer is -------->'+varer.size());
	    	for(integer ii=0;ii<varer.size();ii++){
		        Abonnementers abn = new Abonnementers();
		        Map<String, Object> varerNode= (Map<String, Object>)varer[ii];
		        String navn = (String)varerNode.get('navn');
		        String varenr = (String)varerNode.get('varenr');
		        String sorteringsgruppe = (String)varerNode.get('sorteringsgruppe');
		        //getting information for price from first json response
		        Map<String,Object> priceNodeValue = (Map<String,Object>) firstJsonResponse.get(varenr);
		        priceObjectNodes.put(varenr,priceNodeValue);
		        string betalingsperiode = String.ValueOf(priceNodeValue.get('betalingsperiode'));
		        Decimal sumTotalPrice = decimal.ValueOf(String.ValueOf(priceNodeValue.get('totalpris')));
		        system.debug('value of sumTotalPrice is ======='+sumTotalPrice);
		        abn.ProductName = navn; 
		        abn.ProductCategory = aftaletype;
		        abn.sorteringsgruppe = sorteringsgruppe;
		        abn.varenr = varenr;
		        abn.totalpris = String.ValueOf(priceNodeValue.get('totalpris'));
		        abn.betalingsperiode = String.ValueOf(priceNodeValue.get('betalingsperiode'));
		        abn.pris = String.ValueOf(priceNodeValue.get('pris'));
		        //Added for one time charge - Prachi
		        /*system.debug('abn ' +abn);
		        if(abn.betalingsperiode == 'enkelt'){
		        	Oneprice = Oneprice + Integer.valueOf(abn.totalpris);
		        	system.debug('one price ' +oneprice);
		        	if(aftaletype == 'clear')	
		        		clearOnetimeCharge = Integer.valueOf(abn.totalpris);
		        	else if(aftaletype=='tlf'){
                        if (varenr=='1417006'){                                    
                            TlfNpOnetimeCharge = Integer.valueOf(abn.totalpris);
                        }
                    }
                    system.debug('in enkelt.....');
                    system.debug('clearOnetimeCharge ' +clearOnetimeCharge);
                    system.debug('TlfNpOnetimeCharge ' +TlfNpOnetimeCharge);
                    installations = true;
		        }		        
		        //for boxing event
		        if(aftaletype=='dtv' && varenr=='1204006'){
		        	oneTimePriceForBoxingEvent = Integer.ValueOf(priceNodeValue.get('totalpris'));
		        }*/
	         	if(aftaletype == 'Yousee Plus' && sorteringsgruppe != '02-0090' && sorteringsgruppe != '02-0010'){
	            	if(sorteringsgruppe != '1'){
	                	summaryFlag = true;
	              	}else{
	                	summaryFlag = false;
	              	} 
	           	}else{
	            	summaryFlag = false;
	               	if(varenr == '1201590' && sorteringsgruppe != '1'){
	                  	summaryFlag = true;
	               	} 
	           	}
	           	if(aftaletype == 'clear' && varenr != '1010001' && sorteringsgruppe != '1'){
	            	summaryFlag = true;
	           	}
	           	if(aftaletype == 'bredbånd' ||  aftaletype == 'Telefoni' && sorteringsgruppe != '1'){
	              	summaryFlag = true;
	           	}
	           	if(aftaletype == 'youbio' || aftaletype == 'YouBio'){
	           		summaryFlag = true;
	           	}
	        	if(summaryFlag){
	            	try{
		            	abn.productSummary = (String)productSummaryMap.get(varenr);
		            }catch(Exception ex){
		            	
		            }
		        }else{
		        	abn.productSummary = null;
		        }
	        	system.debug('value of betalingsperiode ========'+betalingsperiode);
		        if(betalingsperiode =='maaned'){
		            abn.priceSuffix ='Kr. /md';
		            totalAbnPrice = totalAbnPrice + sumTotalPrice;
		            abonnementerProducts.add(abn);
		            isYouBioAbnSelected = true;
		        }else{
		            abn.priceSuffix ='Kr.';
		            totalInsPrice = totalInsPrice + sumTotalPrice;
		            installationProducts.add(abn);
		            isYouBioBoxSelected = true;
		        }
		        abonometers.add(abn);
	    	}
		}
		abonnementerProductsTest.addAll(abonnementerProducts);
		system.debug('telePhoneDirectoryName----'+telePhoneDirectoryName+'----selectedNumberForNP----'+selectedNumberForNP+'--telephoniFlag--'+
	    			telephoniFlag+'---selectedNumber---'+selectedNumber+'--NPFutureDate--'+NPFutureDate+'---NPCurrentDate--'+NPCurrentDate);
		addTelofoniInfo(installationProducts,telephoniFlag,selectedNumber,NPFutureDate,NPCurrentDate,telePhoneDirectoryName,selectedNumberForNP);
		getOneTimeChargeForBbTlf(broadbandTelephonyCommonFlag, onlyBroadbandFlag, plusFlag, ekstrakanalerFlag, broadbandUpgradationFlag, telefoniFlag);
		system.debug('this is the response value of abonometers   in dynamicReceiptPageGeneration  ----'+JSON.serialize(abonometers));
		system.debug('this is the response value of abonometers   in dynamicReceiptPageGeneration  ----'+JSON.serialize(installationProducts));
  	} 
   public boolean updateYouBioAbnSelectedStatus(){
   		return isYouBioAbnSelected;
   }
   public boolean updateYouBioBoxSelectedStatus(){
   		return isYouBioBoxSelected;
   }
   private void  addTelofoniInfo(List<Abonnementers> installationProducts, boolean telephoniFlag, String selectedNumber, String NPFutureDate, String NPCurrentDate, String telePhoneDirectoryName, String selectedNumberForNP){    	
		system.debug('This is my addTelofoniInfo method Start');
		Abonnementers abno;
		installationProductsAndTlfInfo.addAll(installationProducts);   
		system.debug('This is my installationProductsAndTlfInfo value in the beginning ---'+JSON.serialize(installationProductsAndTlfInfo));         
	    if (telePhoneDirectoryName=='visalt'){
	        telePhoneDirectoryName='';
	        telePhoneDirectoryName='Kunden ønsker at stå opført i telefonbogen';
	    } else if (telePhoneDirectoryName=='althemmeligt'){
	        telePhoneDirectoryName='';
	        telePhoneDirectoryName='Hemmelige kundedata';
	    } else if (telePhoneDirectoryName=='hemmeligtnummer'){
	        telePhoneDirectoryName='';
	        telePhoneDirectoryName='Hemmeligt nummer';
	    } else if (telePhoneDirectoryName=='hemmeligadresse'){
	        telePhoneDirectoryName='';
	        telePhoneDirectoryName='Hemmelig adresse';
	    }
		try {
	        if(telePhoneDirectoryName!=null && telePhoneDirectoryName!=''){
	        	abno = new Abonnementers();
	            abno.ProductCategory = 'Telefonbogsoplysninger';
	            abno.ProductName=telePhoneDirectoryName;
	            installationProductsAndTlfInfo.add(abno);
	        }
	        if(selectedNumberForNP!=null && selectedNumberForNP!='' && telephoniFlag==false){
	        	abno = new Abonnementers();
	            abno.ProductCategory = 'Nuværende telefonnummer';
	            abno.ProductName=selectedNumberForNP;
	            installationProductsAndTlfInfo.add(abno);
	        }
	        if (selectedNumber!=null && selectedNumber!='' && telephoniFlag==true){
	        	abno = new Abonnementers();
	            abno.ProductCategory = 'Valgte telefonnummer';
	            abno.ProductName=selectedNumber;
	            installationProductsAndTlfInfo.add(abno);
	        }
	        if (NPFutureDate!='' && NPFutureDate!=null){
	        	abno = new Abonnementers();
	            abno.ProductCategory = 'Når bindings-/opsigelsesperioden er afsluttet i nuværende teleselskab – typisk 30 dages opsigelse';
	            abno.ProductName='';
	            installationProductsAndTlfInfo.add(abno);
	        }
	        if (NPCurrentDate!='' && NPCurrentDate!=null){
	        	abno = new Abonnementers();
	            abno.ProductCategory = 'Ønskedato';
	            abno.ProductName = NPCurrentDate;
	            installationProductsAndTlfInfo.add(abno);
	        }
	        system.debug('This is my addTelofoniInfo method End ---');
	        system.debug('This is my installationProductsAndTlfInfo value in the End ---'+JSON.serialize(installationProductsAndTlfInfo));
	    }
	    catch(Exception ex){
	        // Error: in addTelofoniInfo method:
	        system.debug('This is Error: in addTelofoniInfo method----- '+ex.getMessage());
	    }
	}
    
    public String getOneTimeChargeForBbTlf(Boolean broadbandTelephonyCommonFlag, Boolean onlyBroadbandFlag, Boolean plusFlag, Boolean ekstrakanalerFlag, Boolean broadbandUpgradationFlag, Boolean telefoniFlag){
		Integer oneTime = 0;
		Integer dealerPrice = 0; 
		oneTimeChargeForBbTlf = '0';
		system.debug('installations ' +installations);
		Integer dummy = Integer.valueOf(String.valueOf(Oneprice).split('\\.')[0]);
		if(installations){
			if(String.valueOf(dummy).length() == 2){
	            dummy = dummy - Integer.valueOf(String.valueOf(clearOnetimeCharge).split('\\.')[0]);
	            if (broadbandTelephonyCommonFlag || onlyBroadbandFlag ||plusFlag || ekstrakanalerFlag ||broadbandUpgradationFlag||telefoniFlag)
	            	oneTimeChargeForBbTlf = String.valueOf(dummy) + '.00';
	            system.debug('dummy lenth = 2' + dummy);		               
	        }
	        else if (String.valueOf(dummy).length() == 1){
	        	dummy = dummy - Integer.valueOf(String.valueOf(clearOnetimeCharge).split('\\.')[0]) - Integer.valueOf(String.valueOf(TlfNpOnetimeCharge).split('\\.')[0]);
	        	if (broadbandTelephonyCommonFlag || onlyBroadbandFlag ||plusFlag || ekstrakanalerFlag||broadbandUpgradationFlag ||telefoniFlag)
	        		oneTimeChargeForBbTlf = String.valueOf(dummy) + '.00';
	        	system.debug('dummy lenth = 1' + dummy);		       		
	        } 
	        system.debug('dummy ' + dummy + ' oneTimePriceForBoxingEvent ' + oneTimePriceForBoxingEvent);
	        oneTimeChargeForBbTlf = String.valueOf(dummy - oneTimePriceForBoxingEvent) + '.00';
	        system.debug('oneTimeChargeForBbTlf ' +oneTimeChargeForBbTlf);
		}
		else    
        	oneTimeChargeForBbTlf = String.valueOf(dealerPrice) + '.00';
        system.debug('oneTimeChargeForBbTlf aaaaaa' +oneTimeChargeForBbTlf);	
        return 	oneTimeChargeForBbTlf;  
	}  
 	public List<Abonnementers> getInstProdSrlNumbers(String productJsonArray) {
	    string instProSrlNo = productJsonArray;
	    system.debug('value of instProSrlNo in getInstProdSrlNumbers is  '+instProSrlNo);
	    List<Abonnementers> instProSrlNoLstNow = new List<Abonnementers>();
	    String emptyInstProSrlNo = '{}';
	    if(!instProSrlNo.contains(emptyInstProSrlNo)){
	    	List<Object> instProSrlNoLst = (List<Object>) JSON.deserializeUntyped(instProSrlNo);
    	    for(Integer index = 0;index <instProSrlNoLst.size();index++){
		        Abonnementers abnSrlNoPdt= new Abonnementers();
		        Map<String, Object> abnSrlNode= (Map<String, Object>)instProSrlNoLst[index];
		        abnSrlNoPdt.Product = (String)abnSrlNode.get('Product'); 
		        abnSrlNoPdt.SerieNr = 'Serienr. '+(String)abnSrlNode.get('SerieNr');
		        instProSrlNoLstNow.add(abnSrlNoPdt);
	    	}
	    }
	    return instProSrlNoLstNow;
	} 
}