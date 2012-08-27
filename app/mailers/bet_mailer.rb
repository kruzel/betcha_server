class BetMailer < ActionMailer::Base
  default from: "marketing@dropabet.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.bet_mailer.send_invite.subject
  #
  def send_invite(user,bet)
    subject = user.full_name << " invites you to DropaBet"
    @url  = "http://www.dropabet.com:3000"
    @user = user 
    @bet = bet

    mail(:to => user.email, :subject => subject)
    
  end  
end
