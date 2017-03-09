global class scheduledBatchCountAccount implements Schedulable{
    global void execute(SchedulableContext sc) { 
           batchCountAccountOnContact b = new batchCountAccountOnContact();
           database.executebatch(b, 100);
     }
}