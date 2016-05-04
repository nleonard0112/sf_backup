@isTest
private class touClonerUtilTest {
	@isTest
	static void itShouldCloneOppts() {
		// Given
		Opportunity opt = new Opportunity();
		Account acct = new Account();

		acct.Name = 'Test Account ' + DateTime.now();
		insert acct;
		opt.Name = 'Test Opt + ' + DateTime.now();
		opt.AccountId = acct.Id;
        opt.StageName = 'Prospecting';
        opt.Probability = 0;
        opt.Type = '2015 Spring Tour';
        opt.CloseDate = Date.today();
        insert opt;

		Test.startTest();
        touClonerUtil.cloneOpps('1/2/2020', 'Fall', '2015');
		// Whens
		Test.stopTest();
        // Then
        System.assert([select Id from Opportunity].size() > 1);
		

	}
}