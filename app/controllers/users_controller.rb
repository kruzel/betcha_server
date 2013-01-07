#require 'facebook_utils'

class UsersController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:create, :show_by_email, :reset_password]
  
  # GET /users
  # GET /users.json
  def index #TODO allow only to admin
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {:users => @users.as_json( :include => { :user_stat => {}, :badges => { :only => [ :id , :value  ], :methods =>  [ :name, :image_url] } }) } }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @users = User.find_all_by_id(params[:id])
    @user = @users[0]
      
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: {:users => @users.as_json( :include => { :user_stat => {}, :badges => { :only => [ :id , :value  ], :methods =>  [ :name, :image_url] } })} }
    end
  end
  
  # GET /users/show_by_email
  # GET /users/show_by_email.json
  def show_by_email
    users = User.find_all_by_email (params[:email])
    unless users.nil?
      @user = users.first
    end

    @users = Array.new
    @users << @user
      
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: { :users => @users.as_json( :include => { :user_stat => {}, :badges => { :only => [ :id , :value  ], :methods =>  [ :name, :image_url] } })} }
    end
  end
  
  # GET /users/show_by_uid
  # GET /users/show_by_uid.json
  def show_by_uid
    users = User.find_all_by_uid (params[:uid])
    unless users.nil?
      @user = users.first
    end

    @users = Array.new
    @users << @user
      
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: { :users => @users.as_json( :include => { :user_stat => {}, :badges => { :only => [ :id , :value  ], :methods =>  [ :name, :image_url] } }) }}
    end
  end
  
  # GET /users/show_details
  # GET /users/show_details.json
  def show_details
    @user = current_user
    @badges = Badge.find_all_by_user_id(@user.id)
    @user_stats = UserStat.find_all_by_user_id (@user.id)
    @friends = Friend.get_user_friends(@user.id)

    @bets = Bet.find_all_by_user_id(@user.id)

    @predictions = Prediction.find_all_by_user_id (@user.id)
    @predictions.each do |prediction|
      unless prediction.bet.nil?
        @bet = Bet.find(prediction.bet.id)
        unless @bet.nil?
          unless @bets.include?@bet
            @bets << @bet
          end
        end
      end
    end unless (@predictions.nil?)
     
    respond_to do |format|
      format.html # show.html.erb
      #format.json { render json: { :user => @user } }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    @users = Array.new
    @users << @user

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: { :users => @users.as_json( :include => { :user_stat => {}, :badges => { :only => [ :id , :value  ], :methods =>  [ :name, :image_url] } }) } }
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
      unless @user.uid.nil?
        found_user = User.find_by_uid(@user.uid)
      end
      if found_user.nil?
        fb_utils = FacebookUtils.new(@user)
      else
        found_user.access_token = @user.access_token unless @user.access_token.nil?
        fb_utils = FacebookUtils.new(found_user)
      end

      if @user.access_token.nil?
        created = true
      else
        created = fb_utils.get_facebook_info #its an authenticated oauth user, get his info
      end

    else #email provider
      found_user = User.find_by_email(@user.email)

      if found_user.nil? #its a new user
        if @user.password.nil?
          @user.password =  Devise.friendly_token[0,20]
          password_ok = true
        end

        @user.provider="email"

        created = @user.save!
        if created
          user_stat = UserStat.create!(user_id:@user.id )
        end
      end
    end

    unless found_user.nil?
      #its a new user
      #check password, if failed return proper response
      if found_user.provider == "facebook"
        password_ok = true
      else
        password_ok = found_user.valid_password?(@user.password)
      end
      @user = found_user
    end

    @users = Array.new
    @users << @user
    
    respond_to do |format|
      if !found_user.nil? #its an existing user
        if !password_ok
          format.html { redirect_to @user, notice: 'User exist, bad password.' }
          format.json { render json: @user.errors, status: :unauthorized, notice: 'User exist, bad password.' }
        else
          format.html { redirect_to @user, notice: 'User was successfully created.' }
          format.json { render json: {:users => @users.as_json( :include => { :user_stat => {}, :badges => { :only => [ :id , :value  ], :methods =>  [ :name, :image_url] } })}, status: :created, location: @user }
        end
      else
        if created
          format.html { redirect_to @user, notice: 'User was successfully created.' }
          format.json { render json: {:users => @users.as_json( :include => { :user_stat => {}, :badges => { :only => [ :id , :value  ], :methods =>  [ :name, :image_url] } })}, status: :created, location: @user }
        else
          format.html { render action: "new" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end
  
  # PUT /reset_password
  # PUT /reset_password.json
  def reset_password
    @user = User.find_by_email(params[:email])
    @user.send_reset_password_instructions
    
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
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
