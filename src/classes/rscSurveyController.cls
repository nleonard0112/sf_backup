public with sharing class rscSurveyController {
	
	private rscSurvey mSurvey;

	public rscSurveyController(ApexPages.StandardController sc) {
		mSurvey = rscSurvey.find.bySurveyId(sc.getId());
	}

	public PageReference doSurvey() {
        //Determine which is next question
        //show answer screen for that particular question
        PageReference pg = new PageReference('/apex/rscSurveyAnswer');
        pg.getParameters().put('sId',mSurvey.getId());
        pg.getParameters().put('qNum',String.valueOf(mSurvey.getLastQuestionNumber()));
		return pg;
	}
}