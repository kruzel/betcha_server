#require 'facebook_utils'

class UsersController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:create, :show_by_email]
  
  # GET /users
  # GET /users.json
  def index #TODO allow only to admin
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
      
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user.as_json( :include => [ :user_stat, :badges]) }
    end
  end
  
  # GET /users/show_by_email
  # GET /users/show_by_email.json
  def show_by_email
    users = User.find_all_by_email (params[:email])
    unless users.nil?
      @user = users.first
    end
      
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user.as_json( :include => [ :user_stat, :badges ]) }
    end
  end
  
  # GET /users/1/show_details
  # GET /users/1/show_details.json
  def show_details
    @user = current_user
    @badges = Badge.find_all_by_user_id(@user.id)
    @user_stats = UserStat.find_all_by_user_id (@user.id)
    @friends = Friend.get_user_friends(@user.id)
    @bets = Bet.find_all_by_user_id(@user.id)
     
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    created = false
    password_ok = false
    
    @user = User.new(params[:user])
   
    if @user.provider == "facebook"
      if !@user.access_token.nil?
        found_user = User.find_by_access_token(@user.access_token)
      end
      if found_user.nil?
          fb_utils = FacebookUtils.new(@user)
          created = fb_utils.get_facebook_info
          if created
            fb_utils.add_facebook_friends
          end
      end
    else #email provider
      found_user = User.find_by_email(@user.email)
    end    
    
    if found_user.nil? #its a new user
        if @user.password.nil?
          @user.password =  Devise.friendly_token[0,20]
          password_ok = true
        end
        created = @user.save!
        if(created)
          user_stat = UserStat.create!(user_id:@user.id )
        end
    else
      #its an existing user
      #check password, if failed return proper response
      password_ok = found_user.valid_password?(@user.password)
      unless password_ok
        found_user.send_reset_password_instructions
      end
      @user = found_user
    end
    
    respond_to do |format|
      if !found_user.nil? #its an existing user
        if !password_ok
          format.html { redirect_to @user, notice: 'User exist, bad password.' }
          format.json { render json: @user, status: :unauthorized, notice: 'User exist, bad password.' }
        else
          format.html { redirect_to @user, notice: 'User was successfully created.' }
          format.json { render json: @user, status: :created, location: @user }
        end
      else
        if created
          format.html { redirect_to @user, notice: 'User was successfully created.' }
          format.json { render json: @user, status: :created, location: @user }
        else
          format.html { render action: "new" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    success = @user.update_attributes(params[:user])
    
    if success && @user.is_app_installed && !@user.push_notifications_device_id.nil? && @user.push_notifications_device_id.length > 0
        Gcm::Device.create(:registration_id => @user.push_notifications_device_id)
    end

    respond_to do |format|
      if success
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end 
  
  # TODO add User::createBatch(<List> users) + rest api

end
