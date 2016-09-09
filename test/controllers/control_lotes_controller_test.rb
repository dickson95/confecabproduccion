require 'test_helper'

class ControlLotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @control_lote = control_lotes(:one)
  end

  test "should get index" do
    get control_lotes_url
    assert_response :success
  end

  test "should get new" do
    get new_control_lote_url
    assert_response :success
  end

  test "should create control_lote" do
    assert_difference('ControlLote.count') do
      post control_lotes_url, params: { control_lote: { estado_id: @control_lote.estado_id, fecha_id: @control_lote.fecha_id, fecha_id: @control_lote.fecha_id, lote_id: @control_lote.lote_id, sub_estado: @control_lote.sub_estado } }
    end

    assert_redirected_to control_lote_url(ControlLote.last)
  end

  test "should show control_lote" do
    get control_lote_url(@control_lote)
    assert_response :success
  end

  test "should get edit" do
    get edit_control_lote_url(@control_lote)
    assert_response :success
  end

  test "should update control_lote" do
    patch control_lote_url(@control_lote), params: { control_lote: { estado_id: @control_lote.estado_id, fecha_id: @control_lote.fecha_id, fecha_id: @control_lote.fecha_id, lote_id: @control_lote.lote_id, sub_estado: @control_lote.sub_estado } }
    assert_redirected_to control_lote_url(@control_lote)
  end

  test "should destroy control_lote" do
    assert_difference('ControlLote.count', -1) do
      delete control_lote_url(@control_lote)
    end

    assert_redirected_to control_lotes_url
  end
end
