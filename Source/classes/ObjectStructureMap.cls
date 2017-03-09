public class ObjectStructureMap{

    public String nodeId;
    public String nodeType;
    
    public Boolean[] levelFlag = new Boolean[]{};
    public Boolean[] closeFlag = new Boolean[]{};
    
    public Boolean currentNode;
    public Boolean selected;
    public Account account;
   
    public Boolean[] getlevelFlag() { return levelFlag; }
    public Boolean[] getcloseFlag() { return closeFlag; }
    
    public String getnodeId() { return nodeId; }
    public String getnodeType() { return nodeType; }
    
    public Boolean getcurrentNode() { return currentNode; }
    public Boolean getselected() { return selected; }
    public Account getaccount() { return account; }
    
    public void setnodeId( String n ) { this.nodeId = n; }
    public void setlevelFlag( Boolean l ) { this.levelFlag.add(l); }
    public void setlcloseFlag( Boolean l ) { this.closeFlag.add(l); }
    public void setnodeType( String nt ) { this.nodeType = nt; }
    public void setcurrentNode( Boolean cn ) { this.currentNode = cn; }
    public void setselected( Boolean sel ) { this.selected = sel; }
    public void setaccount( Account a ) { this.account = a; }
    
    public ObjectStructureMap(){
    	
    }
    
    //Constructor called edit portal user controller
    public ObjectStructureMap(String nodeId, Boolean[] levelFlag,Boolean[] closeFlag , String nodeType, Boolean lastNode, Boolean currentNode, Account a){
          this.nodeId = nodeId;
          this.levelFlag = levelFlag; 
          this.closeFlag = closeFlag;
          this.nodeType = nodeType;
          this.currentNode = currentNode;
          this.account = a;
        }
        
        //constructor called createportaluser controller
    public ObjectStructureMap(String nodeId, Boolean[] levelFlag,Boolean[] closeFlag , String nodeType, Boolean lastNode, Boolean currentNode, Account a, Boolean selected){
        this.nodeId = nodeId;
        this.levelFlag = levelFlag; 
        this.closeFlag = closeFlag;
        this.nodeType = nodeType;
        this.currentNode = currentNode;
        this.account = a;
        this.selected = selected;
     }

}