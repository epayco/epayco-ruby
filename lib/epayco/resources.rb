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

    # Punto único de salida de las operaciones.
    # En modo legacy (default) devuelve la respuesta cruda, idéntico a versiones
    # anteriores. En modo :mapped aplica el esquema "recurso.accion" (o
    # passthrough si ese esquema aún no existe).
    def self.deliver(raw, action)
      return raw if Epayco.legacy?
      Epayco::Pipeline.run(raw, "#{url}.#{action}")
    end

  end

  # Resources and CRUD

  class Token < Resource
    public_class_method :create
  end

  class Customers < Resource
    public_class_method :create, :get, :list, :update, :updatetoken, :delatetetoken, :addtoken, :getCustomer
  end

  class Plan < Resource
    public_class_method :create, :get, :list, :delete, :update
  end

  class Subscriptions < Resource
    public_class_method :create, :get, :list, :cancel, :charge
  end

  class Bank < Resource
    public_class_method :create, :get, :list
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

  class Daviplata < Resource
    public_class_method :create, :confirm
  end

end
