source "https://rubygems.org"

group :test do
    gem "rake"
    gem "puppet", ENV['PUPPET_GEM_VERSION'] || '~> 4.10'
    gem "rspec-puppet"
    gem "puppetlabs_spec_helper"
    gem 'rspec-puppet-utils'
    gem "metadata-json-lint"
    gem 'puppet-syntax'
    gem 'puppet-lint'
    gem 'puppet-debugger'
    gem 'pry'
end

# to disable installing the 50+ gems this group contains run : bundle install --without integration
# group :integration do
#     gem "beaker"
#     gem "beaker-rspec"
#     gem "vagrant-wrapper"
#     gem 'serverspec'
# end

group :development do
    gem "puppet-blacksmith"
# This gem causes bundler install erorrs
#    gem "guard-rake"
end
