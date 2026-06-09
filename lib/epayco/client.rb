module Epayco
  # Wrapper ergonómico orientado a instancia sobre la configuración a nivel de
  # módulo del SDK. Permite el estilo:
  #
  #   client = Epayco::Client.new(public_key: "...", private_key: "...")
  #   client.bank.list
  #   client.token.create(...)
  #
  # Nota: el SDK guarda la configuración en variables de módulo
  # (Epayco.apiKey, etc.), por lo que crear un Client REconfigura globalmente
  # el SDK. Está pensado para una sola cuenta por proceso, no es multi-tenant.
  class Client
    def initialize(public_key:, private_key:, lang: 'ES', test: false)
      Epayco.apiKey     = public_key
      Epayco.privateKey = private_key
      Epayco.lang       = lang
      Epayco.test       = test
    end

    # Cada accesor devuelve la clase de recurso correspondiente, de modo que
    # client.bank.list  ==  Epayco::Bank.list
    def token;         Epayco::Token;         end
    def customers;     Epayco::Customers;     end
    def plan;          Epayco::Plan;          end
    def subscriptions; Epayco::Subscriptions; end
    def bank;          Epayco::Bank;          end
    def cash;          Epayco::Cash;          end
    def charge;        Epayco::Charge;        end
    def safetypay;     Epayco::Safetypay;     end
    def daviplata;     Epayco::Daviplata;     end
  end
end
