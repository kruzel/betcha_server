require 'test_helper'

class UserStatsControllerTest < ActionController::TestCase
  setup do
    @user_stat = user_stats(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_stats)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_stat" do
    assert_difference('UserStat.count') do
      post :create, user_stat: @user_stat.attributes
    end

    assert_redirected_to user_stat_path(assigns(:user_stat))
  end

  test "should show user_stat" do
    get :show, id: @user_stat.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_stat.to_param
    assert_response :success
  end

  test "should update user_stat" do
    put :update, id: @user_stat.to_param, user_stat: @user_stat.attributes
    assert_redirected_to user_stat_path(assigns(:user_stat))
  end

  test "should destroy user_stat" do
    assert_difference('UserStat.count', -1) do
      delete :destroy, id: @user_stat.to_param
    end

    assert_redirected_to user_stats_path
  end
end
