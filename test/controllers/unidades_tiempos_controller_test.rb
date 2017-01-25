require 'test_helper'

class UnidadesTiemposControllerTest < ActionDispatch::IntegrationTest
  setup do
    @unidad_tiempo = unidades_tiempos(:one)
  end

  test "should get index" do
    get unidades_tiempos_url
    assert_response :success
  end

  test "should get new" do
    get new_unidad_tiempo_url
    assert_response :success
  end

  test "should create unidad_tiempo" do
    assert_difference('UnidadTiempo.count') do
      post unidades_tiempos_url, params: { unidad_tiempo: { segundos: @unidad_tiempo.segundos, unidad: @unidad_tiempo.unidad } }
    end

    assert_redirected_to unidad_tiempo_url(UnidadTiempo.last)
  end

  test "should show unidad_tiempo" do
    get unidad_tiempo_url(@unidad_tiempo)
    assert_response :success
  end

  test "should get edit" do
    get edit_unidad_tiempo_url(@unidad_tiempo)
    assert_response :success
  end

  test "should update unidad_tiempo" do
    patch unidad_tiempo_url(@unidad_tiempo), params: { unidad_tiempo: { segundos: @unidad_tiempo.segundos, unidad: @unidad_tiempo.unidad } }
    assert_redirected_to unidad_tiempo_url(@unidad_tiempo)
  end

  test "should destroy unidad_tiempo" do
    assert_difference('UnidadTiempo.count', -1) do
      delete unidad_tiempo_url(@unidad_tiempo)
    end

    assert_redirected_to unidades_tiempos_url
  end
end
