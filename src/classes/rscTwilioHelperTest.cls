@isTest
private class rscTwilioHelperTest {
	private static testmethod void testTwilio() {

		Test.setMock(HttpCalloutMock.class, new rscMockTwilioResponse());

		Test.startTest();
		List<String> nums = new List<String>();
		nums.add('510-592-6398');
        rscTwilioHelper.sendBulkNotifications(nums,'a');
        rscTwilioHelper.sendNotification('510-592-6398', '510-592-6398', 'a');
		Test.stopTest();

		
	}
}