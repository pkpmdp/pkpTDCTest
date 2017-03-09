public with sharing class spoc2019compController {

	public spoc2019cmp_cls objwrap{get;set;}
	
	public spoc2019compController(){
		objwrap = new spoc2019cmp_cls();
		objwrap.listAudVidMac = new List<SelectOption>();
		objwrap.listAudVidMac = BBW2CPicklistValues.getAudVidMac();
		objwrap.listIntSupplMac = BBW2CPicklistValues.getIntSupplMac();
		objwrap.listIntConTypeMac = BBW2CPicklistValues.getIntConTypeMac();
        objwrap.listSmtTVUpd = BBW2CPicklistValues.getSmtTVUpdTV();
        
        System.debug('****-->'+objwrap.listAudVidMac);
	}	
	
}