require 'test_helper'

class SubEstadosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sub_estado = sub_estados(:one)
  end

  test "should get index" do
    get sub_estados_url
    assert_response :success
  end

  test "should get new" do
    get new_sub_estado_url
    assert_response :success
  end

  test "should create sub_estado" do
    assert_difference('SubEstado.count') do
      post sub_estados_url, params: { sub_estado: { estado_id: @sub_estado.estado_id, sub_estado: @sub_estado.sub_estado } }
    end

    assert_redirected_to sub_estado_url(SubEstado.last)
  end

  test "should show sub_estado" do
    get sub_estado_url(@sub_estado)
    assert_response :success
  end

  test "should get edit" do
    get edit_sub_estado_url(@sub_estado)
    assert_response :success
  end

  test "should update sub_estado" do
    patch sub_estado_url(@sub_estado), params: { sub_estado: { estado_id: @sub_estado.estado_id, sub_estado: @sub_estado.sub_estado } }
    assert_redirected_to sub_estado_url(@sub_estado)
  end

  test "should destroy sub_estado" do
    assert_difference('SubEstado.count', -1) do
      delete sub_estado_url(@sub_estado)
    end

    assert_redirected_to sub_estados_url
  end
end
