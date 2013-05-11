require 'test_helper'

class BooleanTest < ActiveSupport::TestCase

  def setup
    @order = Order.new
  end

  test "boolean access to flag" do
    value = true
    @order.flag = value
    assert_equal value, @order.flag
    assert @order.flag?
    assert_not_equal false, @order.flag

    value = false
    @order.flag = value
    assert_equal value, @order.flag
    assert !@order.flag?
    assert_not_equal true, @order.flag
  end

  test "boolean returns a boolean" do
    value = true
    @order.flag = value
    assert_equal true, @order.flag

    value = false
    @order.flag = value
    assert_equal false, @order.flag
  end

  test "1/0 returns a boolean" do
    @order.flag = 1
    assert_equal true, @order.flag

    @order.flag = 0
    assert_equal false, @order.flag
  end

  test "string 1/0 returns a boolean" do
    @order.flag = '1'
    assert_equal true, @order.flag

    @order.flag = '0'
    assert_equal false, @order.flag

    @order.flag = nil
    assert_equal false, @order.flag
  end

end
