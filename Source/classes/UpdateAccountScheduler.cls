/**
 * UpdateAccountScheduler implements the Schedulable interface.
 * The actual code being executed is located in UpdateAccountSchedulerImpl.
 */
global class UpdateAccountScheduler implements Schedulable {

    global void execute(SchedulableContext SC) {
        UpdateAccountSchedulerImpl impl = new UpdateAccountSchedulerImpl();
        impl.runJob();
    }
}