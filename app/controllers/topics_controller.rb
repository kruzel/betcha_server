class TopicsController < ApplicationController
  before_filter :authenticate_user!

  # GET /topic_categories/topic_category_id/topics
  # GET topic_categories/topic_category_id/topics.json
  def index
    @topic_category = TopicCategory.find(params[:topic_category_id])
    @topics = Topic.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @topics }
    end
  end

  # GET /topic_categories/topic_category_id/topics/1
  # GET /topic_categories/topic_category_id/topics/1.json
  def show
    @topic = Topic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @topic }
    end
  end

  # GET /topic_categories/topic_category_id/topics//show_details/1
  # GET /topic_categories/topic_category_id/topics/show_details/1.json
  def show_details
    @topic_category = TopicCategory.find(params[:topic_category_id])
    @topic = Topic.find(params[:id])
    @prediction_options = @topic.prediction_options
    @topic_result = @topic.topic_result

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @topic }
    end
  end

  # GET /topic_categories/topic_category_id/topics/new
  # GET /topic_categories/topic_category_id/topics/new.json
  def new
    @topic_category = TopicCategory.find(params[:topic_category_id])
    @topic = Topic.new
    @topic.topic_category = @topic_category

    @locations = Location.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @topic }
    end
  end

  # GET /topic_categories/topic_category_id/topics/1/edit
  def edit
    @topic = Topic.find(params[:id])
    @topic_category = @topic.topic_category
    @locations = Location.all
  end

  # POST /topic_categories/topic_category_id/topics
  # POST /topic_categories/topic_category_id/topics.json
  def create
    @topic_category = TopicCategory.find(params[:topic_category_id])
    @topic = Topic.new(params[:topic])
    @topic.topic_category = @topic_category
    @topic.location = Location.find(params[:location][:id])

    respond_to do |format|
      if @topic.save
        format.html { redirect_to [@topic_category,@topic], notice: 'Topic was successfully created.' }
        format.json { render json: @topic, status: :created, location: @topic }
      else
        format.html { render action: "new" }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /topic_categories/topic_category_id/topics/1
  # PUT /topic_categories/topic_category_id/topics/1.json
  def update
    @topic = Topic.find(params[:id])

    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        format.html { redirect_to @topic, notice: 'Topic was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topic_categories/topic_category_id/topics/1
  # DELETE /topic_categories/topic_category_id/topics/1.json
  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy

    respond_to do |format|
      format.html { redirect_to topics_url }
      format.json { head :ok }
    end
  end
end
