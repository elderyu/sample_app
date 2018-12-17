require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users :michael
    @user2 = users :archer
    @user10 = users :user_10
    @user_lana = users :lana
    @micropost = microposts :orange
  end

  test "micropost interface" do
    log_in_as @user
    follow_redirect!
    assert_template 'users/show'
    assert_select 'a', text: "Delete", count: 30
    assert_select 'a', text: "2", count: 1 if @user.microposts.count > 30
    # invalid micropost submission
    post microposts_path, params: {micropost: {content: nil}}
    assert_select 'li', "Content can't be blank"
    assert_select 'div#error_explanation'
    assert_template root_path
    #valid micropost submission
    content = "valid content"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: {micropost: {content: content}}
    end
    assert_redirected_to root_url
    assert_equal flash[:success], "Micropost has been created!"
    follow_redirect!
    assert_select 'span', text: content
    # delete micropost
    first_micropost = @user.microposts.first
    assert_equal first_micropost.content, content
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    assert_equal flash[:success], "Micropost deleted!"
    # delete another user's micropost
    get user_path @user2
    assert_template 'users/show'
    assert_match @user2.name, response.body
    assert_select 'a', text: 'Delete', count: 0
    first_micropost2 = @user2.microposts.first
    assert_no_difference 'Micropost.count' do
      delete micropost_path(first_micropost2)
    end
  end

  test "test micropost sidebar count" do
    log_in_as @user

    get root_path
    assert_equal @user.microposts.count, 53
    assert_match "#{@user.microposts.count} "+"micropost".pluralize(@user.microposts.count), response.body
    assert_match "53 microposts", response.body

    get user_path(@user10)
    assert_match "has no microposts", response.body

    get user_path(@user_lana)
    assert_match "Micropost".pluralize(@user_lana.microposts.count)+" (#{@user_lana.microposts.count})", response.body
    assert_match "Micropost (1)", response.body
  end

  test "image upload" do
    log_in_as @user

    get root_path
    assert_template 'static_pages/home'
    assert_match "micropost[picture]", response.body
    assert_select 'input', name: "micropost[picture]"
    content = "My hedgehog"
    picture = fixture_file_upload "test/fixtures/pobrane.jpg"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: {micropost: {content: content, picture: picture}}
    end
    follow_redirect!
    assert_template 'static_pages/home'
    assert_match content, response.body
    assert_match 'pobrane.jpg', response.body
  end

end
