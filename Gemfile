source "https://rubygems.org"
gemspec

version = ENV["RAILS_VERSION"]
gem 'rails', version ? "~> #{version}" : ">= 4.0.2"

group :development, :test do
#  gem 'watchr'
  gem 'observr'
#  gem 'spork'
#  gem 'spring'
  gem 'simplecov', require: false
end
