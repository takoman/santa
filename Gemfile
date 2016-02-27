source 'https://rubygems.org'
ruby '2.3.0'

gem 'rack-cors'
gem 'pg'
gem 'activerecord', '~> 4.2.0', require: 'active_record'
gem 'json'

gem 'gris'
gem 'gris_paginator'
gem 'roar'
gem 'grape-roar', '~> 0.3.0'
gem 'grape-swagger'
gem 'kaminari', '~> 0.16.2', require: 'kaminari/grape'

gem 'encryptor', '~> 1.1.3'
gem 'bcrypt'

gem 'puma'

group :development, :test do
  gem 'pry'
  gem 'hyperclient', '0.7.0'
end

group :development do
  gem 'annotate'
  gem 'rubocop', require: false
  gem 'shotgun', require: false
end

group :test do
  gem 'database_cleaner'
  gem 'fabrication'
  gem 'rspec'
  gem 'rack-test'
  gem 'simplecov'
  gem 'shoulda-matchers'
  gem 'timecop'
  gem 'webmock'
end
