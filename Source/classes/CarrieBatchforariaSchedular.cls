//Carrie Batch class for creating aria accounts 
global class CarrieBatchforariaSchedular implements Schedulable {
   global void execute(SchedulableContext sc) {
      CarrieAriaBatch carrie_aria = new CarrieAriaBatch(); 
      if(!Test.isRunningTest())
      	database.executebatch(carrie_aria,1);
   }
}