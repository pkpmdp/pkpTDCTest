//Carrie Batch class for refreshing Aria Accounts
global class CarrieBatchSchedularWeekly implements Schedulable {
	global void execute(SchedulableContext sc) {
    	CarrieTransactionsBatch carrie = new CarrieTransactionsBatch('CarrieBatchSchedularWeekly'); 
      	database.executebatch(carrie,1); 
    }
}