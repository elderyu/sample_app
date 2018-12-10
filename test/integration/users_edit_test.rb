require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit"  do
    log_in_as @user
    patch user_path(@user), params: {user: {name: "", email: "", password: "", password_confirmation: ""}}
    assert_template 'users/edit'
    assert_select 'div[class="alert alert-danger"]', "The form contains 3 errors"
  end

  test "successful edit" do
    log_in_as @user
    assert !@user.new_record?
    patch user_path(@user), params: {user: {name: "dsad", email: "foobar@gmail.com", password: "", password_confirmation: ""}}
    follow_redirect!
    assert_template "show"
    assert_equal flash[:success], "Profile updated"
    @user.reload
    assert_equal @user.name, "dsad"
    assert_equal @user.email, "foobar@gmail.com"
  end

end
