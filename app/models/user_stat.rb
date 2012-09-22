class UserStat < ActiveRecord::Base
  include Uuid 
  before_create :gen_uid
  
  belongs_to :user
end
