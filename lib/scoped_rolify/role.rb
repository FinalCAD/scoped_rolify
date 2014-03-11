module Rolify
  module Role

    def add_scope_role(role_name, resource)
      ScopedRolify::Policy.new(self, resource).check!
      add_resourced_role(role_name, resource)
    end

    def remove_scope_role(role_name, resource)
      ScopedRolify::Policy.new(self, resource).check!
      remove_resourced_role(role_name, resource)
    end

    def has_role?(role_name, resource = nil)
      if self.new_record?
        self.roles.detect { |r| r.name.to_s == role_name.to_s && (r.resource == resource || resource.nil?) }
      else
        self.class.adapter.where(self.roles, :name => role_name, :resource => resource)
      end.present?
    end

    private

    def add_resourced_role(role_name, resource)
      if self.new_record?
        self.class.adapter.role_class.new(name: role_name, resource: resource).tap do |role|
          self.roles << role
          if Rolify.dynamic_shortcuts and !self.respond_to?("is_#{role_name}?".to_sym)
            self.class.define_dynamic_method(role_name, resource)
          end
        end
      else
        add_role(role_name, resource)
      end
    end

    def remove_resourced_role(role_name, resource)
      if self.new_record?
        self.roles = self.roles - [self.roles.detect { |r| r.name.to_s == role_name.to_s && r.resource == resource }]
      else
        remove_role(role_name, resource)
      end
    end

  end
end