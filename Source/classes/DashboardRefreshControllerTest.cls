@isTest
private class DashboardRefreshControllerTest{
    static testMethod void refreshDashboardTest(){
        DashboardRefreshController drf = new DashboardRefreshController();
        DashboardRefreshController.TEST_MODE = true;
        drf.setup();
        drf.minutes = 0;  
        drf.refreshDashboard(); 
        DashboardRefreshController.TEST_MODE = false;
    }
}