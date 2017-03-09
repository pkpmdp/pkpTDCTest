//Carrie Batch class for creating aria accounts 
global class CarrieBatchforcustSchedular implements Schedulable {
   global void execute(SchedulableContext sc) {
      CarrieCustomersBatch carrie_cust = new CarrieCustomersBatch(); 
      if(!Test.isRunningTest())
      	database.executebatch(carrie_cust,1);
   }
}