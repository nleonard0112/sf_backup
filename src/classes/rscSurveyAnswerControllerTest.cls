@isTest
private class rscSurveyAnswerControllerTest {
	
	private static testmethod void testSurvey() {

		rscSurveyDefinition sd = rscUnitTestUtils.getSurveyDefinition();


        rsc_Resettlement_Survey__c survey = new rsc_Resettlement_Survey__c();
        survey.Client__c = rscUnitTestUtils.getTestClient().getId();
        survey.Resettlement_Survey_Definition__c = sd.getId();
        rscSurvey s = new rscSurvey(survey);
        s.save();


		ApexPages.currentPage().getParameters().put('sId',s.getId());
		ApexPages.currentPage().getParameters().put('qNum','1');

		Test.startTest();

        rscSurveyAnswerController sac = new rscSurveyAnswerController();
        sac.getAnswerOptions();
        sac.getShowMultiSelectAnswerPanel();
        sac.getShowSelectAnswerPanel();
        sac.getShowTextPanel();
        sac.saveAndContinue();
        sac.saveAndQuit();
        sac.goBack();

        sac.Question.getQuestionText();
        sac.Question.getQuestionNumber();
        sac.Question.getSectionName();
        sac.Question.getPossibleAnswers();
        sac.Question.getType();
        sac.Question.getIsRatingType();
        sac.Question.getIsMultiselectType();
        sac.Question.getIsSelectType();
        sac.Question.getIsTextType();

        s.getLastQuestionNumber();
        s.getSurveyDefinitionId();
        s.setLastQuestionNumber(1);
        s.setStatusComplete();
      
		Test.stopTest();
	}
}