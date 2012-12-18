class ActivityEvent < ActiveRecord::Base
  include Uuid
  before_create :gen_uid

  has_many :activity_event_users
  has_many :users, :through => :activity_event_users

  def get_users
    case event_type
      when "bet"
        bet = Bet.find(object_id)
      when "prediction" , "prediction_update"
        prediction = Prediction.find(object_id)
        bet = Bet.find(prediction.bet.id)
      when "chat"
        chat_message = ChatMessage.find(object_id)
        bet = Bet.find(chat_message.bet.id)
      else
        bet = nil
    end

    predictions = Prediction.find_all_by_bet_id(bet.id)

    users = Array.new
    predictions.each do |prediction|
      users << prediction.user
    end

    return users
  end
end
