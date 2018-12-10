require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @user2 = users(:sawek)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "access for correct user only" do
    log_in_as @user
    get edit_user_path(@user2)
    assert_redirected_to root_path
  end

end
