public class clsCallBackUtil{

    /*
     * Find default intervals for specified day and type
     */
    public static List<clsCallBackDefaultInterval> findDefVals(Date day, String cbType){
        List<clsCallBackDefaultInterval> result = new List<clsCallBackDefaultInterval>();
        Integer dayOfWeek = findDayOfWeek(day);
        //find master object
        List<CB_Schedule_Template__c> templates = [select id from CB_Schedule_Template__c where CB_type__c=:cbType and Valid_from__c<:day order by Valid_from__c desc limit 1];
        
        if (templates.size()==1){
            CB_Schedule_Template__c validTemplate = templates[0];
            List<CB_Default_Schedule__c> defVals;
            //find related child objects
            defVals = [select Monday__c, Tuesday__c, Wednesday__c, Thursday__c, Friday__c, Saturday__c, Sunday__c, Time_from__c, Time_to__c from CB_Default_Schedule__c where Template__c=:validTemplate.id order by Time_from__c];
            for(CB_Default_Schedule__c defVal:defVals){
                Datetime cbFrom = Datetime.newInstance(day,Time.newInstance(defVal.Time_from__c.intValue(),0,0,0));
                Datetime cbTo = Datetime.newInstance(day,Time.newInstance(defVal.Time_to__c.intValue(),0,0,0));
                Integer usedSlots = countUsedSlots(cbType,cbFrom,cbTo);
                result.add(new clsCallBackDefaultInterval(defVal.Time_from__c.intValue(),defVal.Time_to__c.intValue(),selectDaySlots(defVal,dayOfWeek),usedSlots));
            }
        }
      
        return result;
    }

    /* 
     * function findDayOfWeek
     * Param date 
     * Returns Integer 0-6
     * 0 - Sunday, 1 - Monday, 2 - Tuesday, 3 - Wednesday, 4 - Thursday, 5 - Friday, 6 - Saturday 
     * Doesn't work for dates before 1.1.1900
     */
    public static Integer findDayOfWeek(Date day){
        return math.mod(Date.newinstance(1899, 12, 31).daysBetween(day),7);
    }
 
    /*
     * Select maxSlots for specified day of week. 
     * Param dayOfWeek is integer number 0-6
     * 0 - Sunday, 1 - Monday, 2 - Tuesday, 3 - Wednesday, 4 - Thursday, 5 - Friday, 6 - Saturday 
     */
    public static Integer selectDaySlots(CB_Default_Schedule__c defVal, Integer dayOfWeek){
        if(dayOfWeek==0) return defVal.Sunday__c.intValue();
        else if(dayOfWeek==1) return defVal.Monday__c.intValue();
        else if(dayOfWeek==2) return defVal.Tuesday__c.intValue();
        else if(dayOfWeek==3) return defVal.Wednesday__c.intValue();
        else if(dayOfWeek==4) return defVal.Thursday__c.intValue();
        else if(dayOfWeek==5) return defVal.Friday__c.intValue();
        else if(dayOfWeek==6) return defVal.Saturday__c.intValue();
        
        return null;
    }
    
    /*
     * Format Date with default pattern 
     * default pattern is dd-MM-yyyy
     */
    public static String formatDate(Date d){
        return formatDate(d,'dd-MM-yyyy');
    }

    /*
     * Format Date with specified pattern 
     * Date do not have format method like DateTime object
     * DateTime object is used for formating
     */
    public static String formatDate(Date d,String pattern){
        DateTime dt = DateTime.newInstance(d,Time.newInstance(0,0,0,0));
        return dt.format(pattern);
    }

    /*
     * Parse Date in default format 
     * default format is dd-MM-yyyy
     */
    public static Date parseDate(String s){
        String[] dateArray=s.split('-',3);
        return Date.newInstance(Integer.valueOf(dateArray[2]),Integer.valueOf(dateArray[1]),Integer.valueOf(dateArray[0]));
    }
    
    /*
     * Returns count of currently used slots within specified interval for specified type.
     * Params cbFrom and cbTo can be null.
     */
    public static Integer countUsedSlots(String cbType,Datetime cbFrom,Datetime cbTo){
        String queryString = 'SELECT COUNT() FROM CB_Case__c WHERE CB_type__c = \''+cbType+'\' ';
        if(cbFrom!=null){
         String cbFromQuery = cbFrom.formatGmt('yyyy-MM-dd')+'T'+cbFrom.formatGmt('HH:mm:ss.SSS')+'Z';
         queryString+=' AND CB_time_from__c >= '+cbFromQuery;
        }
        if(cbTo!=null){
         String cbToQuery = cbTo.formatGmt('yyyy-MM-dd')+'T'+cbTo.formatGmt('HH:mm:ss.SSS')+'Z';
         queryString+=' AND CB_time_to__c <= '+cbToQuery;
        }
        Integer cntDbCurrent = Database.countQuery(queryString);

        return cntDbCurrent;
    }

    /*
     * Find date of latest scheduled CB Case
     */
    public static Date findLatestCBCase(String cbType){
        List<CB_Case__c> latestCBCase = [SELECT CB_time_to__c FROM CB_Case__c WHERE CB_type__c = :cbType order by CB_time_to__c desc limit 1];
        if(latestCBCase!=null && latestCBCase.size()>0){
            return latestCBCase[0].CB_time_to__c.date();
        }
        return null;
    } 
 
    /*
     * Returns true if there are some CB_cases created for given template id
     */
    /*
    public static boolean isTemplateUsed(String id){
        if (id!=null){
            CB_Schedule_Template__c template = [select CB_type__c,Valid_from__c from CB_Schedule_Template__c where id=:id];
            return isTemplateUsed(template);
        }
        return false;
    }
    */
    /*
     * Returns true if there are some CB_cases created for given template
     */
    public static boolean isTemplateUsed(CB_Schedule_Template__c template){
        if (template!=null){
            Date validTo=findValidTo(template);
            Integer usedSlots = countUsedSlots(template.CB_type__c,template.Valid_from__c,validTo);
            if (usedSlots>0){
                return true;
            }
        }
        return false;
    }


    /*
     * Returns true if template with given id is currently valid
     */
    /*
    public static boolean isCurrentlyValid(String id){
        if (id!=null){
            CB_Schedule_Template__c template = [select CB_type__c,Valid_from__c from CB_Schedule_Template__c where id=:id];
            return isCurrentlyValid(template);
        }
        return false;
    }
    */
    
    /*
     * Returns true if given template is currently valid
     */
    public static boolean isCurrentlyValid(CB_Schedule_Template__c template){
        if (template!=null){
            Date today = Date.today();
            //template valid from is in future
            if(template.Valid_from__c>today){
                return false;
            }
            Date validTo=findValidTo(template);
            //exists next template
            if (validTo!=null){
                //valid to is in future
                if (validTo>today){
                    return true;
                }
                //valid to is in past
                else {
                    return false;
                }
            }
            //next template doesn't exists
            else {
                return true;
            }
        }
        return false;
    }

	/**
	 * Find Valid_to of specified template
	 * It is first day when the next template become valid.
	 */
    public static Date findValidTo(CB_Schedule_Template__c template){
            Date validTo=null;
            List<CB_Schedule_Template__c> nextTemplate = [select Valid_from__c from CB_Schedule_Template__c where CB_type__c=:template.CB_type__c and Valid_from__c>:template.Valid_from__c order by Valid_from__c limit 1];
            //exists next template
            if (nextTemplate.size()>0){
                validTo=nextTemplate[0].Valid_from__c;
            }
            return validTo;
    }
    
    /*
     * Returns count of currently used slots within specified interval for specified type.
     * Params cbFrom and cbTo can be null.
     */
    public static List<CB_Custom_Schedule__c> findIncompatibileCustVals(CB_Schedule_Template__c template,List<CB_Default_Schedule__c> defVals){
        List<CB_Custom_Schedule__c> result = new List<CB_Custom_Schedule__c>();
        if (template!=null){
            //List<CB_Default_Schedule__c> defVals = findDefVals(template);
            List<CB_Custom_Schedule__c> custVals=findCustVals(template);
            for (CB_Custom_Schedule__c custVal:custVals){
                if(!isCompatibile(custVal,defVals)){
                    result.add(custVal);
                }
            }
        }
        return result;
    }


    private static boolean isCompatibile(CB_Custom_Schedule__c custVal,List<CB_Default_Schedule__c> defVals){
        for(CB_Default_Schedule__c defVal:defVals){
            if(defVal.Time_from__c==custVal.CB_time_from__c.hour() && defVal.Time_to__c==custVal.CB_time_to__c.hour()){
                return true;
            }
        }
        return false;
    }
    
    /*
     * Returns true if there are some Custom values created within validity of this template
     */
    public static List<CB_Custom_Schedule__c> findCustVals(CB_Schedule_Template__c template){
        List<CB_Custom_Schedule__c> result = new List<CB_Custom_Schedule__c>();
        if (template!=null){
            Date validTo=findValidTo(template);
            result = findCustVals(template.CB_type__c,template.Valid_from__c,validTo);
        }
        return result;
    }
    
    
    private static List<CB_Custom_Schedule__c> findCustVals(String cbType,Date validFrom,Date validTo){
        List<CB_Custom_Schedule__c> result = new List<CB_Custom_Schedule__c>();
        Time zeroTime = Time.newInstance(0,0,0,0);
        if (validTo==null){
            result = [select CB_type__c,CB_time_from__c,CB_time_to__c,Max_slots__c from CB_Custom_Schedule__c where CB_type__c=:cbType and CB_time_from__c>=:Datetime.newInstance(validFrom,zeroTime) order by CB_time_from__c];
        }
        else {
            result = [select CB_type__c,CB_time_from__c,CB_time_to__c,Max_slots__c from CB_Custom_Schedule__c where CB_type__c=:cbType and CB_time_from__c>=:Datetime.newInstance(validFrom,zeroTime) and CB_time_to__c<=:Datetime.newInstance(validTo,zeroTime) order by CB_time_from__c];
        }
        return result;
    }
    
    /**
     * Find default intervals for specified templates
     */
    /*
    public static List<CB_Default_Schedule__c> findDefVals(CB_Schedule_Template__c template){
        return [select Time_from__c, Time_to__c, Template__c, Monday__c, Tuesday__c, Wednesday__c, Thursday__c, Friday__c, Saturday__c, Sunday__c from CB_Default_Schedule__c where Template__c=:template.ID order by Time_from__c ];
    }
    */
    
    /**
     * Group custom values by days into clsCallBackCustomDay apex class 
     */
    public static List<clsCallBackCustomDay> groupCustValsByDay(List<CB_Custom_Schedule__c> custVals){
        Map<Date,clsCallBackCustomDay> custDaysMap = new Map<Date,clsCallBackCustomDay>();
        for (CB_Custom_Schedule__c item:custVals){
            Date day=item.CB_time_from__c.date();
            clsCallBackCustomDay custDay = custDaysMap.get(day);
            //value does not exists in the map
            if(custDay==null){
                List<CB_Custom_Schedule__c> itemList=new List<CB_Custom_Schedule__c>();
                itemList.add(item);
                custDay = new clsCallBackCustomDay(itemList);
                custDaysMap.put(day,custDay);
            }
            else{
                custDay.custVals.add(item);
            }
        }
        List<Date> mapKeys=new List<Date>();
        mapKeys.addAll(custDaysMap.keySet());
        mapKeys.sort();
		List<clsCallBackCustomDay> result = new List<clsCallBackCustomDay>();
		for (Date d:mapKeys){
			result.add(custDaysMap.get(d));
		}
		return result;
    }
    

}