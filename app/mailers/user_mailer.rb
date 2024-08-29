class UserMailer < Devise::Mailer
  default from: Settings.default_email

  def welcome_mail user
    @user = user
    @login_url = new_user_session_url
    mail(to: @user.email, subject: t("mailer.user_mailer.subject"))
  end

  def reset_password_instructions record, token, opts = {}
    @token = token
    @root_url = root_url
    devise_mail(record, :reset_password_instructions, opts)
  end
end
