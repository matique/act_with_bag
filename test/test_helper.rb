if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start do
    add_filter "/test/"
  end
end

require "combustion"
Combustion.path = "test/internal"
Combustion.initialize! :active_record do
  config.active_record.yaml_column_permitted_classes = [Symbol, Time, Date]
end

require "rails/test_help"
require "minitest/autorun"
require "minitest/benchmark"
# require 'capybara/rails'
