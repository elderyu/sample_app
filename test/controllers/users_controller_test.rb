require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @user2 = users(:sawek)
    @user3 = users(:user_29)
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

  test "should not allow the admin attribute to be edited via web" do
    log_in_as @user2
    patch user_path(@user2), params: {user: {name: "123", email: "dwad@gmail.com", admin: 1}}
    assert_equal @user2.reload.admin, false
  end

  test "redirect destroy when not logged in" do
    delete user_path(@user2)
    assert_redirected_to login_path
    assert_not flash.empty?
  end

  test "non admin users cannot delete users" do
    log_in_as @user2
    assert_not @user2.admin
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_path
  end

  test "admin users can delete users" do
    log_in_as @user
    assert @user.admin?
    assert_difference 'User.count', -1 do
      delete user_path(@user3)
    end
    assert_redirected_to users_path
  end

  test "admin sees destroy link" do
    log_in_as @user
    get users_path
    assert_template 'users/index'
    assert_select 'a', "| Delete"
  end

  test "should redirect following when not logged in" do
    # log_in_as @user
    get following_user_path(@user)
    assert_redirected_to login_path
  end

  test "should redirect followers when not logged in" do
    # log_in_as @user
    get following_user_path(@user)
    assert_redirected_to login_path
  end

end
