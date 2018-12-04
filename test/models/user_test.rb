require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(name: "example user", email: "example@gmail.com")
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
    duplicate_user = @user.dup
    duplicate_user.email.upcase!
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email should be downcased" do
    duplicate_user = @user.dup
    duplicate_user.email.upcase!
    duplicate_user.save
    assert duplicate_user.email, @user.email
  end

end
