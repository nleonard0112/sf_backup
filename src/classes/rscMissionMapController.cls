global with sharing class rscMissionMapController {

    private Id mMissionId;

    public rscMissionMapController(ApexPages.StandardController sc) {
        mMissionId = sc.getId();
    }

    public Id getMissionId() {
        return mMissionId;
    }
    
    //could be members/rendezvous points
    global class MapMarker { 

        public Decimal Lat; 
        public Decimal Lon;
        public String Id;
        public String Type;
        public Decimal Radius;

        public MapMarker(rscMission m) {
        //TODO - make MissionDevice (member?) and MissionRendezvous
        //implement an interface called positionable 
        //this interface should have the following methods
        // getLatitude/Longitude/Id/Type
            Lat  = m.getLatitude();
            Lon  = m.getLongitude();
            Id   = m.getId();
            Type = 'member';
        }

        public MapMarker(rscMissionRendezvous r) {
            Lat  = r.getLatitude();
            Lon  = r.getLongitude();
            Id   = r.getId();
            Type = 'rendezvous';
            Radius = r.getRadiusMeters();
        }

    }
    
    @RemoteAction
    global static List<MapMarker> getMarkers(String missionId) {
        
        List<MapMarker> markers = new List<MapMarker>();

        rscMission m = rscMission.find.byMissionId(missionId);
        markers.add(new MapMarker(m));

        //for(rscMissionMember d : rscMissionMember.find.byMissionIdAndType(missionId, 'Client')) {
        //    if(d.getLatitude() != null && d.getLongitude() !=null ) {
        //        markers.add(new MapMarker(d));
        //    }
        //}

        for(rscMissionRendezvous r : rscMissionRendezvous.find.byMissionId(missionId)) {
            markers.add(new MapMarker(r));
        } 

        return markers;
    }
}