require_relative 'operations'

module Epayco
  class Resource
    include Operations

    # Def url endpoint
    def self.url id=nil
      self.name.split('::').last.downcase
    end

    # Case switch secure or api
    def self.switch
      self.url == "bank" || self.url == "cash" ? true : false
    end


  end

  # Resources and CRUD

  class Token < Resource
    public_class_method :create
  end

  class Customers < Resource
    public_class_method :create, :get, :list, :update, :updatetoken, :delatetetoken, :addtoken
  end

  class Plan < Resource
    public_class_method :create, :get, :list, :delete
  end

  class Subscriptions < Resource
    public_class_method :create, :get, :list, :cancel, :charge
  end

  class Bank < Resource
    public_class_method :create, :get
  end

  class Cash < Resource
    public_class_method :create, :get
  end

  class Charge < Resource
    public_class_method :create, :get
  end

  class Safetypay < Resource
    public_class_method :create
  end

end
