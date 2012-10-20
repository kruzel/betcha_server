class ChatMessagesController < ApplicationController
  before_filter :authenticate_user!

  # GET bets/:bet_id/chat_messages
  # GET bets/:bet_id/chat_messages.json
  def index #TODO allow only to admin
    @chat_messages = ChatMessage.all
    @bet = @chat_messages.first.bet

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: { :chat_messages => @chat_messages } }
    end
  end
  
  # GET bets/:bet_id/show_for_bet
  # GET bets/:bet_id/show_for_bet.json
  def show_for_bet 
    @chat_messages = ChatMessage.where("bet_id = ? AND created_at > ?",params[:bet_id], params[:newer_than])
    @bet = @chat_messages.first.bet

    @chat_message = @chat_messages[0]
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: { :chat_messages => @chat_messages } }
    end
  end

  # GET bets/:bet_id/chat_messages/1
  # GET bets/:bet_id/chat_messages/1.json
  def show
    @chat_message = ChatMessage.find(params[:id])
    @bet = @chat_message.bet

    @chat_messages = Array.new
    @chat_messages <<  @chat_message

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: { :chat_messages => @chat_messages } }
    end
  end

  # GET bets/:bet_id/chat_messages/new
  # GET bets/:bet_id/chat_messages/new.json
  def new
    @chat_message = ChatMessage.new
    @chat_message.user = current_user
    @chat_message.bet_id = params[:bet_id]
    @bet = @chat_message.bet

    @chat_messages = Array.new
    @chat_messages <<  @chat_message

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: { :chat_messages => @chat_messages } }
    end
  end

  # GET bets/:bet_id/chat_messages/1/edit
  def edit
    @chat_message = ChatMessage.find(params[:id])
    @bet = @chat_message.bet
  end

  # POST bets/:bet_id/chat_messages
  # POST bets/:bet_id/chat_messages.json
  def create
    @chat_message = ChatMessage.new(params[:chat_message])
    @chat_message.id = params[:chat_message][:id] unless params[:chat_message][:id].nil?
    @chat_message.user = current_user
    @chat_message.bet_id = params[:bet_id]
    @bet = @chat_message.bet

    @chat_messages = Array.new
    @chat_messages <<  @chat_message

    NotificationUtils.send_bet_update_notification(@bet)

    respond_to do |format|
      if @chat_message.save
        format.html { redirect_to @bet, notice: 'Chat message was successfully created.' }
        format.json { render json: { :chat_messages => @chat_messages }, status: :created, location: [@bet,@chat_message] }
      else
        format.html { render action: "new" }
        format.json { render json: @chat_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT bets/:bet_id/chat_messages/1
  # PUT bets/:bet_id/chat_messages/1.json
  def update
    @chat_message = ChatMessage.find(params[:id])
    @bet = @chat_message.bet

    respond_to do |format|
      if @chat_message.update_attributes(params[:chat_message])
        format.html { redirect_to [@bet,@chat_message], notice: 'Chat message was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @chat_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE bets/:bet_id/chat_messages/1
  # DELETE bets/:bet_id/chat_messages/1.json
  def destroy
    @chat_message = ChatMessage.find(params[:id])
    @bet = @chat_message.bet
    @chat_message.destroy

    respond_to do |format|
      format.html { redirect_to @bet }
      format.json { head :ok }
    end
  end
end
