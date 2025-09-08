require "test_helper"

class Rests::StartControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get rests_start_create_url
    assert_response :success
  end
end
