require "test_helper"

class GymhousesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get gymhouses_show_url
    assert_response :success
  end
end
