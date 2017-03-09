public with sharing virtual class clsComponentControllerBase {

    public clsPageControllerBase pageController { get; 
        set {
            if (value != null) {
	            pageController = value;
                pageController.setComponentController(this);
            }
        }
    }
}