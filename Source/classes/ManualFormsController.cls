public class ManualFormsController {

    public String topSectionContents{get; set; }
    public String bottomSectionContents{get; set;}
    
    
    public void getInformation(){
            Date todayDate = date.today();
            Integer days;
            topSectionContents = '';
            bottomSectionContents= '';
            List<ForhandlerInformations__c> informationList = [Select info.Description__c, info.EndDate__c, info.Group_Information__c, info.Dealer__r.Name, info.SubGroup_Information__c From ForhandlerInformations__c info where info.Page_Type__c =: 'Blanketter' order by Sequence_Number__c];
            for(ForhandlerInformations__c info : informationList) {
                    if(info.EndDate__c != null){ 
                         days = todayDate.daysBetween(info.EndDate__c);
                    }    
                    if((info.EndDate__c == null) ||  (info.EndDate__c != null && days >= 0)) {
                            if('Top'.equals(info.SubGroup_Information__c)){
                                topSectionContents = topSectionContents + info.Description__c;
                            }   
                            if('Bottom'.equals(info.SubGroup_Information__c)){
                                bottomSectionContents = bottomSectionContents + info.Description__c;
                            }      
                    }                             
            }     
    }
            
    public PageReference redirectToPreviewURL() {
        system.Debug('selectedDocType--->' + selectedDocType);
        String newPageUrl ='/apex/previewManualOrdersDocPage';
        PageReference newPage = new PageReference(newPageUrl);
        newPage.getParameters().put('docType' , selectedDocType);
        newPage.getParameters().put('docTypeText' , selectedDocTypeText);
        newPage.setRedirect(true);
        return newPage;
    }
    
    
    public PageReference redirectURL() {
         system.Debug('selectedDocType--->' + selectedDocType);
        String newPageUrl ='/apex/ManualOrdersPage';
        PageReference newPage = new PageReference(newPageUrl);
        newPage.getParameters().put('docType' , selectedDocType);
        newPage.getParameters().put('docTypeText' , selectedDocTypeText);
        newPage.setRedirect(true);
        return newPage;
       }


public Set<ManualOrderingDocument__c> listDoc;
public List<String> listManualDoc;
public Id selectedDocType 
    { 
        get
          {
            return selectedDocType;
          }
        set
          {
              selectedDocType=value;
          } 
    }

public String selectedDocTypeText 
    { 
        get
          {
            return selectedDocTypeText;
          }
        set
          {
              selectedDocTypeText=value;
          } 
    }
    
    
public  List<LookupMaster__c> getDocList(){
    getInformation();
    listManualDoc = new List<String>();
    /*Schema.DescribeFieldResult F = ManualOrderingDocument__c.Document__c.getDescribe();
    List<Schema.PicklistEntry> val = F.getPicklistValues();
    for(Schema.PicklistEntry entry : val){
        system.debug('entry.getLabel()--->' + entry.getLabel());
        listManualDoc.add(entry.getLabel());
    }*/
    List<LookupMaster__c> manualDoc = new List<LookupMaster__c>();
    manualDoc =[Select m.Name,m.Id From LookupMaster__c m where m.recordType__c=: 'Manual Order Document' ];
    for(LookupMaster__c val : manualDoc){
    	if('YouSee lejeboks'.equals(val.name)){
    		val.name = 'Ombyt lejeboks';
    		break;
    	}
        
    }
    
 return manualDoc ;
}
public ManualFormsController(){
}

     
}