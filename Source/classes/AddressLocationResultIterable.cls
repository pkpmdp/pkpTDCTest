global class AddressLocationResultIterable implements Iterable<AggregateResult> {
   global Iterator<AggregateResult> Iterator(){
      return new AddressLocationResultIterator();
   }
}