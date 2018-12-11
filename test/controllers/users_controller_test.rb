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

  test "redirect to target after logging in" do
    get edit_user_path(@user)
    follow_redirect!
    Rails::logger.debug session[:forwarding_url]
    assert !session[:forwarding_url].nil?
    assert_template "sessions/new"
    post login_path, params: {session: {email: @user.email, password: 'password'}}
    follow_redirect!
    assert_template "edit"
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_path
  end
end
