class UsersController < ApplicationController
  before_filter :authenticate_user!
	before_action :set_user, only: [:edit, :update, :destroy]

	def index
    @users = User.all
	end

  def edit
  end

  def update
    if user_params[:password] == user_params[:password_confirmation] && @user.update(user_params)
      respond_to do |format|
        format.html { redirect_to users_path, notice: 'Password Reset successfully.' }
        format.json { render json: @user }
      end
    else
      redirect_to :back, flash: { error: "New password and new password confirmation do not match."}
    end
  end

	def destroy
    if @user.delete
      redirect_to users_path, notice: 'User is successfully deleted.'
    else
      redirect_to users_path, notice: 'User cannot be deleted. Please contact MAS System Administrator.'
    end
	end

	private
    def user_params
      params.require(:user).permit(:name, :email, :role, :status, :password, :password_confirmation)
    end

    def set_user
    	@user = User.find(params[:id])
    end
end
