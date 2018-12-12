require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = User.new(name: "John Brown", email: "john@brown.com", password: "1234567890", password_confirmation: "1234567890", activated: true)
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

  test "login with valid information using signup page" do # changed because email activation, was ok
    get signup_path
    #Rails::logger.debug params[:first]
    post signup_path, params: {user: {name: @user.name, email: @user.email, password: @user.password, password_confirmation: @user.password_confirmation}}
    get login_path
    assert_template 'sessions/new'
    post login_path, params: {session: {email: @user.email, password: @user.password}}
    follow_redirect!
    assert_template root_path
    assert_equal flash[:danger], "Account not activated.Check your email for the activtion link."
    # assert_equal flash[:info], "Please check your email's inbox to activate your account."     # because email verification needed for logging in after signup
    # assert_template 'users/show'
    # assert_select "li[class=?]", "dropdown"
    # assert_select "b[class=?]", "caret"
    # assert_select "a[href=?]", "/logout"
    # #assert session_started?    #not available in test environment
    # assert is_logged_in?
    # delete logout_path
    # follow_redirect!
    # assert_template root_path
    # assert_select "a[href=?]", "/login", count: 1
  end

  test "login with valid information using users.yml" do
    #@user2 = users(:michael) # users means users.yml
    get login_path
    post login_path, params: {session: {email: @user2.email, password: 'password'}}
    follow_redirect!
    assert_template 'users/show'
  end

  test "user logged in after signup?" do # changed because email activation, was ok
    post signup_path, params: {user: {name: @user.name, email: @user.email, password: @user.password, password_confirmation: @user.password_confirmation}}
    follow_redirect!
    assert_template root_path
    assert_equal flash[:info], "Please check your email's inbox to activate your account."     # because email verification needed for logging in after signup
  end

  test "login with remembering" do
    log_in_as @user2, remember_me: '1'
    assert_not_empty cookies["remember_token"]
    assert_not_empty assigns(:user).remember_token
  end

  test "login without remembering" do
    log_in_as @user2, remember_me: '1'
    log_in_as @user2, remember_me: '0'
    assert_empty cookies["remember_token"]
  end

end
