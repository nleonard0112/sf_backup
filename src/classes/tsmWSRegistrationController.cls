@RestResource(urlMapping='/tsregister/*')
global without sharing class tsmWSRegistrationController {

    @HttpPost
    global static void registerUser() {

        RestContext.response.addHeader('Content-Type', 'application/json');
        String payload = RestContext.request.requestBody.toString();
        Map<String,String> body = (Map<String,String>)JSON.deserialize(payload,  Map<String,String>.class);
        String email = body.get('email');
        Boolean recommend = 'true'.equals(body.get('recommend'));
        //recommendation
        if(recommend) {

            insert new tsm_Registration__c(Email__c = email,
                                       Registration_Name__c = body.get('name'),
                                       Recommended_Name__c = body.get('theirName'),
                                       Company__c = body.get('company'),
                                       Other_Expertise__c = body.get('otherExpertise'),
                                       Expertise__c = body.get('areaExpertise'),
                                       LinkedIn__c = body.get('linkedin'),
                                       Recommendation__c = true
                                       );
        }
        //normal registration
        else {
            Contact newContact = getContact(email, body.get('firstname'),body.get('lastname'));
            insert new tsm_Registration__c(Email__c = email,
                                       Registration_Name__c = body.get('firstname') + ' ' + body.get('lastname'),
                                       Comments__c = body.get('comments'),
                                       Dietary_Concerns__c = body.get('dietary'),
                                       Phone__c = body.get('phone'),
                                       Company__c = body.get('company'),
                                       Other_Expertise__c = body.get('otherExpertise'),
                                       Expertise__c = body.get('areaExpertise'),
                                       Job_Title__c = body.get('title'),
                                       LinkedIn__c = body.get('linkedin'),
                                       Contact__c = newContact.Id);
        }
        
        Map<String,String> resp = new Map<String,String>();
        resp.put('status','OK');
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));

    }

    @HttpPut
    global static void doSurvey() {

        RestContext.response.addHeader('Content-Type', 'application/json');
        String payload = RestContext.request.requestBody.toString();
        Map<String,String> body = (Map<String,String>)JSON.deserialize(payload,  Map<String,String>.class);
        String email = body.get('email');
        
        tsm_Registration__c reg = [select Id from tsm_Registration__c where Email__c =: email AND Recommendation__c =: false limit 1];

        reg.How_Hear__c = body.get('howhear');
        reg.How_Familiar__c = toInt(body.get('howfamiliarnk'));
        reg.Familiar_With_Link__c = toBool(body.get('familiarlink'));
        reg.Morning_Brief__c = toInt(body.get('morning'));
        reg.North_Korean_Speakers__c = toInt(body.get('speakers'));
        reg.Issue_Experts__c = toInt(body.get('issueexperts'));
        reg.Overall_Event__c = toInt(body.get('overall'));
        reg.Stay_Involved__c = toBool(body.get('stayinvolved'));
        reg.Capacity__c = body.get('capacity');
        reg.Participate_Again__c = toBool(body.get('participateagain'));
        reg.Invite_Contacts__c = toBool(body.get('invitecontacts'));
        reg.General_Feedback__c = body.get('generalfeedback');
        reg.Make_Better__c = body.get('makebetter');
        reg.Project__c = body.get('project');
        reg.Commitment__c = body.get('commitment');
        reg.Follow_Up_Date__c = body.get('meeting');

        update reg;

        
        Map<String,String> resp = new Map<String,String>();
        resp.put('status','OK');
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));

    }

    private static Boolean toBool(String v) {
        return 'yes'.equalsIgnoreCase(v);
    }

    private static Integer toInt(String v) {
        return v == null ? null : Integer.valueOf(v);
    }


    private static Contact getContact(String email, String firstName, String lastName) {
        List<Contact> contacts = [select Id from Contact where Email =: email limit 1];
        Contact newContact = null;
        if(contacts.size() > 0) {
            newContact = contacts[0];
        }
        else {
            newContact = new Contact(LastName = lastName,
                                     FirstName = firstName, 
                                     Email = email);
            insert newContact;
        }
        return newContact;
    }

}