require 'test_helper'

class DocentesControllerTest < ActionController::TestCase
  setup do
    @docente = docente(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:docente)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create docente" do
    assert_difference('Docente.count') do
      post :create, :docente => @docente.attributes
    end

    assert_redirected_to docente_path(assigns(:docente))
  end

  test "should show docente" do
    get :show, :id => @docente.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @docente.to_param
    assert_response :success
  end

  test "should update docente" do
    put :update, :id => @docente.to_param, :docente => @docente.attributes
    assert_redirected_to docente_path(assigns(:docente))
  end

  test "should destroy docente" do
    assert_difference('Docente.count', -1) do
      delete :destroy, :id => @docente.to_param
    end

    assert_redirected_to docentes_path
  end
end
