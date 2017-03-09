public class cAccount{

   /* This is our wrapper/container class. A container class is a class, a data 
            structure, or an abstract data type whose instances are collections of other 
            objects. In this example a wrapper class contains both the standard salesforce 
            object Contact and a Boolean value */
     public Account acc {get; set;}
     public Boolean selected {get; set;}
                
    /*This is the contructor method. When we create a new cContact object we pass a Contact that is set to the con property. We also set the selected value to false */
    public cAccount(Account a){
              acc = a;
              selected = false;
    }
}