# To change this template, choose Tools | Templates
# and open the template in the editor.

class PredictionUtils
  
    def self.create_predictions(bet, predictions)
      predictions.each do |prediction|
          unless create_and_invite(bet, prediction)
            return false
          end
        end
    end
  
    def self.create_and_invite(bet, prediction)
      success = true

      @prediction = Prediction.new()
      @prediction.id = prediction[:id]
      @prediction.prediction = prediction[:prediction]
      @prediction.bet = bet
      @prediction.user = User.find(prediction[:user_id])

      # check if @prediction.user and prediction user are friends
      # if not create friend record
      unless @prediction.user == bet.user
        @friend = Friend.where("user_id = ? AND friend_id = ?", bet.user.id, @prediction.user.id).first
        if @friend.nil?
          @friend = Friend.new()
          @friend.user = bet.user
          @friend.friend_id = @prediction.user.id
          unless @friend.save
            logger.error("User #{@prediction.user.email} friendship creation failed")
          end
        end
      end

      unless @prediction.save!
        success = false
      else
        url = "http://www.dropabet.com:3000/bets/"
          url << bet.id.to_s
          url << "/predictions/"
          url << @prediction.id.to_s
          url << "/submit"

        message_body = "Hey " << @prediction.user.full_name << ", I bet you that " << bet.subject << ", losers buy winners a " << bet.reward << "\n\n " << url << "\n\nLink to AppStore ... \n\nLink to GooglePlay"
        message_subject = bet.user.full_name
        message_subject << "invites you to DropaBet"

        #push notification to android thru gcm
        if @prediction.user.is_app_installed && !@prediction.user.push_notifications_device_id.nil? && @prediction.user.push_notifications_device_id.length > 0
          device = Gcm::Device.where("registration_id = ?", @prediction.user.push_notifications_device_id).first
          notification = Gcm::Notification.new
          notification.device = device
          notification.collapse_key = "updates_available"
          notification.delay_while_idle = true
          notification.data = {:registration_ids => [@prediction.user.push_notifications_device_id], :data => {:type => "invite", :owner_id => bet.user.id, :user_id => @prediction.user.id , :bet_id => bet.id, :prediction_id => @prediction.id}}
          notification.save
        else

          if(@prediction.user.email.nil? || @prediction.user.email.length>0)
            @mailerJob = BetMailerJob.new(bet.user,bet,@prediction.user,@prediction, url)
            @mailerJob.delay.send_invites
          end

          if(@prediction.user.provider=="facebook")
            #Jabber.debug=true

            sender_chat_id = "-#{bet.user.uid}@chat.facebook.com"
            receiver_chat_id = "-#{@prediction.user.uid}@chat.facebook.com"

            jabber_message = Jabber::Message.new(receiver_chat_id, message_body)
            jabber_message.subject = message_subject

            client = Jabber::Client.new(Jabber::JID.new(sender_chat_id))
            client.connect
            client.auth_sasl(Jabber::SASL::XFacebookPlatform.new(client,
              BetchaServer::Application::config.app_id, bet.user.access_token,
              BetchaServer::Application::config.app_secret), nil)
            client.send(jabber_message)
            client.close
          end 

        end

      end

      return success
    end
end
