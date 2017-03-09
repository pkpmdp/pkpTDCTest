public class clsCBSchedDefValsEditController {

    public static String STYLE_COLOR_RED='red';
    public static String STYLE_COLOR_GREEN='green';

    CB_Schedule_Template__c template;

    ApexPages.StandardController controller;

    public clsCBSchedDefValsEditController(ApexPages.StandardController controller) {
        template = (CB_Schedule_Template__c)controller.getRecord();
        if (template.Id!=null){
            template = [select Working_hours_from__c,Working_hours_to__c,CB_type__c,Period__c,Id,Name,Valid_from__c from CB_Schedule_Template__c where id=:template.id];
        }
        this.controller = controller;
        deletedItems = new List<CB_Default_Schedule__c>();
        
        caseFields = new Case();
        caseFields.Department__c='YOT';
        caseFields.Product_2__c='YOT Call Back';
        caseFields.Type_Task__c=template.CB_type__c;
    }

    DisplayDefVals[] defVals;
    List<CB_Default_Schedule__c> deletedItems;
    Integer rowIndex = 0;
    //proxy object Case c for dependent picklist
    Case caseFields;
    public Case getCaseFields() {return caseFields;}
    
public class DisplayDefVals {
  public Integer rowId { get; set; }
  public CB_Default_Schedule__c item { get; set; }
  public String monStyle;
  public String tueStyle;
  public String wedStyle;
  public String thuStyle;
  public String friStyle;
  public String satStyle;
  public String sunStyle;

  public String getMonStyle(){
      return calcStyle(item.Monday__c);
  }
  public String getTueStyle(){
      return calcStyle(item.Tuesday__c);
  }
  public String getWedStyle(){
      return calcStyle(item.Wednesday__c);
  }
  public String getThuStyle(){
      return calcStyle(item.Thursday__c);
  }
  public String getFriStyle(){
      return calcStyle(item.Friday__c);
  }
  public String getSatStyle(){
      return calcStyle(item.Saturday__c);
  }
  public String getSunStyle(){
      return calcStyle(item.Sunday__c);
  }

  public DisplayDefVals(CB_Default_Schedule__c item,Integer i) {
      this.item = item;
      this.rowId = i;
  }

  private String calcStyle(Decimal val){
    if (val!=null && val.intValue()>0) return clsCBSchedDefValsEditController.STYLE_COLOR_RED;
    return clsCBSchedDefValsEditController.STYLE_COLOR_RED;
  }
     
}

public List<DisplayDefVals> getDefVals() {
        
        if(defVals == null) {
            defVals = new DisplayDefVals[]{};
            for (CB_Default_Schedule__c item : [select Time_from__c, Time_to__c, Template__c, Monday__c, Tuesday__c, Wednesday__c, Thursday__c, Friday__c, Saturday__c, Sunday__c from CB_Default_Schedule__c where template__c=:template.ID order by Time_from__c ]) {
              defVals.add(new DisplayDefVals(item,rowIndex));
              rowIndex++;
            }
        }
        return defVals;
}

public List<CB_Default_Schedule__c> getDefValItems() {
        List<CB_Default_Schedule__c> result = new List<CB_Default_Schedule__c>();
        for (DisplayDefVals defVal:getDefVals()){
            result.add(defVal.item);
        }
        return result;
}


    public CB_Schedule_Template__c getTemplate(){
        return template;
    }
    
    public String getStyleColorRed(){
        return STYLE_COLOR_RED;
    }
    public String getStyleColorGreen(){
        return STYLE_COLOR_GREEN;
    }
    
    public void deleteLine() {
        Integer rowId = Integer.valueOf(ApexPages.currentPage().getParameters().get('rowId')); 

        for(Integer i=0;i<getDefVals().size();i++){
            if(getDefVals()[i].rowId==rowId){
                deletedItems.add(getDefVals()[i].item);
                getDefVals().remove(i);
                break;
            }
        }
    }
    public void newLine() {
        CB_Default_Schedule__c line = new CB_Default_Schedule__c(Time_from__c=0,Time_to__c=0,Template__c=template.ID,Monday__c=0,Tuesday__c=0,Wednesday__c=0,Thursday__c=0,Friday__c=0,Saturday__c=0,Sunday__c=0);
       
        getDefVals().add(new DisplayDefVals(line,rowIndex));
        rowIndex++;
    }

    public void populate() {
        for(Integer i = template.Working_hours_from__c.intValue();i<template.Working_hours_to__c;i++){
        DisplayDefVals foundInterval = findInterval(i);
            if(foundInterval==null){
                CB_Default_Schedule__c line = new CB_Default_Schedule__c(Time_from__c=i,Time_to__c=i+1,Template__c=template.ID,Monday__c=0,Tuesday__c=0,Wednesday__c=0,Thursday__c=0,Friday__c=0,Saturday__c=0,Sunday__c=0);
                getDefVals().add(new DisplayDefVals(line,rowIndex));
                rowIndex++;
            }
            else {
                i=foundInterval.item.Time_to__c.intValue()-1;
            }
        } 
    }
    
    private DisplayDefVals findInterval(Integer paramFrom){
        DisplayDefVals result = null;
        for(DisplayDefVals line :getDefVals()){
            if(line.item.Time_from__c.intValue() == paramFrom){
                result = line;
                break;
            }
        }
        return result;
    }

    public PageReference saveAll() {
    PageReference result =null;
    if (saveTemplate()){
        result = new PageReference(ApexPages.currentPage().getParameters().get('retUrl'));
    }
        return result;
    }

    public void quicksaveAll() {
        saveTemplate();
    }
    
    public boolean saveTemplate(){
        Boolean success = true;
        template.CB_type__c=caseFields.Type_Task__c;
        Savepoint sp;
        if (isValid()){
            try {
                sp = Database.setSavepoint();
                
                upsert template;
                //controller.save();
                saveCollection();
            }
            catch (Exception ex) {
                Database.rollback(sp);
                success = false;
            }
        }
        else {
            success = false;
        }
        return success;
    }

    public void saveCollection(){
            
            for(DisplayDefVals line :getDefVals()){
                if (line.item.Template__c==null){
                    line.item.Template__c=template.ID;
                }   
                upsert line.item;
            }
            for(CB_Default_Schedule__c item :deletedItems){
                if (item.id!=null) {
                    delete item;
                }
            }
            deletedItems.clear();
    }
    
    public boolean isValid(){
        Boolean result = true;
        if(!validateRequired()){
            result = false;
        }
        if(!validateTimeFromGTTimeTo()){
            result = false;
        }
        if(!validateValidFrom()){
            result = false;
        }

        if(!validateWorkingHours()){
            result = false;
        }
        if (!validateMissingInterval()){
            result = false;
        }
        if (!validateOverlappingInterval()){
            result = false;
        }
        return result;
    }
    public boolean validateRequired(){
        Boolean result = true;
        if (caseFields.Type_Task__c==null) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CB_Error_Type_required));
            result=false;
        }
        return result;
    }

    public boolean validateValidFrom(){
        Boolean result = true;
        //if date and type is filled 
        if (template.Valid_from__c!=null && caseFields.Type_Task__c!=null) {
            CB_Schedule_Template__c origTemplate =null;
            if (template.Id!=null){
                origTemplate = [select Valid_from__c from CB_Schedule_Template__c where id=:template.id];
            }
            
            //validate Soonest date for valid from
            //if template is new or valid from is changed
            if (origTemplate==null || template.Valid_from__c!=origTemplate.Valid_from__c){
                //find soonest date
                Date soonestDate=clsCallBackUtil.findLatestCBCase(caseFields.Type_Task__c);
                if (template.Valid_from__c<=soonestDate){
                    String errorMessage = String.format(Label.CB_Error_Soonest_date,new String[]{soonestDate.addDays(1).format()});
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
                    result=false;
                }
            }    
 
            //validate incompatibile intervals in manual settings
            List<CB_Custom_Schedule__c> incompatCustVals = new List<CB_Custom_Schedule__c>();
            if (origTemplate==null || template.Valid_from__c!=origTemplate.Valid_from__c){
                //find incompatibile Custom values for new or changed template
                incompatCustVals  = clsCallBackUtil.findIncompatibileCustVals(template,getDefValItems());
            }
            if (incompatCustVals.size()>0){
                List<clsCallBackCustomDay> incompatDays = clsCallBackUtil.groupCustValsByDay(incompatCustVals);
                
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CB_Error_Incompatible_Intervals));
                for (clsCallBackCustomDay d:incompatDays){
                    String errorMessage = String.format(Label.CB_Error_Incompatible_Intervals_Detail,new String[]{d.day.format()+' '+ d.getIntervalsAndSlots()});
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
                }
                result= false;
            }

        }
        return result;
    }

    public boolean validateTimeFromGTTimeTo(){
        Boolean result = true;
        for(DisplayDefVals line :getDefVals()){
            if(line.item.Time_from__c.intValue() >= line.item.Time_to__c.intValue()){
                String errorMessage = String.format(Label.CB_Error_Time_to_gt_Time_from,new String[]{String.valueOf(line.item.Time_to__c),String.valueOf(line.item.Time_from__c)});
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
                result = false;
            }
        }
        return result;
    }

    public boolean validateWorkingHours(){
        Boolean result = true;
        for(DisplayDefVals line :getDefVals()){
            if(line.item.Time_from__c.intValue()<template.Working_hours_from__c.intValue() || line.item.Time_to__c.intValue()>template.Working_hours_to__c.intValue()){
                String errorMessage = String.format(Label.CB_Error_Interval_Outside_Work_hours,new String[]{String.valueOf(line.item.Time_from__c),String.valueOf(line.item.Time_to__c)});
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
                result = false;
            }
        }
        return result;
    }

    public boolean validateMissingInterval(){
        Boolean result = true;
        for(Integer i = template.Working_hours_from__c.intValue();i<template.Working_hours_to__c;i++){
            DisplayDefVals foundInterval = findInterval(i);
            if (foundInterval==null){
                String errorMessage = String.format(Label.CB_Error_Missing_Interval,new String[]{String.valueOf(i),String.valueOf(i+1)});
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
                result=false;
            }
            else{
                if(foundInterval.item.Time_to__c.intValue()>i){
                    i=foundInterval.item.Time_to__c.intValue()-1;
                }
            }
        }    
        return result;
    }

    public Boolean validateOverlappingInterval(){
        Boolean result = true;
        for(DisplayDefVals line :getDefVals()){
            DisplayDefVals overlapping = findOverlapping(line);
            if(overlapping!=null){
                String errorMessage = String.format(Label.CB_Error_Overlapping_Intervals,new String[]{String.valueOf(line.item.Time_from__c),String.valueOf(line.item.Time_to__c),String.valueOf(overlapping.item.Time_from__c),String.valueOf(overlapping.item.Time_to__c)});
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
                result = false;
            }
        }
        return result;
    }

    private DisplayDefVals findOverlapping(DisplayDefVals input){
        for(DisplayDefVals line :getDefVals()){
            if (input.rowId!=line.rowId){ //do not compare with self
                if(input.item.Time_from__c.intValue()>line.item.Time_from__c.intValue() && input.item.Time_from__c.intValue()<line.item.Time_to__c.intValue()){
                    return line;
                }
                if(input.item.Time_to__c.intValue()>line.item.Time_from__c.intValue() && input.item.Time_to__c.intValue()<line.item.Time_to__c.intValue()){
                    return line;
                }
                if(input.item.Time_from__c.intValue()==line.item.Time_from__c.intValue() && input.item.Time_to__c.intValue()==line.item.Time_to__c.intValue()){
                    return line;
                }
            }
        }
        return null;
    }
    
    public PageReference redirectIfUsed(){
        PageReference result = null;
        if (template.id!=null){
            //if template is used with CB Case or Custom values exist
            if (clsCallBackUtil.isTemplateUsed(template)||clsCallBackUtil.findCustVals(template).size()>0){
                result = Page.CB_Sched_def_vals_used_edit;
                result.getParameters().putAll(ApexPages.currentPage().getParameters());
                result.setRedirect(true);
            }
        }
        return result;
    }
}