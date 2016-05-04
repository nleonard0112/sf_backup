@isTest
private class dmFundraiserForceBatchTest {


	//private static testMethod void testSchedule() {
	//	dmTestUtils.setupTestData();
    //    Test.startTest();
	//	dmFundraiserForceBatch.start();
	//	Test.stopTest();
	//}
	
	private static testMethod void testSummaryBatch() {

		dmTestUtils.setupTestData();
        Test.startTest();
		Id bid = Database.executeBatch(new dmFundraiserForceBatch(), 1);
		Test.stopTest();
	}
}