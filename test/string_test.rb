require "test_helper"

class Order < ActiveRecord::Base
  add_to_bag string: :string
end

class StringTest < ActiveSupport::TestCase
  def setup
    @order = Order.new
  end

  test "assigning boolean to string" do
    value = false
    @order.string = value
    assert_equal "false", @order.string
    value = true
    @order.string = value
    assert_equal "true", @order.string
  end
end
