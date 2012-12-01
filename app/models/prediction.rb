class Prediction < ActiveRecord::Base
  include Uuid 
  before_create :gen_uid
  
  attr_accessible :id, :user_id, :bet_id, :prediction, :date, :user_ack, :bet, :user
  
  belongs_to :user
  belongs_to :bet
  belongs_to :prediction_option
end
# == Schema Information
#
# Table name: predictions
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  bet_id     :integer(4)
#  prediction :string(255)
#  result     :boolean(1)
#  user_ack   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

