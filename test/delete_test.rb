require "test_helper"

class Order < ActiveRecord::Base
Rails.application.config.active_record.yaml_column_permitted_classes = [Symbol]
  add_to_bag :aa, :bb, :cc
  delete_from_bag :bb
end

class DeleteTest < ActiveSupport::TestCase
  def setup
    @order = Order.new
  end

  test "delete a field" do
    @order.aa = "aa"
    @order.bb = "bb"
    @order.cc = "cc"
    @order.save
    assert_equal "aa", @order.aa
    assert_nil @order.bb
    assert_equal "cc", @order.cc
  end
end
