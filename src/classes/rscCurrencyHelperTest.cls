@isTest
private class rscCurrencyHelperTest {
	private static testmethod void testConvert() {
		Test.setMock(HttpCalloutMock.class, new rscMockCurrencyResponse());

		Test.startTest();
        rscCurrencyHelper.convertCurrency(DateTime.now(), 'KRW', 'USD', 200);
		Test.stopTest();

		
	}
}