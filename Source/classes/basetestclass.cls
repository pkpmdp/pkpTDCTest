@isTest(SeeAllData=true)
public class basetestclass {
public void createcase(){
        Case c = new Case();
        
       // insert close case;
    c.Status = 'Cancelled';
    system.debug('/status from case*******' +c.Status);
    c.Internal_Comments_Close_Reason__c = 'hi this is a test demo';
    system.debug('close reason=========='+c.Internal_Comments_Close_Reason__c);
    c.Type_Task__c ='NP in-port';
    system.debug('type task for case*********'+c.Type_Task__c);
    c.NP_Order__c ='a18M0000000978kIAA';
    c.RecordTypeId = '012200000001M7E';
    insert c;
   
    }
    // insert for comment
     public  static CaseComment createcomment(Case ca){
     CaseComment com = new CaseComment();
     com.CommentBody = ca.Internal_Comments_Close_Reason__c;
     system.debug('comment in casecomment***********'+com.CommentBody);
     return com;
  
    }
    static testMethod void CaseTestClass()
        {
           //New Address;
         Address__c addr  = new Address__c();
        addr.Town__c = 'AH';
        addr.Postcode__c = '421002';
        addr.Door_No__c = '301';
        //addr.Side__c = 'A';
        addr.Floor__c = 'Third';
        addr.House_No__c = 'testData';
        addr.Street__c = 'AH';
        addr.Entrance__c = 'A';
        insert addr;
            
             // insert a new customer

        Account acc = new Account();
        acc.Name = 'TestHierarchy';
        acc.Type='Kunde';
        acc.Customer_Segment_Lookup__c = clsTestDataForYS.createLookupCustomerSegment();  
        acc.Street_YK__c = addr.Id;
        acc.Street_YK__r = addr;
        acc.Customer_No__c='1234';
        System.debug(' Address----- '+acc.Street_YK__r);
        insert acc;
            
 /*         // for new contact
    YSRecordTypes__c ysRecords = YSRecordTypes__c.getInstance('YSRecordTypes');    
    String ysContactRecordType = ysRecords.YS_Contact_Record_Type__c;  
       Contact contact1 = new Contact(); 
    //   contact.FirstName = 'TestContactFirstname';
       contact1.LastName = 'TestContactLastname';
       contact1.Email = 'sneha.salunkhe@capgemini.com';
       contact1.Phone = '2222221';
       contact1.RecordTypeId=ysContactRecordType; 
            
   //    contact.MobilePhone = '3333331';
   //    contact.HomePhone = '4444441';
     //  contact.HierarchyAccount__c = acc.id;
    //   contact.Street_P__c = addr.Id;
   //   contact.KissPartyId__c = 'KAS.P2---4015110456';
      contact1.AccountId = acc.Id;
            system.debug('account id*******'+contact1.AccountId);
    //  contact.Account.PersonEmail = contact.Email;
   //   system.debug('*************'+contact.Account.PersonEmail);
      insert contact1;
            
            system.debug('this is before contact');
            system.debug('contact*******'+contact1);
            
            system.debug('hiiiiiiiiii this is fter contact');
        /*    insert acc;
            system.debug('acc.personemail*******'+acc);*/
        
// for np order object

     NP_ORDER__c np = new  NP_ORDER__c();
            np.Telephone_Number__c = '12345678';
            np.Customer_Number__c = '666';
            np.Status__c='NP Order Arrived';
            np.Customer_Name__c='namita P';
            np.Current_Customer_Id__c='1234';
            np.Customer_Email__c ='namita.patil@capegmini.com';
     
           insert np;
                   
            NP_ORDER__c np2 = new  NP_ORDER__c();
            np2.Telephone_Number__c = '';
            np2.Customer_Number__c = '';
            np2.Status__c='NP Order Arrived';
            np2.Customer_Name__c='namita P';
            np2.Current_Customer_Id__c='1234';
            np2.Customer_Email__c ='';
            insert np2;
        
            NP_ORDER__c np3 = new  NP_ORDER__c();
            np3.Telephone_Number__c = '48253445';
            np3.Customer_Number__c = '666';
            np3.Status__c='NP Order Arrived';
            np3.Customer_Name__c='';
            np3.Current_Customer_Id__c='1234';
            np3.Customer_Email__c ='namita.patil@capegmini.com';
            insert np3;
          
 Case c = new Case();
        
       // insert close case;
    c.Status = 'Cancelled';
    system.debug('/status from case*******' +c.Status);
    c.Internal_Comments_Close_Reason__c = 'hi this is a test demo';
    c.Save_in_Kundelog__c=true;
    c.AccountId=acc.id;
    system.debug('close reason=========='+c.Internal_Comments_Close_Reason__c);
    c.Type_Task__c ='NP in-port';
    system.debug('type task for case*********'+c.Type_Task__c);
    c.NP_Order__c =np.Id;
    c.Anlaeg_No_New__c='00924111';      
    c.Customer_Number__c='123456769';
    c.Origin='Kasia';
    c.Product_2__c = 'YOT Call Back';
    c.Department__c ='Blockbuster';
    c.RecordTypeId = '012200000001M7E'; 
  //  update c.RecordTypeId;
    system.debug('record type c------'+c.RecordTypeId);

    insert c;
   
    Case c2 = new Case();
    c2.Status = 'Closed';
    system.debug('/status from case*******' +c2.Status);
    c2.Internal_Comments_Close_Reason__c = 'hi this is a test demo2';
    c2.Save_in_Kundelog__c=true;
    c2.AccountId=acc.id;
    system.debug('close reason=========='+c2.Internal_Comments_Close_Reason__c);
    c2.Type_Task__c ='NP out-port';
    system.debug('type task for case*********'+c2.Type_Task__c);    
    c2.Anlaeg_No_New__c='00924112';      
    c2.Customer_Number__c='';
  //  c2.NP_Customer_Number__c'1234';
    c2.NP_Order__c=np2.Id;
    c2.Product_2__c = 'Andet';
    c2.Department__c ='YKRL';
 //   c2.AccountId='0012000000PU1oXAAT';
    c2.Origin='Kasia';
  //  c2.RecordTypeId = '';
    system.debug('record type c2------'+c2.RecordTypeId);
    insert c2;   
    
            
    Case c3 = new Case(); 
    c3.Status = 'NP Reserved';
    system.debug('/status from case*******' +c3.Status);
    c3.Internal_Comments_Close_Reason__c = 'hi this is a test demo 3';
    c3.Save_in_Kundelog__c=true;
    c3.AccountId=acc.id;
    system.debug('close reason=========='+c3.Internal_Comments_Close_Reason__c);
    c3.Type_Task__c ='NP in-port';
    system.debug('type task for case*********'+c3.Type_Task__c);
    c3.NP_Order__c =np3.Id;
    c3.Anlaeg_No_New__c='00924111';      
    c3.Customer_Number__c='';
    c3.Product_2__c = 'Betaling';
    c3.Department__c ='CCE';
    c3.RecordTypeId = '012D0000000AjY4';
            system.debug('record type c3------'+c3.RecordTypeId);
            
    insert c3;
 
            
       case a =[select id,casenumber from case where id=:c.id];
       System.debug('Case-->'+a);
           
            //insert for casecomment
       CaseComment com = new CaseComment();
       com.ParentId=c.id;
       com.CommentBody = c.Internal_Comments_Close_Reason__c;
       insert com;
            
           
       System.debug('customer no******'+acc);
 
        }
       
}