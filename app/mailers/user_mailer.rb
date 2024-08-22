class UserMailer < ApplicationMailer
  def welcome_mail user, password
    @user = user
    @password = password
    @login_url = login_url
    mail(to: @user.email, subject: t("mailer.user_mailer.subject"))
  end
end
