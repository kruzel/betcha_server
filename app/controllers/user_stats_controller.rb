class UserStatsController < ApplicationController
  before_filter :authenticate_user!
  
  # GET users/:user_id/user_stats
  # GET users/:user_id/user_stats.json
  def index
    @user_stats = UserStat.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: { :user_stats => @user_stats } }
    end
  end
  
  # GET users/:user_id/user_stats/show_for_user
  # GET users/:user_id/user_stats/show_for_user.json
  def show_for_user 
    @users_stats = UserStat.find_all_by_user_id (current_user.id)
           
    respond_to do |format|
      format.html # show_for_user.html.erb
      format.json { render json: { :user_stats => @user_stats } }
    end
  end

  # GET users/:user_id/user_stats/1
  # GET users/:user_id/user_stats/1.json
  def show
    @users_stats = UserStat.find_all_by_user_id(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: { :user_stats => @user_stats } }
    end
  end

  # GET users/:user_id/user_stats/new
  # GET users/:user_id/user_stats/new.json
  def new
    @user_stat = UserStat.new

    @users_stats = Array.new
    @users_stats <<  @user_stat

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: { :user_stats => @user_stats } }
    end
  end

  # GET users/:user_id/user_stats/1/edit
  def edit
    @user_stat = UserStat.find(params[:id])
  end

  # POST users/:user_id/user_stats
  # POST users/:user_id/user_stats.json
  def create
    @user_stat = UserStat.new(params[:user_stat])

    @users_stats = Array.new
    @users_stats <<  @user_stat

    respond_to do |format|
      if @user_stat.save
        format.html { redirect_to @user_stat, notice: 'User stat was successfully created.' }
        format.json { render json: { :user_stats => @user_stats }, status: :created, location: @user_stat }
      else
        format.html { render action: "new" }
        format.json { render json: @user_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT users/:user_id/user_stats/1
  # PUT users/:user_id/user_stats/1.json
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

  # DELETE users/:user_id/user_stats/1
  # DELETE users/:user_id/user_stats/1.json
  def destroy
    @user_stat = UserStat.find(params[:id])
    @user_stat.destroy

    respond_to do |format|
      format.html { redirect_to user_stats_url }
      format.json { head :ok }
    end
  end
end
