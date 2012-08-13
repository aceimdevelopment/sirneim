require 'test_helper'

class AsistenciaControllerTest < ActionController::TestCase
  test "should get ver_asistencia.html.haml" do
    get :ver_asistencia.html.haml
    assert_response :success
  end

end
