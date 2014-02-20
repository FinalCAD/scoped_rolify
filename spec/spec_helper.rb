require 'bundler/setup'

require 'rolify'
require 'scopable'
require 'rails'

require 'coveralls'
Coveralls.wear!

ENV['ADAPTER'] ||= 'active_record'

load File.dirname(__FILE__) + "/support/adapters/#{ENV['ADAPTER']}.rb"
load File.dirname(__FILE__) + '/support/data.rb'

RSpec.configure do |c|
  c.run_all_when_everything_filtered = true
end

