#require 'facebook_utils'

class UsersController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:create]
  
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
    success = false
    
    @user = User.new(params[:user])
   
    if @user.provider == "facebook"
      found_user = User.find_by_uid(@user.uid)
      if found_user.nil?
        unless params[:access_token].nil?
          fb_utils = FacebookUtils.new(@user,@access_token)
          success = fb_utils.get_facebook_info
          if success
            fb_utils.add_facebook_friends
          end
        end
      end
    else #email provider
      found_user = User.find_by_email(@user.email)
    end    
       
    if found_user.nil?
      if @user.password.nil?
        @user.password =  Devise.friendly_token[0,20]
      end
      success = @user.save!
      if(success)
        user_stat = UserStat.create!(user_id:@user.id )
      end
    else
      if found_user.valid_password?(@user.password)
        @user = found_user
        success = true
      else
        success = false
      end
      
    end
    
    respond_to do |format|
      if success
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
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
