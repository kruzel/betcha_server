class BetsController < ApplicationController
  
  before_filter :authenticate_user!
  
  # GET /bets
  # GET /bets.json
  def index
    @bets = Bet.all

    @predictions = Prediction.find_all_by_user_id (current_user.id)
    @predictions.each do |prediction|
      unless prediction.bet.nil?
        @bet = Bet.find(prediction.bet.id)
        unless @bets.include?@bet
          @bets << @bet unless (@bet.nil?)
        end
      end
    end unless (@predictions.nil?)

    @users = Array.new
    unless (@predictions.nil?)
      @predictions.each do |prediction|
        unless @users.include?(prediction.user)
          @users << prediction.user
        end
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: { :bets => @bets.as_json( :include => { :user => {} , :predictions => { :include =>  :prediction_option } , :chat_messages => {}, :topic => {} } ), :users => @users } }
    end
  end

  # GET /bets/1
  # GET /bets/1.json
  def show
    @bet = Bet.find(params[:id])
    @predictions = Prediction.find_all_by_bet_id(@bet.id)
    @chat_messages = ChatMessage.find_all_by_bet_id(@bet.id)
    @users = Array.new
    unless (@predictions.nil?)
      @predictions.each do |prediction|
        unless @users.include?(prediction.user)
          @users << prediction.user
        end
      end
    end

    @bets = Array.new
    @bets << @bet
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: { :bets => @bets.as_json( :include => { :user => {} , :predictions => { :include =>  :prediction_option } , :chat_messages => {}, :topic => {} } ), :users => @users } }
    end
  end
  
  # GET /bets/show_for_user
  # GET /bets/show_for_user.json
  def show_for_user
    @bets = Bet.find_all_by_user_id(current_user.id)
    
    @predictions = Prediction.find_all_by_user_id (current_user.id)
    @predictions.each do |prediction|
      unless prediction.bet.nil?
        @bet = Bet.find(prediction.bet.id)
        unless @bets.include?@bet
          @bets << @bet unless (@bet.nil?)
        end
      end
    end unless (@predictions.nil?)

    @users = Array.new
    unless (@predictions.nil?)
      @predictions.each do |prediction|
        unless @users.include?(prediction.user)
          @users << prediction.user
        end
      end
    end
          
    respond_to do |format|
      format.html # show_for_user.html.erb
      format.json { render json: { :bets => @bets.as_json( :include => { :user => {} , :predictions => { :include =>  :prediction_option } , :chat_messages => {}, :topic => {} } ), :users => @users } }
    end
  end

  # GET /bets/show_updates_for_user
  # GET /bets/show_updates_for_user.json
  def show_updates_for_user
    last_update = params[:updated_at]
    unless last_update.nil?
      @bets = Bet.where("user_id = ? AND updated_at > ?", current_user.id, last_update)

      @predictions = Prediction.where("user_id = ? AND updated_at > ?", current_user.id, last_update)
      @predictions.each do |prediction|
          @bet = Bet.find(prediction.bet.id)
          unless @bets.include?@bet
            @bets << @bet unless (@bet.nil?)
          end
        end unless (@predictions.nil?)
    end

    @users = Array.new
    unless (@predictions.nil?)
      @predictions.each do |prediction|
        unless @users.include?(prediction.user)
          @users << prediction.user
        end
      end
    end
    
    respond_to do |format|
      format.html # show_for_user.html.erb
      format.json { render json: { :bets => @bets.as_json( :include => { :user => {} , :predictions => { :include =>  :prediction_option } , :chat_messages => {}, :topic => {} } ), :users => @users } }
    end
  end

  # GET /bets/new
  # GET /bets/new.json
  def new
    @bet = Bet.new
    @bet.user = current_user

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: { :bet => @bet } }
    end
  end

  # GET /bets/1/edit
  def edit
    @bet = Bet.find(params[:id])
  end

  # POST /bets
  # POST /bets.json
  def create
    success = false
    @bet = Bet.new(params[:bet])
    @bet.id = params[:bet][:id] unless params[:bet][:id].nil?
    @bet.user = current_user
    success = @bet.save!
    
    predictions = params[:predictions]
    predictions = params[:bet][:predictions] if predictions.nil?
    unless predictions.nil?
      PredictionUtils.create_predictions(@bet,predictions)
    end

    @bets = Array.new
    @bets << @bet

    if success
      event = ActivityEvent.new(params[:activity_event])
      event.event_type = "bet"
      event.obj_id = @bet.id
      event.description =  @bet.subject
      event.users = event.get_users
      event.save
    end
    
    respond_to do |format|
      if success
        format.html { redirect_to @bet, notice: 'Bet was successfully created.' }
        format.json { render json: { :bets => @bets.as_json( :include => { :user => {} , :predictions => { :include =>  :prediction_option } , :chat_messages => {}, :topic => {} } ) }, status: :created, location: @bet }
      else
        format.html { render action: "new" }
        format.json { render json: @bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bets/1
  # PUT /bets/1.json
  def update
    @bet = Bet.find(params[:id])

    respond_to do |format|
      if @bet.update_attributes(params[:bet])
        format.html { redirect_to @bet, notice: 'Bet was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @bet.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PUT /bets/1/update_or_create
  # PUT /bets/1/update_or_create.json
  def update_or_create
    success = false
    @bet = Bet.find(params[:id])
    if @bet.nil?
      @bet = Bet.new(params[:bet])
      success = @bet.save
    else
      success = @bet.update_attributes(params[:bet])
    end

    respond_to do |format|
      if success
        format.html { redirect_to @bet, notice: 'Bet was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bets/1
  # DELETE /bets/1.json
  def destroy
    @bet = Bet.find(params[:id])
    if @bet.user == current_user
      @bet.predictions.each do |prediction|
        if prediction.user == current_user
          prediction.archive = true
        end
      end
      success = true
    else
      success = false
    end

    respond_to do |format|
      if success
        format.html { redirect_to :controller => :users, :action => :show_details, :id => current_user.id }
        format.json { head :ok }
      else
        format.html { redirect_to :controller => :users, :action => :show_details, :id => current_user.id , notice: 'Unauthorised.' }
        format.json { head :unauthorized  }
      end
    end
  end
end
