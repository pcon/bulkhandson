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

	public static testMethod void bulkNonConvert() {
		List<Lead> leads = new List<Lead>();
		
		for (Integer i = 0; i < 200; i++) {
			Lead lead = createLead();
			leads.add(lead);
		}
		
		Test.startTest();
		
		insert leads;
		
		Test.stopTest();
		
		Map<Id, Lead> leadMap = new Map<Id, Lead>(leads);
		leads = fetchLeads(leadMap.keySet());
		
		for (Lead lead: leads) {
			System.assert(!lead.IsConverted, 'Lead should not be converted');
		}
	}

	public static testMethod void bulkConvert() {
		List<Lead> leads = new List<Lead>();
		
		for (Integer i = 0; i < 200; i++) {
			Lead lead = createLead();
			makeFreeTrial(lead);
			leads.add(lead);
		}
		
		Test.startTest();
		
		insert leads;
		
		Test.stopTest();
		
		Map<Id, Lead> leadMap = new Map<Id, Lead>(leads);
		leads = fetchLeads(leadMap.keySet());
		
		for (Lead lead: leads) {
			System.assert(lead.IsConverted, 'Lead should be converted');
		}
	}

	public static testMethod void bulkConvertBonus() {
		List<Lead> shouldBeConverted = new List<Lead>();
		List<Lead> shouldNotBeConverted = new List<Lead>();

		for (Integer i = 0; i < 100; i++) {
			Lead testLeadNonConvert = createLead();
			Lead testLeadConvert = createLead();
			makeFreeTrial(testLeadConvert);
			
			shouldBeConverted.add(testLeadConvert);
			shouldNotBeConverted.add(testLeadNonConvert);
		}
		
		List<Lead> toInsert = new List<Lead>();
		toInsert.addAll(shouldBeConverted);
		toInsert.addAll(shouldNotBeConverted);
		
		Test.startTest();
		
		insert toInsert;
		
		Test.stopTest();
		
		Map<Id, Lead> expectedConversions = new Map<Id, Lead>(shouldBeConverted);
		Map<Id, Lead> expectedNonConversions = new Map<Id, Lead>(shouldNotBeConverted);
		
		Set<Id> leadIds = new Set<Id>();
		leadIds.addAll(expectedConversions.keySet());
		leadIds.addAll(expectedNonConversions.keySet());
		
		for (Lead result: fetchLeads(leadIds)) {
			if (expectedConversions.containsKey(result.Id)) {
				System.assert(result.isConverted, 'This lead should have been converted ' + result);
				expectedConversions.remove(result.Id);
			} else if (expectedNonConversions.containsKey(result.Id)) {
				System.assert(!result.isConverted, 'This lead should not have been converted ' + result);
				expectedNonConversions.remove(result.Id);
			} else {
				System.assert(false, 'We got a Lead we did not expect to get back ' + result);
			}
		}
		
		System.assert(expectedConversions.isEmpty(), 'We did not get back all the converted leads we expected');
		System.assert(expectedNonConversions.isEmpty(), 'We did not get back all the non converted leads we expected');
	}
}