Epayco Ruby
=====

Ruby wrapper for Epayco API

## Description

API to interact with Epayco
https://api.epayco.co/

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
  "card[cvc]" => "123",
  "hasCvv" => true #hasCvv: validar codigo de seguridad en la transacción
}

begin
  token = Epayco::Token.create credit_info
  puts token
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
  city: "Bogota",
  address: "Cr 4 # 55 36",
  default: true
}

begin
  customer = Epayco::Customers.create customer_info
  puts customer
rescue Epayco::Error => e
  puts e
end
```

#### Retrieve

```ruby
begin
  customer = Epayco::Customers.get "id_customer"
  puts customer
rescue Epayco::Error => e
  puts e
end
```

```ruby
begin
  customer = Epayco::Customers.getCustomer "email","joe@payco.co"
  puts customer
rescue Epayco::Error => e
  puts e
end
```

#### List

```ruby
get_customers_info = {
  page: "6",
  perPage: "10"
}
begin
  customer = Epayco::Customers.list get_customers_info
  puts customer
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
  puts customer
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
  puts customer
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
  id_plan: "coursereact2",
  name: "Course react js",
  description: "Course react and redux",
  amount: 30000,
  currency: "cop",
  interval: "month",
  interval_count: 1,
  trial_days: 30,
  ip: "127.0.0.1",
  iva: 5700,
  ico: 0,
  planLink: "https://github.com/epayco",
  greetMessage: "discounted react and redux course",
  linkExpirationDate:"2025-03-11",
  subscriptionLimit: 10, #Subscription limit between 0 and 10000
  imgUrl: "https://epayco.com/wp-content/uploads/2023/04/logo-blanco.svg",
  discountValue: 5000, #discount value
  discountPercentage:19, #discount percentage
  transactionalLimit: 2, #transactional Limit
  additionalChargePercentage:0, #Additional charge percentage limit
  firstPaymentAdditionalCost:45700  #Installation Cost
}

begin
  plan = Epayco::Plan.create plan_info
  puts plan
rescue Epayco::Error => e
  puts e
end
```

#### Retrieve

```ruby
begin
  plan = Epayco::Plan.get "coursereact"
  puts plan 
rescue Epayco::Error => e
  puts e
end
```

#### List

```ruby
begin
  plan = Epayco::Plan.list
  puts plan
rescue Epayco::Error => e
  puts e
end
```

#### Remove

```ruby
begin
  plan = Epayco::Plan.delete "coursereact"
  puts plan
rescue Epayco::Error => e
  puts e
end
```

#### Update

```ruby
plan_info = {
  #id_plan: "coursereact2",
  name: "Course react js",
  description: "Course react and redux",
  amount: 35700,
  currency: "cop",
  interval: "month",
  interval_count: 1,
  trial_days: 0,
  ip: "127.0.0.1",
  iva: 5700,
  ico: 0,
  #transactionalLimit: 2, #transactional Limit
  #additionalChargePercentage:0, #Additional charge percentage limit
  afterPayment:"message after paying"
}
begin
  plan = Epayco::Plan.update "coursereact2", plan_info
  puts plan
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
  puts sub
rescue Epayco::Error => e
  puts e
end
```

#### Retrieve

```ruby
begin
  sub = Epayco::Subscriptions.get "id_subscription"
  puts sub
rescue Epayco::Error => e
  puts e
end
```

#### List

```ruby
begin
  sub = Epayco::Subscriptions.list
  puts sub
rescue Epayco::Error => e
  puts e
end
```

#### Cancel

```ruby
begin
  sub = Epayco::Subscriptions.cancel "id_subscription"
  puts sub 
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
  ip: "190.000.000.000"  #This is the client's IP, it is required
}

begin
  sub = Epayco::Subscriptions.charge subscription_info
  puts sub
rescue Epayco::Error => e
  puts e
end
```

### PSE

#### Listar bancos
```ruby
begin
   Bank = Epayco::Bank.list
   puts Bank
  rescue Epayco::Error => e
   puts e
end
```

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
  city: "Bogota",
  cell_phone: "3010000001",
  ip: "190.000.000.000",  #client's IP, it is required
  url_response: "https://tudominio.com/respuesta.php",
  url_confirmation: "https://tudominio.com/confirmacion.php",
  metodoconfirmacion: "GET",
  #Los parámetros extras deben ser enviados tipo string, si se envía tipo array generara error.
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
  puts pse
rescue Epayco::Error => e
  puts e
end
```

#### Retrieve

```ruby
begin
  pse = Epayco::Bank.get "ticketId"
  puts pse
rescue Epayco::Error => e
  puts e
end
```


### Split Payments

Previous requirements: https://docs.epayco.co/tools/split-payment

### Split payment

```ruby
payment_info = {
  #Other customary parameters...
  splitpayment:"true",
  split_app_id:"P_CUST_ID_CLIENTE APPLICATION",
  split_merchant_id:"P_CUST_ID_CLIENTE COMMERCE",
  split_type: "02",
  split_primary_receiver:"P_CUST_ID_CLIENTE APPLICATION",
  split_primary_receiver_fee: "10",
  split_rule:"multiple", #si se envía este parámetro el campo split_receivers se vuelve obligatorio
  split_receivers: JSON.generate([
    {:id =>'P_CUST_ID_CLIENTE 1 RECEIVER', :total => '58000', :iva => '8000', :base_iva => '50000', :fee => '10'},
    {:id =>'P_CUST_ID_CLIENTE 2 RECEIVER', :total => '58000', :iva => '8000', :base_iva => '50000', :fee => '10'}
  ]) #Puede añadir la cantidad de receptores que desee
}
begin
  split_pse = Epayco::Bank.create pse_info
  puts split_pse
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
    country: "CO",
    city: "bogota",
    ip: "190.000.000.000",  #This is the client's IP, it is required
    url_response: "https://tudominio.com/respuesta.php",
    url_confirmation: "https://tudominio.com/confirmacion.php",
    metodoconfirmacion: "GET",
    #Los parámetros extras deben ser enviados tipo string, si se envía tipo array generara error.
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
  puts cash
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
  puts cash
rescue Epayco::Error => e
  puts e
end
```

### Split Payments

Previous requirements: https://docs.epayco.co/tools/split-payment


### Split payment

```ruby
payment_info = {
  #Other customary parameters...
  splitpayment:"true",
  split_app_id:"P_CUST_ID_CLIENTE APPLICATION",
  split_merchant_id:"P_CUST_ID_CLIENTE COMMERCE",
  split_type: "02",
  split_primary_receiver:"P_CUST_ID_CLIENTE APPLICATION",
  split_primary_receiver_fee: "10",
  split_rule:"multiple",#si se envía este parámetro el campo split_receivers se vuelve obligatorio
  split_receivers: JSON.generate([
    {:id =>'P_CUST_ID_CLIENTE 1 RECEIVER', :total => '58000', :iva => '8000', :base_iva => '50000', :fee => '10'},
    {:id =>'P_CUST_ID_CLIENTE 2 RECEIVER', :total => '58000', :iva => '8000', :base_iva => '50000', :fee => '10'}
  ]) #Puede añadir la cantidad de receptores que desee
}
begin
  split_cash = Epayco::Cash.create cash_info, "efecty"
  puts split_cash
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
  ip: "190.000.000.000",  #This is the client's IP, it is required
  country: "CO",
  city: "bogota",
  url_response: "https://tudominio.com/respuesta.php",
  url_confirmation: "https://tudominio.com/confirmacion.php",
  method_confirmation: "GET",
  use_default_card_customer: true, # if the user wants to be charged with the card that the customer currently has as default = true
  currency: "COP",
  dues: "12",
  #Los parámetros extras deben ser enviados tipo string, si se envía tipo array generara error.
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
  puts pay
rescue Epayco::Error => e
  puts e
end
```

#### Retrieve

```ruby
begin
  pay = Epayco::Charge.get "transactionID"
  puts pay
rescue Epayco::Error => e
  puts e
end
```
### Split Payments

Previous requirements: https://docs.epayco.co/tools/split-payment

### Split 1-1

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
  puts split_payment_info
rescue Epayco::Error => e
  puts e
end
```

### Split Multiple

```ruby
payment_info = {
  #Other customary parameters...
  splitpayment:"true",
  split_app_id:"P_CUST_ID_CLIENTE APPLICATION",
  split_merchant_id:"P_CUST_ID_CLIENTE COMMERCE",
  split_type: "02",
  split_primary_receiver:"P_CUST_ID_CLIENTE APPLICATION",
  split_primary_receiver_fee: "10",
  split_rule:"multiple", #si se envía este parámetro el campo split_receivers se vuelve obligatorio
  split_receivers: [
    {:id =>'P_CUST_ID_CLIENTE 1 RECEIVER', :total => '58000', :iva => '8000', :base_iva => '50000', :fee => '10'},
    {:id =>'P_CUST_ID_CLIENTE 2 RECEIVER', :total => '58000', :iva => '8000', :base_iva => '50000', :fee => '10'}
  ] #Puede añadir la cantidad de receptores que desee
}
begin
  split_payment_info = Epayco::Charge.create payment_info
  puts split_payment_info
rescue Epayco::Error => e
  puts e
end
```

### Daviplata

### Create
```ruby
payment_info = {
    doc_type: "CC",
    document: "1053814580414720",
    name: "Testing",
    last_name: "PAYCO",
    email: "exmaple@epayco.co",
    ind_country: "57",
    phone: "314853222200033",
    country: "CO",
    city: "bogota",
    address: "Calle de prueba",
    ip: "189.176.0.1",
    currency: "COP",
    description: "ejemplo de transaccion con daviplata",
    value: "100",
    tax: "0",
    ico: "0"
    tax_base: "0",
    method_confirmation: "GET",
    url_response: "https://tudominio.com/respuesta.php",
    url_confirmation: "https://tudominio.com/confirmacion.php",
    extra1: "",      
    extra2: "",
    extra3: "",
    extra4: "",
    extra5: "",  
    extra6: "",
    extra7: "",
    extra8: "",
    extra9: "",
    extra10: ""
}

begin
  daviplata = Epayco::Daviplata.create payment_info
  puts daviplata
rescue Epayco::Error => e
  puts e
end
```

### confirm transaccion

```ruby
confirm = {
    ref_payco: "45508846", # It is obtained from the create response
    id_session_token: "45081749", # It is obtained from the create response
    otp: "2580"
}
begin
  daviplata = Epayco::Daviplata.confirm confirm
  puts daviplata
rescue Epayco::Error => e
  puts e
end  
```

### Safetypay

### Create

```ruby 
payment_info = {
    cash: "1",
    end_date: "2021-08-05",
    doc_type: "CC",
    document: "123456789",
    name: "Jhon",
    last_name: "doe",
    email: "jhon.doe@yopmail.com",
    ind_country: "57",
    phone: "3003003434",
    country: "CO",
    invoice: "fac-01", # opcional
    city: "N/A",
    address: "N/A",
    ip: "192.168.100.100",
    currency: "COP",
    description: "Thu Jun 17 2021 11:37:01 GMT-0400 (hora de Venezuela)",
    value: 100000,
    tax: 0,
    ico: 0,
    tax_base: 0,
    url_confirmation: "https://tudominio.com/respuesta.php",
    url_response: "https://tudominio.com/respuesta.php",
    method_confirmation: "POST",
    extra1: "",      
    extra2: "",
    extra3: "",
    extra4: "",
    extra5: "",  
    extra6: "",
    extra7: "",
    extra8: "",
    extra9: "",
    extra10: ""
}
begin
  safetypay = Epayco::Safetypay.create payment_info
  puts safetypay
rescue Epayco::Error => e
  puts e
end  

```


