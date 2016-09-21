require 'test_helper'

class ProgramacionesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get programaciones_index_url
    assert_response :success
  end

end
