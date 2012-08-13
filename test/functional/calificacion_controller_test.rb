require 'test_helper'

class CalificacionControllerTest < ActionController::TestCase
  test "should get index.html.haml" do
    get :index.html.haml
    assert_response :success
  end

end
