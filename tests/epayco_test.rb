require File.expand_path("../lib/epayco", File.dirname(__FILE__))
require 'json'

Epayco.apiKey = '491d6a0b6e992cf924edd8d3d088aff1'
Epayco.privateKey = '491d6a0b6e992cf924edd8d3d088aff1'

# params = {
#   "card[number]" => "4575623182290326",
#   "card[exp_year]" => "2017",
#   "card[exp_month]" => "07",
#   "card[cvc]" => "123"
# }
#
# begin
#   token = Epayco::Token.create params
#   puts token
# rescue Epayco::Error => e
#   puts "errors"
# end

# params = {
#   token_card: "NZdBoKPLaaNayfNNo",
#   name: "Joe Doe",
#   email: "joe@payco.co",
#   phone: "3005234321",
#   default: true
# }
#
# begin
#   customer = Epayco::Customers.create params
#   puts customer
# rescue Epayco::Error => e
#   puts "errors"
# end

# begin
#   customer = Epayco::Customers.get "QPweRtnPuo8LNoPcW"
#   puts customer
# rescue Epayco::Error => e
#   puts "errors"
# end

begin
  customer = Epayco::Customers.list
  puts customer
rescue Epayco::Error => e
  puts "errors"
end
