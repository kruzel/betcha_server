require 'test_helper'

class TopicCategoriesControllerTest < ActionController::TestCase
  setup do
    @topic_category = topic_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:topic_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create topic_category" do
    assert_difference('TopicCategory.count') do
      post :create, topic_category: @topic_category.attributes
    end

    assert_redirected_to topic_category_path(assigns(:topic_category))
  end

  test "should show topic_category" do
    get :show, id: @topic_category.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @topic_category.to_param
    assert_response :success
  end

  test "should update topic_category" do
    put :update, id: @topic_category.to_param, topic_category: @topic_category.attributes
    assert_redirected_to topic_category_path(assigns(:topic_category))
  end

  test "should destroy topic_category" do
    assert_difference('TopicCategory.count', -1) do
      delete :destroy, id: @topic_category.to_param
    end

    assert_redirected_to topic_categories_path
  end
end
