require 'test_helper'


class Order < ActiveRecord::Base
  serialize :bag, Hash
  add_to_bag :field, :flag => :boolean, :at => :date
end


class BagTest < ActiveSupport::TestCase

  def setup
    @order = Order.new
  end

  test "has a bag" do
    assert @order.respond_to?(:bag)
  end

  test "has setters and getters" do
    assert @order.respond_to?(:field)
    assert @order.respond_to?(:flag)
    assert @order.respond_to?(:at)

    assert @order.respond_to?('field=')
    assert @order.respond_to?('flag=')
    assert @order.respond_to?('flag?')
    assert @order.respond_to?('at=')
  end

  test "string access to field" do
    value = 'abc'
    @order.field = value
    assert_equal value, @order.field
    assert_not_equal 'def', @order.field
  end

  test "date access to at" do
    value = DateTime.now
    @order.at = value
    assert_equal value, @order.at
    assert_not_equal 'def', @order.at
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

  test "bag is hidden" do
    value = 'abc'
    @order.field = value
    @order.bag = 'bad thing'
    assert_equal value, @order.field
  end

end
