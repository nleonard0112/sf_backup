@isTest
private class rscMissionReferralTest {

	private static testmethod void testReferral() {
		rsc_Mission_Referral__c mr = new rsc_Mission_Referral__c();
		insert mr;

		ApexPages.StandardController sc = new ApexPages.StandardController(mr);

		rscMissionReferralController mc = new rscMissionReferralController(sc);

        Test.startTest();
		mc.createMission();
		mc.MissionReferral.getMissionId();
		mc.MissionReferral.getBirthplace();
		mc.MissionReferral.getGender();

        Test.stopTest();


	}
	
}