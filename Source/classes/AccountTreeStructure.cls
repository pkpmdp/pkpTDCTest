public class AccountTreeStructure{
        // Find the tom most element in Heirarchy
        public String getTopElement(String objId) {
        	
        	    System.debug('**AccountTreeStructure :objId**'+objId);
                Boolean top = false;
                while (!top) {
                    //
                    // Change below
                    //
                    Account a = [Select a.id, a.ParentId From Account a where a.id = :objId LIMIT 1];
                    //
                    
                    if (a.ParentID != null) {
                        objId = a.ParentID;
                    }
                    else {
                        top=true;
                    }
                }
                return objId ;
        }
    
        // Determin if the element is a closing element
        public List<Boolean> setcloseFlag(List<String> cnl, List<String> nnl, String nodeType){
                List<Boolean> flagList = new List<Boolean>{};
                
                for(Integer i = nnl.size(); i < cnl.size();i++){
                            flagList.add(true);
                }
                return flagList;
        }
        
       
}