require 'test_helper'

class CalendarioControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get calendario_index_url
    assert_response :success
  end

  test "should get new" do
    get calendario_new_url
    assert_response :success
  end

  test "should get create" do
    get calendario_create_url
    assert_response :success
  end

  test "should get edit" do
    get calendario_edit_url
    assert_response :success
  end

  test "should get update" do
    get calendario_update_url
    assert_response :success
  end

  test "should get destroy" do
    get calendario_destroy_url
    assert_response :success
  end

end
