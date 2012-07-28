require 'test_helper'


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

  test "have bag" do
    assert @user.respond_to?(:bag)
    assert @admin.respond_to?(:bag)
  end

  test "has setters and getters" do
    assert @user.respond_to?(:name)
    assert @admin.respond_to?(:name)
    assert @admin.respond_to?(:key)

    assert @user.respond_to?('name=')
    assert @admin.respond_to?('name=')
    assert @admin.respond_to?('key=')

    assert_equal false, @user.respond_to?(:key)
    assert_equal false, @user.respond_to?('key=')
  end

  test "access to name & key" do
    name = 'name'
    key = 'key'
    @admin.name = name
    @admin.key = key
    assert_equal name, @admin.name
    assert_equal key, @admin.key
    assert_not_equal 'def', @admin.name
    assert_not_equal 'def', @admin.key
  end

end
