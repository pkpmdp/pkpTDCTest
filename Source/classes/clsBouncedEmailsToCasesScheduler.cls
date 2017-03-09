global class clsBouncedEmailsToCasesScheduler implements Schedulable {

    global void execute(SchedulableContext SC) {
        // Actual code being executed has been implemented in:
        clsBouncedEmailsToCasesImpl impl = new clsBouncedEmailsToCasesImpl();
        impl.runJob();
    }
}