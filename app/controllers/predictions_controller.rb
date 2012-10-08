class PredictionsController < ApplicationController
  before_filter :authenticate_user! , :except => [:submit,:update]
  
  # GET /bets/:bet_id/predictions
  # GET /bets/:bet_id/predictions.json
  def index #TODO allow only to admin
    @predictions = Prediction.all
    @bet = @predictions.first.bet

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: { :predictions => @predictions } }
    end
  end

  # GET /bets/:bet_id/predictions/1
  # GET /bets/:bet_id/predictions/1.json
  def show
    @prediction = Prediction.find(params[:id])
    @bet = @prediction.bet

    @predictions = Array.new
    @predictions << @prediction
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: { :predictions =>  @predictions } }
    end
  end
  
  # GET /bets/:bet_id/predictions/show_bet_id
  # GET /bets/:bet_id/predictions/show_bet_id.json
  def show_for_bet
    @predictions = Prediction.where("bet_id = ?",params[:bet_id])
    @bet = @predictions.first unless @predictions.nil?
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: { :predictions => @predictions } }
    end
  end

  # GET /bets/:bet_id/predictions/show_updates_for_bet
  # GET /bets/:bet_id/predictions/show_updates_for_bet.json
  def show_updates_for_bet
    last_update = params[:updated_at]
    unless last_update.nil
      @predictions = Prediction.where("bet_id = ? AND updated_at > ?",params[:bet_id], last_update)
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: { :predictions => @predictions } }
    end
  end
  
  # GET /bets/:bet_id/predictions/new
  # GET /bets/:bet_id/predictions/new.json
  def new
    @prediction = Prediction.new
    @prediction.user = current_user
    @prediction.bet_id = params[:bet_id]
    @bet = @prediction.bet

    @predictions = Array.new
    @predictions << @prediction

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: { :predictions => @predictions } }
    end
  end

  # GET /predictions/1/edit
  def edit
    @prediction = Prediction.find(params[:id])
    @bet = @prediction.bet
  end

  # GET /bets/:bet_id/predictions/1/submit
  def submit
    @prediction = Prediction.find(params[:id])
    @bet = @prediction.bet
  end

  # POST /predictions
  # POST /predictions.json
  def create
    @prediction = Prediction.new(params[:prediction])
    @prediction.id = params[:prediction][:id] unless params[:prediction][:id].nil?
    @prediction.user = current_user
    @prediction.bet = Bet.find(params[:bet_id])
    @bet = @prediction.bet

    @predictions = Array.new
    @predictions << @prediction

    respond_to do |format|
      if @prediction.save
        format.html { redirect_to @bet, notice: 'User bet was successfully created.' }
        format.json { render json: { :predictions => @predictions }, status: :created, location: [@bet,@prediction] }
      else
        format.html { render action: "new" }
        format.json { render json: @prediction.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /bets/:bet_id/create_and_invite.json
  def create_and_invite
    success = true
    
    @prediction = Prediction.new(params[:prediction])   
    @bet = Bet.find(@prediction.bet_id)
    @user = User.find(@prediction.user_id)

    # check if @user and prediction user are friends
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

    if @prediction.save!
      PredictionUtils.create_and_invite(@bet,@prediction)
    else
      success = false
    end

    @predictions = Array.new
    @predictions << @prediction
    
    respond_to do |format|
      if success
        format.html { redirect_to @bet, notice: 'User bet was successfully created.' }
        format.json { render json: { :predictions => @predictions }, status: :created, location: [@bet,@prediction] }
      else
        format.html { render action: "new" }
        format.json { render json: @prediction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bets/:bet_id/predictions/1
  # PUT /bets/:bet_id/predictions/1.json
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
  
  # PUT /bets/:bet_id/predictions/update_list
  # PUT /bets/:bet_id/predictions/update_list.json
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

  # DELETE /bets/:bet_id/predictions/1
  # DELETE /bets/:bet_id/predictions/1.json
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
