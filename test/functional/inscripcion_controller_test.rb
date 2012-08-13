require 'test_helper'

class InscripcionControllerTest < ActionController::TestCase
  test "should get paso1" do
    get :paso1
    assert_response :success
  end

  test "should get paso2" do
    get :paso2
    assert_response :success
  end

  test "should get paso3" do
    get :paso3
    assert_response :success
  end

end
