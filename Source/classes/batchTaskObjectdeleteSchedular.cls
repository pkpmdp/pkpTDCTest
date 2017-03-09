// Schedular class for deleting Task objects 
global class batchTaskObjectdeleteSchedular implements Schedulable {
   global void execute(SchedulableContext sc) {
      batchTaskObjectdelete obj = new batchTaskObjectdelete(); 
      database.executebatch(obj);
   }
}