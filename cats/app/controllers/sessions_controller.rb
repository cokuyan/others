class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: [:create, :new]

  def create
    user = User.find_by_credentials(
      params[:user][:user_name],
      params[:user][:password]
    )

    if user.nil?
      render :new
    else
      Session.create!(
        user_id: user.id,
        session_token: User.generate_session_token,
        user_agent: request.env["HTTP_USER_AGENT"],
        ip_address: request.remote_ip
      )
      login!(user)

      redirect_to cats_url
    end
  end

  def destroy
    logout!
    flash[:notice] = "Logged out successfully"
    redirect_to home_url
  end

  def new
  end
end
