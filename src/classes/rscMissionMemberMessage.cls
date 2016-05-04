public class rscMissionMemberMessage extends rscModel {

    public static final String T_INCOMING = 'Incoming';
    public static final String T_OUTGOING = 'Outgoing';

    public static final String ACT_LOC_UPDATE = 'Location Update';
    public static final String ACT_WIPE = 'Wipe';
    public static final String ACT_GPS_OFF = 'GPS Off';
    public static final String ACT_GPS_ON = 'GPS On';


    public static Finder find = new Finder('rsc_Mission_Member_Message__c');

    public rscMissionMemberMessage(rsc_Mission_Member_Message__c m) {
        super(m);
    }

    public rscMissionMemberMessage(String jsonData) {
        this(new rsc_Mission_Member_Message__c(Payload__c = jsonData));
        Map<String,Object> decryptedBody = (Map<String,Object>)JSON.deserializeUntyped(jsonData);

        getObj().put('Location__latitude__s',decryptedBody.get('lat'));
        getObj().put('Location__longitude__s',decryptedBody.get('lon'));
        getObj().put('Battery__c',decryptedBody.get('bat'));
        getObj().put('Source__c',decryptedBody.get('source'));
        getObj().put('Speed__c',decryptedBody.get('speed'));
        getObj().put('Bearing__c',decryptedBody.get('bearing'));
        getObj().put('Accuracy__c',decryptedBody.get('accuracy'));
        getObj().put('Device_Id__c',decryptedBody.get('id'));
        getObj().put('Phone_Number__c',decryptedBody.get('phone'));
        getObj().put('Sent__c', DateTime.newInstance((Long)decryptedBody.get('time')));
        
    }

    public String getDeviceId() {
        return (String)getObj().get('Device_Id__c');
    }

    public Decimal getLatitude() {
        return (Decimal)getObj().get('Location__Latitude__s');
    }

    public Decimal getLongitude() {
        return (Decimal)getObj().get('Location__Longitude__s');
    }

    public void setType(String type) {
        getObj().put('Type__c',type);
    }

    public void setAction(String action) {
        getObj().put('Action__c',action);
    }
 
    public void setMission(Id mission) {
        getObj().put('Client__c',mission);
    }

    public rscMissionMemberMessage(rscModel m) {
        this((rsc_Mission_Member_Message__c)m.getObj());
    }

    public class Finder extends rscFinder {

        public Finder(String sObjectName) {
            super(sObjectName);
        }

        public rscMissionMemberMessage byMessageId(Id messageId) {
            return new rscMissionMemberMessage(byId(messageId));
        }

        public virtual List<rscMissionMemberMessage> byMissionId(String missionId) {
            List<rsc_Mission_Member_Message__c> messages = Database.query(getSelect() + 'where Mission__c =: missionId order by createddate desc');
            List<rscMissionMemberMessage> decorated = new List<rscMissionMemberMessage>();
            for(rsc_Mission_Member_Message__c m : messages) {
                decorated.add(new rscMissionMemberMessage(m));
            }
            return decorated;
        }

    } 



}