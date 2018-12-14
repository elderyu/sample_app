require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users :michael
  end

  test "check title, username, gravatar, micropost count, paginated microposts" do
    log_in_as @user
    get user_path @user.id
    assert_template 'show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h3', "Microposts (#{@user.microposts.count})"
    assert_match @user.microposts.count.to_s, response.body
    # assert_select 'a[href="/users?page=2"]', text: 2
    assert_select 'h1>img.gravatar'
    @user.microposts.paginate(page: 1). each do |micropost|
      assert_match micropost.content, response.body
    end
    assert_select 'a[rel="next"]', text: '2', count: 1
  end
end
