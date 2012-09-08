class PredictionsController < ApplicationController
  before_filter :authenticate_user! , :except => [:submit,:update]
  
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
  
  # GET /predictions/1/submit
  def submit
    @prediction = Prediction.find(params[:id])
    @bet = @prediction.bet
  end

  # POST /predictions
  # POST /predictions.json
  def create
    @prediction = Prediction.new(params[:prediction])   
    @prediction.user = current_user
    @bet = Bet.find(params[:bet_id])

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

  # POST /create_and_invite.json
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

    unless @prediction.save!
      success = false
    else
      url = "http://www.dropabet.com:3000/bets/"
        url << @bet.id.to_s
        url << "/predictions/"
        url << @prediction.id.to_s
        url << "/submit"
        
      message_body = "Hey " << @user.full_name << ", I bet you that " << @bet.subject << ", losers buy winners a " << @bet.reward << "\n\n " << url << "\n\nLink to AppStore ... \n\nLink to GooglePlay"
      message_subject = current_user.full_name
      message_subject << "invites you to DropaBet"
        
      if(@user.email.nil? || @user.email.length>0)
        @mailerJob = BetMailerJob.new(current_user,@bet,@user,@prediction, url)
        @mailerJob.delay.send_invites
      end
      
      if(@user.provider=="facebook")
        #Jabber.debug=true
        
        sender_chat_id = "-#{current_user.uid}@chat.facebook.com"
        receiver_chat_id = "-#{@user.uid}@chat.facebook.com"
        
        jabber_message = Jabber::Message.new(receiver_chat_id, message_body)
        jabber_message.subject = message_subject

        client = Jabber::Client.new(Jabber::JID.new(sender_chat_id))
        client.connect
        client.auth_sasl(Jabber::SASL::XFacebookPlatform.new(client,
          BetchaServer::Application::config.app_id, current_user.access_token,
          BetchaServer::Application::config.app_secret), nil)
        client.send(jabber_message)
        client.close
      end 
      
      #push notification to android thru gcm
      if @user.is_app_installed && !@user.push_notifications_device_id.nil? && @user.push_notifications_device_id.length > 0
        device = Gcm::Device.where("registration_id = ?", @user.push_notifications_device_id).first
        notification = Gcm::Notification.new
        notification.device = device
        notification.collapse_key = "updates_available"
        notification.delay_while_idle = true
        notification.data = {:registration_ids => [@user.push_notifications_device_id], :data => {:owner_id => current_user.id, :user_id => @user.id , :bet_id => @bet.id, :prediction_id => @prediction.id}}
        notification.save
      end
    end
    
    respond_to do |format|
      if success
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
   
    @bet = Bet.find(params[:bet_id])
       
    params[:users].each do |tmpUser|
      # check if existing tmpUser
      # if found associate to prediction
      # otherwise create a new tmpUser
      id = tmpUser[:user][:id]
      @user = User.find(id) unless id.nil?

      unless @user.nil?
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

        @mailerJob = BetMailerJob.new(@bet,@user,@prediction)
        @mailerJob.delay.send_invites
      end
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
