public with sharing class rscMission extends rscModel {
    
    public static Finder find = new Finder('rsc_Mission__c');

    private List<rscMissionMemberMessage> mMessages;
    private Boolean mIsMessageListDirty = false;

    public rscMission() {
        this(new rsc_Mission__c());
    }

    public rscMission(rsc_Mission__c m) {
        super(m);
    }

    public rscMission(rscModel m) {
        this((rsc_Mission__c)m.getObj());
    }

    public void init() {
        generateUUID();
        generateKey();
    }

    public void addMessage(rscMissionMemberMessage message) {
        if(mMessages == null) {
            mIsMessageListDirty = true;
            mMessages = new List<rscMissionMemberMessage>();
        }
        message.setMission(this.getId());
        mMessages.add(message);

        //TODO check if its incoming location
        setLatitude(message.getLatitude());
        setLongitude(message.getLongitude());
    }

    public virtual override void save() {
        super.save();
        if(mMessages != null) rscModel.save(mMessages);
    }

    public String getStatus() {
        return (String)getObj().get('Status__c');
    }

    public void setStatus(String s) {
        getObj().put('Status__c', s);
    }

     public String getKey() {
        return (String)getObj().get('Key__c');
    }

    private void generateUUID() {
        getObj().put('GUID__c', rscCryptoUtil.randomUUID());
    }

    private void generateKey() {
        getObj().put('Key__c', rscCryptoUtil.randomAESKey());
    }

    public Boolean getCompromised() {
        return (Boolean)getObj().get('Compromised__c');
    }

    public void setCompromised(Boolean compromised) {
        getObj().put('Compromised__c',compromised);
    }

    public Boolean getIsNotified() {
        return (Boolean)getObj().get('SMS_Sent__c');
    }

     public void setIsNotified(Boolean notified) {
        getObj().put('SMS_Sent__c',notified);
    }


    public String getDeviceId() {
        return (String) getObj().get('Device__c');
    }

    public void setDeviceId(Id deviceId) {
        getObj().put('Device__c',deviceId);
    }

    public Decimal getLatitude() {
        return (Decimal)getObj().get('Location__Latitude__s');
    }

    public Decimal getLongitude() {
        return (Decimal)getObj().get('Location__Longitude__s');
    }

     public void setLatitude(Decimal lat) {
        getObj().put('Location__Latitude__s',lat);
    }

    public void setLongitude(Decimal lon) {
        getObj().put('Location__Longitude__s',lon);
    }

    public List<rscMissionMemberMessage> getMessages() {
        //If we added some messages and never queried for any
        //next time we try to get the messages, make sure and
        //combine the lists.
        if(mIsMessageListDirty) {
            List<rscMissionMemberMessage> temp = rscMissionMemberMessage.find.byMissionId(this.getId());
            mMessages.addAll(temp);
        }
        else if(mMessages == null) {
            mMessages = rscMissionMemberMessage.find.byMissionId(this.getId());
        }
        return mMessages;
    }

    public void purgeMessages() {
        rscModel.destroy(getMessages());
    }

    public class Finder extends rscFinder {

        public Finder(String sObjectName) {
            super(sObjectName);
        }

        public virtual rscMission byGUID(String guid) {
            addFields(new Set<String>{'Device__r.Device_Id__c'});
            return new rscMission(Database.query(getSelect() + 'where GUID__c =: guid'));
        }

        public rscMission byMissionId(Id missionId) {
            return new rscMission(byId(missionId));
        }
    }
}