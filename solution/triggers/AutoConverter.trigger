Trigger AutoConverter on Lead (after insert) {
	LeadStatus convertStatus = [
		select MasterLabel
		from LeadStatus
		where IsConverted = true
		limit 1
	];

	List<Database.LeadConvert> leadsToConvert = new List<Database.LeadConvert>();

	for (Lead lead: Trigger.new) {           
		if (!lead.isConverted && lead.WebForm__c == 'Free Trial') {
			Database.LeadConvert lc = new Database.LeadConvert();
			String oppName = lead.Name;
					
			lc.setLeadId(lead.Id);
			lc.setOpportunityName(oppName);
			lc.setConvertedStatus(convertStatus.MasterLabel);
					
			leadsToConvert.add(lc);
		}
	}

	if (!leadsToConvert.isEmpty()) {
		List<Database.LeadConvertResult> results = Database.convertLead(leadsToConvert);
	}
}