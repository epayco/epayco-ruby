require_relative 'operations'

module Epayco
  class Resource
    include Operations

    # def self.url id=nil
    #   resource_name = self.name.split('::').last.downcase
    #   id ? "/#{resource_name}/#{id}/" : "/#{resource_name}/"
    # end

    def self.apiKey
      puts self.apiKey
    end
  end

  class Token < Resource
    public_class_method :create
  end

  class Customers < Resource
    public_class_method :create, :get, :list
  end

end
