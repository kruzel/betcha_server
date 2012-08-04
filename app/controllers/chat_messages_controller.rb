class ChatMessagesController < ApplicationController
  before_filter :authenticate_user!

  # GET /chat_messages
  # GET /chat_messages.json
  def index #TODO allow only to admin
    @chat_messages = ChatMessage.all
    @bet = @chat_messages.first.bet

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @chat_messages }
    end
  end
  
  # GET /chat_messages_for_bet
  # GET /chat_messages_for_bet.json
  def chat_messages_for_bet 
    @chat_messages = ChatMessage.where("bet_id = ? AND created_at > ?",params[:bet_id], params[:newer_than])
    @bet = @chat_messages.first.bet
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @chat_messages }
    end
  end

  # GET /chat_messages/1
  # GET /chat_messages/1.json
  def show
    @chat_message = ChatMessage.find(params[:id])
    @bet = @chat_message.bet

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @chat_message }
    end
  end

  # GET /chat_messages/new
  # GET /chat_messages/new.json
  def new
    @chat_message = ChatMessage.new
    @chat_message.user = current_user
    @chat_message.bet_id = params[:bet_id]
    @bet = @chat_message.bet

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @chat_message }
    end
  end

  # GET /chat_messages/1/edit
  def edit
    @chat_message = ChatMessage.find(params[:id])
    @bet = @chat_message.bet
  end

  # POST /chat_messages
  # POST /chat_messages.json
  def create
    @chat_message = ChatMessage.new(params[:chat_message])
    @chat_message.user = current_user
    @chat_message.bet_id = params[:bet_id]
    @bet = @chat_message.bet

    respond_to do |format|
      if @chat_message.save
        format.html { redirect_to @bet, notice: 'Chat message was successfully created.' }
        format.json { render json: @chat_message, status: :created, location: @chat_message }
      else
        format.html { render action: "new" }
        format.json { render json: @chat_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /chat_messages/1
  # PUT /chat_messages/1.json
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

  # DELETE /chat_messages/1
  # DELETE /chat_messages/1.json
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
