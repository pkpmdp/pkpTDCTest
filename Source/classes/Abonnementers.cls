public class Abonnementers {
	//The Below wrapper class contains all the necessary fields.
         public string ProductCategory{get;set;}
         public string ProductName{get;set;}
         public string productSummary{get;set;}
         public string sorteringsgruppe{get;set;}
         public String totalpris{get;set;}
         public string betalingsperiode{get;set;}
         public String pris{get;set;}
         public String varenr{get;set;}
         public String priceSuffix{get;set;}
         public String Product{get;set;}
         public String SerieNr{get;set;}
		 // pkp
    
    static testMethod void testAbonnementers(){
        Abonnementers a = new Abonnementers();
        a.ProductCategory = 'clear';
        a.ProductName = 'youbio';
        a.productSummary = 'abc';
        a.sorteringsgruppe = 'def';
        a.totalpris = '120.25';
        a.betalingsperiode = 'hhh';
        a.pris = '25.23';
        a.varenr = '234123';
        a.priceSuffix ='ggg';
        a.Product = 'kio';
        a.SerieNr = '542123';
    }

}