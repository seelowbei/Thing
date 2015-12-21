class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable, :rememberable, :trackable

  def is_superadmin?
    self.role == 'superadmin'
  end

  def is_admin?
    self.role == 'admin'
  end

  private

  def user_params
    params.required(:user).permit(:password, :password_confirmation)
  end


end
