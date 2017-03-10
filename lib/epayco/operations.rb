module Epayco
  module Operations
    module ClassMethods

      private

      def create params={}, api_key=nil
        name = self.name.split('::').last.downcase
        if name == "token"
          url = "/v1/tokens"
        elsif name == "customers"
          url = "/payment/v1/customer/create"
        end
        Epayco.request :post, url, api_key, params
      end

      def get uid, params={}, api_key=nil
        name = self.name.split('::').last.downcase
        if name == "customers"
          url = "/payment/v1/customer/" + uid + "/"
        end
        Epayco.request :get, url, api_key, params
      end

      def list params={}, api_key=nil
        name = self.name.split('::').last.downcase
        if name == "customers"
          url = "/payment/v1/customers/" + Epayco.apiKey + "/"
        end
        Epayco.request :get, url, api_key, params
      end

    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
