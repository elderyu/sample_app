require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(name: "example user", email: "example@gmail.com", password: "foobar", password_confirmation: "foobar")
    @user2 = User.new(name: "example user", email: "example@gmail.com", password: "foobar", password_confirmation: "foobar")
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
    assert_equal @user2.email, @user.reload.email
  end

  test "password should be long enough" do
    @user.password = "22"
    #Rails::logger.debug "User password_digest: #{@user.password_digest}"
    assert_not @user.valid?
  end

end
