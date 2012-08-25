class BetMailer < ActionMailer::Base
  default from: "marketing@dropabet.com"
  
  def initialize(user, bet)
    @user = user
    @bet = bet
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.bet_mailer.send_invite.subject
  #
  def send_invite
     subject = @user.first_name + " invites you to DropaBet"
     @greeting = 
     @url  = "http://www.dropabet.com:3000"

    mail(:to => @user.email, :subject => subject)
    
  end  
end
