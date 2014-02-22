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
	        	format.html {redirect_to questions_path , notice: "There is some issue for submitting your question."}
	      	end 
  		end
	end

	def report
			#@from = Date.today.strftime("%d/%m/%Y")
			#@to = Date.today.strftime("%d/%m/%Y")
		if params[:search]
			@from = params[:search][:from_date]
			@to = params[:search][:till_date]
			@questions = Question.search(params[:search]) 
		end

		respond_to do |format|
			format.html
			format.csv { send_data @questions.to_csv }
		end
		
	end	

private
  def question_params
    params.require(:question).permit!
  end
end