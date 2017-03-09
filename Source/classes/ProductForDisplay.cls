public class ProductForDisplay{
        public string businessArea{get;set;}
        public string productName{get;set;} 
        public string price{get;set;}   
    
    static testMethod void testProductForDisplay(){
        ProductForDisplay p = new ProductForDisplay();
        p.businessArea = 'abc'; 
        p.productName = 'cde';
        p.price = '1.23';
    }
}