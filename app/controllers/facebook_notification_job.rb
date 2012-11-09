class FacebookNotificationJob
  def initialize(sender, receiver, message_subject, message_body)
    @sender_uid = sender.uid
    @receiver_uid = receiver.uid
    @message_subject = message_subject
    @message_body = message_body
  end

  def send_notification
    #Jabber.debug=true

    #TODO find how to send FB chat notification from delayed job
=begin
    sender_chat_id = "-#{@sender_uid}@chat.facebook.com"
    receiver_chat_id = "-#{@receiver_uid}@chat.facebook.com"

    jabber_message = Jabber::Message.new(receiver_chat_id, @message_body)
    jabber_message.subject = @message_subject

    client = Jabber::Client.new(Jabber::JID.new(sender_chat_id))
    client.connect
    client.auth_sasl(Jabber::SASL::XFacebookPlatform.new(client,
                                                         BetchaServer::Application::config.app_id, sender.access_token,
                                                         BetchaServer::Application::config.app_secret), nil)
    client.send(jabber_message)
    client.close
=end
  end

end