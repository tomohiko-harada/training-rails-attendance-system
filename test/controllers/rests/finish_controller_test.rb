require 'test_helper'

class Rests::FinishControllerTest < ActionDispatch::IntegrationTest
  test 'should get create' do
    get rests_finish_create_url
    assert_response :success
  end
end
