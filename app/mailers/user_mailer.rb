class UserMailer < ApplicationMailer
  default from: 'no-reply@yourdomain.com'

  def send_password_email(user, raw_password)
    @user = user
    @password = raw_password
    mail(to: @user.email, subject: 'Your account password')
  end
end
