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
    assert !@user.new_record?
    patch user_path(@user), params: {user: {name: "dsad", email: "foobar@gmail.com", password: "", password_confirmation: ""}}
    #assert_template "show"
    assert_select 'div#error_explanation', "The form contains 4 errors"
  end

end
