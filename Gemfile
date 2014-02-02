source "http://rubygems.org"
gemspec

version = ENV["RAILS_VERSION"]
gem 'rails', version ? "~> #{version}" : ">= 4.0.0"

group :development, :test do
  gem 'sqlite3'
  gem 'watchr'
  gem 'spork'
  gem 'simplecov', require: false
end
