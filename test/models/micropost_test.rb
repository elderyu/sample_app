require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users :michael
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "currently content can be empty" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "content should have less than 140 characters" do
    @micropost.content = 'a'*141
    assert_not @micropost.valid?
  end

  test "exercises" do
     micropost = @user.microposts.create(content: "Lorem ipsum")
     assert_equal @user.microposts.find(micropost.id).content, "Lorem ipsum"
     assert @user == micropost.user
     assert @user.microposts.first == micropost
  end

  test "order should be most recent first" do
    assert_equal microposts(:orange), Micropost.first
  end

  test "dependent microposts are destroyed when user is destroyed" do
    @user.save
    # Rails::logger.debug "="*81
    # Rails::logger.debug Micropost.second.created_at
    # Rails::logger.debug Micropost.last.created_at
    # Rails::logger.debug "="*81
    # Rails::logger.debug time_ago_in_words(3.minutes.ago)
    #micropost = @user.microposts.create(content: "Lorem ipsum")
    @user.destroy
    assert_equal @user.microposts.count, 0
  end


end
