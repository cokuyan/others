class UsersController < ApplicationController
  before_action :require_admin_user!, only: [:index, :update]
  before_action :require_current_user!, only: :show

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "User created successfully\nPlease check your email to activate your account"
      msg = UserMailer.activation_email(@user)
      msg.deliver
      redirect_to new_session_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.try(:toggle, :admin) && @user.save
      flash[:notice] = "#{@user.email} is now an admin"
      redirect_to users_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :index
    end
  end

  def activate
    @user = User.find_by_activation_token(params[:activation_token])
    if @user.try(:toggle, :activated) && @user.save
      flash[:notice] = "Account activated successfully\nPlease login to continue"
    else
      flash[:notice] = "Account activation failed"
    end
    redirect_to new_session_url
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :ip_address)
  end
end
