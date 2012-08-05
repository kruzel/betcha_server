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
    @user = User.new(params[:user])
    @user.provider = params[:provider] unless params[:provider].nil?
    
    if @user.provider == "facebook"
      unless params[:access_token].nil?
        @user.access_token = params[:access_token] 
        fb_client = FBGraph::Client.new(:client_id => config.app_id,:secret_id =>config.app_secret ,:token => @user.access_token)
        user_info = fb_client.selection.me.info!

        @user.email = user_info.email
        @user.full_name = user_info.name
        @user.provider = "facebook"
        @user.uid = user_info.id
#        @user.expires_at = user_info.credentials.expires_at
#        @user.expires = 
        @user.gender = user_info.gender
        @user.locale = user_info.locale
        @user.profile_pic_url = fb_client.selection.me.picture
        @user.password =  Devise.friendly_token[0,20]
      end
    else #email provider
      @user.email = params[:email] unless params[:email].nil?
      @user.password = params[:password] 
      @user.full_name = params[:full_name] unless params[:full_name].nil?
    end    
    
    respond_to do |format|
      if @user.save
        if @user.full_name.nil?
          @user.full_name = @user.full_name
        end
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
end
