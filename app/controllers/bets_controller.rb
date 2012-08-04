class BetsController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /bets
  # GET /bets.json
  def index #TODO allow only to admin
    @bets = Bet.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bets }
    end
  end

  # GET /bets/1
  # GET /bets/1.json
  def show
    @bet = Bet.find(params[:id])
    @predictions = Prediction.find_all_by_bet_id(@bet.id)
    @chat_messages = ChatMessage.find_all_by_bet_id(@bet.id)
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bet }
    end
  end
  
  # GET /bets/show_for_user
  # GET /bets/show_for_user.json
  def show_for_user
    @bets = Array.new
    
    @predictions = Prediction.find_all_by_user_id (current_user.id)
    @predictions.each do |prediction|
        @bet = Bet.find(prediction.bet.id)
        @bets << @bet unless (@bet.nil?)
      end unless (@predictions.nil?)
          
    respond_to do |format|
      format.html # show_for_user.html.erb
      format.json { render json: @bets }
    end
  end

  # GET /bets/new
  # GET /bets/new.json
  def new
    @bet = Bet.new
    @bet.user = current_user

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bet }
    end
  end

  # GET /bets/1/edit
  def edit
    @bet = Bet.find(params[:id])
  end

  # POST /bets
  # POST /bets.json
  def create
    @bet = Bet.new(params[:bet])
    @bet.user = current_user
    
    if @bet.due_date.nil?
        @bet.due_date = Time.new
    end
    
    respond_to do |format|
      if @bet.save
        format.html { redirect_to @bet, notice: 'Bet was successfully created.' }
        format.json { render json: @bet, status: :created, location: @bet }
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

  # DELETE /bets/1
  # DELETE /bets/1.json
  def destroy
    @bet = Bet.find(params[:id])
    @bet.destroy

    respond_to do |format|
      format.html { redirect_to bets_url }
      format.json { head :ok }
    end
  end
end
