@IsTest
private class AutoConverter_Test {
	private static Integer LEAD_COUNT = 0;

	private static Lead createLead() {
		LEAD_COUNT += 1;
		return new Lead(
			FirstName = '_unittest_firstname_: ' + LEAD_COUNT,
			LastName = '_unittest_lastname_: ' + LEAD_COUNT,
			Company = '_unittest_company_: ' + LEAD_COUNT,
			Status = 'Inquiry',
			WebForm__c = 'Not Free Trial'
		);
	}

	public static void makeFreeTrial(Lead lead) {
		lead.WebForm__c = 'Free Trial';
	}

	public static List<Lead> fetchLeads(Set<Id> ids) {
		return [
			select isConverted
			from Lead
			where Id in :ids
		];
	}

	public static testMethod void trialConvert() {
		Lead testLead = createLead();
		makeFreeTrial(testLead);
		
		Test.startTest();
		
		insert testLead;
		
		Test.stopTest();
		
		List<Lead> results = fetchLeads(new Set<Id>{testLead.Id});
		
		System.assertEquals(1, results.size(), 'Did not get the right number of leads back');
		System.assert(results.get(0).isConverted, 'The lead should have been converted since it was a "Free Trail"');
	}

	public static testMethod void nonTrialNoConvert() {
		Lead testLead = createLead();
		
		Test.startTest();
		
		insert testLead;
		
		Test.stopTest();
		
		List<Lead> results = fetchLeads(new Set<Id>{testLead.Id});
		
		System.assertEquals(1, results.size(), 'Did not get the right number of leads back');
		System.assert(!results.get(0).isConverted, 'The lead should not have been converted since it was not a "Free Trail"');
	}
}