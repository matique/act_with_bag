require "test_helper"

class Order < ActiveRecord::Base
  add_to_bag({i: :integer}, {f: :float})
end

class TypeTest < ActiveSupport::TestCase
  def setup
    @order = Order.new
  end

  test "miscellaneous values" do
    [123, 2.3, "abc", nil, {a: 1}, [1, 2]].each { |value|
      @order.field = value
      assert_value value, @order.field

      @order.save
      id = @order.id
      order = Order.find(id)
      assert_value value, order.field
    }
  end

  test "Time & Date" do
    time = Time.now
    today = Date.today
    [time, today].each { |value|
      @order.field = value
      assert_value value, @order.field

      @order.save
      id = @order.id
      order = Order.find(id)
      assert_value value, order.field
    }
  end

  test "integer" do
    value = "123"
    @order.i = value
    assert_equal value.to_i, @order.i
    assert_kind_of Integer, @order.i
  end

  test "float" do
    value = "1.23"
    @order.f = value
    assert_equal value.to_f, @order.f
    assert_kind_of Float, @order.f
  end

  private

  def assert_value(expect, actual)
    assert_equal expect, actual if expect
    assert_nil actual unless expect
  end
end
