require "spec_helper"

describe Devise::SessionsController do

	it "should redirect to report_questions_path after user sign out" do
		@request.env["devise.mapping"] = Devise.mappings[:user]
		@user = FactoryGirl.create(:user)
		request.env["HTTP_REFERER"] = "/questions/report"
    	sign_in(@user)
    	delete :destroy, id: @user.id
		expect(response).to redirect_to report_questions_path		
	end
end
