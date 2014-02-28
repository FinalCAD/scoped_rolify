module Rolify
  module Role
    
    def add_scope_role(role_name, resource)
      raise MissingResourceError, 'You should provide resource' unless resource
      raise InstanceResourceError, 'You should provide INSTANCE resource' unless resource.respond_to?(:id)
      
      add_role(role_name, resource)
    end

  end
end