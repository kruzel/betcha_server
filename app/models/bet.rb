class Bet < ActiveRecord::Base
  include Uuid 
  before_create :gen_uid
  
  belongs_to :user
  has_many :predictions, :dependent => :destroy
  has_many :chat_messages, :dependent => :destroy
  belongs_to :topic
  belongs_to :topic_category
end
# == Schema Information
#
# Table name: bets
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  subject    :string(255)
#  reward     :string(255)
#  due_date   :datetime
#  state      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

