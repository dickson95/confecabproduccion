require 'test_helper'

class RolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rol = roles(:one)
  end

  test "should get index" do
    get roles_url
    assert_response :success
  end

  test "should get new" do
    get new_rol_url
    assert_response :success
  end

  test "should create rol" do
    assert_difference('Role.count') do
      post roles_url, params: { rol: { name: @rol.name } }
    end

    assert_redirected_to rol_url(Role.last)
  end

  test "should show rol" do
    get rol_url(@rol)
    assert_response :success
  end

  test "should get edit" do
    get edit_rol_url(@rol)
    assert_response :success
  end

  test "should update rol" do
    patch rol_url(@rol), params: { rol: { name: @rol.name } }
    assert_redirected_to rol_url(@rol)
  end

  test "should destroy rol" do
    assert_difference('Role.count', -1) do
      delete rol_url(@rol)
    end

    assert_redirected_to roles_url
  end
end
