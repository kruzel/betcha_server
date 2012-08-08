class FriendsController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /friends
  # GET /friends.json
  def index 
    friends_ids = Friend.find_all_by_user_id (current_user.id)
          
    @friends = Array.new
    friends_ids.each do |friend|
        user = User.find(friend.friend_id)
        @friends << user 
    end unless (friends_ids.nil?)
      
    respond_to do |format|
      format.html # show_for_user.html.erb
      format.json { render json: @friends }
    end
  end
end