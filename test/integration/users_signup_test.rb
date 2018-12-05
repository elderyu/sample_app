require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

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
end
