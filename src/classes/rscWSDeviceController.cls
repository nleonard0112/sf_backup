@RestResource(urlMapping='/device/*')
global without sharing class rscWSDeviceController {
    
    /* Request looks like this
     * https://rescueapp-developer-edition.na16.force.com/services/apexrest/device/?id=a01j0000001ukP4
     * We probably don't even want a HTTP GET method like this
     * but this is for demonstration
     
    @HttpGet
    global static void getDeviceMessage() {

        String payload = RestContext.request.requestBody.toString();
        String guid = RestContext.request.params.get('guid');

        Map<String,String> encryptedBody = (Map<String,String>)JSON.deserialize(payload,  Map<String,String>.class);
        String encryptedData = encryptedBody.get('data');
        rscMissionMember member = rscMissionMember.find.byGUID(guid);

        //TODO get oubound messages and process them. (Mark them as sent?) actually - this should probably 
        //be a different controller altogether.

        Map<String,String> resp = new Map<String,String>();
        resp.put('status','OK');
        resp.put('name',device.getName());
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
    }*/

    /* 
     * This method should accept an encrypted JSON method from the 
     * android application to update the location of a particular device
     * 
     */
    @HttpPut
    global static void updateDevice() {

        RestContext.response.addHeader('Content-Type', 'application/json');
        
        String payload = RestContext.request.requestBody.toString();
        String guid = RestContext.request.params.get('guid');

        Map<String,String> encryptedBody = (Map<String,String>)JSON.deserialize(payload,  Map<String,String>.class);
        String encryptedData = encryptedBody.get('data');
        rscMission member = rscMission.find.byGUID(guid);

        Blob decryptedBlob = Crypto.decryptWithManagedIV('AES256', EncodingUtil.base64Decode(member.getKey()), EncodingUtil.base64decode(encryptedData));

        rscMissionMemberMessage mesg = new rscMissionMemberMessage(decryptedBlob.toString());
        

        //TODO - should do something here to 
        //detect replay attacks as well. E.g. numbering 
        // messages against datetimes or something
        if(!member.getDeviceId().equals(mesg.getDeviceId())) {
            //Don't throw ane exception, proceed as normal but maybe mark the record as compromised
            //TODO - send out alerts.
            member.setCompromised(true);
        }

        mesg.setAction(rscMissionMemberMessage.ACT_LOC_UPDATE);
        mesg.setType(rscMissionMemberMessage.T_INCOMING);

        //Add message in so geo coordinates are updated first
        //before we try to do computation below. 
        member.addMessage(mesg);
       
        //If the notification hasn't been sent out for client 
        //check rendezvous points and do so. 
        if(!member.getIsNotified()) {
            List<rsc_Mission_Rendezvous__c> closePickup =  [SELECT Id,Name,Rendezvous__r.Name,Rendezvous__r.Radius_Meters__c, Rendezvous__r.Location__Latitude__s,Rendezvous__r.Location__Longitude__s FROM rsc_Mission_Rendezvous__c where Mission__c =: member.getId()];
            for(rsc_Mission_Rendezvous__c r : closePickup) {

                Decimal lat1 = r.Rendezvous__r.Location__Latitude__s;
                Decimal lon1 = r.Rendezvous__r.Location__Longitude__s;

                Decimal lat2 = member.getLatitude();
                Decimal lon2 = member.getLongitude();

                //TODO - factor out computeDistance into rendezvous wrapper or something. 
                if(r.Rendezvous__r.Radius_Meters__c/1000 > computeDistance(lat1,lon1, lat2, lon2)) {
                    
                    List<String> numbers = new List<String>();
                    for(rsc_Ops_Team__c ops : [select Notification_Number__c from rsc_Ops_Team__c where Mission__c =: member.getId()]) {
                        numbers.add(ops.Notification_Number__c);
                    }
                    //TODO - put isNotified on mission ops team members?
                    if(numbers.size() > 0 && !member.getIsNotified()) {
                         rscTwilioHelper.sendBulkNotifications(numbers,'Client group entered the Rendezvous radius, ETA 36 hours');
                         member.setIsNotified(true);
                    }
                    else {
                        //TODO - panic since there is NO ONE to notify :(
                    }
                    break;
                }
            }
        }
        member.save();
        
        Map<String,String> resp = new Map<String,String>();
        resp.put('status','OK');
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));

    }

    /*  Computes the distance between two lat,long coordinates based on
     *  great circle math
     */
    private static Decimal computeDistance(Decimal lat1, Decimal lon1, Decimal lat2, Decimal lon2) {
        Decimal R = 6371; // km
        Decimal dLat = toRadians(lat2-lat1);
        Decimal dLon = toRadians(lon2-lon1);
        lat1 = toRadians(lat1);
        lat2 = toRadians(lat2);

        Decimal a = Math.sin(dLat/2) * Math.sin(dLat/2) +
        Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2); 
        Decimal c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
        return R * c;
    }

    /*  Computes radians from degrees
     */
    private static Decimal toRadians(Decimal degrees) {
        return degrees * (Math.PI/180);
    }


}