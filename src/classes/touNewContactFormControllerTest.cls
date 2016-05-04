@isTest
private class touNewContactFormControllerTest {
	
	//setup an account, opportunity and event owner (contact)
    static Account setup() {
    
		Account a = new Account();
		a.Name = 'Test Account' + DateTime.now();
        insert a;

        Contact c = new Contact();
        c.LastName = 'Test Contact' + DateTime.now();
        c.AccountId = a.Id;
        insert c;

        
        Opportunity opp = new Opportunity();
        opp.AccountId = a.Id;
        opp.Name = 'Some Random Opp' + Datetime.now();
        opp.Contact__c = c.Id;
        opp.StageName = 'Prospecting';
        opp.Probability = 0;
        opp.CloseDate = Date.today();
        insert opp;

        return a;
    }


	@isTest
	static void itShouldSaveAndNew() {
 
        //Given
		Account a = setup();
		Contact c = [select Id from Contact where AccountId =: a.Id];

		// When we load the page and then click save 
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(a);
        touNewContactFormController cont = new touNewContactFormController(sc);

        Contact newC = new Contact();
        newC.LastName = 'Test Contact' + DateTime.now();
        newC.AccountId = a.Id;

        cont.AccountContact = newC;
        cont.saveAndNewContact();


        Test.stopTest();

        // Then, the Contact (Event Coordinator) for the most recent opportunity should change
        System.assert([select Contact__c from Opportunity where AccountId =: a.Id].Contact__c != c.Id);

	}

	@isTest
	static void itShouldCancel() {
		
         //Given an account
		Account a = setup();
		Contact c = [select Id from Contact where AccountId =: a.Id];


		// When we load the page and cancel it
		Test.startTest();

		ApexPages.StandardController sc = new ApexPages.StandardController(a);
        touNewContactFormController cont = new touNewContactFormController(sc);


		Contact newC = new Contact();
        newC.LastName = 'Test Contact' + DateTime.now();
        newC.AccountId = a.Id;

        cont.AccountContact = newC;
        cont.cancelContact();


        Test.stopTest();

        // Then, the Contact (Event Coordinator) for the most recent opportunity should be intact
        System.assert([select Contact__c from Opportunity where AccountId =: a.Id].Contact__c == c.Id);

	

	}
}