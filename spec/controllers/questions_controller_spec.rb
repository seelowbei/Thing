require "spec_helper"

describe QuestionsController do

  describe "GET #index" do
    context "as a visitor" do

      it "should allow to post a question" do
        post 'create', :question => { question_text: "Rspec testing", bypass_humanizer: true}
        assigns(:question).should be_persisted
        flash[:notice].should_not be_nil
        response.should redirect_to(new_question_path)
      end

      it "should render new question path if question is not saved " do
        post 'create', :question => { question_text: "Rspec testing"} 
        expect(response).to render_template('new')
      end

    end
  end

  describe "GET #report" do
    context " as an admin" do
      before do
        Question.create(question_text: "Rspec" , created_at: "11/02/2014", bypass_humanizer: true)
        @request.env["devise.mapping"] = Devise.mappings[:user]
        @user = FactoryGirl.create(:user)
        request.env["HTTP_REFERER"] = "/questions/report"
        sign_in(@user)
      end

      it "should allow to access report generation page" do
        expect(response.status).to eq(200)
      end

      it "should allow to search and return the correct question list" do
        get 'report', :search => {:from_date => "10/02/2014", :till_date => "13/03/2014"}
        assigns[:search].should_not be_nil
        expect(:search.first.question_text).to eq "Rspec"
      end

      it "should allow to export the correct question list to csv report" do
        get 'report', :search => {:from_date => "10/02/2014", :till_date => "13/03/2014"}
        it.should_receive(:send_file).with(@file, {:filename =>"report.csv", :type => 'text/csv', :disposition => 'attachment'})
        do_get    
        pending 
      end 

      it "should redirect to report_questions_path with error message if date request is invalid" do
        get 'report', :search => {:from_date => "10/04/2014", :till_date => "13/03/2014"}
        flash[:notice].should_not be_nil
        #expect(flash[:notice]).to eq "FROM DATE cannot be greater than TO DATE "
        expect(response).to redirect_to report_questions_path
      end
    end

    context "as a visitor" do
      it "should not allow visitor to access report page" do
        get :report
        expect(response.status).to eq(302)
      end
    end

  end

end