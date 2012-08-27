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
#    @prediction.bet_id = params[:bet_id]
#    @prediction.prediction = params[:prediction] unless request.format=="html"
    @bet = @prediction.bet

    respond_to do |format|
      if @prediction.save
        format.html { redirect_to @bet, notice: 'User bet was successfully created.' }
        format.json { render json: @prediction, status: :created, location: [@bet,@prediction] }
      else
        format.html { render action: "new" }
        format.json { render json: @prediction.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /send_invites.json
  def send_invites
    success = true
    new_users = Array.new
    
    @bet = Bet.find(params[:bet_id])
       
    params[:users].each do |tmpUser|
          # check if existing tmpUser
          # if found associate to prediction
          # otherwise create a new tmpUser
          @user = User.find(tmpUser[:id]) unless tmpUser[:id].nil?
                      
          if @user.nil?
            @user = User.new(tmpUser[:user])
#            @user.full_name = tmpUser[:full_name] unless tmpUser[:full_name].nil?
#            @user.uid = tmpUser[:uid] unless tmpUser[:uid].nil?
#            @user.access_token = tmpUser[:access_token] unless tmpUser[:access_token].nil?
#            @user.gender = tmpUser[:gender] unless tmpUser[:gender].nil?
#            @user.locale = tmpUser[:locale] unless tmpUser[:locale].nil?
#            @user.profile_pic_url = tmpUser[:profile_pic_url] unless tmpUser[:profile_pic_url].nil?
#            @user.ensure_authentication_token
            @user.password =  Devise.friendly_token[0,20]
            unless @user.save!
              logger.error("User #{@user.email} user acount creation failed")
              next
            end
          end

          # check if current_tmpUser and prediction user are friends
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
      
          @predictions = Prediction.find_all_by_user_id_and_bet_id(@user.id, params[:bet_id])
          if @predictions.nil? || @predictions.size == 0 
            @prediction = Prediction.new() #should include tmpUser ids for existing users, email or FB ID or both
          else
            @prediction = @predictions.first
          end
          
          @prediction.bet_id = params[:bet_id]
          @prediction.user = @user

          unless @prediction.save!
            success = false
            break
          end
      
        @mailerJob = BetMailerJob.new(@user, @bet)
        @mailerJob.delay.send_invite
        
    end
    
    #send FB invite or email to all participants
    
    respond_to do |format|
      if success
        format.json { head :ok , status: :created, location: [@bet,@prediction] }
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
