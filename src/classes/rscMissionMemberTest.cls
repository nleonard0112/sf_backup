@isTest
private class rscMissionMemberTest {
	

	private static testmethod void testModel() {
          	
        rscMissionMember member = rscUnitTestUtils.getTestClient();
    	Test.startTest();

	    member.setGender('Male');
	    member.setBirthplace('Someplace');
	    member.save();
	    Id misId = member.getMissionId();
        Id memId = member.getId();

        List<rscMissionMember> members = rscMissionMember.find.byMissionId(misId);
        member = rscMissionMember.find.byMemberId(memId);

    	Test.stopTest();
    }
}