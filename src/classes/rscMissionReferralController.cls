public with sharing class rscMissionReferralController {

	public rscMissionReferral MissionReferral {get; set;}

	public rscMissionReferralController(ApexPages.StandardController sc)  {
		MissionReferral = rscMissionReferral.find.byMissionReferralId(sc.getId());
	}

	public PageReference createMission() {
       Id missionId = null;
       
       if(MissionReferral.getMissionId() == null) {

			rscMission mission = new rscMission();
			mission.save();
			missionId = mission.getId();

            rscMissionMember member = new rscMissionMember();
            member.setGender(MissionReferral.getGender());
            member.setBirthplace(MissionReferral.getBirthplace());
            member.setMissionId(mission.getId());

            member.save();


            MissionReferral.setReferredClient(member.getId());
			MissionReferral.setMissionId(mission.getId());
			MissionReferral.save();
	    }
	    else {
	    	missionId = MissionReferral.getMissionId();
	    }

		return new PageReference('/' + missionId);
	}
}