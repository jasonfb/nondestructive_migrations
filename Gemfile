gemspec
source 'https://rubygems.org'

gem "appraisal"
gem 'guard'
gem 'guard-rspec'
gem 'rake'
gem 'byebug', platform: :mri_21

gem 'sqlite3'
gem 'pg'
gem 'mocha'

# these versions of Rails are used only when running 'rake test' without using Appraisal
# when run with Appraisal, this version gets overwritten by appraisal
# (also special versions of minitest or minitest-rails are used depending
# on Rails version being tested against)
gem "rails", require: false

gem 'minitest-rg'

group :test do
  gem 'simplecov', require: false
end
