class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :registerable, :rememberable, :trackable

  def edit
    @user = current_user
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update(user_params)
      
      sign_in @user, :bypass => true
      redirect_to report_questions_path
    else
      render "edit"
    end
  end

  private

  def user_params
    
    params.required(:user).permit(:password, :password_confirmation)
  end


end
