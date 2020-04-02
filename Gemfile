source "https://rubygems.org"
ruby "2.6.5"

gem 'rack'
gem 'grape'
gem 'sequel'
gem 'rack-cors'
gem 'grape-swagger'

group :production do
  gem 'pg', '~> 0.18'
end

group :development, :test do
  gem 'pry'
  gem 'rack-test'
  gem 'rake'
  gem 'rspec'
  gem 'sqlite3'
end