module Rolify
  module Finders

    def with_role(role_name, resource = nil)
      raise MissingResourceError, "You should provide resource" unless resource
      raise InstanceResourceError, "You should provide INSTANCE resource" unless resource.respond_to?(:id)

      self.adapter.scope(self, :name => role_name, :resource => resource)
    end

  end
end