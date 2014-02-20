require 'rolify'

class MissingResourceError  < StandardError; end
class InstanceResourceError < StandardError; end

module Rolify
  module Role

    def add_role(role_name, resource = nil)
      raise MissingResourceError, "You should provide resource" unless resource
      raise InstanceResourceError, "You should provide INSTANCE resource" unless resource.respond_to?(:id)

      role = self.class.adapter.find_or_create_by(role_name.to_s, resource.class.name, resource.id)
      if !roles.include?(role)
        self.class.define_dynamic_method(role_name, resource) if Rolify.dynamic_shortcuts
        self.class.adapter.add(self, role)
      end
      role
    end

  end
end