public with sharing class rscMissionRendezvous extends rscModel {
    
    public static Finder find = new Finder('rsc_Mission_Rendezvous__c');


    public rscMissionRendezvous(rsc_Mission_Rendezvous__c d) {
        super(d);
    }

    public rscMissionRendezvous(rscModel m) {
        this((rsc_Mission_Rendezvous__c)m.getObj());
    }

    public Decimal getRadiusMeters() {
        return (Decimal)getObj().getSObject('Rendezvous__r').get('Radius_Meters__c');
    }

    public Decimal getLatitude() {
        return (Decimal)getObj().getSObject('Rendezvous__r').get('Location__Latitude__s');
    }

    public Decimal getLongitude() {
        return (Decimal)getObj().getSObject('Rendezvous__r').get('Location__Longitude__s');
    }

    public class Finder extends rscFinder {

        public Finder(String sObjectName) {
            super(sObjectName);
            addFields(new Set<String> {
                'Rendezvous__r.Radius_Meters__c',
                'Rendezvous__r.location__latitude__s',
                'Rendezvous__r.Location__Longitude__s'
            });
        }

        public rscMissionRendezvous byRendezvousId(Id rendezvousId) {
            return new rscMissionRendezvous(byId(rendezvousId));
        }

        public virtual List<rscMissionRendezvous> byMissionId(Id missionId) {
            List<rsc_Mission_Rendezvous__c> members = Database.query(getSelect() + 'where Mission__c =: missionId');
            List<rscMissionRendezvous> decorated = new List<rscMissionRendezvous>();
            for(rsc_Mission_Rendezvous__c d : members) {
                decorated.add(new rscMissionRendezvous(d));
            }
            return decorated;
        }
    }
}