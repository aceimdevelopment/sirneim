require 'test_helper'

class TipoEstadosControllerTest < ActionController::TestCase
  setup do
    @tipo_estado = tipo_estado(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tipo_estado)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tipo_estado" do
    assert_difference('TipoEstado.count') do
      post :create, :tipo_estado => @tipo_estado.attributes
    end

    assert_redirected_to tipo_estado_path(assigns(:tipo_estado))
  end

  test "should show tipo_estado" do
    get :show, :id => @tipo_estado.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @tipo_estado.to_param
    assert_response :success
  end

  test "should update tipo_estado" do
    put :update, :id => @tipo_estado.to_param, :tipo_estado => @tipo_estado.attributes
    assert_redirected_to tipo_estado_path(assigns(:tipo_estado))
  end

  test "should destroy tipo_estado" do
    assert_difference('TipoEstado.count', -1) do
      delete :destroy, :id => @tipo_estado.to_param
    end

    assert_redirected_to tipo_estados_path
  end
end
