require 'test_helper'

class UserBetsControllerTest < ActionController::TestCase
  setup do
    @user_bet = user_bets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_bets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_bet" do
    assert_difference('UserBet.count') do
      post :create, user_bet: @user_bet.attributes
    end

    assert_redirected_to user_bet_path(assigns(:user_bet))
  end

  test "should show user_bet" do
    get :show, id: @user_bet.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_bet.to_param
    assert_response :success
  end

  test "should update user_bet" do
    put :update, id: @user_bet.to_param, user_bet: @user_bet.attributes
    assert_redirected_to user_bet_path(assigns(:user_bet))
  end

  test "should destroy user_bet" do
    assert_difference('UserBet.count', -1) do
      delete :destroy, id: @user_bet.to_param
    end

    assert_redirected_to user_bets_path
  end
end
