class UserStatsController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /user_stats
  # GET /user_stats.json
  def index
    @user_stats = UserStat.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_stats }
    end
  end
  
  # GET /user_stats/show_for_user
  # GET /user_stats/show_for_user.json
  def show_for_user 
    @users_stats = UserStat.find_all_by_user_id (current_user.id)
           
    respond_to do |format|
      format.html # show_for_user.html.erb
      format.json { render json: @users_stats }
    end
  end

  # GET /user_stats/1
  # GET /user_stats/1.json
  def show
    @user_stat = UserStat.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_stat }
    end
  end

  # GET /user_stats/new
  # GET /user_stats/new.json
  def new
    @user_stat = UserStat.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_stat }
    end
  end

  # GET /user_stats/1/edit
  def edit
    @user_stat = UserStat.find(params[:id])
  end

  # POST /user_stats
  # POST /user_stats.json
  def create
    @user_stat = UserStat.new(params[:user_stat])

    respond_to do |format|
      if @user_stat.save
        format.html { redirect_to @user_stat, notice: 'User stat was successfully created.' }
        format.json { render json: @user_stat, status: :created, location: @user_stat }
      else
        format.html { render action: "new" }
        format.json { render json: @user_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_stats/1
  # PUT /user_stats/1.json
  def update
    @user_stat = UserStat.find(params[:id])

    respond_to do |format|
      if @user_stat.update_attributes(params[:user_stat])
        format.html { redirect_to @user_stat, notice: 'User stat was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_stats/1
  # DELETE /user_stats/1.json
  def destroy
    @user_stat = UserStat.find(params[:id])
    @user_stat.destroy

    respond_to do |format|
      format.html { redirect_to user_stats_url }
      format.json { head :ok }
    end
  end
end
