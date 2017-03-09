//Carrie Batch class for refreshing Aria Accounts
global class CarrieBatchSchedular implements Schedulable {
   global void execute(SchedulableContext sc) {
      CarrieTransactionsBatch carrie = new CarrieTransactionsBatch('CarrieBatchSchedular'); 
      database.executebatch(carrie,1);
   }
}