require File.expand_path("../lib/epayco", File.dirname(__FILE__))
require 'json'

Epayco.apiKey = '491d6a0b6e992cf924edd8d3d088aff1'
Epayco.privateKey = '268c8e0162990cf2ce97fa7ade2eff5a'
Epayco.lang = 'ES'
Epayco.test = true


# #TOKEN
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
#   puts e
# end

#CUSTOMER
#
# params = {
#   token_card: "NZdBoKPLaaNayfNNo",
#   name: "Joe Doe",
#   email: "joe@payco.co",
#   phone: "3005234321",
#   default: true
# }

# begin
#   customer = Epayco::Customers.create params
#   puts customer
# rescue Epayco::Error => e
#   puts e
# end

# begin
#   customer = Epayco::Customers.get "rsoBM9gmz8wL56kNg"
#   puts customer
# rescue Epayco::Error => e
#   puts "errors"
# end

# begin
#   customer = Epayco::Customers.list
#   puts customer
# rescue Epayco::Error => e
#   puts "errors"
# end

#PLANS

# params = {
#   id_plan: "coursereact",
#   name: "Course react js",
#   description: "Course react and redux",
#   amount: 30000,
#   currency: "cop",
#   interval: "month",
#   interval_count: 1,
#   trial_days: 30
# }
#
# begin
#   plan = Epayco::Plan.create params
#   puts plan
# rescue Epayco::Error => e
#   puts "errors"
# end

# begin
#   plan = Epayco::Plan.get "coursereact"
#   puts plan
# rescue Epayco::Error => e
#   puts "errors"
# end

# begin
#   plan = Epayco::Plan.list
#   puts plan
# rescue Epayco::Error => e
#   puts "errors"
# end

#subscription

# params = {
#   id_plan: "coursereact",
#   customer: "QPweRtnPuo8LNoPcW",
#   token_card: "NZdBoKPLaaNayfNNo"
# }
#
# begin
#   sub = Epayco::Subscriptions.create params
#   puts sub
# rescue Epayco::Error => e
#   puts "errors"
# end

# begin
#   sub = Epayco::Subscriptions.get "7ShcGjjco9wGCb4Su"
#   puts sub
# rescue Epayco::Error => e
#   puts "errors"
# end

# begin
#   sub = Epayco::Subscriptions.list
#   puts sub
# rescue Epayco::Error => e
#   puts "errors"
# end

#PSE

params = {
  bank: "1007",
  invoice: "1472050778",
  description: "Pago pruebas",
  value: "10000",
  tax: "0",
  tax_base: "0",
  currency: "COP",
  type_person: "0",
  doc_type: "CC",
  doc_number: "10358519",
  name: "PRUEBAS",
  last_name: "PAYCO",
  email: "no-responder@payco.co",
  country: "CO",
  cell_phone: "3010000001",
  ip: "186.116.10.133",
  url_response: "https:/secure.payco.co/restpagos/testRest/endpagopse.php",
  url_confirmation: "https:/secure.payco.co/restpagos/testRest/endpagopse.php",
  method_confirmation: "GET",
}

begin
  pse = Epayco::Bank.create params
  puts pse
rescue Epayco::Error => e
  puts e
end
