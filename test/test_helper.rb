require 'rubygems'
require 'test/unit'
require 'active_record'

ActiveRecord::Base.establish_connection({
  :adapter => 'postgresql',
  :database => 'docu_test'
})

ActiveRecord::Schema.define do
  create_table 'orders', :force => true do |t|
    t.column 'bag', :text
  end
end

require File.dirname(__FILE__) + '/../init.rb'
