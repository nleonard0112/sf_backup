@isTest
private class dmTaxReceiptBatchTest {


	private static testMethod void testSchedule() {
		dmTestUtils.setupTestData();
		Test.setMock(HttpCalloutMock.class, new dmMockTaxReceiptResponse());
        Test.startTest();
		dmTaxReceiptBatch.start();
		Test.stopTest();
	}
	
	private static testMethod void testSummaryBatch() {

		dmTestUtils.setupTestData();
		Test.setMock(HttpCalloutMock.class, new dmMockTaxReceiptResponse());
        Test.startTest();
		Id bid = Database.executeBatch(new dmTaxReceiptBatch(UserInfo.getSessionId()), 1);
		Test.stopTest();

	}
}