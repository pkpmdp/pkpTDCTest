@istest
public class DealerProductReceiptGenerationTest {
    static testmethod void DealerProductReceiptGenerationTest(){
        DealerProductReceiptGeneration obj= new DealerProductReceiptGeneration();
        String priceJsonResponse = '{"1101001":{"totalpris":"120.61","copydan":"20.35","fejlkode":0,"moms":"18.84","links":[{"mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8","href":"http://preprod-kasia.yousee.dk/afsaetning/mindstepris-beregning-uden-binding/0005017038///0/1101001",'+
            '"rel":"mindstepris-beregning"}],"betalingsperiode":"maaned","mindstepris":"120.61","produkt":"1101001","koda":"4.80","radiokoda":"1.25","pris":"75.37"},"1112001":{"totalpris":"295.00","copydan":"0.00","fejlkode":0,"moms":"59.00","links":[{"mediatype":"application/vnd.yousee.kasia2+json;version=1;'+
            'charset=UTF-8","href":"http://preprod-kasia.yousee.dk/afsaetning/mindstepris-beregning-uden-binding/0005017038///0/1112001","rel":"mindstepris-beregning"}],"betalingsperiode":"enkelt","mindstepris":"295.00","produkt":"1112001","koda":"0.00","radiokoda":"0.00","pris":"236.00"}}';
        
		String receiptValgtResponse = '{"valgt":[{"aftalenr":"0","aftaletype":"clear","kundetype":"I","kundeid":"610031533","links":[{"rel":"slet-varer","href":"http://preprod-kasia.yousee.dk/afsaetning/slet/0/varer","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}],'+
            '"varer":[{"navn":"Skift til mindre pakke","sortering":"11-11-1152","produktgruppe":"1BK","varenr":"1112001","beregnet-handlings-dato":"21-07-2015","varetype":"kyd","sorteringsgruppe":"99-9999","sorteringsgruppenavn":"Hjælpegruppe. Produkt vises til sidst.","kortnavn":"Omk. m/gebyr",'+
            '"links":[{"rel":"slet","href":"http://preprod-kasia.yousee.dk/afsaetning/slet/0/1112001","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"navn":"Grundpakke","digi-info":"CL","ga-handling":"Nedgradering","sortering":"11-01-0010","produktgruppe":"1GP",'+
            '"varenr":"1101001","abonnementsid":"-1296745597","beregnet-handlings-dato":"21-07-2015","varetype":"ga","sorteringsgruppe":"01-0010","sorteringsgruppenavn":"Kabel-tv","vaegtning":"10","kortnavn":"Grundpakke","links":[{"rel":"slet","href":"http://preprod-kasia.yousee.dk/afsaetning/slet/0/1101001",'+
            '"mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}],"clear-baand":["CLEAR1GP"]}]}]}';
       
        String receiptValgtResponse1 = '{"valgt":[{"aftalenr":"0","aftaletype":"bb","kundetype":"I","kundeid":"610031533","links":[{"rel":"slet-varer","href":"http://preprod-kasia.yousee.dk/afsaetning/slet/0/varer","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}],'+
            '"varer":[{"navn":"Skift til mindre pakke","sortering":"11-11-1152","produktgruppe":"1BK","varenr":"1112001","beregnet-handlings-dato":"21-07-2015","varetype":"kyd","sorteringsgruppe":"99-9999","sorteringsgruppenavn":"Hjælpegruppe. Produkt vises til sidst.","kortnavn":"Omk. m/gebyr",'+
            '"links":[{"rel":"slet","href":"http://preprod-kasia.yousee.dk/afsaetning/slet/0/1112001","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"navn":"Grundpakke","digi-info":"CL","ga-handling":"Nedgradering","sortering":"11-01-0010","produktgruppe":"1GP",'+
            '"varenr":"1101001","abonnementsid":"-1296745597","beregnet-handlings-dato":"21-07-2015","varetype":"ga","sorteringsgruppe":"01-0010","sorteringsgruppenavn":"Kabel-tv","vaegtning":"10","kortnavn":"Grundpakke","links":[{"rel":"slet","href":"http://preprod-kasia.yousee.dk/afsaetning/slet/0/1101001",'+
            '"mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}],"clear-baand":["CLEAR1GP"]}]}]}';
        
        String receiptValgtResponse2 = '{"valgt":[{"aftalenr":"0","aftaletype":"dtv","kundetype":"I","kundeid":"610031533","links":[{"rel":"slet-varer","href":"http://preprod-kasia.yousee.dk/afsaetning/slet/0/varer","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}],'+
            '"varer":[{"navn":"Skift til mindre pakke","sortering":"11-11-1152","produktgruppe":"1BK","varenr":"1112001","beregnet-handlings-dato":"21-07-2015","varetype":"kyd","sorteringsgruppe":"99-9999","sorteringsgruppenavn":"Hjælpegruppe. Produkt vises til sidst.","kortnavn":"Omk. m/gebyr",'+
            '"links":[{"rel":"slet","href":"http://preprod-kasia.yousee.dk/afsaetning/slet/0/1112001","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"navn":"Grundpakke","digi-info":"CL","ga-handling":"Nedgradering","sortering":"11-01-0010","produktgruppe":"1GP",'+
            '"varenr":"1101001","abonnementsid":"-1296745597","beregnet-handlings-dato":"21-07-2015","varetype":"ga","sorteringsgruppe":"01-0010","sorteringsgruppenavn":"Kabel-tv","vaegtning":"10","kortnavn":"Grundpakke","links":[{"rel":"slet","href":"http://preprod-kasia.yousee.dk/afsaetning/slet/0/1101001",'+
            '"mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}],"clear-baand":["CLEAR1GP"]}]}]}';
        
        String receiptValgtResponse3 = '{"valgt":[{"aftalenr":"0","aftaletype":"tlf","kundetype":"I","kundeid":"610031533","links":[{"rel":"slet-varer","href":"http://preprod-kasia.yousee.dk/afsaetning/slet/0/varer","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}],'+
            '"varer":[{"navn":"Skift til mindre pakke","sortering":"11-11-1152","produktgruppe":"1BK","varenr":"1112001","beregnet-handlings-dato":"21-07-2015","varetype":"kyd","sorteringsgruppe":"99-9999","sorteringsgruppenavn":"Hjælpegruppe. Produkt vises til sidst.","kortnavn":"Omk. m/gebyr",'+
            '"links":[{"rel":"slet","href":"http://preprod-kasia.yousee.dk/afsaetning/slet/0/1112001","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"navn":"Grundpakke","digi-info":"CL","ga-handling":"Nedgradering","sortering":"11-01-0010","produktgruppe":"1GP",'+
            '"varenr":"1101001","abonnementsid":"-1296745597","beregnet-handlings-dato":"21-07-2015","varetype":"ga","sorteringsgruppe":"01-0010","sorteringsgruppenavn":"Kabel-tv","vaegtning":"10","kortnavn":"Grundpakke","links":[{"rel":"slet","href":"http://preprod-kasia.yousee.dk/afsaetning/slet/0/1101001",'+
            '"mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}],"clear-baand":["CLEAR1GP"]}]}]}';
        
        String receiptValgtResponse4 = '{"valgt":[{"aftalenr":"0","aftaletype":"youbio","kundetype":"I","kundeid":"610031533","links":[{"rel":"slet-varer","href":"http://preprod-kasia.yousee.dk/afsaetning/slet/0/varer","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}],'+
            '"varer":[{"navn":"Skift til mindre pakke","sortering":"11-11-1152","produktgruppe":"1BK","varenr":"1112001","beregnet-handlings-dato":"21-07-2015","varetype":"kyd","sorteringsgruppe":"99-9999","sorteringsgruppenavn":"Hjælpegruppe. Produkt vises til sidst.","kortnavn":"Omk. m/gebyr",'+
            '"links":[{"rel":"slet","href":"http://preprod-kasia.yousee.dk/afsaetning/slet/0/1112001","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"navn":"Grundpakke","digi-info":"CL","ga-handling":"Nedgradering","sortering":"11-01-0010","produktgruppe":"1GP",'+
            '"varenr":"1101001","abonnementsid":"-1296745597","beregnet-handlings-dato":"21-07-2015","varetype":"ga","sorteringsgruppe":"01-0010","sorteringsgruppenavn":"Kabel-tv","vaegtning":"10","kortnavn":"Grundpakke","links":[{"rel":"slet","href":"http://preprod-kasia.yousee.dk/afsaetning/slet/0/1101001",'+
            '"mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}],"clear-baand":["CLEAR1GP"]}]}]}';
         String receiptValgtResponse5 = '{"valgt":[{"aftalenr":"0","aftaletype":"test","kundetype":"I","kundeid":"610031533","links":[{"rel":"slet-varer","href":"http://preprod-kasia.yousee.dk/afsaetning/slet/0/varer","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}],'+
            '"varer":[{"navn":"Skift til mindre pakke","sortering":"11-11-1152","produktgruppe":"1BK","varenr":"1112001","beregnet-handlings-dato":"21-07-2015","varetype":"kyd","sorteringsgruppe":"99-9999","sorteringsgruppenavn":"Hjælpegruppe. Produkt vises til sidst.","kortnavn":"Omk. m/gebyr",'+
            '"links":[{"rel":"slet","href":"http://preprod-kasia.yousee.dk/afsaetning/slet/0/1112001","mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}]},{"navn":"Grundpakke","digi-info":"CL","ga-handling":"Nedgradering","sortering":"11-01-0010","produktgruppe":"1GP",'+
            '"varenr":"1101001","abonnementsid":"-1296745597","beregnet-handlings-dato":"21-07-2015","varetype":"ga","sorteringsgruppe":"01-0010","sorteringsgruppenavn":"Kabel-tv","vaegtning":"10","kortnavn":"Grundpakke","links":[{"rel":"slet","href":"http://preprod-kasia.yousee.dk/afsaetning/slet/0/1101001",'+
            '"mediatype":"application/vnd.yousee.kasia2+json;version=1;charset=UTF-8"}],"clear-baand":["CLEAR1GP"]}]}]}';
        Map<String,String> productSummaryMap  = new Map<String,String>();
        productSummaryMap.put(null, 'test af tekstændringer');
        productSummaryMap.put('1101001', 'Det skulle ikke undre mig om... test test');
        productSummaryMap.put('1101003', 'Bredband is free with this package');
        productSummaryMap.put('1101109', 'Ved bestilling af BB giver Isabelle is');
        productSummaryMap.put('1101204', 'This is FP-BS Product');
        productSummaryMap.put('1201001', 'Indsæt tekst her');
        productSummaryMap.put('1201005', null);
        productSummaryMap.put('1201007', null);
        productSummaryMap.put('1201010', null);
        productSummaryMap.put('1201012', null);
        
        Boolean telephoniFlag = false;
        Boolean broadbandTelephonyCommonFlag = false;
        Boolean plusFlag = false;
        Boolean ekstrakanalerFlag = false;
        Boolean telefoniFlag = false;
        //obj.installations = true;
        //public void dynamicReceiptPageGeneration(String priceJsonResponse, String receiptValgtResponse,Map<String,String> productSummaryMap, Boolean telephoniFlag, String selectedNumber,String NPFutureDate, String NPCurrentDate, Boolean broadbandTelephonyCommonFlag, Boolean onlyBroadbandFlag, Boolean plusFlag, Boolean ekstrakanalerFlag, Boolean broadbandUpgradationFlag, Boolean telefoniFlag, String telePhoneDirectoryName, String selectedNumberForNP)	
       obj.dynamicReceiptPageGeneration(priceJsonResponse, receiptValgtResponse, productSummaryMap, telephoniFlag, null, null, '11-11-1152', false, null, false, false, null, true, 'visalt', '1101001');
        obj.dynamicReceiptPageGeneration(priceJsonResponse, receiptValgtResponse1, productSummaryMap, true, '1101001', '11-11-1152', '11-11-1152', false, null, false, false, null, true, 'althemmeligt', '1101001');
        obj.dynamicReceiptPageGeneration(priceJsonResponse, receiptValgtResponse2, productSummaryMap, telephoniFlag, null, null, '11-11-1152', false, null, false, false, null, true, 'hemmeligtnummer', '1101001');
        obj.dynamicReceiptPageGeneration(priceJsonResponse, receiptValgtResponse3, productSummaryMap, telephoniFlag, null, null, '11-11-1152', false, null, false, false, null, true, 'hemmeligadresse', '1101001');
        obj.dynamicReceiptPageGeneration(priceJsonResponse, receiptValgtResponse4, productSummaryMap, telephoniFlag, null, null, '11-11-1152', false, null, false, false, null, true, 'althemmeligt', '1101001');
        obj.dynamicReceiptPageGeneration(priceJsonResponse, receiptValgtResponse5, productSummaryMap, telephoniFlag, null, null, '11-11-1152', false, null, false, false, null, true, 'althemmeligt', '1101001');
        obj.getInstProdSrlNumbers('{}');
        obj.updateYouBioAbnSelectedStatus();
        obj.updateYouBioBoxSelectedStatus();
    }
    

}