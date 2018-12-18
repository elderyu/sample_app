require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  def setup
    @user = users :michael
    @other = users :archer
    log_in_as @user
  end

  test "following page" do
    get following_user_path @user
    assert_template 'users/_show_follow'
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "followers page" do
    get followers_user_path @user
    assert_template 'users/_show_follow'
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "should follow user the standard way" do
    assert_difference 'Relationship.count', 1 do
      post relationships_path, params: {followed_id: @other.id}
    end
  end

  test "should follow user using Ajax" do
    assert_difference 'Relationship.count', 1 do
      post relationships_path, params: {followed_id: @other.id}, xhr: true
    end
  end

  test "should unfollow user the standard way" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference 'Relationship.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test "should unfollow user using Ajax" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference 'Relationship.count', -1 do
      delete relationship_path(relationship), xhr: true
    end
  end

end
