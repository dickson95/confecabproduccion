require 'test_helper'

class ProgramacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @programacion = programaciones(:one)
  end

  test "should get index" do
    get programaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_programacion_url
    assert_response :success
  end

  test "should create programacion" do
    assert_difference('Programacion.count') do
      post programaciones_url, params: { programacion: { costo_total: @programacion.costo_total, lote_id: @programacion.lote_id, mes: @programacion.mes, precio_total: @programacion.precio_total, secuencia: @programacion.secuencia } }
    end

    assert_redirected_to programacion_url(Programacion.last)
  end

  test "should show programacion" do
    get programacion_url(@programacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_programacion_url(@programacion)
    assert_response :success
  end

  test "should update programacion" do
    patch programacion_url(@programacion), params: { programacion: { costo_total: @programacion.costo_total, lote_id: @programacion.lote_id, mes: @programacion.mes, precio_total: @programacion.precio_total, secuencia: @programacion.secuencia } }
    assert_redirected_to programacion_url(@programacion)
  end

  test "should destroy programacion" do
    assert_difference('Programacion.count', -1) do
      delete programacion_url(@programacion)
    end

    assert_redirected_to programaciones_url
  end
end
