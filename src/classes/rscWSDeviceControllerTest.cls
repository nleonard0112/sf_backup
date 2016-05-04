@isTest
public class rscWSDeviceControllerTest {

	 private static testmethod void testCommsEndpoint() {

	 	rscUnitTestUtils.TestSetup setup = rscUnitTestUtils.getMissionSetup();

	 	RestRequest req = new RestRequest();
	    RestResponse res = new RestResponse();

	    req.requestBody = Blob.valueOf('{"data":"usz7ih+J9vqOCG3SIjdBGldH5OM+vWx+Y2XyzXiznvyaRI\\/PTH22oEbIqBRKCima3AZTHsKIJ0W0\\nFlNvMdLy0T6wOfr3JvciYMgaBsCdX0qbTszPYM3iV2tkcHPT1nDSBUNzW+tNDv6wnHyeZtDB4wXb\\n9lD56tkXUz+Bp6zGPzRPCfpVrwcFOSc68J\\/L5CkaWE67l6q9XfkmaDtmYVqdnDfXBciDk2xWCUVD\\ncb7ZdmSQK8YqzT\\/I5C02UsU4QD33onUcSUboYGYSW32EyVbWsg==\\n"}');
        req.params.put('guid','473cc58c-e09c-4fc3-a384-9ec338de4bc2');


	    req.requestURI = '/services/apexrest/device';  //Request URL
	    req.httpMethod = 'PUT';//HTTP Request Type
	    RestContext.request = req;
	    RestContext.response = res;

	    Test.setMock(HttpCalloutMock.class, new rscMockTwilioResponse());


	 	Test.startTest();

	 	rscWSDeviceController.updateDevice();

	 
	 	setup.mission.init();

        ApexPages.StandardController sc = new ApexPages.StandardController(setup.mission.getObj());
	 	rscMissionMapController mc = new rscMissionMapController(sc);

	 	rscMissionMapController.getMarkers(setup.mission.getId());


	 	Test.stopTest();

	 	



	 }
	
}