@isTest
private class tsmWSRegistrationControllerTest {

    private static testmethod void testRegisterUser() {
    	RestRequest req = new RestRequest(); 
        RestResponse resp = new RestResponse();

    	req.addHeader('Content-Type', 'application/json');
    	req.requestBody = Blob.valueOf('{"name":"Jason Swenski","lastname":"swenski", "firstname":"jason", "email":"jswenski@testlink.org"}');
    	RestContext.request = req;
    	RestContext.response = resp;

        Test.startTest();
    	tsmWSRegistrationController.registerUser();
    	Test.stopTest();
    	System.assert([select Id from tsm_Registration__c].size() == 1);
    }
	
}