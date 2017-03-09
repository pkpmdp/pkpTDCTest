public class cObjectStructureMap{
    public ObjectStructureMap pos {get; set;}
    public Boolean selected {get; set;}
    //Added - merge editportalusercontroller - createportalusercontroller
    public Boolean prevselected {get; set;}                      
    /*This is the contructor method. When we create a new cContact object we pass a 
     Contact that is set to the con property. We also set the selected value to false */
    
    public cObjectStructureMap(){
    	
    }
     public cObjectStructureMap(ObjectStructureMap a){
         pos = a;
         selected = false;
         prevselected = false;
    }
 
         /*public ObjectStructureMap pos {get; set;}
                public Boolean selected {get; set;}
                public Boolean prevselected {get; set;}
                public cObjectStructureMap(ObjectStructureMap a){
                    pos = a;
                    selected = false;
                    prevselected = false;
                }*/
}