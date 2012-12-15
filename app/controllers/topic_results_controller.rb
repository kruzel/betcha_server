class TopicResultsController < ApplicationController
  before_filter :authenticate_user!

  # GET /topic_categories/topic_category_id/topics/topic_id/topic_results
  # GET /topic_categories/topic_category_id/topics/topic_id/topic_results.json
  def index
    @topic_results = TopicResult.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @topic_results }
    end
  end

  # GET /topic_categories/topic_category_id/topics/topic_id/topic_results/show_for_topic
  # GET /topic_categories/topic_category_id/topics/topic_id/topic_results/show_for_topic.json
  def show_for_topic
    @topic_results = TopicResult.find_all_by_topic_id(params[:topic_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @topic_results }
    end
  end

  # GET /topic_categories/topic_category_id/topics/topic_id/topic_results/1
  # GET /topic_categories/topic_category_id/topics/topic_id/topic_results/1.json
  def show
    @topic_result = TopicResult.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @topic_result }
    end
  end

  # GET /topic_categories/topic_category_id/topics/topic_id/topic_results/new
  # GET /topic_categories/topic_category_id/topics/topic_id/topic_results/new.json
  def new
    @topic_result = TopicResult.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @topic_result }
    end
  end

  # GET /topic_categories/topic_category_id/topics/topic_id/topic_results/1/edit
  def edit
    @topic_result = TopicResult.find(params[:id])
  end

  # POST /topic_categories/topic_category_id/topics/topic_id/topic_results
  # POST /topic_categories/topic_category_id/topics/topic_id/topic_results.json
  def create
    @topic_result = TopicResult.new(params[:topic_result])

    respond_to do |format|
      if @topic_result.save
        format.html { redirect_to @topic_result, notice: 'Topic result was successfully created.' }
        format.json { render json: @topic_result, status: :created, location: @topic_result }
      else
        format.html { render action: "new" }
        format.json { render json: @topic_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /topic_categories/topic_category_id/topics/topic_id/topic_results/1
  # PUT /topic_categories/topic_category_id/topics/topic_id/topic_results/1.json
  def update
    @topic_result = TopicResult.find(params[:id])

    respond_to do |format|
      if @topic_result.update_attributes(params[:topic_result])
        format.html { redirect_to @topic_result, notice: 'Topic result was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @topic_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topic_categories/topic_category_id/topics/topic_id/topic_results/1
  # DELETE /topic_categories/topic_category_id/topics/topic_id/topic_results/1.json
  def destroy
    @topic_result = TopicResult.find(params[:id])
    @topic_result.destroy

    respond_to do |format|
      format.html { redirect_to topic_results_url }
      format.json { head :ok }
    end
  end
end
