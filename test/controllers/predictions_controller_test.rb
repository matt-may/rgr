require 'test_helper'

class PredictionsControllerTest < ActionController::TestCase
  setup do
    @prediction = predictions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:predictions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create prediction" do
    assert_difference('Prediction.count') do
      post :create, prediction: { height: @prediction.height, weight: @prediction.weight }
    end

    assert_redirected_to prediction_path(assigns(:prediction))
  end

  test "should make correct prediction -> male" do
    assert_difference('Prediction.count') do
      post :create, prediction: { height: @prediction.height, weight: @prediction.weight }
    end

    assert_equal 'male', assigns(:prediction).result
  end

  test "should make correct prediction -> female" do
    prediction = predictions(:five)
    assert_difference('Prediction.count') do
      post :create, prediction: { height: prediction.height, weight: prediction.weight }
    end

    assert_equal 'female', assigns(:prediction).result
  end

  test "should show prediction" do
    get :show, id: @prediction
    assert_response :success
  end

  test "should destroy prediction" do
    assert_difference('Prediction.count', -1) do
      delete :destroy, id: @prediction
    end

    assert_redirected_to predictions_path
  end
end
