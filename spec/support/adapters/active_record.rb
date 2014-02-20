require 'active_record'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Base.extend Rolify

load File.dirname(__FILE__) + '/../schema.rb'

# Standard user and role classes
class User < ActiveRecord::Base
  rolify
end

class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, join_table: :users_roles
  belongs_to :resource, polymorphic: true

  extend Rolify::Adapter::Scopes
end

# Resources classes
class Forum < ActiveRecord::Base
  #resourcify done during specs setup to be able to use custom user classes
end