# == Schema Information
#
# Table name: users
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
#  validates :name, :presence => true
#  validates :email, :presence => true 
  
  has_many :bets
  has_many :user_bets
end
