class Bet < ActiveRecord::Base
  belongs_to :user
  has_many :predictions, :dependent => :destroy
  
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

