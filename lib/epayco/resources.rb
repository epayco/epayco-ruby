require_relative 'operations'

module Epayco
  class Resource
    include Operations

    def self.url id=nil
      resource_name = self.name.split('::').last.downcase
    end
  end

  class Token < Resource
    public_class_method :create
  end

  class Customers < Resource
    public_class_method :create, :get, :list
  end

  class Plan < Resource
    public_class_method :create, :get, :list
  end

  class Subscriptions < Resource
    public_class_method :create, :get, :list
  end

  class Bank < Resource
    public_class_method :create
  end

end
