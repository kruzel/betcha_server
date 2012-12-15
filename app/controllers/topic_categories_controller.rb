class TopicCategoriesController < ApplicationController
  # GET /topic_categories
  # GET /topic_categories.json
  def index
    @topic_categories = TopicCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: { :topic_categories => @topic_categories.as_json( :only => [ :id , :name ], :methods =>  :image_url, :include => { :topics => { :only => [ :id , :name, :location_id, :start_time, :end_time ], :include =>  { :prediction_options => { :only => [ :id , :name  ], :methods =>  :image_url }, :topic_result => {} } } }) } }
    end
  end

  # GET /topic_categories/1
  # GET /topic_categories/1.json
  def show
    @topic_category = TopicCategory.find(params[:id])

    @topic_categories = Array.new
    @topic_categories << @topic_category

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: { :topic_categories => @topic_categories.as_json( :only => [ :id , :name ], :methods =>  :image_url, :include => { :topics => { :only => [ :id , :name, :location_id, :start_time, :end_time ], :include =>  { :prediction_options => { :only => [ :id , :name  ], :methods =>  :image_url }, :topic_result => {} } } }) } }
    end
  end

  # GET /topic_categories/show_details/1
  # GET /topic_categories/show_details/1.json
  def show_details
    @topic_category = TopicCategory.find(params[:id])
    @topics = @topic_category.topics

    respond_to do |format|
      format.html # show_details.html.erb
      format.json { render json: @topic_category }
    end
  end

  # GET /topic_categories/new
  # GET /topic_categories/new.json
  def new
    @topic_category = TopicCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @topic_category }
    end
  end

  # GET /topic_categories/1/edit
  def edit
    @topic_category = TopicCategory.find(params[:id])
  end

  # POST /topic_categories
  # POST /topic_categories.json
  def create
    @topic_category = TopicCategory.new(params[:topic_category])

    @topic_categories = Array.new
    @topic_categories << @topic_category

    respond_to do |format|
      if @topic_category.save
        format.html { redirect_to @topic_category, notice: 'Topic category was successfully created.' }
        format.json { render json: { :topic_categories => @topic_categories.as_json( :only => [ :id , :name ], :methods =>  :image_url, :include => { :topics => { :only => [ :id , :name, :location_id, :start_time, :end_time ], :include =>  { :prediction_options => { :only => [ :id , :name  ], :methods =>  :image_url }, :topic_result => {} } } }) }, status: :created, location: @topic_category }
      else
        format.html { render action: "new" }
        format.json { render json: @topic_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /topic_categories/1
  # PUT /topic_categories/1.json
  def update
    @topic_category = TopicCategory.find(params[:id])

    respond_to do |format|
      if @topic_category.update_attributes(params[:topic_category])
        format.html { redirect_to @topic_category, notice: 'Topic category was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @topic_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topic_categories/1
  # DELETE /topic_categories/1.json
  def destroy
    @topic_category = TopicCategory.find(params[:id])
    @topic_category.destroy

    respond_to do |format|
      format.html { redirect_to topic_categories_url }
      format.json { head :ok }
    end
  end
end
