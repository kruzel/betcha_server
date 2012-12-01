require 'test_helper'

class ActivityEventsControllerTest < ActionController::TestCase
  setup do
    @activity_event = activity_events(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:activity_events)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create activity_event" do
    assert_difference('ActivityEvent.count') do
      post :create, activity_event: @activity_event.attributes
    end

    assert_redirected_to activity_event_path(assigns(:activity_event))
  end

  test "should show activity_event" do
    get :show, id: @activity_event.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @activity_event.to_param
    assert_response :success
  end

  test "should update activity_event" do
    put :update, id: @activity_event.to_param, activity_event: @activity_event.attributes
    assert_redirected_to activity_event_path(assigns(:activity_event))
  end

  test "should destroy activity_event" do
    assert_difference('ActivityEvent.count', -1) do
      delete :destroy, id: @activity_event.to_param
    end

    assert_redirected_to activity_events_path
  end
end
