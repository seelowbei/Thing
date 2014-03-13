require "spec_helper"


describe QuestionsController do

  before do
    Question.create(question_text: "Rspec" , created_at: "11/02/2014", bypass_humanizer: true)
    @user = FactoryGirl.create(:user)
  end
  
  it "should allow a visitor to post a question" do
    post 'create', :question => { question_text: "Rspec testing", bypass_humanizer: true}
    assigns[:question].should be_new_record
    response.status.should be(200)
  end

  it "should allow signed in user (admin) to access report generation page" do
    request.env["HTTP_REFERER"] = "/questions/report"
    sign_in(@user)
    response.status.should be(200)
  end

  it "should allow signed in user (admin) to generate report" do
    request.env["HTTP_REFERER"] = "/questions/report"
    sign_in(@user)
    search  = { :from_date => "10/02/2014", :till_date => "13/03/2014"}
    Question.search(search).should_not be_empty
  end

  it "should generate the correct question list report" do
    request.env["HTTP_REFERER"] = "/questions/report"
    sign_in(@user)
    search  = { :from_date => "10/02/2014", :till_date => "13/03/2014"}
    expect(Question.search(search).first.question_text).to eq "Rspec"
  end 

  it "should not allow visitor to access report page" do
    get :report
    expect(response.status).to eq(302)
  end
end