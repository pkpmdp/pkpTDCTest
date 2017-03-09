public class SampleController {
    private Aria_API_Configuration__c config { get; private set; }
    Account customer = new Account();
    public String fakturaid{get;set;}
    public Decimal ariaAccountNo;

    public String comments{get;set;}
    public String selectComments{get;set;}
    public String creditType {get; set;}
    //public String RadioType {get; set;}
    public transient HttpResponse klipresRefund;
    public List<SelectOption> commentsList{get;set;}
    
    public HttpResponse response;
    public PageReference pageRef = null;
    
    public Aria_Account__c ariaAcc {get; set;}
    public boolean IsBBs {get; set;}
    public boolean showForbrug {get; set;}
    public boolean IsBB {get; set;}
    public String PageAriaId{get;set;}
    public boolean NoKlippikort{get; set;}
    public boolean allForm{get; set;}
    public ApexPages.StandardController controller {get; set;}
    public list<Invoice_Payment__c> listInvPay = new list<Invoice_Payment__c> ();
    public transient HttpResponse res;     
    public List<BlockBusterKlipStatus> BBKlipStatus; 
    public Account acc; 
    public integer klipCount {get; set;}
    public Decimal Amount = 0.0;
    public Decimal AmountFull = 0.0;
    public Decimal koda = 0.0;
    public String titleName{get;set;}
    public Map<String,String> mapforErrorMessageODP {get;set;}
    public Map<String,String> mapforErrorMessageAria {get;set;}
    public boolean isFullRefund{get; set;} // SPOC-2037
    public boolean isFullRefundrender{get; set;} // SPOC-2037
    // Controller
    public SampleController (ApexPages.StandardController controller){
       
        customer = (Account)controller.getRecord(); 
        fakturaId = ApexPages.currentPage().getParameters().get('Fid');
        //titleName = ApexPages.currentPage().getParameters().get('title');
        creditType='1';
        config = CarrieCommonUtil.validateAPIConfiguration(config);
        //ariaAccountNo = customer.Aria_Account_No__c;  
        if(fakturaId!=null)
            titleName = [SELECT Titel__c,id from Invoice_Payment__c where Faktura__c =:fakturaId limit 1].Titel__c;
        
        this.controller = controller;
    
               
        Aria_Account__c ariaAcc = new Aria_Account__c();
        acc = new Account();
        try{
            acc = [select Id,Betaler_ID__c,Brands__c,Customer_No__c  from Account where Id =: controller.getRecord().Id];
            ariaAcc = [select Id,Aria_Plan_Name__c,account__c from Aria_Account__c where account__c =: acc.Id];
           
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Carrie_Exception));
            return;
        }  
        
        mapforErrorMessageODP = new Map<String, String>
        {'1001' => 'User not found'
         
        };
       
       mapforErrorMessageAria = new Map<String, String>
       {
        
       };
                          /*listInvPay =  BlockbusterKlipkrtRefndController.lastFaktura(controller.getRecord().Id);
     system.debug('listInvPay *** '+listInvPay);
                if(listInvPay.size() == 0)
                {
                    NoKlippikort = true;
                    allForm = false;
                }
                else
                {
                    NoKlippikort = false;
                    allForm = true;
                }*/
    }
    
    public void pageActionFun()
    {
        list<Invoice_Payment__c> list1 = BlockbusterKlipkrtRefndController.lastFaktura(acc.Id);
        System.debug(' ****** Latest invoice '+list1);
        res = BlockBusterODPServices.getKlipsStatus(acc.Customer_No__c); 
        BBKlipStatus = new List<BlockBusterKlipStatus>();
        string resBody = res.getbody();
        if(Test.isRunningTest() == true)
        {
            //resBody = '{"clipcards":[{"ref":"7d4d8e4ad9cfaa759b8225b6c03ad4b4","product_id":"1","price":"9900","created_at":"2014-11-10 05:11:23","title":"Klippekort","num_clip":"3","clips":[{"id":"268","expires_at":"2015-11-10 05:11:23","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"269","expires_at":"2015-11-10 05:11:23","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"270","expires_at":"2015-11-10 05:11:23","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"97c5e41ed3c91375912cbce05c47718d","product_id":"1","price":"9900","created_at":"2014-11-10 05:11:48","title":"Klippekort","num_clip":"3","clips":[{"id":"271","expires_at":"2015-11-10 05:11:48","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"272","expires_at":"2015-11-10 05:11:48","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"273","expires_at":"2015-11-10 05:11:48","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"93db07a2ee07942dc916685bddeac3a4","product_id":"1","price":"9900","created_at":"2014-11-10 05:12:16","title":"Klippekort","num_clip":"3","clips":[{"id":"274","expires_at":"2015-11-10 05:12:16","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"275","expires_at":"2015-11-10 05:12:16","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"276","expires_at":"2015-11-10 05:12:16","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"bac050dde7a5666b88d801d1a22378e1","product_id":"1","price":"9900","created_at":"2014-11-12 06:54:26","title":"Klippekort","num_clip":"3","clips":[{"id":"412","expires_at":"2015-11-12 06:54:26","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"413","expires_at":"2015-11-12 06:54:26","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"414","expires_at":"2015-11-12 06:54:26","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"d13a11881289d904c68b5cc7cb7e7094","product_id":"1","price":"9900","created_at":"2014-11-12 06:54:38","title":"Klippekort","num_clip":"3","clips":[{"id":"415","expires_at":"2015-11-12 06:54:38","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"416","expires_at":"2015-11-12 06:54:38","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"417","expires_at":"2015-11-12 06:54:38","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"03618b24a49e81f95f3d3dfddaed1502","product_id":"1","price":"9900","created_at":"2014-11-12 06:54:52","title":"Klippekort","num_clip":"3","clips":[{"id":"418","expires_at":"2015-11-12 06:54:52","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"419","expires_at":"2015-11-12 06:54:52","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"420","expires_at":"2015-11-12 06:54:52","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"88300c4bf21e9fd0a29d2edc076db5de","product_id":"1","price":"9900","created_at":"2014-11-12 06:55:08","title":"Klippekort","num_clip":"3","clips":[{"id":"421","expires_at":"2015-11-12 06:55:08","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"422","expires_at":"2015-11-12 06:55:08","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"423","expires_at":"2015-11-12 06:55:08","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"9b1bc64e8c37a7f58e65e557539156aa","product_id":"1","price":"9900","created_at":"2014-11-12 06:55:30","title":"Klippekort","num_clip":"3","clips":[{"id":"424","expires_at":"2015-11-12 06:55:30","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"425","expires_at":"2015-11-12 06:55:30","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"426","expires_at":"2015-11-12 06:55:30","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"008512ad1b9af4adff3d73f68ad9a1b9","product_id":"1","price":"9900","created_at":"2014-11-12 06:55:48","title":"Klippekort","num_clip":"3","clips":[{"id":"427","expires_at":"2015-11-12 06:55:48","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"428","expires_at":"2015-11-12 06:55:48","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"429","expires_at":"2015-11-12 06:55:48","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"89bb7bc0267bcf75d97acfb1c0d98538","product_id":"1","price":"9900","created_at":"2014-11-12 06:56:05","title":"Klippekort","num_clip":"3","clips":[{"id":"430","expires_at":"2015-11-12 06:56:05","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"431","expires_at":"2015-11-12 06:56:05","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"432","expires_at":"2015-11-12 06:56:05","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"2f4a5574747045512bc9fc8ff8c1a13f","product_id":"1","price":"9900","created_at":"2014-11-12 06:58:41","title":"Klippekort","num_clip":"3","clips":[{"id":"433","expires_at":"2015-11-12 06:58:41","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"434","expires_at":"2015-11-12 06:58:41","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"435","expires_at":"2015-11-12 06:58:41","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"dfe6d5160494e0a2908b218e855e6846","product_id":"1","price":"9900","created_at":"2014-11-12 07:13:01","title":"Klippekort","num_clip":"3","clips":[{"id":"436","expires_at":"2015-11-12 07:13:01","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"437","expires_at":"2015-11-12 07:13:01","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"438","expires_at":"2015-11-12 07:13:01","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"ed62821972fcee2a6ca6b051d103107d","product_id":"1","price":"9900","created_at":"2014-11-12 07:13:27","title":"Klippekort","num_clip":"3","clips":[{"id":"439","expires_at":"2015-11-12 07:13:27","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"440","expires_at":"2015-11-12 07:13:27","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"441","expires_at":"2015-11-12 07:13:27","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"2d5da5c4bce390c8c7f1f943e2204a52","product_id":"1","price":"9900","created_at":"2014-11-12 07:15:57","title":"Klippekort","num_clip":"3","clips":[{"id":"442","expires_at":"2015-11-12 07:15:57","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"443","expires_at":"2015-11-12 07:15:57","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"444","expires_at":"2015-11-12 07:15:57","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"2fd6db31fac45ee7553696fbd59f8cf3","product_id":"1","price":"9900","created_at":"2014-11-12 07:16:17","title":"Klippekort","num_clip":"3","clips":[{"id":"445","expires_at":"2015-11-12 07:16:17","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"446","expires_at":"2015-11-12 07:16:17","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"447","expires_at":"2015-11-12 07:16:17","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"97229e0eeb4d8e30e61e1ed64312524e","product_id":"1","price":"9900","created_at":"2014-11-12 07:16:36","title":"Klippekort","num_clip":"3","clips":[{"id":"448","expires_at":"2015-11-12 07:16:36","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"449","expires_at":"2015-11-12 07:16:36","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"450","expires_at":"2015-11-12 07:16:36","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"aab474fe0dc79c8c5466edd4753aad1b","product_id":"1","price":"9900","created_at":"2014-11-12 07:18:24","title":"Klippekort","num_clip":"3","clips":[{"id":"451","expires_at":"2015-11-12 07:18:24","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"452","expires_at":"2015-11-12 07:18:24","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"453","expires_at":"2015-11-12 07:18:24","updated_at":null,"state":"free","price":null,"order_type":null}]},{"ref":"1e1108b3267203f3ae6cf9801e6c2b21","product_id":"1","price":"9900","created_at":"2014-11-12 07:18:44","title":"Klippekort","num_clip":"3","clips":[{"id":"454","expires_at":"2015-11-12 07:18:44","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"455","expires_at":"2015-11-12 07:18:44","updated_at":null,"state":"free","price":null,"order_type":null},{"id":"456","expires_at":"2015-11-12 07:18:44","updated_at":null,"state":"free","price":null,"order_type":null}]}]}';
            resbody ='{"clipcards":[{"ref":"7736ba4b25c5c0bc270fbd94fc88a931","product_id":"1","price":"9900","koda":244,"created_at":"2015-01-30 12:54:26","title":"Klippekort","num_clip":"3","clips":[{"id":"1225","expires_at":"2016-01-30 12:54:26","updated_at":null,"state":"free","price":null,"price_koda":3300,"koda":81,"order_type":null},{"id":"1226","expires_at":"2016-01-30 12:54:26","updated_at":null,"state":"free","price":null,"price_koda":3300,"koda":81,"order_type":null},{"id":"1227","expires_at":"2016-01-30 12:54:26","updated_at":null,"state":"free","price":null,"price_koda":3300,"koda":81,"order_type":null}]},{"ref":"acf54af4c41de4e775f52e0237208535","product_id":"1","price":"9900","koda":244,"created_at":"2015-01-30 12:54:50","title":"Klippekort","num_clip":"3","clips":[{"id":"1228","expires_at":"2016-01-30 12:54:50","updated_at":null,"state":"free","price":null,"price_koda":3300,"koda":81,"order_type":null},{"id":"1229","expires_at":"2016-01-30 12:54:50","updated_at":null,"state":"free","price":null,"price_koda":3300,"koda":81,"order_type":null},{"id":"1230","expires_at":"2016-01-30 12:54:50","updated_at":null,"state":"free","price":null,"price_koda":3300,"koda":81,"order_type":null}]},{"ref":"5caee54bcff133914d5ea5f7547490c4","product_id":"1","price":"9900","koda":244,"created_at":"2015-01-30 12:55:15","title":"Klippekort","num_clip":"3","clips":[{"id":"1231","expires_at":"2016-01-30 12:55:15","updated_at":null,"state":"free","price":null,"price_koda":3300,"koda":81,"order_type":null},{"id":"1232","expires_at":"2016-01-30 12:55:15","updated_at":null,"state":"free","price":null,"price_koda":3300,"koda":81,"order_type":null},{"id":"1233","expires_at":"2016-01-30 12:55:15","updated_at":null,"state":"free","price":null,"price_koda":3300,"koda":81,"order_type":null}]}]}';
        }
        BBKlipStatus = BlockbusterParse.parseKlipsStatus(resBody);
        integer count=0;
        if(resBody != '')
        {
            if(BBKlipStatus.size() > 0)
            {
                // Pickup all klippekort and calculte total no of free clips
                count = 0;
                for(BlockBusterKlipStatus klip: BBKlipStatus)
                {
                    for(BlockBusterKlipStatus.clipDets klip1: klip.clips)
                    {
                        if(klip1.state == 'free')
                        {
                            count++;
                        }
                    }
                }
                system.debug('Klippikort **** '+count);
            }
        }
        if(count < 3 && count >0)
        {
                isFullRefundrender = true;
        }
       klipCount = count;
       BlockBusterKlipStatus BBstatus;
        integer freeCount = 0;
        system.debug('BBKlipStatus ******* '+BBKlipStatus.size());
        if(resBody != '')
        {
            if(BBKlipStatus.size() > 0)
            {
                // Pickup latest klipkort and calculate free klips
                BBstatus = BBKlipStatus[BBKlipStatus.size()-1];// 
                system.debug('******* BBSTATUS clip *****'+BBKlipStatus[BBKlipStatus.size()-1]);
                koda=Decimal.valueOf(BBKlipStatus[BBKlipStatus.size()-1].koda)/100;//Implemented for Spoc-1978
                system.debug('Koda value' + koda); 
                freeCount = 0;
                for(BlockBusterKlipStatus.clipDets klip: BBstatus.clips)
                {
                    if(klip.state == 'free')
                    {
                        //koda += Decimal.valueOf(klip.koda)/100; Commented for New implementation of Spoc-1978
                        freeCount++;
                    }
                }
                system.debug('***** Count ****** '+freeCount);
                	Amount = ((Integer.valueOf(BBstatus.price)/3)*freeCount)/100;
                	AmountFull = ((Integer.valueOf(BBstatus.price)/3)*3)/100;
                system.debug('**** Amount ******* '+Amount);
            }
        }
    }
    
    //check wherthr invoice is klippikort or non-klippikort
    public pagereference onGemClick()
    {
        if(fakturaId == null)
        {
             if(selectComments==null || selectComments=='')
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Value kræves Bemærkning feltet'));
                return null;
            }
            else
            {
                listInvPay =  BlockbusterKlipkrtRefndController.lastFaktura(controller.getRecord().Id);
                system.debug('listInvPay *** '+listInvPay);
                if(listInvPay.size() == 0)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Ingen Klippikort fakturaer er til stede for denne kunde'));
                    return null;
                }
                else
                {
                    system.debug('listInvPay *** '+listInvPay);
                    List<Invoice_Subscription__c> listAllKlipikort =  BlockbusterKlipkrtRefndController.PageLoadFun(controller.getRecord().Id, selectComments,listInvPay);
                    //
                    string errCode;
                    if(isFullRefund == true)
                    {
                    	klipresRefund = BlockBusterCallOut.IssueRefundKlippikort(listInvPay, selectComments, listAllKlipikort,AmountFull,koda,isFullRefund);
                    	errCode = BlockbusterKlipkrtRefndController.klipRefund(listAllKlipikort,listInvPay, controller.getRecord().Id, selectComments,klipresRefund,AmountFull,'1');
                    }
                    else
                    {
                    	klipresRefund = BlockBusterCallOut.IssueRefundKlippikort(listInvPay, selectComments, listAllKlipikort,Amount,koda,isFullRefund);
                    	errCode = BlockbusterKlipkrtRefndController.klipRefund(listAllKlipikort,listInvPay, controller.getRecord().Id, selectComments,klipresRefund,amount,'0');
                    }
	                if(!String.isBlank(errCode))
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errCode));
                        return null;
                    }
                }
                
            }
            PageReference pageRef = new PageReference('/'+controller.getRecord().Id); 
            pageRef.setRedirect(true);
            return pageRef;
        }
        else
        {
            pageRef = save();
            /*pageRef = new PageReference('/'+controller.getRecord().Id); 
            pageRef.setRedirect(true);
            return pageRef;*/
        return pageRef;
        }
    }
    
    public pagereference save()
    {   
        Pagereference pr;
        System.debug('In Save method ***** ');
        if(selectComments==null || selectComments=='')
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Value kræves Bemærkning feltet'));
            return null;
        }
        else{
                try{
                    Map<String,Invoice_Subscription__c> MapprodnavnToInvSubs = new Map<String,Invoice_Subscription__c>();
                    for(Invoice_Subscription__c inIS : [SELECT Amount__c,Comments__c,Faktura_line_no__c,Faktura__c,Id,Invoice_Number__c,
                                                            IsDeleted,Name,Periode__c,Plan_Name__c,
                                                                Pris_pr_md__c,Service_Name__c FROM Invoice_Subscription__c where Faktura__c =:fakturaId])
                    MapprodnavnToInvSubs.put(inIS.Service_Name__c,inIS);
                  //  system.debug('*****************************'+Comments__c);
                    
                    //if(MapprodnavnToInvSubs.containsKey('Klippekort'))
                        //RefundForKlippKort(fakturaid,MapprodnavnToInvSubs.values());
                    //else
                       pr  = RefundForNonKlippkort(fakturaid,MapprodnavnToInvSubs.values());   
             
                }
                catch(exception e){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
                    return null;
                }
            }
         /*Aria_Account__c listAcct = [select id,Account__c from Aria_Account__c where Account__c =: controller.getRecord().Id limit 1];
         System.debug(listAcct);
         pageRef = new PageReference('/'+listAcct.Account__c); 
         pageRef.setRedirect(true);*/
         return pr;
              
    }
 public PageReference redirectPage() 
    {
   
        Aria_Account__c listAcct1 = [select id,Account__c from Aria_Account__c where Account__c =: controller.getRecord().Id limit 1];
       System.debug(listAcct1);
       PageReference pageRef = new PageReference('/'+listAcct1.Account__c); 
         pageRef.setRedirect(true);
        return pageRef;
    }  
     
    
    public BlockBusterRefundDetailsWrapper objBBRefundDetails;
    public BlockBusterIssueRefundWrapper objBBIssueRef;
    public List<BlockBusterCreditCardTransact> listGetCredit;
    public transient HttpResponse resRefund;
    public transient HttpResponse resrefDet;
    public transient HttpResponse getRegisResp;
    public transient HttpResponse cancelRegisResp;
    public String respIssueRefund = '';
    public String respRefundDetails = ''; 
    public String getRegistr;
    public String cancelRegis;
    
    public pagereference RefundForNonKlippkort(String Fakturaid,List<Invoice_Subscription__c>lstInvSubs){
        /*List<Payment_Invoice__c>lstPayInv = new List<Payment_Invoice__c>([SELECT Account__c,Amount_Applied__c,                                                            
                                                            Amount__c,Applied_Against__c,Aria_Account__c,
                                                                Aria_Account__r.Aria_Account_No__c,Balance__c,
                                                                    checkPaymentApplied__c,CommentsLong__c,Account__r.Customer_No__c,
                                                                        Comments__c,CreatedById,CreatedDate,
                                                                            Credit_Reason__c,Datoforudskrift__c,
                                                                                External_Name__c,Fakturanummer__c,
                                                                                    Faktura__c,Id,IsDeleted,isVoid__c,
                                                                                        LastModifiedById,LastModifiedDate,
                                                                                            Momspligtigt_bel_b__c,Name,
                                                                                                Payment_date_time__c,Payment_Date__c,
                                                                                                    Payment_Type__c,Payment__c,SystemModstamp,
                                                                                                        Transaction_No__c,transaction_source_id__c,
                                                                                                            Void_Date__c FROM Payment_Invoice__c where 
                                                                                                                Faktura__c = :Fakturaid and Amount_Applied__c >0]);*/
        
        List<Invoice_Payment__c>lstPayInv = new List<Invoice_Payment__c>([SELECT Account__c,Amount_Applied__c,Aria_Account__c,
                                                        Balance__c,Betalingsfrist__c,checkPaymentApplied__c,Aria_Account__r.Aria_Account_No__c,
                                                            CreatedById,CreatedDate,Datoforudskrift__c,External_Name__c,
                                                                Fakturabelob__c,Fakturanummer__c,Faktura__c,Id,Account__r.Customer_No__c,
                                                                    invoice_no__c,Invoice_Statement__c,Invoice_Type__c,
                                                                        IsDeleted,isVoid__c,LastModifiedById,LastModifiedDate,
                                                                            Momspligtigt_bel_b__c,Name,Payment_date_time__c,Payment_date__c,
                                                                                Payment__c,Refund_BB__c,Refund_button__c,Refund__c,
                                                                                    Remaining_coupons__c,Saldo__c,Service_Credit__c,sort__c,
                                                                                        statement_no__c,SystemModstamp,Titel__c,
                                                                                            Transaction_Date__c,Transaction_No__c,
                                                                                                Transaktionsdato_BB__c,Void_Date__c FROM Invoice_Payment__c 
                                                                                                    where Faktura__c =: Fakturaid and Fakturabelob__c>0]);
        if(!lstPayInv.isEmpty()){
            //if(!Test.isRunningTest()){
            
            getRegisResp = BlockBusterODPServices.getCreditTransaction(lstPayInv[0].Account__r.Customer_No__c); //get credit transaction
            
            if(getRegisResp!= null){
                                                
            getRegistr = getRegisResp.getBody();
            if(getRegistr!=''){
            
                    listGetCredit = new List<BlockBusterCreditCardTransact>();
                    listGetCredit = BlockbusterParse.parseGetCancelRegis(getRegistr);
                    system.debug('listGetCredit==='+listGetCredit);
                    
                    if(!listGetCredit.isEmpty()){
                         if(listGetCredit[0].errorcode == null){
                            BlockBusterCreditCardTransact BBCredTrans = AssignOrderId(listGetCredit,Fakturaid);// get the orderid from ODP
                            system.debug('BBCredTrans  '+BBCredTrans);
                            
                            if(BBCredTrans!=null){
                                                                    
                                if(BBCredTrans.orderid!=null){
                                    resRefund = BlockBusterCallOut.IssueRefund(lstPayInv,selectComments,lstInvSubs); //Issuing Refund
                                    
                                    if(resRefund!=null){
                
                                        respIssueRefund = resRefund.getBody();
                                        if(respIssueRefund !=''){
                                            
                                            objBBIssueRef = new BlockBusterIssueRefundWrapper();
                                            objBBIssueRef = BlockbusterParse.parseIssueRefund(respIssueRefund); //parsing refund response
                                            
                                            if(objBBIssueRef!=null){
                                                
                                                if(objBBIssueRef.error_msg=='OK'){
                                                    
                                                    resrefDet = BlockBusterCallOut.RefundDetails(String.valueOf(lstPayInv[0].Aria_Account__r.Aria_Account_No__c)); //callout to refund details
                        
                        
                                                    if(resrefDet!=null){
                                                        respRefundDetails = resrefDet.getBody();
                                                        if(respRefundDetails!=''){
                                                            
                                                            objBBRefundDetails = new BlockBusterRefundDetailsWrapper();
                                                            objBBRefundDetails = BlockbusterParse.parseRefundDetails(respRefundDetails); // parsing refund details response
                                                            
                                                            if(objBBRefundDetails!=null){
                                                                
                                                                if(objBBRefundDetails.error_msg=='OK'){ 
                                                                     
                                                                        cancelRegisResp = BlockBusterODPServices.cancelCreditTransaction(lstPayInv[0].Account__r.Customer_No__c,BBCredTrans.orderid);// deregister order
                                                                        system.debug('cancelRegisResp  '+cancelRegisResp);
                                                                        
                                                                        if(cancelRegisResp!=null)
                                                                        cancelRegis = cancelRegisResp.getBody();
                                                                        system.debug('cancelRegis  '+cancelRegis);
                                                                        Map<String,String>mapRefOrderId = new Map<String,String>();
                                                                        mapRefOrderId = (Map<String,String>)JSON.deserialize(cancelRegis,Map<String,String>.class);
                                                                        system.debug('mapRefOrderId  '+mapRefOrderId);
                                                                        if(mapRefOrderId.get('Refunded orderid')!=''){
                                                                            BlockBusterCallOut.refundMsgingForNonKlipKort(listInvPayInv, BBCredTrans); // acknowledge email sent
                                                                            BlockBusterInsertUpdate.InsertRefundDetails(objBBRefundDetails); // refund details maintained in spoc
                                                                            BlockBusterInsertUpdate.UpdateInvoicePayment(objBBRefundDetails); // updating the invoice payment
                                                                        }
                                                                }
                                                                else
                                                                {   
                                                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,objBBRefundDetails.error_msg)); 
                                                                    return null;                                        
                                                                }
                                                            }
                                                        }
                                                    }                                       
                                            
                                                }
                                                else{
                                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,objBBIssueRef.error_msg));  
                                                    return null;
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                                else
                                {
                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Film cannot be refunded')); 
                                    return null;
                                }
                            
                                }                               
                            }
                             else{
                                String errmessage = getErrorMessage(listGetCredit);
                                system.debug('errormessage'+errmessage);
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errmessage)); 
                                return null;
                                }
                            }
                        }
                    }
                //}
            

        }   
            
        pageRef = new PageReference('/'+controller.getRecord().Id); 
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public String getErrorMessage(List<BlockBusterCreditCardTransact>listCredit){
        return 'Error';
    }
    
   //public List<BlockBusterKlipStatus> BBKlipStatus;
   /*public void RefundForKlippKort(String Fakturaid,List<Invoice_Subscription__c>lstInvSubs){
        String respKlipStatus;
        String respKlipCancel; 
        respKlipStatus = BlockBusterCallOut.getKlipsForKlipKort(fakturaId);
        if(respKlipStatus!=''){
            BBKlipStatus = new List<BlockBusterKlipStatus>();
            BBKlipStatus = BlockbusterParse.parseKlipsStatus(respKlipStatus);
            if(!BBKlipStatus.isEmpty())
                Map<String,Decimal> MapAmtToRefund = BlockBusterInsertUpdate.calcRefundAmt(BBKlipStatus);
                
        }
   }*/
   List<Invoice_Payment__c> listInvPayInv = new List<Invoice_Payment__c>();
   public BlockBusterCreditCardTransact AssignOrderId(List<BlockBusterCreditCardTransact>listCredit,String fakturaId){
        
        BlockBusterCreditCardTransact objBBCredTrans = new BlockBusterCreditCardTransact();
        listInvPayInv = [SELECT Titel__c,Transaction_Date__c,Id,Faktura__c,Payment__c, Account__c ,
                                Account__r.PersonEmail,Account__r.Customer_No__c,Account__r.FirstName,Account__r.LastName FROM Invoice_Payment__c where Faktura__c =:fakturaId];
        
        system.debug('listInvPayInv '+listInvPayInv);
        system.debug('listCredit '+listCredit);
        if(!listCredit.isEmpty()){
            for(BlockBusterCreditCardTransact obj: listCredit){
                Integer compare = obj.title.compareTo(listInvPayInv[0].Titel__c);
                system.debug('compare '+compare);
                if(compare == 0)
                    objBBCredTrans = obj;
            }
        }
        system.debug('objBBCredTrans   '+objBBCredTrans);
        return objBBCredTrans;  
   }
  
    public List<SelectOption> getCreditTypes() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1','Tilbagebetal'));
        return options;
    }   

    public List<SelectOption> getRefundcommentsList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '-- Select One --'));   
             

        // Find all the reason codes in the custom setting
        Map<String, RefundCode__c> reasoncodes = RefundCode__c.getAll();
        // Sort them by name
        List<String> codenames = new List<String>();
        codenames.addAll(reasoncodes.keySet());
        codenames.sort();
        
        // Create the Select Options.
        for (String code : codenames) {
            RefundCode__c cde = reasoncodes.get(code);
            //options.add(new SelectOption(cde.Reasoncode__c, cde.Name));
            options.add(new SelectOption(cde.Name,cde.Reasoncode__c));
        }

        return options;
    }    

}