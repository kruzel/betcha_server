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
        unless  @prediction.user == bet.user
          NotificationUtils.send_bet_invite_notification(bet, @prediction)
        end
      end

      return success
    end
end
