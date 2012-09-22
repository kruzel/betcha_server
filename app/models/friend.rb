class Friend < ActiveRecord::Base
  include Uuid 
  before_create :gen_uid
  
  belongs_to :user
  belongs_to :friend, :class_name => "User"
  
  def self.get_user_friends(user_id)
    friends_ids = Friend.find_all_by_user_id (user_id)
    @friends = Array.new
    friends_ids.each do |friend|
        friend_user = User.find(friend.friend_id)
        @friends << friend_user 
    end unless (friends_ids.nil?)
    return @friends
  end
  
end
# == Schema Information
#
# Table name: friends
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  friend_id  :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

