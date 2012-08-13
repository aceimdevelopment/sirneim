require 'test_helper'

class InscripcionAdminControllerTest < ActionController::TestCase
  test "should get paso0" do
    get :paso0
    assert_response :success
  end

end
