class BetMailer < ActionMailer::Base
  default from: "marketing@dropabet.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.bet_mailer.send_invite.subject
  #
  def send_invite(receiver, bet_message_subject, message_body)
    logger.info("receiver email: " << receiver.email)
    @message_body = message_body
    mail(:to => receiver.email, :subject => bet_message_subject)
    
  end  
end
