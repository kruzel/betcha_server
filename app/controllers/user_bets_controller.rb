class UserBetsController < ApplicationController
  # GET /user_bets
  # GET /user_bets.json
  def index
    @user_bets = UserBet.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_bets }
    end
  end

  # GET /user_bets/1
  # GET /user_bets/1.json
  def show
    @user_bet = UserBet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_bet }
    end
  end
  
  # GET /user_bets/show_bet_id
  # GET /user_bets/show_bet_id.json
  def show_bet_id
    @user_bets = UserBet.where("bet_id = ?",params[:bet_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_bets }
    end
  end

  # GET /user_bets/new
  # GET /user_bets/new.json
  def new
    @user_bet = UserBet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_bet }
    end
  end

  # GET /user_bets/1/edit
  def edit
    @user_bet = UserBet.find(params[:id])
  end

  # POST /user_bets
  # POST /user_bets.json
  def create
    @user_bet = UserBet.new(params[:user_bet])   
    @user_bet.date = Time.new

    respond_to do |format|
      if @user_bet.save
        format.html { redirect_to @user_bet, notice: 'User bet was successfully created.' }
        format.json { render json: @user_bet, status: :created, location: @user_bet }
      else
        format.html { render action: "new" }
        format.json { render json: @user_bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_bets/1
  # PUT /user_bets/1.json
  def update
    @user_bet = UserBet.find(params[:id])
    if(!params[:user_result_bet].nil?)
      @user_bet.user_result_bet = params[:user_result_bet]
    end

    respond_to do |format|
      if @user_bet.update_attributes(params[:user_bet])
        format.html { redirect_to @user_bet, notice: 'User bet was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_bet.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PUT /user_bets/update_list
  # PUT /user_bets/update_list.json
  def update_list
   
    success = true
    
    params[:_json].each do |entry|
        unless UserBet.update(entry[:id], :user_result_bet => entry[:user_result_bet])
          success = false
          break
        end
    end
    
    respond_to do |format|
      if success
        format.html { redirect_to @user_bet, notice: 'User bet was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_bets/1
  # DELETE /user_bets/1.json
  def destroy
    @user_bet = UserBet.find(params[:id])
    @user_bet.destroy

    respond_to do |format|
      format.html { redirect_to user_bets_url }
      format.json { head :ok }
    end
  end
end
