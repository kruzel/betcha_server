require 'test_helper'

class StakesControllerTest < ActionController::TestCase
  setup do
    @stake = stakes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stakes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stake" do
    assert_difference('Stake.count') do
      post :create, stake: @stake.attributes
    end

    assert_redirected_to stake_path(assigns(:stake))
  end

  test "should show stake" do
    get :show, id: @stake.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stake.to_param
    assert_response :success
  end

  test "should update stake" do
    put :update, id: @stake.to_param, stake: @stake.attributes
    assert_redirected_to stake_path(assigns(:stake))
  end

  test "should destroy stake" do
    assert_difference('Stake.count', -1) do
      delete :destroy, id: @stake.to_param
    end

    assert_redirected_to stakes_path
  end
end
