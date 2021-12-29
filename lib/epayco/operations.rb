module Epayco
  module Operations
    module ClassMethods

      private

      # Action create
      def create params={}, extra=nil
        dt=false
        apify = false
        cashdata = false
        if self.url == "token"
          url = "/v1/tokens"
        elsif self.url == "customers"
          url = "/payment/v1/customer/create"
        elsif self.url == "plan"
          url = "/recurring/v1/plan/create"
        elsif self.url == "subscriptions"
          url = "/recurring/v1/subscription/create"
        elsif self.url == "bank"
          url = "/pagos/debitos.json"
        elsif self.url == "safetypay"
          apify = true
          url = "/payment/process/safetypay"
        elsif self.url == "cash"
          cashdata = true
          if extra == "efecty"
            url = "/v2/efectivo/efecty"
            cashdata = true
          elsif extra == "baloto"
            url = "/v2/efectivo/baloto"
            cashdata = true
          elsif extra == "gana"
            url = "/v2/efectivo/gana"
            cashdata = true
          elsif extra == "redservi"
            url = "/v2/efectivo/redservi"
            cashdata = true
          elsif extra == "puntored"
            url = "/v2/efectivo/puntored"
            cashdata = true
          else
            raise Error.new('109', Epayco.lang)
          end
        elsif self.url == "charge"
          url = "/payment/v1/charge/create"
        elsif self.url == "daviplata"
          url = "/payment/process/daviplata"
          apify = true
        end
        Epayco.request :post, url, extra, params, self.switch, cashdata, dt, apify
      end

      # Action retrieve from id
      def get uid, params={}, extra=nil
        switch = self.switch;
        cashdata=false
        dt=false
        if self.url == "customers"
          url = "/payment/v1/customer/" + Epayco.apiKey + "/" + uid + "/"
        elsif self.url == "plan"
          url = "/recurring/v1/plan/" + Epayco.apiKey + "/" + uid + "/"
        elsif self.url == "subscriptions"
          url = "/recurring/v1/subscription/" + uid + "/" + Epayco.apiKey  + "/"
        elsif self.url == "bank"
          url = "/pse/transactioninfomation.json?transactionID=" + uid + "&public_key=" + Epayco.apiKey
          switch = true
        elsif self.url == "cash" || self.url == "charge"
          url = "/transaction/response.json?ref_payco=" + uid + "&public_key=" + Epayco.apiKey
          switch = true
        end
        Epayco.request :get, url, extra, params, switch, cashdata, dt, apify = false
      end

      # Action update
      def update uid, params={}, extra=nil
        cashdata=false
        dt=false
        if self.url == "customers"
          url = "/payment/v1/customer/edit/" + Epayco.apiKey + "/" + uid + "/"
        end
        Epayco.request :post, url, extra, params, self.switch, cashdata, dt, apify = false
      end

          # Action update token
      def updatetoken params={}, extra=nil
        if self.url == "customers"
          url = "/payment/v1/customer/reasign/card/default"
          cashdata = false
          dt = true
        end
        Epayco.request :post, url, extra, params, self.switch, cashdata, dt, apify = false
      end

      def delatetetoken params={}, extra=nil
        if self.url == "customers"
          url = "/v1/remove/token"
          cashdata = false
          dt = true
        end
        Epayco.request :post, url, extra, params, self.switch, cashdata, dt, apify = false
      end
      
      def addtoken params={}, extra=nil
        if self.url == "customers"
          url = "/v1/customer/add/token"
          cashdata = false
          dt = true
        end
        Epayco.request :post, url, extra, params, self.switch, cashdata, dt, apify = false
      end

      # Action retrieve all documents from user
      def list params={}, extra=nil
        cashdata=false
        dt=false
        if self.url == "customers"
          url = "/payment/v1/customers/" + Epayco.apiKey + "/"
        elsif self.url == "plan"
          url = "/recurring/v1/plans/" + Epayco.apiKey + "/"
        elsif self.url == "subscriptions"
          url = "/recurring/v1/subscriptions/" + Epayco.apiKey
        elsif self.url == "bank"
          url = "/pse/bancos.json?public_key=" + Epayco.apiKey
        end
        Epayco.request :get, url, extra, params, self.switch, cashdata, dt, apify = false
      end

      # Remove data from api
      def delete uid, params={}, extra=nil
        cashdata=false
        dt=false
        if self.url == "plan"
          url = "/recurring/v1/plan/remove/" + Epayco.apiKey + "/" + uid
        end
        Epayco.request :post, url, extra, params, self.switch, cashdata, dt, apify = false
      end

      # Cance subscription
      def cancel uid, params={}, extra=nil
        cashdata=false
        dt=false
        params["id"] = uid
        params["public_key"] = Epayco.apiKey
        if self.url == "subscriptions"
          url = "/recurring/v1/subscription/cancel"
        end
        Epayco.request :post, url, extra, params, self.switch, cashdata, dt, apify = false
      end

      def charge params={}, extra=nil
        cashdata=false
        dt=false
        if self.url == "subscriptions"
          url = "/payment/v1/charge/subscription/create"
        end
        Epayco.request :post, url, extra, params, self.switch, cashdata, dt, apify = false
      end

      def confirm params={}
        cashdata=false
        dt=false
        apify=true
        if self.url == "daviplata"
          url = "/payment/confirm/daviplata"
        end
        Epayco.request :post, url, nil, params, self.switch, cashdata, dt, apify

      end


    end

    # Export methods
    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
