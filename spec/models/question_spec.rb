require 'spec_helper'
require 'csv'

describe Question do
	
	it "should check the date request and return true if from date > till date " do
		search  = { :from_date =>"01/03/2014", :till_date =>"13/03/2014"}
		wrong_date_request = Question.check_date_request?(search)
	 	wrong_date_request.should == false
	end

	it "should check, validate and display blank error mesage" do
		question = Question.new
		question.should_not be_valid
		expect { question.save! }.to raise_error(ActiveRecord::RecordInvalid)
	end

	it "should search and return the question" do
		Question.create(question_text: "Doing rspec testing", bypass_humanizer: true)
		search  = { :from_date =>"10/03/2014", :till_date =>"13/03/2015"}	     	
		questions =  Question.search(search)
		questions.should_not be_empty
	end

	it "should export the question list to csv " do
		expected_csv = File.read('report.csv')
		@question = Question.create(question_text: "test" , created_at: "11/02/2014", bypass_humanizer: true)
  		generated_csv = Question.to_csv
  		generated_csv.should == expected_csv
	end
end