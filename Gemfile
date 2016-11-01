source "https://rubygems.org"
gemspec

version = ENV["RAILS_VERSION"]
gem 'rails', version ? "~> #{version}" : ">= 4.0.2"

group :development, :test do
  gem 'sqlite3'
  gem 'observr'
#  gem 'spork'
#  gem 'spring'
end

group :test do
#  gem 'watchr'
  gem 'simplecov', require: false
end
