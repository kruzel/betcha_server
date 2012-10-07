class NotificationUtils
  def delayed_send_notification
    Gcm::Notification.send_notifications
  end
  handle_asynchronously :delayed_send_notification

  def prepare_invite_GCM_notification(bet, prediction)
    device = Gcm::Device.where("registration_id = ?", bet.user.push_notifications_device_id).first
    notification = Gcm::Notification.new
    notification.device = device
    notification.collapse_key = "updates_available"
    notification.delay_while_idle = true
    notification.data = {:registration_ids => [@prediction.user.push_notifications_device_id], :data => {:type => "invite", :owner_id => bet.user.id, :user_id => prediction.user.id , :bet_id => bet.id, :prediction_id => prediction.id}}
    notification.save

    push_notification_utils = NotificationUtils.new
    push_notification_utils.delayed_send_notification
  end

  def self.send_facebook_chat_message(sender, receiver, message_subject, message_body)
    #Jabber.debug=true

    sender_chat_id = "-#{sender.uid}@chat.facebook.com"
    receiver_chat_id = "-#{receiver.uid}@chat.facebook.com"

    jabber_message = Jabber::Message.new(receiver_chat_id, message_body)
    jabber_message.subject = message_subject

    client = Jabber::Client.new(Jabber::JID.new(sender_chat_id))
    client.connect
    client.auth_sasl(Jabber::SASL::XFacebookPlatform.new(client,
                                                         BetchaServer::Application::config.app_id, sender.access_token,
                                                         BetchaServer::Application::config.app_secret), nil)
    client.send(jabber_message)
    client.close
  end

  def self.send_bet_invite_notification(bet, prediction)
    if prediction.user.is_app_installed && !prediction.user.push_notifications_device_id.nil? && prediction.user.push_notifications_device_id.length > 0
      #this is a structured message with bet and prediction ids
      prepare_invite_GCM_notification(bet, prediction)
    else
      url = "http://www.dropabet.com:3000/bets/"
      url << bet.id.to_s
      url << "/predictions/"
      url << prediction.id.to_s
      url << "/submit"

      message_body = "Hey " << prediction.user.full_name << ", I bet you that " << bet.subject << ", losers buy winners a " << bet.reward << "\n\n " << url << "\n\nLink to AppStore ... \n\nLink to GooglePlay"
      message_subject = bet.user.full_name
      message_subject << "invites you to DropaBet"

      if(prediction.user.email.nil? || prediction.user.email.length>0)
        @mailerJob = BetMailerJob.new(bet.user, message_subject, message_body)
        @mailerJob.delay.send_invites
      else
        if(@prediction.user.provider=="facebook")
          send_facebook_chat_message(bet.user, prediction.user, message_subject, message_body )
        end
      end
    end
  end

  def self.send_prediction_update_notification(bet, prediction)
=begin
    if prediction.user.is_app_installed && !prediction.user.push_notifications_device_id.nil? && prediction.user.push_notifications_device_id.length > 0
      #this is a structured message with bet and prediction ids
      prepare_invite_GCM_notification(bet, prediction)
    else
      url = "http://www.dropabet.com:3000/bets/"
      url << bet.id.to_s

      message_body = "Hey " << prediction.user.full_name << ", bet " << bet.subject << ", have been updated " << "\n\nLink to bet: " << url << "\n\nLink to AppStore ... \n\nLink to GooglePlay"
      message_subject = bet.user.full_name
      message_subject << "invites you to DropaBet"

      if(prediction.user.email.nil? || prediction.user.email.length>0)
        @mailerJob = BetMailerJob.new(bet.user, message_subject, message_body)
        @mailerJob.delay.send_invites
      end

      if(@prediction.user.provider=="facebook")
        send_facebook_chat_message(bet.user, prediction.user, message_subject, message_body )
      end

    end
=end
  end

end