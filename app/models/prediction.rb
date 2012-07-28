class Prediction < ActiveRecord::Base
  attr_accessible :id, :user_id, :bet_id, :prediction, :date, :user_ack, :bet, :user
  
  belongs_to :user
  belongs_to :bet
end
