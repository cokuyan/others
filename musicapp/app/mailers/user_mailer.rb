class UserMailer < ActionMailer::Base
  default from: "auto@musicapp.com"

  def activation_email(user)
    @user = user
    @url = activate_users_url(activation_token: user.activation_token)
    mail(to: user.email, subject: 'Welcome to MusicApp')
  end
end
