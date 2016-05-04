public with sharing class rscDevice extends rscModel {
    
    public static Finder find = new Finder('rsc_Device__c');

    public rscDevice(rsc_Device__c d) {
        super(d);
    }

    public rscDevice(rscModel m) {
        this((rsc_Device__c)m.getObj());
    }

    public class Finder extends rscFinder {

        public Finder(String sObjectName) {
            super(sObjectName);
        }

        public rscDevice byDeviceId(Id deviceId) {
            return new rscDevice(byId(deviceId));
        }
    }
}