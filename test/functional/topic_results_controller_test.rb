require 'test_helper'

class TopicResultsControllerTest < ActionController::TestCase
  setup do
    @topic_result = topic_results(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:topic_results)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create topic_result" do
    assert_difference('TopicResult.count') do
      post :create, topic_result: @topic_result.attributes
    end

    assert_redirected_to topic_result_path(assigns(:topic_result))
  end

  test "should show topic_result" do
    get :show, id: @topic_result.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @topic_result.to_param
    assert_response :success
  end

  test "should update topic_result" do
    put :update, id: @topic_result.to_param, topic_result: @topic_result.attributes
    assert_redirected_to topic_result_path(assigns(:topic_result))
  end

  test "should destroy topic_result" do
    assert_difference('TopicResult.count', -1) do
      delete :destroy, id: @topic_result.to_param
    end

    assert_redirected_to topic_results_path
  end
end
