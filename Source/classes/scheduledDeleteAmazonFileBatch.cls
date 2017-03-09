global class scheduledDeleteAmazonFileBatch implements Schedulable{
    global void execute(SchedulableContext sc) {
        Amazon_batchDeleteInActiveAmazonFiles b = new Amazon_batchDeleteInActiveAmazonFiles(); 
        database.executebatch(b);
    }
}