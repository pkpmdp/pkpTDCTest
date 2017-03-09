global class YKSPOC_PostNewsInChatter implements Schedulable{

	global void execute(SchedulableContext SC){
		PostNewsInChatter pnc = new PostNewsInChatter();
		pnc.updateChatter();
	}
}