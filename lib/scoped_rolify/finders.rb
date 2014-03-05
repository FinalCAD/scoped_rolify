module Rolify
  module Finders

    def with_scoped_role role_name, resource
      raise MissingResourceError, "You should provide resource" unless resource
      raise InstanceResourceError, "You should provide INSTANCE resource" unless resource.respond_to?(:id)

      self.joins(:roles).where(rolify_constraints(role_name, resource))
    end

    def with_any_scoped_role role_names, resource
      self.joins(:roles).where(rolify_constraints(role_names, resource))
    end

    def rolify_constraints role_names, resource
      raise 'You should give somes role' if role_names.nil? or (role_names||[]).empty?
      table = Arel::Table.new(:roles)
      [].tap do |_constraints|
        Array.wrap(role_names).each do |name|
          _constraints << [].tap do |_constraint|
            _constraint << table[:name].eq(name)
            _constraint << table[:resource_type].eq(resource.class.name)
            _constraint << table[:resource_id].eq(resource.id)
          end.reduce(:and)
        end
      end.reduce(:or)
    end

  end
end