public with sharing class BlockbusterParse {

	public static BlockBusterIssueRefundWrapper parseIssueRefund(String refBody){
		 BlockBusterIssueRefundWrapper inv = new BlockBusterIssueRefundWrapper();
		 try{
	           JSONParser parser = JSON.createParser(refBody);
				while (parser.nextToken() != null) {
		        // Start at the array of response.
			        system.debug(' parseIssueRefund *** parser.getCurrentToken()=1=='+parser.getCurrentToken());
			        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
			            
		                // Advance to the start object marker to       			              
	                    // Read entire response object, including its array of line items.
	                    inv = (BlockBusterIssueRefundWrapper)parser.readValueAs(BlockBusterIssueRefundWrapper.class);	                    
	                    //listBBRIssuerefund.add(inv);
	                    system.debug('BlockBusterIssueRefundWrapper: ' + inv);
	                    // For debugging purposes, serialize again to verify what was parsed.
	                    String s = JSON.serialize(inv);
	                    system.debug('Serialized invoice: ' + s);
			        }
	    		}
           
        }catch(Exception e){
                system.debug('%%Inside response catch#'+e.getMessage());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error in Response'+e.getMessage()));
            	
        } 
		return inv;
	}
	
	
	public static BlockBusterRefundDetailsWrapper parseRefundDetails(String refDetBody){
		List<BlockBusterRefundDetailsWrapper>listBBRefundDetails = new List<BlockBusterRefundDetailsWrapper>();
		BlockBusterRefundDetailsWrapper inv = new BlockBusterRefundDetailsWrapper();
		try{
	           JSONParser parser = JSON.createParser(refDetBody);
				while (parser.nextToken() != null) {
		        // Start at the array of response.
			        system.debug('parseRefundDetails *** parser.getCurrentToken()=1=='+parser.getCurrentToken());
			        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
			            
		                // Advance to the start object marker to       			              
	                    // Read entire response object, including its array of line items.
	                    inv = (BlockBusterRefundDetailsWrapper)parser.readValueAs(BlockBusterRefundDetailsWrapper.class);	                    
	                    system.debug('BlockBusterRefundDetailsWrapper: ' + inv);
	                    // For debugging purposes, serialize again to verify what was parsed.
	                    listBBRefundDetails.add(inv);
	                    
	                    String s = JSON.serialize(inv);
	                    system.debug('Serialized invoice: ' + s);
			        }
	    		}
           
        }catch(Exception e){
                system.debug('%%Inside response catch#'+e.getMessage());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error in Response'+e.getMessage()));
            	
        } 
		return inv;
	}
	
	public static List<BlockBusterKlipStatus> parseKlipsStatus(String refDetBody){
		
		List<BlockBusterKlipStatus>listBBKlipsStatus = new List<BlockBusterKlipStatus>();
		BlockBusterKlipStatus inv = new BlockBusterKlipStatus();
		try{
	           JSONParser parser = JSON.createParser(refDetBody);
				while (parser.nextToken() != null) {
					if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
						while (parser.nextToken() != null) {
				        // Start at the array of response.
					        system.debug('parser.getCurrentToken()=1=='+parser.getCurrentToken());
					        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
					            
				                // Advance to the start object marker to       			              
			                    // Read entire response object, including its array of line items.
			                    inv = (BlockBusterKlipStatus)parser.readValueAs(BlockBusterKlipStatus.class);	                    
			                    system.debug('BlockBusterRefundDetailsWrapper: ' + inv);
			                    // For debugging purposes, serialize again to verify what was parsed.
			                    listBBKlipsStatus.add(inv);
			                    system.debug('listBBKlipsStatus: ' + listBBKlipsStatus);
			                    String s = JSON.serialize(inv);
			                    system.debug('Serialized invoice: ' + s);
					        }
			    		}
					}
				}
           
        }catch(Exception e){
                system.debug('%%Inside response catch#'+e.getMessage());
               // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error in Response'+e.getMessage()));
            	
        } 
		return listBBKlipsStatus;
	}
	
	public static List<BlockBusterCancelKlips> parseCancelKlips(String refDetBody){
		
		List<BlockBusterCancelKlips>listBBKlipsStatus = new List<BlockBusterCancelKlips>();
		BlockBusterCancelKlips inv = new BlockBusterCancelKlips();
		try{
	           JSONParser parser = JSON.createParser(refDetBody);
				//while (parser.nextToken() != null) {
					//if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
						while (parser.nextToken() != null) {
				        // Start at the array of response.
					        system.debug('parser.getCurrentToken()=1=='+parser.getCurrentToken());
					        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
					            
				                // Advance to the start object marker to       			              
			                    // Read entire response object, including its array of line items.
			                    inv = (BlockBusterCancelKlips)parser.readValueAs(BlockBusterCancelKlips.class);	                    
			                    system.debug('BlockBusterRefundDetailsWrapper: ' + inv);
			                    // For debugging purposes, serialize again to verify what was parsed.
			                    listBBKlipsStatus.add(inv);
			                    system.debug('listBBKlipsStatus: ' + listBBKlipsStatus);
			                    String s = JSON.serialize(inv);
			                    system.debug('Serialized invoice: ' + s);
					        }
			    		}
					//}
				//}
           
        }catch(Exception e){
                system.debug('%%Inside response catch#'+e.getMessage());
               // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error in Response'+e.getMessage()));
            	
        } 
		return listBBKlipsStatus;
	}
	
	
	public static List<BlockBusterCreditCardTransact> parseGetCancelRegis(String refBody){ 
		 BlockBusterCreditCardTransact inv = new BlockBusterCreditCardTransact();
		 List<BlockBusterCreditCardTransact> listinv = new List<BlockBusterCreditCardTransact>();
		 try{
	           JSONParser parser = JSON.createParser(refBody);
				while (parser.nextToken() != null) {
		        // Start at the array of response.
			        system.debug(' parseIssueRefund *** parser.getCurrentToken()=1=='+parser.getCurrentToken());
			        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
			            while(parser.nextToken() != null){
			            	if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getCurrentName() == 'creditcardtransactions'){
			            		system.debug(' parseIssueRefund *** parser.getCurrentToken()=2=='+parser.getCurrentToken());			            		    
					            		while(parser.nextToken() != null){
					            		if(parser.getCurrentToken() == JSONToken.START_ARRAY){
						            	   system.debug(' parseIssueRefund *** parser.getCurrentToken()=3=='+parser.getCurrentToken());  
								            	while(parser.nextToken() != null){
								            	if(parser.getCurrentToken() == JSONToken.START_OBJECT){
									            	system.debug(' parseIssueRefund *** parser.getCurrentToken()=3=='+parser.getCurrentToken());
									                // Advance to the start object marker to       			              
								                    // Read entire response object, including its array of line items.
								                    inv = (BlockBusterCreditCardTransact)parser.readValueAs(BlockBusterCreditCardTransact.class);	                    
								                    //listBBRIssuerefund.add(inv);
								                    system.debug('BlockBusterCreditCardTransact: ' + inv);
								                    // For debugging purposes, serialize again to verify what was parsed.
								                    String s = JSON.serialize(inv);
								                    system.debug('Serialized invoice: ' + s);
								                    listinv.add(inv);
								            	}
								          }
					            	 }
			            		}
			            	}
			            	else if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getCurrentName() == 'errorcode'){
			            		Map<String,String>mapErr = new Map<String,String>();
                                mapErr = (Map<String,String>)JSON.deserialize(refBody,Map<String,String>.class);
                                BlockBusterCreditCardTransact obj = new BlockBusterCreditCardTransact(mapErr.get('errorcode'),mapErr.get('error'));
                                listinv.add(obj);
                                system.debug('listinv' + listinv);
			            	}
			            }
			        }
	    		}
           
        }catch(Exception e){
                system.debug('%%Inside response catch#'+e.getMessage());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error in Response'+e.getMessage()));
            	
        } 
		return listinv;
	}
}