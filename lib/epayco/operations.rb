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
          url = "/restpagos/pagos/debitos.json"
        elsif self.url == "safetypay"
          apify = true
          url = "/payment/process/safetypay"
        elsif self.url == "cash"
          cashdata = true
          if extra == "efecty"
            url = "/restpagos/v2/efectivo/efecty"
          elsif extra == "baloto"
            url = "/restpagos/v2/efectivo/baloto"
          elsif extra == "gana"
            url = "/restpagos/v2/efectivo/gana"
          elsif extra == "redservi"
            url = "/restpagos/v2/efectivo/redservi"
          elsif extra == "puntored"
            url = "/restpagos/v2/efectivo/puntored"
          else
            raise Error.new('109', Epayco.lang)
          end
        elsif self.url == "charge"
          url = "/payment/v1/charge/create"
        elsif self.url == "daviplata"
          url = "/payment/process/daviplata"
          apify = true
        end
        Epayco.request :post, url, extra, params, self.switch, cashdata, sp, dt, apify
      end

      # Action retrieve from id
      def get uid, params={}, extra=nil
        switch = self.switch;
        cashdata=false
        sp=false
        dt=false
        if self.url == "customers"
          url = "/payment/v1/customer/" + Epayco.apiKey + "/" + uid + "/"
        elsif self.url == "plan"
          url = "/recurring/v1/plan/" + Epayco.apiKey + "/" + uid + "/"
        elsif self.url == "subscriptions"
          url = "/recurring/v1/subscription/" + uid + "/" + Epayco.apiKey  + "/"
        elsif self.url == "bank"
          url = "/restpagos/pse/transactioninfomation.json?transactionID=" + uid + "&public_key=" + Epayco.apiKey
          switch = true
        elsif self.url == "cash" || self.url == "charge"
          url = "/restpagos/transaction/response.json?ref_payco=" + uid + "&public_key=" + Epayco.apiKey
          switch = true
        end
        Epayco.request :get, url, extra, params, switch, cashdata, sp, dt
      end

      # Action update
      def update uid, params={}, extra=nil
        cashdata=false
        sp=false
        dt=false
        if self.url == "customers"
          url = "/payment/v1/customer/edit/" + Epayco.apiKey + "/" + uid + "/"
        end
        Epayco.request :post, url, extra, params, self.switch, cashdata, sp, dt
      end

          # Action update token
      def updatetoken params={}, extra=nil
        if self.url == "customers"
          url = "/payment/v1/customer/reasign/card/default"
          cashdata = false
          sp = false
          dt = true
        end
        Epayco.request :post, url, extra, params, self.switch, cashdata, sp, dt
      end

      def delatetetoken params={}, extra=nil
        if self.url == "customers"
          url = "/v1/remove/token"
          cashdata = false
          sp = false
          dt = true
        end
        Epayco.request :post, url, extra, params, self.switch, cashdata, sp, dt
      end
      
      def addtoken params={}, extra=nil
        if self.url == "customers"
          url = "/v1/customer/add/token"
          cashdata = false
          sp = false
          dt = true
        end
        Epayco.request :post, url, extra, params, self.switch, cashdata, sp, dt
      end

      # Action retrieve all documents from user
      def list params={}, extra=nil
        cashdata=false
        sp=false
        dt=false
        if self.url == "customers"
          url = "/payment/v1/customers/" + Epayco.apiKey + "/"
        elsif self.url == "plan"
          url = "/recurring/v1/plans/" + Epayco.apiKey + "/"
        elsif self.url == "subscriptions"
          url = "/recurring/v1/subscriptions/" + Epayco.apiKey
        elsif self.url == "bank"
          url = "/restpagos/pse/bancos.json?public_key=" + Epayco.apiKey
        end
        Epayco.request :get, url, extra, params, self.switch, cashdata, sp, dt
      end

      # Remove data from api
      def delete uid, params={}, extra=nil
        cashdata=false
        sp=false
        dt=false
        if self.url == "plan"
          url = "/recurring/v1/plan/remove/" + Epayco.apiKey + "/" + uid
        end
        Epayco.request :post, url, extra, params, self.switch, cashdata, sp, dt
      end

      # Cance subscription
      def cancel uid, params={}, extra=nil
        cashdata=false
        sp=false
        dt=false
        params["id"] = uid
        params["public_key"] = Epayco.apiKey
        if self.url == "subscriptions"
          url = "/recurring/v1/subscription/cancel"
        end
        Epayco.request :post, url, extra, params, self.switch, cashdata, sp, dt
      end

      def charge params={}, extra=nil
        cashdata=false
        sp=false
        dt=false
        if self.url == "subscriptions"
          url = "/payment/v1/charge/subscription/create"
        end
        Epayco.request :post, url, extra, params, self.switch, cashdata, sp, dt
      end

      def confirm params={}
        cashdata=false
        sp=false
        dt=false
        apify=true
        if self.url == "daviplata"
          url = "/payment/confirm/daviplata"
        end
        Epayco.request :post, url, nil, params, self.switch, cashdata, sp, , apify

      end


    end

    # Export methods
    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
