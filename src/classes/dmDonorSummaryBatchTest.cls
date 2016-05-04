@isTest
private class dmDonorSummaryBatchTest {

    private static testMethod void testTwiddle() {
        Test.startTest();
		dmDonorSummaryUtil.twiddle();
		Test.stopTest();
	}


	//private static testMethod void testSchedule() {
	//	dmTestUtils.setupTestData();
    //    Test.startTest();
	//	dmDonorSummaryBatch.start();
	//	Test.stopTest();
	//}
	
	private static testMethod void testSummaryBatch() {


		dmTestUtils.setupTestData();
        Test.startTest();
		Id bid = Database.executeBatch(new dmDonorSummaryBatch(), 50);
		Test.stopTest();

	}
}