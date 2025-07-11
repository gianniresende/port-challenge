class UserMailer < ApplicationMailer
  default from: 'no-reply@yourdomain.com'

  def send_welcome_email(user, raw_password)
    @user = user
    @password = raw_password
    mail(to: @user.email, subject: 'Seja bem-vindo ao TeamTalk!')
  end
end
