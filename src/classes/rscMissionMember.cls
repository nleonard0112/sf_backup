public class rscMissionMember extends rscModel {
    
    public static Finder find = new Finder('rsc_Client__c');

    public rscMissionMember() {
        this(new rsc_Client__c());
    }

    public rscMissionMember(sObject d) {
        super(d);
    }

    public rscMissionMember(rscModel m) {
        this((sObject)m.getObj());
    }

    public virtual override void save() {
        super.save();
    }

    public void setGender(String gender) {
        getObj().put('Gender__c', gender);
    }

    public void setBirthplace(String birthplace) {
        getObj().put('Birthplace__c', birthplace);
    }

    public Id getMissionId() {
        return (Id)getObj().get('Mission__c');
    }

    public void setMissionId(Id missionId) {
        getObj().put('Mission__c', missionId);
    }

    public class Finder extends rscFinder {

        public Finder(String sObjectName) {
            super(sObjectName);
        }

        public rscMissionMember byMemberId(Id memberId) {
            return new rscMissionMember(byId(memberId));
        }

        public virtual List<rscMissionMember> byMissionId(Id missionId) {
        
            
            List<rsc_Client__c> members = Database.query(getSelect() + 'where Mission__c =: missionId');
            List<rscMissionMember> decorated = new List<rscMissionMember>();
            for(rsc_Client__c d : members) {
                decorated.add(new rscMissionMember(d));
            }
            return decorated;

        }

        public virtual List<rscMissionMember> byMissionIdAndType(Id missionId, String type) {
        
            
            List<rsc_Client__c> members = Database.query(getSelect() + 'where Mission__c =: missionId AND Type__c =: type');
            List<rscMissionMember> decorated = new List<rscMissionMember>();
            for(rsc_Client__c d : members) {
                decorated.add(new rscMissionMember(d));
            }
            return decorated;

        }
    }
}