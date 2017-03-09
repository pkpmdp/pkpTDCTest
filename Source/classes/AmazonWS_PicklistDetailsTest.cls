@isTest(seeAlldata=true)
public class AmazonWS_PicklistDetailsTest {
     static testMethod void AmazonWS_PicklistDetailsTest() {
        
        System.RestContext.request = new RestRequest();
        RestContext.request.addParameter('action','category_documenttypes_upload');
        RestContext.request.addParameter('action','category_documenttypes');
        
        AmazonWS_PicklistDetails.doGetAction();
        AmazonWS_PicklistDetails.getStatusPickListValues();
       
         }
    static testMethod void AmazonWS_PicklistDetailsTest1(){
       AmazonWS_PicklistDetails.getDocTagPickListValues();
        }
   
}