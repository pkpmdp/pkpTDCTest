public with sharing class DashboardRefreshController 
{ 
 public Boolean needsRefresh {get; set;} 
 public Boolean canRefresh {get; set;} 
 public Id dbIdent {get; set;} 
 public Integer minutes {get; set;}
 public static boolean TEST_MODE = false; 
   
 public DashboardRefreshController() 
 { 
  needsRefresh=true; 
  setup(); 
  minutes=10; 
 } 
   
 public void setup() 
 { 
  Map<String, String> headers=ApexPages.currentPage().getHeaders(); 
  String referrer=headers.get('Referer'); 
    
  if(TEST_MODE){
   referrer='';
  } 
  
  if (null==referrer) 
  { 
   canRefresh=false; 
  } 
  else
  { 
   Integer lastSlashPos=referrer.lastIndexOf('/'); 
   lastSlashPos++; 
   Integer paramPos=referrer.indexOf('?', lastSlashPos); 
    
    
   String result=''; 
   if (-1!=paramPos) 
   { 
    result=referrer.substring(lastSlashPos, paramPos); 
   } 
   else
   { 
    result=referrer.substring(lastSlashPos); 
   } 
     
   try
   { 
    dbIdent=result; 
    canRefresh=true; 
   } 
   catch (Exception e) 
   { 
    canRefresh=false;  
   } 
  } 
 } 
   
 public PageReference refreshDashboard() 
 { 
  minutes--; 
  if (-1==minutes) 
  { 
   needsRefresh=false; 
   String refUrlStr='/dash/dashboardRefresh.apexp?id='+dbIdent; 
   Boolean refreshed=false; 
   Integer idx=0; 
   while ( (!refreshed) && (idx<10) ) 
   { 
    PageReference pr=new PageReference(refUrlStr); 
    Blob body= Blob.valueOf('');
    if(!TEST_MODE){
      body=pr.getContent(); 
    }  
    String bodyStr=body.toString(); 
    refreshed=(-1!=bodyStr.indexOf('Last refreshed')); 
    idx++; 
   } 
  } 
     
  return null; 
 } 
}