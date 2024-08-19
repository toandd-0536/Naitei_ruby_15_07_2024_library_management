class OrderMailer < ApplicationMailer
  def order_mail user, card
    @user = user
    @card = card
    @home_url = root_url
    mail to: @user.email, subject: t("mailer.order_mailer.subject")
  end
end
