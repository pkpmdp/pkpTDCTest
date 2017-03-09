trigger EmailMessageBeforeDelete on EmailMessage (before delete) {
	for (EmailMessage em : Trigger.old) {
		if (UserInfo.getProfileId() != '00e20000000v9G1') {
			em.addError ('Cannot delete EmailMessages');
		}
	}
}