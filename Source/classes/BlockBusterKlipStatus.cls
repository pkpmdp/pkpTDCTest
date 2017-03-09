public with sharing class BlockBusterKlipStatus {
    
    public string ref;
    public string product_id;
    public string price;
    public string koda;//Added for Spoc-1978
    public string created_at;
    public string title;
    public string num_clip;
    public List<clipDets>clips;
    
    public class clipDets{
        public string id;
        public string expires_at;
        public string updated_at;
        public string state;
        public string price;
        public string price_koda;
        public string koda;
        public string order_type;       
    }
}