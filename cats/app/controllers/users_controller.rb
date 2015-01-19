class UsersController < ApplicationController

  before_action :require_current_user!, except: [:create, :new]
  before_action :redirect_if_logged_in, only: [:create, :new]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login!(@user)
      flash[:notice] = "Welcome, #{@user.user_name}!"
      redirect_to cats_url
    else
      render :new # TODO render error messages with flash[]
    end
  end

  def show
    @user = current_user
  end

  private

    def user_params
      params.require(:user).permit(:user_name, :password)
    end

end
