public class BlockBusterCaseSubmittedController{
    public String returnUrl{get; set;}
    public String platform,customerno,email,facebookuserid,firstname,lastname,order_id,personid,phone;
    public String stylesheet{get; set;}
    public BlockBusterCaseSubmittedController(){
        Map<String, String> UrlParameterMap = ApexPages.currentPage().getParameters();
        //returnUrl=ApexPages.currentPage().getParameters().get('returlparam');
        System.debug('UrlParameterMap&&&&&&7' +UrlParameterMap);
        platform=UrlParameterMap.get('/apex/WebCaseForm?browser_platform');
        system.debug('platform***********'+platform);
        customerno=UrlParameterMap.get('customerno');
        email=UrlParameterMap.get('email');
        system.debug('************email'+email);
        facebookuserid=UrlParameterMap.get('facebookuserid');
        firstname=UrlParameterMap.get('firstname');
        lastname=UrlParameterMap.get('lastname');
        order_id=UrlParameterMap.get('order_id');
        personid=UrlParameterMap.get('personid');
        phone=UrlParameterMap.get('phone');
        stylesheet=UrlParameterMap.get('stylesheet');
        if(String.isBlank(email)){
        returnUrl='/apex/WebCaseForm?&firstname='+firstname+'&lastname='+lastname+'&phone='+phone+'&customerno='+customerno+'&personid='+personid+'&facebookuserid='+facebookuserid+'&order_id='+order_id+'&browser_platform='+platform+'&stylesheet='+stylesheet;
        }else{
        returnUrl='/apex/WebCaseForm?email='+email+'&firstname='+firstname+'&lastname='+lastname+'&phone='+phone+'&customerno='+customerno+'&personid='+personid+'&facebookuserid='+facebookuserid+'&order_id='+order_id+'&browser_platform='+platform+'&stylesheet='+stylesheet;
        }
        System.debug('The url to be hit' + returnUrl );
   }
   
   public PageReference goBack(){
       System.debug('The url to be hit***********' + returnUrl );
       PageReference pr= new PageReference(returnUrl);
       pr.setRedirect(true);
       return pr;
   
   
   }
}