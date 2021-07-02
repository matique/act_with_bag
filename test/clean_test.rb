require "test_helper"

class Order < ActiveRecord::Base
  add_to_bag :name
  add_to_bag :name2
end

class CleanTest < ActiveSupport::TestCase
  def setup
    @order = Order.new
  end

  test "assigning nil removes field from bag" do
    value = "abc"
    assert_equal false, @order.bag.has_key?(:name)
    @order.name = value
    assert_equal true, @order.bag.has_key?(:name)
    @order.name = nil
    assert_equal false, @order.bag.has_key?(:name)
  end

  test "assigning nil to not yet initialized field" do
    assert_equal false, @order.bag.has_key?(:name2)
    @order.name2 = nil
    assert_equal false, @order.bag.has_key?(:name2)
  end
end
