module Rolify
  module Finders

    def with_scoped_role role_name, resource, options={}
      ScopedRolify::Policy.new(self, resource).check_persisted!
      self.joins(:roles).where(rolify_constraints(role_name, resource, options))
    end

    def with_any_scoped_role role_names, resource, options={}
      ScopedRolify::Policy.new(self, resource).check_persisted!
      self.joins(:roles).where(rolify_constraints(role_names, resource, options))
    end

    private

    def rolify_constraints role_names, resource, options={}
      raise 'You should give somes role' if role_names.nil? or Array(role_names).empty?
      ScopedRolify::Policy.new(self, resource).check_persisted!

      scope = options.fetch(:scope, :resource)
      raise 'Only scope :resource or :root are supported' unless %i(resource root).include?(scope)

      field_type, field_id = begin
        case scope
        when :resource
          [ :resource_type, :resource_id ]
        when :root
          [ :root_resource_type, :root_resource_id ]
        end
      end

      table = Arel::Table.new(:roles)
      [].tap do |constraints|
        Array.wrap(role_names).each do |name|
          constraints << [].tap do |constraint|
            constraint << table[:name].eq(Arel::Nodes::Quoted.new(name))
            constraint << table[field_type].eq(Arel::Nodes::Quoted.new(resource.class.name))
            constraint << table[field_id].eq(Arel::Nodes::Quoted.new(resource.id))
          end.reduce(:and)
        end
      end.reduce(:or)
    end

  end
end
