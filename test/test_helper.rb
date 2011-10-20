require 'rubygems'
require 'test/unit'
require 'active_record'

ActiveRecord::Base.establish_connection({
  :adapter => 'sqlite3',
  :database => 'docu_test'
})

ActiveRecord::Schema.define do
  create_table 'orders', :force => true do |t|
    t.column 'bag', :text
  end
end

require File.dirname(__FILE__) + '/../lib/act_with_bag.rb'
