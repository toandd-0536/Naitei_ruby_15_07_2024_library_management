class UserMailer < ApplicationMailer
  def welcome_mail user
    @user = user
    @login_url = new_user_session_url
    mail(to: @user.email, subject: t("mailer.user_mailer.subject"))
  end
end
