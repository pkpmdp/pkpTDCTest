global class Custom_Exception extends Exception {

	global Boolean isCritical{get; set;}
	
	global Custom_Exception(String msg,Boolean ic){
		this.setMessage(msg);
		this.isCritical = false;
	}

}