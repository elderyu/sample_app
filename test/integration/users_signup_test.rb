require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {user: {name: "", email: "invalid@email", password: "", password_confirmation: ""}}
    end
    assert_template 'users/new'
    assert_select "div[id=?]", "error_explanation"
    assert_select "div[class=?]", "alert alert-danger"
    assert_select "li", "Password can't be blank", count: 2
    #assert_select 'div.<CSS class for field with error>'
  end

  test "vaild signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params:{user: {name: "example user", email: "example@user.com.pl", password: "1234567890", password_confirmation: "1234567890"}}
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns :user
    assert_not user.activated?
    # try to log in as non-activated user
    log_in_as user
    assert_not is_logged_in?
    # invalid activation token
    get edit_account_activation_path "invalid token", email: user.email
    assert_not is_logged_in?
    # valid token, wrong email
    get edit_account_activation_path user.activation_token, email: "wrong@email.com"
    assert_not is_logged_in?
    # valid activation token and email
    get edit_account_activation_path user.activation_token, email: user.email
    assert user.reload.activated?
    follow_redirect!
    assert_template 'show'
    assert is_logged_in?
    # assert_select "div[class=?]", "alert alert-success"
    # assert_equal flash[:info], "Please check your email's inbox to activate your account."
  end

end
