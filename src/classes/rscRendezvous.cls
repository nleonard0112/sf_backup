public with sharing class rscRendezvous extends rscModel {
    
    public static Finder find = new Finder('rsc_Rendezvous__c');

    public rscRendezvous(rsc_Rendezvous__c d) {
        super(d);
    }

    public rscRendezvous(rscModel m) {
        this((rsc_Rendezvous__c)m.getObj());
    }

    public Decimal getRadiusMeters() {
        return (Decimal)getObj().get('Radius_Meters__c');
    }

    public Decimal getLatitude() {
        return (Decimal)getObj().get('Location__Latitude__s');
    }

    public void setLatitude(Decimal l) {
        getObj().put('Location__Latitude__s', l);   
    }

    public Decimal getLongitude() {
        return (Decimal)getObj().get('Location__Longitude__s');
    }

    public void setLongitude(Decimal l) {
        getObj().put('Location__Longitude__s', l);  
    }

    public void setRadiusMiles(Decimal m) {
        getObj().put('Radius_Miles__c',m);
    }

    public class Finder extends rscFinder {

        public Finder(String sObjectName) {
            super(sObjectName);
        }

        public rscRendezvous byRendezvousId(Id rendezvousId) {
            return new rscRendezvous(byId(rendezvousId));
        }
    }
}