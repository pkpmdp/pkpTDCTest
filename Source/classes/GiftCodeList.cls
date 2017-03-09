public class GiftCodeList{
    public Id giftCodeId {get;set;}
    public List<String> getCodes(){
        List<Gift_Code__c> giftCodes = [Select Code_Formatted__c from Gift_Code__c where id=:giftCodeId ];
        String codes =  giftCodes[0].Code_Formatted__c;
        System.debug('component codes=>'+codes );
        return codes.split(',');
    }
}