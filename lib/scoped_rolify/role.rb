module Rolify
  module Role
    def add_role(role_name, resource = nil)
      role = self.class.adapter.find_or_create_by(role_name.to_s,
                                                  (resource.is_a?(Class) ? resource.to_s : resource.class.base_class.name if resource),
                                                  (resource.id if resource && !resource.is_a?(Class)))

      if !roles.include?(role)
        self.class.define_dynamic_method(role_name, resource) if Rolify.dynamic_shortcuts
        self.class.adapter.add(self, role)
      end
      role
    end
    alias_method :grant, :add_role

    def add_scope_role(role_name, resource)
      ScopedRolify::Policy.new(self, resource).check!
      add_resourced_role(role_name, resource)
    end

    def remove_scope_role(role_name, resource)
      ScopedRolify::Policy.new(self, resource).check!
      remove_resourced_role(role_name, resource)
    end

    private

    def remove_resourced_role(role_name, resource)
      if self.new_record?
        self.roles = self.roles - [self.roles.detect { |r| r.name.to_s == role_name.to_s && r.resource == resource }]
      else
        remove_role(role_name, resource)
      end
    end

    def add_resourced_role(role_name, resource)
      root_resource = resource.respond_to?(:root_resource) ? resource.send(resource.root_resource) : nil

      if self.new_record?
        role = self.class.adapter.role_class.find_or_initialize_by(name: role_name, resource: resource, root_resource: root_resource).tap do |role|
          self.roles << role
          if Rolify.dynamic_shortcuts and !self.respond_to?("is_#{role_name}?".to_sym)
            self.class.define_dynamic_method(role_name, resource)
          end
        end
      else
        role = add_role_with_root(role_name, resource, root_resource)
      end
      add_role_to_resource(role)
      load_dynamic_shortcuts(role_name, resource)
      role
    end

    def load_dynamic_shortcuts(role_name, resource)
      if Rolify.dynamic_shortcuts and !self.respond_to?("is_#{role_name}?".to_sym)
        self.class.define_dynamic_method(role_name, resource)
      end
    end

    def add_role_to_resource(role)
      self.roles << role unless self.roles.include?(role)
    end

    def add_role_with_root(role_name, resource, root_resource)
      unless root_resource
        add_role(role_name, resource)
      else
        conditions = {
          name: role_name.to_s,
          resource_type: resource.class.base_class.name,
          resource_id: resource.id,
        }
        if root_resource
          conditions.merge!({ root_resource_type: (root_resource.is_a?(Class) ? root_resource.to_s : root_resource.class.base_class.name) })
          unless root_resource.is_a?(Class) # Useless for the moment (Already false)
            conditions.merge!({ root_resource_id: root_resource.id })
          end
        end
        self.class.adapter.role_class.where(conditions).first_or_create
      end
    end

  end
end
