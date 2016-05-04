@isTest
private class rscFinderTest {
	private static testmethod void testFinder() {
		
		Contact c = new Contact();
		c.LastName = 'contact' + DateTime.now();
		insert c; 
        
		Test.startTest();
        rscFinder find = new rscFinder('Contact');
 
        find.getFieldSet();
        find.byId(c.Id);
		Test.stopTest();
	}
}