require "spec_helper"
require 'csv'

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

      it "should allow to search with date and return the correct question list" do
        get 'report', :search => {:from_date => "10/02/2014", :till_date => "13/03/2014"}
        assigns(:questions).should_not be_nil
        expect(assigns(:questions).first.question_text).to eq "Rspec"
      end

      it "should redirect to report_questions_path with error message if date request is invalid" do
        get 'report', :search => {:from_date => "10/04/2014", :till_date => "13/03/2014"}
        expect(response).to redirect_to report_questions_path
        expect(flash[:error]).to eq "FROM DATE cannot be greater than TO DATE "
      end

      let(:csv_string)  { Question.to_csv }
      let(:csv_options) { {filename: "report.csv", disposition: 'attachment', type: 'text/csv; charset=utf-8; header=present'} }

      it "should allow to export the correct question list to csv report" do
        #get 'report', :search => {:from_date => "10/02/2014", :till_date => "13/03/2014"}
        #should_receive(:send_data).with(@file, {:filename =>"report.csv", :type => 'text/csv', :disposition => 'attachment'})
        #expect(:send_data).not_to be_nil
        #expect(:send_data).to eq "Rspec"
        #expect(:send_data).with(Question.all.to_csv).returns(:success)
        #@controller.should_receive(:send_data).with(csv_string).and_return { @controller.render nothing: true } # to prevent a 'missing template' error
        #get :report, format: :csv
        pending
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