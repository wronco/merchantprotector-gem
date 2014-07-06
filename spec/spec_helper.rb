ENV['RAILS_ENV'] = 'test'
require 'pry'
require 'rails'
require 'webmock/rspec'
require 'Merchantprotector'

RSpec.configure do |config|
  config.color = true
  config.formatter = 'documentation'
  config.order = "random"
end

def reset_configuration
  Rollbar.reconfigure do |config|
  end
end

def local?
  ENV['LOCAL'] == '1'
end
