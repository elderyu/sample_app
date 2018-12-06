require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get login_path
    assert_response :success
    #Rails::logger.debug login_url      http://www.example.com/login
    #Rails::logger.debug login_path     /login
  end

end
