class FriendsController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /users/:user_idfriends/show_for_user
  # GET /users/:user_id/friends/show_for_user.json
  def show_for_user 
    friends_ids = Friend.find_all_by_user_id (current_user.id)
          
    @friends = Array.new
    friends_ids.each do |friend|
        user = User.find(friend.friend_id)
        @friends << user 
    end unless (friends_ids.nil?)
      
    respond_to do |format|
      format.html # show_for_user.html.erb
      format.json { render json: { :friends => @friends } }
    end
  end
  
  # GET /users/:user_id/friends/show_updates_for_user
  # GET /users/:user_id/friends/show_updates_for_user.json
  def show_updates_for_user 
    last_update = params[:updated_at]
    unless last_update.nil?
      friends_ids = Friend.where("user_id = ? AND updated_at > ?", current_user.id, last_update)

      @friends = Array.new
      friends_ids.each do |friend|
          user = User.find(friend.friend_id)
          @friends << user 
      end unless (friends_ids.nil?)
    end
    
    respond_to do |format|
      format.html # show_for_user.html.erb
      format.json { render json: { :friends => @friends } }
    end
  end
end
