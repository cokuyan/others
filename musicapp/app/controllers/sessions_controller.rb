class SessionsController < ApplicationController
  before_action :ensure_user_activated!, only: :create

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_credentials(*user_params.values)
    if @user.nil?
      @user = User.new(email: params[:user][:email])
      flash.now[:errors] = ["Invalid Email/Password Combination"]
      render :new
    else
      login!(@user)
      redirect_to user_url(@user)
    end
  end

  def destroy
    logout!
    flash[:notice] = "Logged out successfully"
    redirect_to new_session_url
  end


  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def ensure_user_activated!
    @user = User.find_by_credentials(*user_params.values)
    if @user && !@user.activated
      flash[:notice] = "Please activate your email"
      redirect_to new_session_url
    end
  end
end
