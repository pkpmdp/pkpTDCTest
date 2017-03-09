global class scheduleBatchCustomerTeam implements Schedulable{
    global void execute(SchedulableContext sc) { 
           batchRetrieveCustomerTeam b = new batchRetrieveCustomerTeam();
           database.executebatch(b);
     }
}