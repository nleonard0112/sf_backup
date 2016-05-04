@isTest
private class rscCryptoUtilTest {
    
    private static testmethod void testUUID() {
    	Test.startTest();
        System.assert(rscCryptoUtil.randomUUID() != null);
    	Test.stopTest();
    }

    private static testmethod void randomAESKey() {
    	Test.startTest();
        System.assert(rscCryptoUtil.randomUUID() != null);
    	Test.stopTest();
    }
}