require 'test_helper'

class SeguimientosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @seguimiento = seguimientos(:one)
  end

  test "should get index" do
    get seguimientos_url
    assert_response :success
  end

  test "should get new" do
    get new_seguimiento_url
    assert_response :success
  end

  test "should create seguimiento" do
    assert_difference('Seguimiento.count') do
      post seguimientos_url, params: { seguimiento: { cantidad: @seguimiento.cantidad, control_lote_id: @seguimiento.control_lote_id } }
    end

    assert_redirected_to seguimiento_url(Seguimiento.last)
  end

  test "should show seguimiento" do
    get seguimiento_url(@seguimiento)
    assert_response :success
  end

  test "should get edit" do
    get edit_seguimiento_url(@seguimiento)
    assert_response :success
  end

  test "should update seguimiento" do
    patch seguimiento_url(@seguimiento), params: { seguimiento: { cantidad: @seguimiento.cantidad, control_lote_id: @seguimiento.control_lote_id } }
    assert_redirected_to seguimiento_url(@seguimiento)
  end

  test "should destroy seguimiento" do
    assert_difference('Seguimiento.count', -1) do
      delete seguimiento_url(@seguimiento)
    end

    assert_redirected_to seguimientos_url
  end
end
