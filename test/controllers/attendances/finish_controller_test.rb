require 'test_helper'

class Attendances::FinishControllerTest < ActionDispatch::IntegrationTest
  test 'should get create' do
    get attendances_finish_create_url
    assert_response :success
  end
end
