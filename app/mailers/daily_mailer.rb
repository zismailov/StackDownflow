class DailyMailer < ApplicationMailer
  default from: "noreply@stackdownflow.com"

  def digest(user, questions)
    @user = user
    @questions = questions

    mail to: user.email
  end
end
