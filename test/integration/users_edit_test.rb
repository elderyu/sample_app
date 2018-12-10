require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit"  do
    @user.save
    log_in_as @user
    get edit_user_path(@user)
    assert_template 'edit'
    patch user_path(@user), params: {user: {name: "", email: "", password: "", password_confirmation: ""}}
    assert_template 'users/edit'
    assert_select 'div[class="alert alert-danger"]', "The form contains 4 errors"
  end

  test "successful edit" do
    #log_in_as @user
    Rails::logger.debug @user.id
    get edit_user_path(@user)
    Rails::logger.debug @user.id
    assert_template 'edit'
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: {user: {name: name, email: email, password: "", password_confirmation: ""}}
    follow_redirect!
    assert_template 'show'
    #Rails::logger.debug flash[:danger]
    #assert_select 'div#error_explanation', "The form contains 4 errors"
    #Rails::logger.debug
    # assert_redirected_to @user
    # #assert_template 'show'
    # assert_equal "Profile updated", flash[:success]
  end
end
