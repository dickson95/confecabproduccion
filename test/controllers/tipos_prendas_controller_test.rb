require 'test_helper'

class TiposPrendasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tipo_prenda = tipos_prendas(:one)
  end

  test "should get index" do
    get tipos_prendas_url
    assert_response :success
  end

  test "should get new" do
    get new_tipo_prenda_url
    assert_response :success
  end

  test "should create tipo_prenda" do
    assert_difference('TipoPrenda.count') do
      post tipos_prendas_url, params: { tipo_prenda: { tipo: @tipo_prenda.tipo } }
    end

    assert_redirected_to tipo_prenda_url(TipoPrenda.last)
  end

  test "should show tipo_prenda" do
    get tipo_prenda_url(@tipo_prenda)
    assert_response :success
  end

  test "should get edit" do
    get edit_tipo_prenda_url(@tipo_prenda)
    assert_response :success
  end

  test "should update tipo_prenda" do
    patch tipo_prenda_url(@tipo_prenda), params: { tipo_prenda: { tipo: @tipo_prenda.tipo } }
    assert_redirected_to tipo_prenda_url(@tipo_prenda)
  end

  test "should destroy tipo_prenda" do
    assert_difference('TipoPrenda.count', -1) do
      delete tipo_prenda_url(@tipo_prenda)
    end

    assert_redirected_to tipos_prendas_url
  end
end
