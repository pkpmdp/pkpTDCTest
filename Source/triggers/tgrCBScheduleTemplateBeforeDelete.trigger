trigger tgrCBScheduleTemplateBeforeDelete on CB_Schedule_Template__c (before delete) {
    for(CB_Schedule_Template__c item:Trigger.old){
        if (clsCallBackUtil.isCurrentlyValid(item)){
            item.addError(Label.CB_Error_Delete_Valid_Template);
        }
        if (clsCallBackUtil.isTemplateUsed(item)){
            item.addError(Label.CB_Error_Delete_Template_with_CBCase);
        }
        List<CB_Custom_Schedule__c> custVals = clsCallBackUtil.findCustVals(item);
        List<CB_Custom_Schedule__c> custValsInFuture=new List<CB_Custom_Schedule__c>();
        for(CB_Custom_Schedule__c custVal:custVals){
            if(custVal.CB_time_to__c>Datetime.now()){
                custValsInFuture.add(custVal);
            }
        }
        
        if (custValsInFuture.size()>0){
            item.addError(Label.CB_Error_Del_Templ_with_Man_Settings);
            List<clsCallBackCustomDay> custDays = clsCallBackUtil.groupCustValsByDay(custValsInFuture);
            for (clsCallBackCustomDay d:custDays){
                String errorMessage = String.format(Label.CB_Error_Del_Templ_Man_Setting_Detail,new String[]{d.day.format()+' '+ d.getIntervalsAndSlots()});
                item.addError(errorMessage);
            }
        }
        else {
            delete custVals;
        }
    }
}