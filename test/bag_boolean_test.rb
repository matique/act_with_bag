require "test_helper"

class Order < ActiveRecord::Base
  add_to_bag bool: :boolean
end

class BagBooleanTest < ActiveSupport::TestCase
  def setup
    @order = Order.new
  end

  test "uninitialized boolean should return false" do
    assert_equal false, @order.bool
    assert_equal false, @order.bag.has_key?(:bool)
  end

  test "optimized storage of boolean" do
    @order.bool = false
    assert_equal false, @order.bag.has_key?(:bool)
    @order.bool = 0
    assert_equal false, @order.bag.has_key?(:bool)
    @order.bool = "0"
    assert_equal false, @order.bag.has_key?(:bool)
  end

  test "a true value requires storage in the bag" do
    @order.bool = true
    assert_equal true, @order.bag.has_key?(:bool)
    assert_equal true, @order.bool
  end

  test "reassigning a false value should drop storage in bag" do
    @order.bool = true
    @order.bool = false
    assert_equal false, @order.bag.has_key?(:bool)
  end
end
