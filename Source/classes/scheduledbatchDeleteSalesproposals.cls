global class scheduledbatchDeleteSalesproposals implements Schedulable{
    global void execute(SchedulableContext sc) {
        batchDeleteSalesproposals b = new batchDeleteSalesproposals(); 
        database.executebatch(b);
    }
}