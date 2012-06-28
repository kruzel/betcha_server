class UserBet < ActiveRecord::Base
  attr_accessible :id, :user_id, :bet_id, :user_result_bet, :date, :user_ack
  
  belongs_to :user
  belongs_to :bet
end
