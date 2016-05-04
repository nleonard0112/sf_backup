public with sharing class rscMissionController {
    rscMission mMission;
    public rscMissionController(ApexPages.StandardController sc) {
        mMission = rscMission.find.byMissionId(sc.getId());
    }

    //TODO - probably change this so that we can mark missions as 
    //failed/successful instead, also use static final consts
    public PageReference completeMission() {
        mMission.setStatus('Completed');
        mMission.save();
        return new PageReference('/' + mMission.getId());
    }


    public PageReference activateMission() {
        mMission.init();
        mMission.save();
        return new PageReference('/'+mMission.getId());
    }
}