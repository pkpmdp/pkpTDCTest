public with sharing class StatusMessagesWrapper {
	public Map<String, List<IWLBaseWidgetController.StatusMessage>> statusMessages { get; set; }
	
	public StatusMessagesWrapper(Map<String, List<IWLBaseWidgetController.StatusMessage>> statMessages) {
		this.statusMessages = statMessages;
	}
	
	public Integer size {
		get {
			return (this.statusMessages != null) ? this.statusMessages.size() : 0;
		} 
	}
	
	public Set<String> StatusGroups {
		get {
			return (this.statusMessages != null) ? this.statusMessages.keySet() : new Set<String>();
		}
	}
}