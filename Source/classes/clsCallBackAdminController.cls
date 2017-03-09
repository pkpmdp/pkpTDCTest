public class clsCallBackAdminController {

    public clsCallBackAdminController() {

    }

    public class TemplateWithStyle{
        public TemplateWithStyle(CB_Schedule_Template__c template){
            this.item = template;
        }
        public TemplateWithStyle(CB_Schedule_Template__c template,String itemStyle){
                this(template);
            this.itemStyle = itemStyle;
        }

        public CB_Schedule_Template__c item {get;set;}
        public String itemStyle {get;set;}
    }

    List<TemplateWithStyle> templates;
    List<clsCallBackCustomDay> custVals;
    
    public List<TemplateWithStyle> getTemplates() {
    	if (templates==null){
	        templates = new List<TemplateWithStyle>();
	        List<CB_Schedule_Template__c> result;
	        //select all
	        result = [select ID,Name,Valid_from__c,CB_type__c from CB_Schedule_Template__c order by Valid_from__c,CB_type__c];
	        for(CB_Schedule_Template__c item:result){
	            String itemStyle='';
	            if(clsCallBackUtil.isCurrentlyValid(item)){
	                itemStyle='font-weight:bold';
	            }
	            templates.add(new TemplateWithStyle(item,itemStyle));
	        }
	        //Following code display only actually valid template and all templates from future for each CB_type
	        /*
	        List<AggregateResult> cbTypes = [select CB_type__c,MAX(Valid_from__c) from CB_Schedule_Template__c group by CB_type__c];
	        for (AggregateResult ar : cbTypes ){
	            String CBType=(String)ar.get('CB_type__c');
	            result = [select ID,Name,Valid_from__c, CB_type__c from CB_Schedule_Template__c where CB_type__c=:CBType and Valid_from__c <=:Date.today() order by Valid_from__c desc limit 1];
	            for(CB_Schedule_Template__c item:result){
	                templates.add(new TemplateWithStyle(item,'font-weight:bold'));
	            }
	            result = [select ID,Name,Valid_from__c, CB_type__c from CB_Schedule_Template__c where CB_type__c=:CBType and Valid_from__c >:Date.today() order by Valid_from__c];
	            for(CB_Schedule_Template__c item:result){
	                templates.add(new TemplateWithStyle(item));
	            }
	        }
	        */
    	}
        return templates;
    }

    public List<clsCallBackCustomDay> getCustVals() {
        custVals = clsCallBackCustomDay.populateList([select ID,Name,CB_type__c, CB_time_from__c, CB_time_to__c, Max_slots__c from CB_Custom_Schedule__c where CB_time_from__c>=:Date.today() order by CB_time_from__c]);
        return custVals;
    }

    public void deleteTemplate(){
        Savepoint sp;
        try{
            sp = Database.setSavepoint();
            String templateId = ApexPages.currentPage().getParameters().get('templateId'); 
            Integer templateIndex = findTemplateIndex(templateId);
            CB_Schedule_Template__c template = templates[templateIndex].item;
            delete template;
            templates.remove(templateIndex);
        }
        catch (Exception ex) {
            Database.rollback(sp);
        }
    }
    private Integer findTemplateIndex(String id){
        Integer result;
        for(Integer i=0;i<templates.size();i++){
            if (templates[i].item.id==id){
                result=i;
                break;
            }
        }
        return result;
    }
    
    public PageReference editTemplate(){
        String templateId = ApexPages.currentPage().getParameters().get('templateId'); 
        return new PageReference('/apex/CB_Sched_def_vals_edit?id=' + templateId + '&retURL=/apex/CallBackAdminPage'); 
    }

    public void deleteCustomDay(){
        String paramDate = ApexPages.currentPage().getParameters().get('date'); 
        String paramType = ApexPages.currentPage().getParameters().get('type'); 
        for (Integer i=0;i<custVals.size();i++){
            clsCallBackCustomDay custVal = custVals[i];
            if(custVal.CB_type==paramType && custVal.getUrlFormatedDay()==paramDate){
                delete custVal.custVals;
                custVals.remove(i);
                break;
            }
        }
    }
}