Epayco
=====

Ruby wrapper for Epayco API

## Description

API to interact with Epayco
https://epayco.co/docs/api/

## Installation

As usual, you can install it using rubygems.

```
$ gem install epayco-sdk-ruby

```

## Usage

```ruby
require 'epayco-sdk-ruby'

Epayco.apiKey = 'YOU_PUBLIC_API_KEY'
Epayco.privateKey = 'YOU_PRIVATE_API_KEY'
Epayco.lang = 'ES'
Epayco.test = true
```

### Create Token

```ruby
credit_info = {
  "card[number]" => "4575623182290326",
  "card[exp_year]" => "2017",
  "card[exp_month]" => "07",
  "card[cvc]" => "123"
}

begin
  token = Epayco::Token.create credit_info
rescue Epayco::Error => e
  puts e
end
```

### Customers

#### Create

```ruby
customer_info = {
  token_card: "eXj5Wdqgj7xzvC7AR",
  name: "Joe",
  last_name: "Doe", #This parameter is optional
  email: "joe@payco.co",
  phone: "3005234321",
  default: true
}

begin
  customer = Epayco::Customers.create customer_info
rescue Epayco::Error => e
  puts e
end
```

#### Retrieve

```ruby
begin
  customer = Epayco::Customers.get "id_customer"
rescue Epayco::Error => e
  puts e
end
```

#### List

```ruby
begin
  customer = Epayco::Customers.list
rescue Epayco::Error => e
  puts e
end
```

#### Update

```ruby
update_customer_info = {
  name: "Alex"
}

begin
  customer = Epayco::Customers.update "id_customer", update_customer_info
rescue Epayco::Error => e
  puts e
end
```

#### Delete Customers'token

```ruby
delete_customer_info = {
  franchise: "visa",
  mask: "457562******0326",
  customer_id: "id_customer"

}

begin
  customer = Epayco::Customers.delatetetoken delete_customer_info
rescue Epayco::Error => e
  puts e
end
```

#### Add new token default to card existed

```ruby
 customer_info = {
   customer_id: "id_client",
   token: "**********Q2ZLD9",
   franchise: "visa",
   mask: "457562******0326"
 }
 begin
   customer = Epayco::Customers.updatetoken customer_info
   puts customer
 rescue Epayco::Error => e
   puts e
 end
```


#### Add new token to customer existed

```ruby
 customer_info = {
   token_card: "sHBxXAzfGPGa3J9b6",
   customer_id: "id_client"
 }
 begin
   customer = Epayco::Customers.addtoken customer_info
   puts customer
 rescue Epayco::Error => e
   puts e
 end
```


### Plans

#### Create

```ruby
plan_info = {
  id_plan: "coursereact",
  name: "Course react js",
  description: "Course react and redux",
  amount: 30000,
  currency: "cop",
  interval: "month",
  interval_count: 1,
  trial_days: 30
}

begin
  plan = Epayco::Plan.create plan_info
rescue Epayco::Error => e
  puts e
end
```

#### Retrieve

```ruby
begin
  plan = Epayco::Plan.get "coursereact"
rescue Epayco::Error => e
  puts e
end
```

#### List

```ruby
begin
  plan = Epayco::Plan.list
rescue Epayco::Error => e
  puts e
end
```

#### Remove

```ruby
begin
  plan = Epayco::Plan.delete "coursereact"
rescue Epayco::Error => e
  puts e
end
```

### Subscriptions

#### Create

```ruby
subscription_info = {
  id_plan: "coursereact",
  customer: "A6ZGiJ6rgxK5RB2WT",
  token_card: "eXj5Wdqgj7xzvC7AR",
  doc_type: "CC",
  doc_number: "5234567",
  #Optional parameter: if these parameter it's not send, system get ePayco dashboard's url_confirmation
  url_confirmation: "https://tudominio.com/confirmacion.php",
  method_confirmation: "POST"
}

begin
  sub = Epayco::Subscriptions.create subscription_info
  assert(sub)
rescue Epayco::Error => e
  puts e
end
```

#### Retrieve

```ruby
begin
  sub = Epayco::Subscriptions.get "id_subscription"
rescue Epayco::Error => e
  puts e
end
```

#### List

```ruby
begin
  sub = Epayco::Subscriptions.list
rescue Epayco::Error => e
  puts e
end
```

#### Cancel

```ruby
begin
  sub = Epayco::Subscriptions.cancel "id_subscription"
rescue Epayco::Error => e
  puts e
end
```

#### Pay Subscription

```ruby
subscription_info = {
  id_plan: "coursereact",
  customer: "A6ZGiJ6rgxK5RB2WT",
  token_card: "eXj5Wdqgj7xzvC7AR",
  url_response: "https://tudominio.com/respuesta.php",
  url_confirmation: "https://tudominio.com/confirmacion.php",
  doc_type: "CC",
  doc_number: "5234567",
  id: "190.000.000.000"  #This is the client's IP, it is required
}

begin
  sub = Epayco::Subscriptions.charge subscription_info
rescue Epayco::Error => e
  puts e
end
```

### PSE

#### Create

```ruby
pse_info = {
  bank: "1022",
  invoice: "1472050778",
  description: "pay test",
  value: "10000",
  tax: "0",
  tax_base: "0",
  currency: "COP",
  type_person: "0",
  doc_type: "CC",
  doc_number: "10358519",
  name: "testing",
  last_name: "PAYCO",
  email: "no-responder@payco.co",
  country: "CO",
  cell_phone: "3010000001",
  id: "190.000.000.000",  #client's IP, it is required
  url_response: "https://tudominio.com/respuesta.php",
  url_confirmation: "https://tudominio.com/confirmacion.php",
  method_confirmation: "GET",
  #Extra params: These params are optional and can be used by the commerce
  extra1: "",
  extra2: "",
  extra3: "",
  extra4: "",
  extra5: "",
  extra6: "",
  extra7: ""
}

begin
  pse = Epayco::Bank.create pse_info
rescue Epayco::Error => e
  puts e
end
```

#### Retrieve

```ruby
begin
  pse = Epayco::Bank.get "transactionID"
rescue Epayco::Error => e
  puts e
end
```


### Split Payments

Previous requirements: https://docs.epayco.co/tools/split-payment

```ruby
pse_info = {
  #Other customary parameters...
  splitpayment:"true",
  split_app_id:"P_CUST_ID_CLIENTE APPLICATION",
  split_merchant_id:"P_CUST_ID_CLIENTE COMMERCE",
  split_type: "02",
  split_primary_receiver:"P_CUST_ID_CLIENTE APPLICATION",
  split_primary_receiver_fee: "10"
}
begin
  split_pse = Epayco::Bank.create pse_info
rescue Epayco::Error => e
  puts e
end
```

### Cash

#### Create

```ruby
cash_info = {
    invoice: "1472050778",
    description: "pay test",
    value: "20000",
    tax: "0",
    tax_base: "0",
    currency: "COP",
    type_person: "0",
    doc_type: "CC",
    doc_number: "10358519",
    name: "testing",
    last_name: "PAYCO",
    email: "test@mailinator.com",
    cell_phone: "3010000001",
    end_date: "2017-12-05",
    id: "190.000.000.000",  #This is the client's IP, it is required
    url_response: "https://tudominio.com/respuesta.php",
    url_confirmation: "https://tudominio.com/confirmacion.php",
    method_confirmation: "GET",
    #Extra params: These params are optional and can be used by the commerce
    extra1: "",
    extra2: "",
    extra3: "",
    extra4: "",
    extra5: "",
    extra6: "",
    extra7: ""
}

begin
  cash = Epayco::Cash.create cash_info, "efecty"
rescue Epayco::Error => e
  puts e
end

```
#### List

```ruby
 cash = Epayco::Cash.create cash_info, "efecty"
 cash = Epayco::Cash.create cash_info, "gana"
 cash = Epayco::Cash.create cash_info, "baloto"#//expiration date can not be longer than 30 days
 cash = Epayco::Cash.create cash_info, "redservi"#//expiration date can not be longer than 30 days
 cash = Epayco::Cash.create cash_info, "puntored"#//expiration date can not be longer than 30 days
```


#### Retrieve

```ruby
begin
  cash = Epayco::Cash.get "transactionID"
rescue Epayco::Error => e
  puts e
end
```

### Split Payments

Previous requirements: https://docs.epayco.co/tools/split-payment

```ruby
cash_info = {
  #Other customary parameters...
  splitpayment:"true",
  split_app_id:"P_CUST_ID_CLIENTE APPLICATION",
  split_merchant_id:"P_CUST_ID_CLIENTE COMMERCE",
  split_type: "02",
  split_primary_receiver:"P_CUST_ID_CLIENTE APPLICATION",
  split_primary_receiver_fee: "10"
}
begin
  split_cash = Epayco::Cash.create cash_info, "efecty"
rescue Epayco::Error => e
  puts e
end
```


### Payment

#### Create

```ruby
payment_info = {
  token_card: "eXj5Wdqgj7xzvC7AR",
  customer_id: "A6ZGiJ6rgxK5RB2WT",
  doc_type: "CC",
  doc_number: "1035851980",
  name: "John",
  last_name: "Doe",
  email: "example@email.com",
  bill: "OR-1234",
  description: "Test Payment",
  value: "116000",
  tax: "16000",
  tax_base: "100000",
  id: "190.000.000.000",  #This is the client's IP, it is required
  url_response: "https://tudominio.com/respuesta.php",
  url_confirmation: "https://tudominio.com/confirmacion.php",
  use_default_card_customer: true, # if the user wants to be charged with the card that the customer currently has as default = true
  currency: "COP",
  dues: "12",
  #Extra params: These params are optional and can be used by the commerce
  extra1: "",
  extra2: "",
  extra3: "",
  extra4: "",
  extra5: "",
  extra6: "",
  extra7: ""
}

begin
  pay = Epayco::Charge.create payment_info
rescue Epayco::Error => e
  puts e
end
```

#### Retrieve

```ruby
begin
  pay = Epayco::Charge.get "transactionID"
rescue Epayco::Error => e
  puts e
end
```
### Split Payments

Previous requirements: https://docs.epayco.co/tools/split-payment

```ruby
payment_info = {
  #Other customary parameters...
  splitpayment:"true",
  split_app_id:"P_CUST_ID_CLIENTE APPLICATION",
  split_merchant_id:"P_CUST_ID_CLIENTE COMMERCE",
  split_type: "02",
  split_primary_receiver:"P_CUST_ID_CLIENTE APPLICATION",
  split_primary_receiver_fee: "10"
}
begin
  split_payment_info = Epayco::Charge.create payment_info
rescue Epayco::Error => e
  puts e
end
```


