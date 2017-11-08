require 'bundler/setup'

require 'rolify'
require 'scoped_rolify'
require 'rails'
require 'pry'

require 'coveralls'
Coveralls.wear!

ENV['ADAPTER'] ||= 'active_record'

load File.dirname(__FILE__) + "/support/adapters/#{ENV['ADAPTER']}.rb"

RSpec.configure do |config|
  config.filter_run focused: true
  config.run_all_when_everything_filtered = true

  config.before(:each) do
    [ User, Role, Forum, Category].each &:destroy_all
    load File.dirname(__FILE__) + '/support/data.rb'
  end
end

