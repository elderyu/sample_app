require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = User.new(name: "John Brown", email: "john@brown.com", password: "1234567890", password_confirmation: "1234567890")
    @user2 = users(:michael) # users means users.yml
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: {session: {email: "", password: ""}}
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information using signup page" do
    get signup_path
    #Rails::logger.debug params[:first]
    post signup_path, params: {user: {name: @user.name, email: @user.email, password: @user.password, password_confirmation: @user.password_confirmation}}
    get login_path
    assert_template 'sessions/new'
    post login_path, params: {session: {email: @user.email, password: @user.password}}
    follow_redirect!
    assert_template 'users/show'
    assert_select "li[class=?]", "dropdown"
    assert_select "b[class=?]", "caret"
    assert_select "a[href=?]", "/logout"
    #assert session_started?    #not available in test environment
    assert is_logged_in?
    delete logout_path
    follow_redirect!
    assert_template root_path
    assert_select "a[href=?]", "/login", count: 1
  end

  test "login with valid information using users.yml" do
    #@user2 = users(:michael) # users means users.yml
    get login_path
    post login_path, params: {session: {email: @user2.email, password: 'password'}}
    follow_redirect!
    assert_template 'users/show'
  end

  test "user looged in after signup?" do
    post signup_path, params: {user: {name: @user.name, email: @user.email, password: @user.password, password_confirmation: @user.password_confirmation}}
    follow_redirect!
    assert_select "a[href=?]", "/logout"
  end

end
