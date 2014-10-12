source 'https://rubygems.org'

gemspec

gem "appraisal"

gem 'guard'
gem 'guard-rspec'
gem 'rake'
gem 'byebug', platform: :mri_21

# this default version of rails is used only when running 'rake test'
# when run with appraisal, this version gets overwritten by appraisal
gem "rails", "4.1.6", :require => false


group :test do
  gem 'simplecov', :require => false
end