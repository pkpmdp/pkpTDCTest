public with sharing class clsConsoleCustomerRedirectController {
public String idParam{get;set;}
public String idAccount{get;set;}
public String mess{get;set;}
public clsConsoleCustomerRedirectController(){
idParam=System.currentPagereference().getParameters().get('id');
    mess ='No customer attached, Please attach a customer';
            if (idParam!=null){
                if (idParam.startsWith('001')){
                    idAccount=idParam;
                }
                else if (idParam.startsWith('003')){
                    List<Contact> contactList = [Select AccountId From Contact where id=:idParam];
                    if (contactList.size()==1){
                        idAccount = contactList[0].AccountId;
                    }
                }
                else if (idParam.startsWith('500')){
                    List<Case> caseList = [Select AccountId From Case where id=:idParam];
                    if (caseList.size()==1){
                        idAccount = caseList[0].AccountId;
                    }
                }
            }
            system.debug('#############  ' + idAccount); // DEBUG VISHAL
}


public PageReference RedirectToCustomerpanel(){
if(idAccount!=null && idAccount.length()>5)
return new PageReference('/apex/ConsoleCustomerLeftPanelPoC_YKRB?id='+idAccount);
else
return new PageReference('/apex/ConsoleCustomerLog?id='+idParam);
}
}