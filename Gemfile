source "https://rubygems.org"
gemspec

group :development, :test do
  gem 'observr'
#  gem 'spork'
#  gem 'spring'
end

group :test do
  version = ENV["RAILS_VERSION"]
  gem 'rails', version ? "~> #{version}" : "~> 5.1"
  gem 'simplecov', require: false
end
