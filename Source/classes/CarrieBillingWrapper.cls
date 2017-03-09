public with sharing class CarrieBillingWrapper {
    public Integer error_code;
    public String error_msg;
    public Integer starting_record;
    public Integer total_records;
    public List<Account_details> account_details;

    public class Account_details {
        public Integer acct_no;
        public Integer senior_acct_no;
        public String user_id;
        public String password;
        public Integer status_cd;
        public Integer plan_no;
        public String first_name;
        public Integer mi;
        public String last_name;
        public String address_1;
        public String address_2;
        public String city;
        public String locality;
        public String postal_code;
        public String country;
        public Integer phone_npa;
        public Integer phone_nxx;
        public Integer phone_suffix;
        public Integer phone_extension;
        public String intl_phone;
        public String alt_email;
        public Integer client_acct_id;
        public Integer promo_cd;
        public Integer resp_level_cd;
        public Integer pay_method;
        public String created;
        public String last_updated;
        public Integer client_1;
        public String company_name;
        public List<Current_billing_info> current_billing_info;
        public String plan_name;
        public String state_prov;
        public String country_english;
        public String promo_name;
        public Integer no_provision_ind;
        public Integer bill_action_cd;
        public String status_name;
        public Decimal acct_balance;
        public List<Supp_field> supp_field;
        public Integer bill_day;
        public List<Supp_plan> supp_plan; //FIX FOR SUPP PLAN
        public String invoice_posting_method_cd;
        public String acct_start_date;
        public String pay_method_name;

    }
    
    public class Current_billing_info {
        public String billing_first_name;
        public String billing_middle_initial;
        public String billing_last_name;
        public String billing_address1;
        public String billing_address2;
        public String billing_city;
        public String billing_state;
        public String billing_locality;
        public String billing_zip;
        public String billing_country;
        public Integer billing_phone_npa;
        public Integer billing_phone_nxx;
        public Integer billing_phone_suffix;
        public Integer billing_phone_extension;
        public String billing_intl_phone;
        public String billing_email;
        public Integer billing_pay_method;
        public String billing_cc_expire_mm;
        public String billing_cc_expire_yyyy;
        public Integer billing_bank_routing_num;
        public Integer billing_agreement_id;
    }

    public class Supp_field {
        public String supp_field_name;
        public String supp_field_value;
    }
    
    /* FIX FOR SUPP PLAN */
    public class Supp_plan {
        public Integer supp_plan_no;
        public String supp_plan_name;
    }
    
    public static CarrieBillingWrapper parse(String json) {
        return (CarrieBillingWrapper) System.JSON.deserialize(json, CarrieBillingWrapper.class);
    }
    
    static testMethod void testParse() {
        String json = '{\"error_code\":0,\"error_msg\":\"OK\",\"starting_record\":0,\"total_records\":2,\"account_details\":[{\"acct_no\":3439411,\"senior_acct_no\":null,\"user_id\":\"vishalverma\",\"password\":\"capgemini2012\",\"status_cd\":-3,\"plan_no\":10263079,\"first_name\":\"Vishal\",\"mi\":null,\"last_name\":\"Verma\",\"address_1\":\"123 capgemini\",\"address_2\":\"SEP2B3\",\"city\":\"Mumbai\",\"locality\":\"Vikhroli\",\"postal_code\":\"400079\",\"country\":\"IN\",\"phone_npa\":null,\"phone_nxx\":null,\"phone_suffix\":null,\"phone_extension\":null,\"intl_phone\":\"1234567890\",\"alt_email\":\"vishal.a.verma@capgemini.com\",\"client_acct_id\":null,\"promo_cd\":null,\"resp_level_cd\":1,\"pay_method\":4,\"created\":\"2012-02-27 07:37:27\",\"last_updated\":\"2012-09-23 01:31:17\",\"client_1\":null,\"company_name\":null,\"current_billing_info\":[{\"billing_first_name\":\"Vishal\",\"billing_middle_initial\":null,\"billing_last_name\":\"Verma\",\"billing_address1\":\"123 capgemini\",\"billing_address2\":\"SEP2B3\",\"billing_city\":\"Mumbai\",\"billing_state\":null,\"billing_locality\":\"Vikhroli\",\"billing_zip\":\"400079\",\"billing_country\":\"IN\",\"billing_phone_npa\":null,\"billing_phone_nxx\":null,\"billing_phone_suffix\":null,\"billing_phone_extension\":null,\"billing_intl_phone\":\"1234567890\",\"billing_email\":\"vishal.a.verma@capgemini.com\",\"billing_pay_method\":4,\"billing_cc_expire_mm\":null,\"billing_cc_expire_yyyy\":null,\"billing_bank_routing_num\":null}],\"plan_name\":\"YouSee\",\"state_prov\":null,\"country_english\":\"India\",\"promo_name\":null,\"no_provision_ind\":1,\"bill_action_cd\":-1,\"status_name\":\"TERMINATED\",\"acct_balance\":-11,\"supp_field\":[{\"supp_field_name\":\"Betaler\",\"supp_field_value\":\"610255311\"},{\"supp_field_name\":\"Juridisk\",\"supp_field_value\":\"60082721\"}],\"bill_day\":27,\"supp_plan\":[{\"supp_plan_no\":10532741,\"supp_plan_name\":\"Telefoni Fast pris\"},{\"supp_plan_no\":10532745,\"supp_plan_name\":\"Telefoni Fastpris\"}]}]}';
        CarrieBillingWrapper obj = parse(json);
        System.assert(obj != null);
    }
}