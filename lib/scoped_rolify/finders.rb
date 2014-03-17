module Rolify
  module Finders

    def with_scoped_role role_name, resource
      ScopedRolify::Policy.new(self, resource).check_persisted!
      self.joins(:roles).where(rolify_constraints(role_name, resource))
    end

    def with_any_scoped_role role_names, resource
      ScopedRolify::Policy.new(self, resource).check_persisted!
      self.joins(:roles).where(rolify_constraints(role_names, resource))
    end

    def rolify_constraints role_names, resource
      raise 'You should give somes role' if role_names.nil? or (role_names||[]).empty?
      root_resource = resource.respond_to?(:root_resource) ? resource.send(resource.root_resource) : nil
      ScopedRolify::Policy.new(self, resource).check_persisted!
      table = Arel::Table.new(:roles)
      [].tap do |_constraints|
        Array.wrap(role_names).each do |name|
          _constraints << [].tap do |_constraint|
            _constraint << table[:name].eq(name)
            _constraint << table[:resource_type].eq(resource.class.name)
            _constraint << table[:resource_id].eq(resource.id)
            if root_resource
              _constraint << table[:root_resource_type].eq(root_resource.class.name)
              _constraint << table[:root_resource_id].eq(root_resource.id)
            end
          end.reduce(:and)
        end
      end.reduce(:or)
    end

  end
end