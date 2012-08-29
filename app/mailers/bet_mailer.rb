class BetMailer < ActionMailer::Base
  default from: "marketing@dropabet.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.bet_mailer.send_invite.subject
  #
  def send_invite(owner,user,bet,prediction)
    logger.info("Bet #{bet.id} User #{user.email} mail invite")
    @owner = owner
    @user = user 
    @bet = bet
    
    subject = user.full_name.clone
    subject << " invites you to DropaBet"
    @url = "http://www.dropabet.com:3000/bets/"
    @url << bet.id.to_s
    @url << "/predictions/"
    @url << prediction.id.to_s
    @url << "/edit"

    mail(:to => user.email, :subject => subject)
    
  end  
end
