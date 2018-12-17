require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(name: "example user", email: "example@gmail.com", password: "foobar12345", password_confirmation: "foobar12345")
    @user2 = User.new(name: "example user", email: "example@gmail.com", password: "foobar12345", password_confirmation: "foobar12345")
    @user_michael = users(:michael)
    @user_archer = users(:archer)
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "should be present" do
    @user.name = "Korzonek"
    @user.email = "korzonek@drzewo.gmailus.com"
    assert @user.valid?
  end

  test "not too long" do
    @user.name = "a"*53
    assert_not @user.valid?
  end

  test "email unique" do
    @duplicate_user = @user.dup
    @duplicate_user.email.upcase!
    @user.save
    assert_not @duplicate_user.valid?
  end

  test "email should be downcased" do
    @user.email.upcase!
    @user.save
    @user2.save
    assert_equal @user2.email, @user.reload.email
  end

  test "password should be long enough" do
    @user.password = "22"
    assert_not @user.valid?
  end

  test "checking remember method" do
    assert_not @user.name.nil?
    @user.remember
    assert_not @user.remember_digest.blank?
  end

  test "following users" do
    assert_not @user_michael.following? @user_archer
    @user_michael.follow @user_archer
    assert @user_michael.following? @user_archer
    @user_michael.unfollow @user_archer
    assert_not @user_michael.following? @user_archer
  end

end
