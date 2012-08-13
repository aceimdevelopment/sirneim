require 'test_helper'

class EstudianteNivelacionesControllerTest < ActionController::TestCase
  setup do
    @estudiante_nivelacion = estudiante_nivelacion(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:estudiante_nivelacion)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create estudiante_nivelacion" do
    assert_difference('EstudianteNivelacion.count') do
      post :create, :estudiante_nivelacion => @estudiante_nivelacion.attributes
    end

    assert_redirected_to estudiante_nivelacion_path(assigns(:estudiante_nivelacion))
  end

  test "should show estudiante_nivelacion" do
    get :show, :id => @estudiante_nivelacion.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @estudiante_nivelacion.to_param
    assert_response :success
  end

  test "should update estudiante_nivelacion" do
    put :update, :id => @estudiante_nivelacion.to_param, :estudiante_nivelacion => @estudiante_nivelacion.attributes
    assert_redirected_to estudiante_nivelacion_path(assigns(:estudiante_nivelacion))
  end

  test "should destroy estudiante_nivelacion" do
    assert_difference('EstudianteNivelacion.count', -1) do
      delete :destroy, :id => @estudiante_nivelacion.to_param
    end

    assert_redirected_to estudiante_nivelaciones_path
  end
end
