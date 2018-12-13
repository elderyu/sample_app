require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users :michael
  end

  test "password reset" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # invalid email
    post password_resets_path, params: {password_reset: {email: "invalid email"}}
    assert_template 'password_resets/new'
    assert_equal flash[:danger], "Email not found."
    # valid email
    post password_resets_path, params: {password_reset: {email: @user.email}}
    assert_redirected_to root_path
    assert_equal flash[:info], "Email sent with password reset confirmation."
    # password reset form
    user = assigns :user
    # wrong email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_path
    # wrong token
    get edit_password_reset_path "invalid token", email: user.email
    assert_redirected_to root_path
    # user not active
    user.toggle! :activated
    get edit_password_reset_path user.reset_token, email: user.email
    assert_redirected_to root_path
    user.toggle! :activated
    # valid email and reset_token
    get edit_password_reset_path user.reset_token, email: user.email
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    patch password_reset_path user.reset_token, params: {email: user.email, user: {password: "", password_confirmation: ""}}
    assert_select 'div#error_explanation'
    patch password_reset_path user.reset_token, params: {email: user.email, user: {password: "password1", password_confirmation: "password1"}}
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
    # assert_equal flash[:success], "Password has been changed."
    # assert_redirected_to

  end
end
