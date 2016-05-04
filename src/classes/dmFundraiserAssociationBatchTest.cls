@isTest
private class dmFundraiserAssociationBatchTest {


	//private static testMethod void testSchedule() {
	//	dmTestUtils.setupTestData();
    //    Test.startTest();
	//	dmFundraiserAssociationBatch.start();
	//	Test.stopTest();
	//}
	
	private static testMethod void testSummaryBatch() {

		dmTestUtils.setupTestData();
        Test.startTest();
		Id bid = Database.executeBatch(new dmFundraiserAssociationBatch(), 1);
		Test.stopTest();
	}
}