# To change this template, choose Tools | Templates
# and open the template in the editor.

class BetMailerJob

  def initialize( receiver, message_subject, message_body)
    @receiver = receiver
    @message_subject = message_subject
    @message_body = message_body
  end
  
  def send_invites
    if(@receiver.email.nil? || @receiver.email.length>0)
      BetMailer.send_invite(@receiver,@message_subject,@message_body).deliver
      return
    end
  end
end
