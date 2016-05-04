@isTest
private class dmDonorMatchPDFControllerTest {
	private static testMethod void testController() {

       	dmTestUtils.setupTestData();
	    dm_Donor_Match__c c = [select Id from dm_Donor_Match__c limit 1];
	    ApexPages.currentPage().getParameters().put('id',c.Id);

        Test.startTest();
	    dmDonorMatchPDFController cont = new dmDonorMatchPDFController();
        Test.stopTest();


	}
}