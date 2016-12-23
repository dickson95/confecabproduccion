require 'test_helper'

class EstadosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get estados_index_url
    assert_response :success
  end

  test "should get edit" do
    get estados_edit_url
    assert_response :success
  end

  test "should get update" do
    get estados_update_url
    assert_response :success
  end

end
