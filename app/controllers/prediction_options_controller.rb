class PredictionOptionsController < ApplicationController
  before_filter :authenticate_user!

  # GET /topic_categories/topic_category_id/topics/topic_id/prediction_options
  # GET /topic_categories/topic_category_id/topics/topic_id/prediction_options.json
  def index
    @topic_category = TopicCategory.find(params[:topic_category_id])
    @topic = Topic.find(params[:topic_id])
    @prediction_options = PredictionOption.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: { :prediction_options => @prediction_options }}
    end
  end

  # GET /topic_categories/topic_category_id/topics/topic_id/prediction_options/1
  # GET /topic_categories/topic_category_id/topics/topic_id/prediction_options/1.json
  def show
    @topic_category = TopicCategory.find(params[:topic_category_id])
    @topic = Topic.find(params[:topic_id])
    @prediction_option = PredictionOption.find(params[:id])

    @prediction_options = Array.new
    @prediction_options << @prediction_option

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: { :prediction_options => @prediction_options } }
    end
  end

  # GET /topic_categories/topic_category_id/topics/topic_id/prediction_options/new
  # GET /topic_categories/topic_category_id/topics/topic_id/prediction_options/new.json
  def new
    @topic_category = TopicCategory.find(params[:topic_category_id])
    @topic = Topic.find(params[:topic_id])
    @prediction_option = PredictionOption.new
    @prediction_option.topic = @topic

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @prediction_option }
    end
  end

  # GET /topic_categories/topic_category_id/topics/topic_id/prediction_options/1/edit
  def edit
    @topic_category = TopicCategory.find(params[:topic_category_id])
    @topic = Topic.find(params[:topic_id])
    @prediction_option = PredictionOption.find(params[:id])
  end

  # POST /topic_categories/topic_category_id/topics/topic_id/prediction_options
  # POST /topic_categories/topic_category_id/topics/topic_id/prediction_options.json
  def create
    @topic_category = TopicCategory.find(params[:topic_category_id])
    @topic = Topic.find(params[:topic_id])
    @prediction_option = PredictionOption.new(params[:prediction_option])
    @prediction_option.topic = @topic

    @prediction_options = Array.new
    @prediction_options << @prediction_option

    respond_to do |format|
      if @prediction_option.save
        format.html { redirect_to [@topic_category,@topic,@prediction_option], notice: 'Prediction option was successfully created.' }
        format.json { render json: { :prediction_options => @prediction_options }, status: :created, location: @prediction_option }
      else
        format.html { render action: "new" }
        format.json { render json: @prediction_option.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /topic_categories/topic_category_id/topics/topic_id/prediction_options/1
  # PUT /topic_categories/topic_category_id/topics/topic_id/prediction_options/1.json
  def update
    @prediction_option = PredictionOption.find(params[:id])

    respond_to do |format|
      if @prediction_option.update_attributes(params[:prediction_option])
        format.html { redirect_to @prediction_option, notice: 'Prediction option was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @prediction_option.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topic_categories/topic_category_id/topics/topic_id/prediction_options/1
  # DELETE /topic_categories/topic_category_id/topics/topic_id/prediction_options/1.json
  def destroy
    @prediction_option = PredictionOption.find(params[:id])
    @prediction_option.destroy

    respond_to do |format|
      format.html { redirect_to topic_category_topic_prediction_options_url }
      format.json { head :ok }
    end
  end
end
