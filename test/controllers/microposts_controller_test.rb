require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @micropost = microposts :orange
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: {micropost: {content: "content"}}
    end
    assert_not flash.empty?
    assert_equal flash[:danger], "Please log in."
    assert_redirected_to login_path
  end

  test "should redirect destroy when not logged in" do
    assert_not @micropost.nil?
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_not flash.empty?
    assert_equal flash[:danger], "Please log in."
    assert_redirected_to login_path
  end

end
