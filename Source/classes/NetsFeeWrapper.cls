global class NetsFeeWrapper {

       /* global Invoice__c objwrapperInvoice{get;set;}
        global Boolean showPayNow{get;set;}
        global Boolean showImageFlag{get;set;}
        global String sortedInvNo{get;set;}
        global boolean showPDF {get;set;}
        global String strPartialAmt{get;set;}
        global Boolean blnShowText{get;set;}
        global Integer rowcount{get;set;}
        
        global netsFeeWrapper(Invoice__c obj,Boolean pn,Boolean Im,Boolean pdf,Boolean Text,Integer cnt){
            objwrapperInvoice = new Invoice__c();
            showPayNow = false;
            showImageFlag = false;
            showPDF = false;
            blnShowText = false;
            objwrapperInvoice = obj;
            showPayNow = pn;
            showImageFlag = Im; 
            showPDF = pdf; 
            blnShowText = Text;
            strPartialAmt = ''; 
            rowcount = cnt;
            sortedInvNo = String.valueOf(obj.Sorted_Invoice_Number__c);   
            system.debug('inside comparabel =====>'+sortedInvNo);                            
        }
        
        global Integer compareTo(Object objToCompare) {
            system.debug('inside comparabel =====>');
            NetsFeeWrapper  compareTo= (NetsFeeWrapper)objToCompare;
            if (sortedInvNo == compareTo.sortedInvNo) return 0;
            if (sortedInvNo > compareTo.sortedInvNo) return -1;
            return 1; 
        }*/
}