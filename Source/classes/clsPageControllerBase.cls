public with sharing virtual class clsPageControllerBase {
	
    private clsComponentControllerBase myComponentController;
	
    public virtual clsComponentControllerBase getMyComponentController() {
        return myComponentController;
    }

    public virtual void setComponentController(clsComponentControllerBase compController) {
        myComponentController = compController;
    }
	
    public clsPageControllerBase getThis() {
        return this;
    }
    	
}