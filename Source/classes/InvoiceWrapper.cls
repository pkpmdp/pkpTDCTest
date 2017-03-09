public with sharing class InvoiceWrapper {

       public String Id{get;set;}
       public String Name{get;set;}
       public String suspended{get;set;}
       public String automaticCreditCardCancellationStatus{get;set;}
       public String invoiceNumber{get;set;}
       public String billSequenceNo{get;set;}
       public Boolean creditnote{get;set;}
       public String period{get;set;}
       public String balance{get;set;}
       public String vatCalculated{get;set;}
       public String amountTotalTax{get;set;}
       public String lastPaymentDate{get;set;}
       public Boolean paid{get;set;}
       public Boolean pdfDownloadable{get;set;}
       public String description{get;set;}
       public String paymentMethod{get;set;}
       public String excerptItemType{get;set;}
       public String accountNumber{get;set;}
       public String amountTotalInclVat{get;set;}
       public String documentDate{get;set;}
       public String documentNumber{get;set;} 
       public String strPartialAmt{get;set;}
       public Integer rowcount{get;set;}
       public List<GetBillsErr> error{get;set;}
       public Decimal Sample{get;set;}
       public String lastpaymentFrCal{get;set;}

}