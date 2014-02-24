require 'csv'
class QuestionsController < ApplicationController
before_filter :authenticate_user!,  only: [:report]


	def index
		@question = Question.new
	end

	def create
		@question = Question.new(question_params) 
		respond_to do |format|
			if @question.save
	        	format.html { redirect_to questions_path, notice: 'One question was successfully submitted.' }
	        else
	        	if @question.question_text.blank?
	        		format.html {redirect_to questions_path , notice: "Please input your question."}
	        	else
	        		format.html {redirect_to questions_path , notice: "Incorret answer. Please answer another question."}
	        	end	
	      	end 
  		end
	end

	def report
			
		if params[:search]
			@from = params[:search][:from_date]
			@to = params[:search][:till_date]
			@questions = Question.search(params[:search]) 

			respond_to do |format|
				if Question.check_date_request?(params[:search])
					format.html {redirect_to report_questions_path, notice: "FROM DATE cannot be greater than TO DATE "}
				else
					format.html
				end
			
				format.csv { send_data @questions.to_csv }
			end
		end

		
		
	end	

private
  def question_params
    params.require(:question).permit!
  end
end