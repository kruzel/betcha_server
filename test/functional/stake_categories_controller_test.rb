require 'test_helper'

class StakeCategoriesControllerTest < ActionController::TestCase
  setup do
    @stake_category = stake_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stake_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stake_category" do
    assert_difference('StakeCategory.count') do
      post :create, stake_category: @stake_category.attributes
    end

    assert_redirected_to stake_category_path(assigns(:stake_category))
  end

  test "should show stake_category" do
    get :show, id: @stake_category.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stake_category.to_param
    assert_response :success
  end

  test "should update stake_category" do
    put :update, id: @stake_category.to_param, stake_category: @stake_category.attributes
    assert_redirected_to stake_category_path(assigns(:stake_category))
  end

  test "should destroy stake_category" do
    assert_difference('StakeCategory.count', -1) do
      delete :destroy, id: @stake_category.to_param
    end

    assert_redirected_to stake_categories_path
  end
end
