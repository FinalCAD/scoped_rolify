module ScopedRolify
  class Policy < Struct.new(:model, :resource)

    def check!
      raise MissingResourceError, "You should provide resource" unless self.resource
      raise InstanceResourceError, "You should provide INSTANCE resource" unless self.resource.respond_to?(:id)
    end

    def check_persisted!
      check!
      raise PersistenceError, "You should ask on persisted resource" unless self.resource.persisted?
    end

  end
end