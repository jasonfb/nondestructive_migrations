source 'https://rubygems.org'

gemspec

gem "appraisal"
gem 'guard'
gem 'guard-rspec'
gem 'rake'
gem 'byebug', platform: [:mri_21, :mri_20]



gem 'sqlite3'
gem 'mysql2'
gem 'mocha'

# these versions of Rails are used only when running 'rake test' without using Appraisal
# when run with Appraisal, this version gets overwritten by appraisal
# (also special versions of minitest or minitest-rails are used depending
# on Rails version being tested against)

# ENABLE FOR testing Rails 4.1
gem "rails", "4.1.6", :require => false

gem 'minitest-rg'

group :test do
  gem 'simplecov', :require => false
end