public class rscUnitTestUtils {

	public class TestSetup {
		public rscMissionMember client {get; set;}
		public rscMission mission {get; set;}
		public rscDevice device {get; set;}
		public rscMissionRendezvous rendezvous {get; set;}
	}

        public static rscSurveyDefinition getSurveyDefinition() {
                rsc_Resettlement_Survey_Definition__c sd = new rsc_Resettlement_Survey_Definition__c();
                sd.Name = 'Some Survey';
                insert sd;

                rsc_Resettlement_Survey_Question__c q1 = new rsc_Resettlement_Survey_Question__c();
                q1.Answer_Type__c = 'Multi-Select';
                q1.Question_Number__c = 1;
                q1.Possible_Answers__c = 'a;b;c';
                q1.Question__c = 'What is the right letter?';
                q1.Resettlement_Survey_Definition__c = sd.Id;
                insert q1;

                return new rscSurveyDefinition(sd);
        }

	public static TestSetup getMissionSetup() {
                if(!Test.isRunningTest()) return null;
         
        		TestSetup setup = new TestSetup();
        		setup.mission = getTestMission();
                setup.client = getTestClient();
                setup.device = getTestDevice();

                setup.client.setMissionId(setup.mission.getId());
                setup.client.save();
                setup.mission.setDeviceId(setup.device.getId());
                setup.mission.save();
                setup.rendezvous = getMissionRendezvous(setup.mission);

                return setup;
        	}

	public static rscMissionRendezvous getMissionRendezvous(rscMission m) {
		if(!Test.isRunningTest()) return null;

                rsc_Rendezvous__c rendezvous = new rsc_Rendezvous__c();
                rscRendezvous r = new rscRendezvous(rendezvous);
                r.setLatitude(39.648359);
                r.setLongitude(-104.727749);
                r.setRadiusMiles(10);
                r.save();

                rsc_Mission_Rendezvous__c mr = new rsc_Mission_Rendezvous__c();
                mr.Mission__c = m.getId();
                mr.Rendezvous__c = r.getId();
                insert mr;

		return new rscMissionRendezvous(mr);
	}
	
	public static rscMissionMember getTestClient() {
		if(!Test.isRunningTest()) return null;

                rsc_Client__c client = new rsc_Client__C();
                insert client;
		return new rscMissionMember(client);
	}

	public static rscMission getTestMission() {
		if(!Test.isRunningTest()) return null;

                rsc_Mission__c mission = new rsc_Mission__C();
                insert mission;
                mission.Key__c = '0YzgzebLwRZwn67B7LVISq4dLkPaCdtm5ooT9Pj0vBM=';
                mission.GUID__c = '473cc58c-e09c-4fc3-a384-9ec338de4bc2';
		return new rscMission(mission);
	}

	public static rscDevice getTestDevice() {
		if(!Test.isRunningTest()) return null;

                rsc_Device__c device = new rsc_Device__C();
                device.Device_Id__c = '00000000-5896-8b33-5595-f63d0033c587';
                insert device;
		return new rscDevice(device);
	}


}