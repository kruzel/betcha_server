# To change this template, choose Tools | Templates
# and open the template in the editor.

class FacebookUtils
    
    def initialize(user)
      @user = user
    end
    
    def get_facebook_info
      fb_client = FBGraph::Client.new(:client_id => BetchaServer::Application::config.app_id,:secret_id => BetchaServer::Application::config.app_secret ,:token => @user.access_token)
      user_info = fb_client.selection.me.info!

      @user.email = user_info.email
      @user.full_name = user_info.name
      @user.provider = "facebook"
      @user.uid = user_info.id
  #      user.expires_at = user_info.credentials.expires_at 
  #      @user.expires = 
      @user.gender = user_info.gender
      @user.locale = user_info.locale
      @user.profile_pic_url = fb_client.selection.me.picture
      @user.password =  Devise.friendly_token[0,20]
      return @user.save
    end
  
    def add_facebook_friends
      fb_client = FBGraph::Client.new(:client_id => BetchaServer::Application::config.app_id,:secret_id => BetchaServer::Application::config.app_secret ,:token => @user.access_token)
      
      fb_friends = fb_client.selection.me.friends.info!

      fb_friends_ids = Array.new
      fb_friends.data[:data].each do |friend_info|  
        fb_friends_ids << friend_info.id
      end

      Rails.logger.error "before facebook get friends info"
      fb_friends_data = fb_client.selection.user(fb_friends_ids).friends.info!
      Rails.logger.error "after facebook get friends info"

      friends_users = []
      friends = []

      fb_friends_data.data.each do |friend_info|
        begin
          friend_user = User.find_all_by_uid(friend_info[1].id).first
        rescue ActiveRecord::RecordNotFound 
          Rails.logger.info "failed to find facebook user locally"
        end
        if friend_user.nil?
          #its a new user, create it
          friend_user = User.new()
          #get friend data from facebook
          #friend_fb_user_info = fb_client.selection.user(friend_info[0].id).info!

  #        friend_user.email = friend_fb_user_info.email
          friend_user.full_name = friend_info[1].name
          friend_user.provider = "facebook"
          friend_user.uid = friend_info[1].id
      #      friend_user.expires_at = user_info.credentials.expires_at 
      #      friend_user.expires = 
          friend_user.gender = friend_info[1].gender
          friend_user.locale = friend_info[1].locale
          friend_user.profile_pic_url = fb_client.selection.user(friend_info[1].id).picture
          friend_user.password =  Devise.friendly_token[0,20]

          friends_users << friend_user
        end
      end
    
      unless User.import friends_users, :validate => false
        Rails.logger.error "failed to add facebook friends!"
      end

      fb_friends_data.data.each do |friend_info|
        begin
          friend_user = User.find_all_by_uid(friend_info[1].id).first
        rescue ActiveRecord::RecordNotFound 
          Rails.logger.info "failed to find facebook user locallly"
        end
        unless friend_user.nil?
          #user exist, check if friend
          begin
            friend = Friend.find_by_user_id_and_friend_id(@user.id, friend_info[1].id)
          rescue ActiveRecord::RecordNotFound 
            Rails.logger.info "failed to find facebook friend locallly"
          end
          if friend.nil?
            friend = Friend.new()
            friend.user = @user
            friend.friend_id = friend_user.id
            friends << friend
          end
        end
      end

      unless Friend.import friends
        Rails.logger.error "failed to associate friends!"
      end

    end
    handle_asynchronously :add_facebook_friends
  
end
