source "https://rubygems.org"

group :test do
    gem "rake"
    gem "puppet", ENV['PUPPET_GEM_VERSION'] || '~> 4.8.0'
    gem "rspec-puppet"
    gem "puppetlabs_spec_helper"
    gem 'rspec-puppet-utils'
    gem 'hiera-puppet-helper', :git => 'https://github.com/bobtfish/hiera-puppet-helper.git'
    gem "metadata-json-lint"
    gem 'puppet-syntax'
    gem 'puppet-lint'
    gem 'puppet-debugger', :git => 'https://github.com/nwops/puppet-debugger'
end

# to disable installing the 50+ gems this group contains run : bundle install --without integration
group :integration do
    gem "beaker"
    gem "beaker-rspec"
    gem "vagrant-wrapper"
    gem 'serverspec'
end

group :development do
    gem "travis"
    gem "travis-lint"
    gem "puppet-blacksmith"
    gem 'puppet-repl' # assuming you are using puppet 3.8+
# This gem causes bundler install erorrs
#    gem "guard-rake"
end
