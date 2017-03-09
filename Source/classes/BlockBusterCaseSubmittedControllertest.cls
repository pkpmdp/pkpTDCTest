@isTest
public class BlockBusterCaseSubmittedControllertest{

  public static testMethod void myUnitTest(){
    PageReference pageRef = Page.BlockBusterCaseSubmittedPage;
    Test.setCurrentPage(pageRef);
    ApexPages.currentPage().getParameters().put('/apex/WebCaseForm?browser_platform','exploree');
    BlockBusterCaseSubmittedController obj = new BlockBusterCaseSubmittedController();
    obj.goBack();

    }
}