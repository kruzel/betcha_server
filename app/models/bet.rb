class Bet < ActiveRecord::Base
  belongs_to :user
  has_many :predictions, :dependent => :destroy
  
end
