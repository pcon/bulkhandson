Trigger AutoConverter on Lead (after insert) {
	for (Lead lead: Trigger.new) {
		LeadStatus convertStatus = [
				select MasterLabel
				from LeadStatus
				where IsConverted = true
				limit 1
			];
			
		if (!lead.isConverted && lead.WebForm__c == 'Free Trial') {
			Database.LeadConvert lc = new Database.LeadConvert();
			String oppName = lead.Name;
					
			lc.setLeadId(lead.Id);
			lc.setOpportunityName(oppName);
			lc.setConvertedStatus(convertStatus.MasterLabel);
					
			Database.LeadConvertResult result = Database.ConvertLead(lc);
		}
	}
}