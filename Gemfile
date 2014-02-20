source 'https://rubygems.org'

# Specify your gem's dependencies in scopable.gemspec
gemspec

ENV['ADAPTER'] ||= 'active_record'

group :test do
  case ENV['ADAPTER']
  when nil, 'active_record'
    gem 'sqlite3', platform: 'ruby'
    gem 'activerecord', '>= 3.2.0', require: 'active_record'
  else
    raise "Unknown model adapter: #{ENV['ADAPTER']}"
  end

  gem 'pry'
  gem 'coveralls', require: false
end
