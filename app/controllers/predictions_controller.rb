class PredictionsController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /predictions
  # GET /predictions.json
  def index #TODO allow only to admin
    @predictions = Prediction.all
    @bet = @predictions.first.bet

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @predictions }
    end
  end

  # GET /predictions/1
  # GET /predictions/1.json
  def show
    @prediction = Prediction.find(params[:id])
    @bet = @prediction.bet
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @prediction }
    end
  end
  
  # GET /predictions/show_bet_id
  # GET /predictions/show_bet_id.json
  def show_bet_id
    @predictions = Prediction.where("bet_id = ?",params[:bet_id])
    @bet = @predictions.first.bet
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @predictions }
    end
  end

  # GET /predictions/new
  # GET /predictions/new.json
  def new
    @prediction = Prediction.new
    @prediction.user = current_user
    @prediction.bet_id = params[:bet_id]
    @bet = @prediction.bet
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @prediction }
    end
  end

  # GET /predictions/1/edit
  def edit
    @prediction = Prediction.find(params[:id])
    @bet = @prediction.bet
  end

  # POST /predictions
  # POST /predictions.json
  def create
    @prediction = Prediction.new(params[:prediction])   
    @prediction.user = current_user
    @prediction.bet_id = params[:bet_id]
    @prediction.prediction = params[:prediction] unless request.format=="html"
    @bet = @prediction.bet

    respond_to do |format|
      if @prediction.save
        format.html { redirect_to @bet, notice: 'User bet was successfully created.' }
        format.json { render json: @prediction, status: :created, location: @prediction }
      else
        format.html { render action: "new" }
        format.json { render json: @prediction.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /create_batch.json
  def create_batch
    success = true
    
    params[:users].each do |entry|
          # check if existing user
          # if found associate to prediction
          # otherwise create a new user
          unless entry[:user_id].nil?
            @user = User.find(entry[:user_id])
          end
          if @user.nil?
            @user = User.new()
            @user.email = entry[:email] unless entry[:email].nil?
            @user.full_name = entry[:full_name] unless entry[:full_name].nil?
            @user.provider = entry[:provider] unless entry[:provider].nil?
            @user.uid = entry[:uid] unless entry[:uid].nil?
            @user.access_token = entry[:access_token] unless entry[:access_token].nil?
            @user.gender = entry[:gender] unless entry[:gender].nil?
            @user.locale = entry[:locale] unless entry[:locale].nil?
            @user.profile_pic_url = entry[:profile_pic_url] unless entry[:profile_pic_url].nil?
          
            @user.ensure_authentication_token
            unless @user.save
              logger.error("User #{@user.email} user acount creation failed")
              next
            end
          end

          # check if current_user and prediction user are friends
          # if not create friend record
          unless @user == current_user
            @friend = Friend.where("user_id = ? AND friend_id = ?", current_user.id, @user.id).first
            if @friend.nil?
              @friend = Friend.new()
              @friend.user = current_user
              @friend.friend_id = @user.id
              unless @friend.save
                logger.error("User #{@user.email} friendship creation failed")
              end
            end
          end
      
          @predictions = Prediction.find_all_by_user_id_and_bet_id entry[:user_id], entry[:bet_id]
          if @predictions.nil? || @predictions.size == 0 
            @prediction = Prediction.new() #should include user ids for existing users, email or FB ID or both
          else
            @prediction = @predictions.first
          end
          
          @prediction.bet_id = entry[:bet_id]
          @prediction.user = @user

          unless @prediction.save
            success = false
            break
          end
        
    end
    
    
    respond_to do |format|
      if success
        format.json { head :ok , status: :created, location: @prediction }
      else
        format.json { render json: @prediction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /predictions/1
  # PUT /predictions/1.json
  def update
    @prediction = Prediction.find(params[:id])
    if(!params[:prediction].nil?)
      @prediction.prediction = params[:prediction]
    end
    @bet = @prediction.bet

    respond_to do |format|
      if @prediction.update_attributes(params[:prediction])
        format.html { redirect_to [@bet,@prediction] , notice: 'User bet was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @prediction.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PUT /predictions/update_list
  # PUT /predictions/update_list.json
  def update_list
   
    success = true
    
    params[:predictions].each do |entry|
        unless Prediction.update(entry[:id], :prediction => entry[:prediction])
          success = false
          break
        end
    end
    
    respond_to do |format|
      if success
        format.html { redirect_to @prediction, notice: 'User bet was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @prediction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /predictions/1
  # DELETE /predictions/1.json
  def destroy
    @prediction = Prediction.find(params[:id])
    @bet = @prediction.bet
    @prediction.destroy

    respond_to do |format|
      format.html { redirect_to @bet }
      format.json { head :ok }
    end
  end
end