class FriendsController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /friends/show_for_user
  # GET /friends/show_for_user.json
  def show_for_user 
    friends_ids = Friend.find_all_by_user_id (current_user.id)
          
    @friends = Array.new
    friends_ids.each do |friend|
        user = User.find(friend.friend_id)
        tmp_friend = User.new()
        tmp_friend.id = user.id
        tmp_friend.email = user.email
        tmp_friend.full_name = user.full_name
        tmp_friend.profile_pic_url = user.profile_pic_url
        @friends << tmp_friend 
    end unless (friends_ids.nil?)
      
    respond_to do |format|
      format.html # show_for_user.html.erb
      format.json { render json: @friends }
    end
  end
end
