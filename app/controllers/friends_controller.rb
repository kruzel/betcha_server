class FriendsController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /friends/show_for_user
  # GET /friends/show_for_user.json
  def show_for_user 
    friends_ids = Friends.find_all_by_user_id (current_user.id)
          
    @friends = Array.new
    friends_ids.each do |friend|
      #user = User.find(friend.friend)
        #@friend_list << user unless (user.nil?)
        @friends << friend
    end unless (friends_ids.nil?)
      
    respond_to do |format|
      format.html # show_for_user.html.erb
      format.json { render json: @friends }
    end
  end
end
