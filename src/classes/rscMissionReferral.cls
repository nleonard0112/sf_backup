public with sharing class rscMissionReferral extends rscModel {

	public static Finder find = new Finder('rsc_Mission_Referral__c');

	public rscMissionReferral(rsc_Mission_Referral__c m) {
        super(m);
    }

    public rscMissionReferral(rscModel m) {
        this((rsc_Mission_Referral__c)m.getObj());
    }

    public void setMissionId(Id missionId) {
        getObj().put('Mission__c', missionId);
    }

    public void setReferredClient(Id referredClient) {
        getObj().put('Client_Referred__c', referredClient);
    }

    public Id getMissionId() {
        return (Id)getObj().get('Mission__c');
    }

    public String getBirthplace() {
        return (String)getObj().get('Country_Of_Birth__c');
    }

    public String getGender() {
        return (String)getObj().get('Client_Gender__c');
    }

    public class Finder extends rscFinder {

        public Finder(String sObjectName) {
            super(sObjectName);
        }

        public rscMissionReferral byMissionReferralId(Id missionReferralId) {
            return new rscMissionReferral(byId(missionReferralId));
        }
    }


}