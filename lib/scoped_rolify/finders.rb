module Rolify
  module Finders

    def with_scoped_role role_name, resource
      raise MissingResourceError, "You should provide resource" unless resource
      raise InstanceResourceError, "You should provide INSTANCE resource" unless resource.respond_to?(:id)

      User.joins(:roles).where(constraints([role_name], resource))
    end

    def with_any_scoped_role role_names, resource
      User.joins(:roles).where(constraints(role_names, resource))
    end

    private

    def constraints role_names, resource
      table = Arel::Table.new(:roles)
      [].tap do |_constraints|
        role_names.each do |name|
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