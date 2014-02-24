class RegistrationsController < Devise::RegistrationsController

  protected

  def after_update_path_for(resource)
    	report_questions_path
  end
end