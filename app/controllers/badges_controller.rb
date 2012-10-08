class BadgesController < ApplicationController
  before_filter :authenticate_user!
  
  # GET users/:user_id/badges
  # GET users/:user_id/badges.json
  def index
    @badges = Badge.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: { :badges => @badges } }
    end
  end

  # GET users/:user_id/badges/1
  # GET users/:user_id/badges/1.json
  def show
    @badges = Badge.find_all_by_id(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: { :badges => @badges } }
    end
  end

  # GET users/:user_id/badges/new
  # GET users/:user_id/badges/new.json
  def new
    @badge = Badge.new

    @badges = Array.new
    @badges << @badge

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: { :badges => @badges } }
    end
  end

  # GET users/:user_id/badges/1/edit
  def edit
    @badge = Badge.find(params[:id])
  end

  # POST users/:user_id/badges
  # POST users/:user_id/badges.json
  def create
    @badge = Badge.new(params[:badge])

    @badges = Array.new
    @badges << @badge

    respond_to do |format|
      if @badge.save
        format.html { redirect_to @badge, notice: 'Badge was successfully created.' }
        format.json { render json: { :badges => @badges }, status: :created, location: @badge }
      else
        format.html { render action: "new" }
        format.json { render json: @badge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT users/:user_id/badges/1
  # PUT users/:user_id/badges/1.json
  def update
    @badge = Badge.find(params[:id])

    @badges = Array.new
    @badges << @badge

    respond_to do |format|
      if @badge.update_attributes(params[:badge])
        format.html { redirect_to @badge, notice: 'Badge was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @badge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE users/:user_id/badges/1
  # DELETE users/:user_id/badges/1.json
  def destroy
    @badge = Badge.find(params[:id])
    @badge.destroy

    respond_to do |format|
      format.html { redirect_to badges_url }
      format.json { head :ok }
    end
  end
end
