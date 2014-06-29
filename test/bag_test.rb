require 'test_helper'

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

  test "bag is hidden" do
    value = 'abc'
    @order.field = value
    @order.bag = 'bad thing'
    assert_equal value, @order.field
  end

  test "merge for :at :date" do
    model = :order
    params = {model => {'at(1i)' => '1', 'at(2i)' => '2','at(3i)' => '3'}}
    res = Order.merge({}, params)
    assert_equal Date.new(1, 2, 3), res[model][:at]
  end

  test "integer&float" do
    time = Time.now
    [123, 2.3, "abc", nil, {a: 1}, [1,2], time].each { |value|
      @order.field = value
      assert_equal value, @order.field

      @order.save
      id = @order.id
      order = Order.find(id)
      assert_equal value, order.field
    }
  end

end
