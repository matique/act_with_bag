require 'test_helper'


class Order < ActiveRecord::Base
  add_to_bag :category
end


class AccessorTest < ActiveSupport::TestCase

  def setup
    @order = Order.new
  end

  test "should reject overwriting of column category" do
    value = 'abc'
    assert @order.respond_to?(:category)
    @order.category = value
    assert_equal false, @order.bag.has_key?(:category)
  end

end
