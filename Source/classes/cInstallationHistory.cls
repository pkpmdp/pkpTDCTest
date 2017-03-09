global class cInstallationHistory implements comparable{

        global String Installation_Lbnr{get;set;}
        global String formattedAddress{get;set;}
        global String StartDate{get;set;}
        global String EndDate{get;set;}
        global String ProductName{get;set;}
        
        global Integer compareTo(Object ObjToCompare) {
            cInstallationHistory comapareToStud = (cInstallationHistory)ObjToCompare;      
            
            Date passedDate = Date.parse(comapareToStud.EndDate);
            passedDate = date.newInstance(passedDate.year(), passedDate.month(), passedDate.day());
            system.debug('passedDate====='+passedDate);
           
            Date Nowdate =  Date.parse(this.EndDate);
            Nowdate = date.newInstance(Nowdate.year(), Nowdate.month(), Nowdate.day());
            system.debug('Nowdate========'+Nowdate);
           
            if(Nowdate == passedDate )
            { 
               return 0;
            }
            else if(Nowdate < passedDate)
            {   
                return 1;
            }
            else{       
                return -1;
                }
        }
}