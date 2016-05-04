public with sharing class rscSurveyAnswerController {
	
	private Id mSurveyId;
	private rscSurvey mSurvey;

	public Integer QuestionNumber {get; set;}
	public rscSurveyQuestion Question {get; set;}
	public rscSurveyDefinition Definition {get; set;}
	public String Answer {get; set;}

	public rscSurveyAnswerController() {

        mSurveyId = ApexPages.currentPage().getParameters().get('sId');
        QuestionNumber = Integer.valueOf(ApexPages.currentPage().getParameters().get('qNum'));
        //get current question. 

        mSurvey = rscSurvey.find.bySurveyId(mSurveyId);
        
        Question = rscSurveyQuestion.find.bySurveyQuestionNumber(QuestionNumber);
        Definition = rscSurveyDefinition.find.bySurveyDefinitionId(mSurvey.getSurveyDefinitionId());

        //Answer = get the answer if one has been recorded.  

	}

	public List<SelectOption> getAnswerOptions() {
        List<SelectOption> options = new List<SelectOption>();
        for(String ans : Question.getPossibleAnswers()) {
        	options.add(new SelectOption(ans,ans));
        }
        return options;
    }

    public Boolean getShowSelectAnswerPanel() {
        return Question.getIsSelectType() || Question.getIsRatingType();
    }

    public Boolean getShowMultiSelectAnswerPanel() {
        return Question.getIsMultiselectType();
    }

    public Boolean getShowTextPanel() {
        return Question.getIsTextType();
    }

    private void saveAnswer() {

    }

	public PageReference saveAndContinue() {

        saveAnswer();
        
        Integer nextQuestionNumber = QuestionNumber + 1;
        if(Definition.getNumberOfQuestions() < nextQuestionNumber) {
             mSurvey.setStatusComplete();
             mSurvey.save();
             PageReference pg = new PageReference('/' + mSurveyId);
             pg.setRedirect(true);
             return pg;
        }
        
        mSurvey.setLastQuestionNumber(nextQuestionNumber);
        mSurvey.save();

        PageReference pg = new PageReference('/apex/rscSurveyAnswer');
        pg.getParameters().put('sId',mSurvey.getId());
        pg.getParameters().put('qNum',String.valueOf(nextQuestionNumber));
        pg.setRedirect(true);
        return pg;
	}

	public PageReference saveAndQuit() {

        saveAnswer();
        
        Integer nextQuestionNumber = QuestionNumber + 1;
        if(Definition.getNumberOfQuestions() < nextQuestionNumber) {
             mSurvey.setStatusComplete();
        }
        else {
            mSurvey.setLastQuestionNumber(nextQuestionNumber);
        }
        mSurvey.save();
		PageReference pg = new PageReference('/' + mSurveyId);
		pg.setRedirect(true);
		return pg;
	}

	public PageReference goBack() {

        //TODO - save the answer, mark current question on rsc_Survey
        //but go back one.

		return new PageReference('/');
	}

	public PageReference skipQuestion() {
        //don't save answer, mark current question, and move forward. 

		return new PageReference('/');
	}

}