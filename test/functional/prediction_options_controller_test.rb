require 'test_helper'

class PredictionOptionsControllerTest < ActionController::TestCase
  setup do
    @prediction_option = prediction_options(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:prediction_options)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create prediction_option" do
    assert_difference('PredictionOption.count') do
      post :create, prediction_option: @prediction_option.attributes
    end

    assert_redirected_to prediction_option_path(assigns(:prediction_option))
  end

  test "should show prediction_option" do
    get :show, id: @prediction_option.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @prediction_option.to_param
    assert_response :success
  end

  test "should update prediction_option" do
    put :update, id: @prediction_option.to_param, prediction_option: @prediction_option.attributes
    assert_redirected_to prediction_option_path(assigns(:prediction_option))
  end

  test "should destroy prediction_option" do
    assert_difference('PredictionOption.count', -1) do
      delete :destroy, id: @prediction_option.to_param
    end

    assert_redirected_to prediction_options_path
  end
end
