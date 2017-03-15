module Epayco
  module Operations
    module ClassMethods

      private

      def create params={}, api_key=nil
        if self.url == "token"
          url = "/v1/tokens"
        elsif self.url == "customers"
          url = "/payment/v1/customer/create"
        elsif self.url == "plan"
          url = "/recurring/v1/plan/create"
        elsif self.url == "subscriptions"
          url = "/recurring/v1/subscription/create"
        elsif self.url == "bank"
          url = "/restpagos/pagos/debitos.json"
        end
        switch = self.url == "bank" ? true : false
        Epayco.request :post, url, api_key, params, switch
      end

      def get uid, params={}, api_key=nil
        if self.url == "customers"
          url = "/payment/v1/customer/" + Epayco.apiKey + "/" + uid + "/"
        elsif self.url == "plan"
          url = "/recurring/v1/plan/" + Epayco.apiKey + "/" + uid + "/"
        elsif self.url == "subscriptions"
          url = "/recurring/v1/subscription/" + uid + "/" + Epayco.apiKey  + "/"
        end
        switch = self.url == "bank" ? true : false
        Epayco.request :get, url, api_key, params, switch
      end

      def list params={}, api_key=nil
        if self.url == "customers"
          url = "/payment/v1/customers/" + Epayco.apiKey + "/"
        elsif self.url == "plan"
          url = "/recurring/v1/plans/" + Epayco.apiKey + "/"
        elsif self.url == "subscriptions"
          url = "/recurring/v1/subscriptions/" + Epayco.apiKey
        end
        Epayco.request :get, url, api_key, params
      end

      def remove
      end

      def cancel
      end

    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
