# To change this template, choose Tools | Templates
# and open the template in the editor.

class BetMailerJob
  def initialize(owner,bet,user,prediction)
    @owner = owner
    @bet = bet
    @user = user
    @prediction = prediction
  end
  
  def send_invites
    #invite notifications priorities: push to app, email, facebook
    #if(@user.sAppInstalled) ...
    
    if(@user.email.nil? || @user.email.length>0)
      BetMailer.send_invite(@owner,@user,@bet,get_url).deliver
      return
    end
    
    if(@user.provider=="facebook")
      sender_chat_id = "-#{@owner.uid}@chat.facebook.com"
      receiver_chat_id = "-#{@user.uid}@chat.facebook.com"
      message_body = "Hey " << @user.full_name << ", I bet you that " << @bet.subject << ", losers buy winners a " << @bet.reward << "\n\n " << get_url << "\n\nLink to AppStore ... \n\nLink to GooglePlay"
      message_subject = @owner.uid << "invites you to DropaBet"

      jabber_message = Jabber::Message.new(receiver_chat_id, message_body)
      jabber_message.subject = message_subject

      client = Jabber::Client.new(Jabber::JID.new(sender_chat_id))
      client.connect
      client.auth_sasl(Jabber::SASL::XFacebookPlatform.new(client,
        BetchaServer::Application::config.app_id, @owner.access_token,
        BetchaServer::Application::config.app_secret), nil)
      client.send(jabber_message)
      client.close

    end     
  end
  
  def get_url
    url = "http://www.dropabet.com:3000/bets/"
    url << @bet.id.to_s
    url << "/predictions/"
    url << @prediction.id.to_s
    url << "/submit"
    
    return url
  end
end
