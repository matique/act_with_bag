if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter '/test/'
  end
end

#require 'rails/test_help'
require 'minitest/autorun'
require 'minitest/benchmark'
#require 'capybara/rails'

require 'active_record'

ActiveRecord::Base.establish_connection({
  adapter:  'sqlite3',
  database: 'bag.sqlite3'
})

ActiveRecord::Schema.define do
  create_table 'orders', :force => true do |t|
    t.string :category
    t.column 'bag', :text
  end
end

ActiveRecord::Schema.define do
  create_table 'users', :force => true do |t|
    t.string :type
    t.text   :bag
  end
end

require File.dirname(__FILE__) + '/../lib/act_with_bag.rb'


class Order < ActiveRecord::Base
  add_to_bag :field, flag: :boolean, at: :date
end
