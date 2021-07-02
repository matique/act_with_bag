require "test_helper"

class User < ActiveRecord::Base
  add_to_bag :name
end

class Administrator < User
  add_to_bag :key
end

class StiTest < ActiveSupport::TestCase
  def setup
    @user = User.new
    @admin = Administrator.new
  end

  test "kind of" do
    assert_kind_of User, @user
    assert_kind_of Administrator, @admin
  end

  test "STI field type" do
    assert_nil @user.type
    assert_equal "Administrator", @admin.type
  end

  test "have bag" do
    assert @user.respond_to?(:bag)
    assert @admin.respond_to?(:bag)
  end

  test "has setters and getters" do
    assert @user.respond_to?(:name)
    assert @admin.respond_to?(:name)
    assert @admin.respond_to?(:key)

    assert @user.respond_to?("name=")
    assert @admin.respond_to?("name=")
    assert @admin.respond_to?("key=")

    assert_equal false, @user.respond_to?(:key)
    assert_equal false, @user.respond_to?("key=")
  end

  test "access to name & key" do
    name = "name"
    key = "key"
    @admin.name = name
    @admin.key = key
    assert_equal name, @admin.name
    assert_equal key, @admin.key
    assert_not_equal "def", @admin.name
    assert_not_equal "def", @admin.key
  end

  test "merge" do
    model = :administrator
    params = {model => {"at(1i)" => "1", "at(2i)" => "2", "at(3i)" => "3"}}
    res = Administrator.merge({}, params)
    assert_nil res[model][:at]
  end
end
