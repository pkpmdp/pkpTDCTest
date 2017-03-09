// Schedular class for deleting handler objects 
global class batchHandlerObjectdeleteSchedular implements Schedulable {
   global void execute(SchedulableContext sc) {
      batchHandlerObjectdelete obj = new batchHandlerObjectdelete(); 
      database.executebatch(obj);
   }
}