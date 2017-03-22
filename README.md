Epayco
=====

Ruby wrapper for Epayco API

## Description

API to interact with Epayco
https://epayco.co/docs/api/

## Installation

As usual, you can install it using rubygems.

```
$ gem install epayco-ruby
```

## Usage

```
require 'epayco-ruby'

Epayco.apiKey = '491d6a0b6e992.......'
Epayco.privateKey = '268c8e0162990cf.......'
Epayco.lang = 'ES'
Epayco.test = true
```

### Create Token

```
credit_info = {
  "card[number]": "4575623182290326",
  "card[exp_year]": "2017",
  "card[exp_month]": "07",
  "card[cvc]": "123"
}

begin
  token = Epayco::Token.create credit_info
  assert(token)
rescue Epayco::Error => e
  puts e
end
```

### Customers

#### Create

```
customer_info = {
  token_card: "eXj5Wdqgj7xzvC7AR",
  name: "Joe Doe",
  email: "joe@payco.co",
  phone: "3005234321",
  default: true
}

begin
  customer = Epayco::Customers.create customer_info
  assert(customer)
rescue Epayco::Error => e
  puts e
end
```

#### Retrieve

```
begin
  customer = Epayco::Customers.get "id_customer"
  assert(customer)
rescue Epayco::Error => e
  puts e
end
```

#### List

```
begin
  customer = Epayco::Customers.list
  assert(customer)
rescue Epayco::Error => e
  puts e
end
```

#### Update

```
update_customer_info = {
  name: "Alex"
}

begin
  customer = Epayco::Customers.update "id_customer", update_customer_info
  assert(customer)
rescue Epayco::Error => e
  puts e
end
```

### Plans

#### Create

```
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
  assert(plan)
rescue Epayco::Error => e
  puts e
end
```

#### Retrieve

```
begin
  plan = Epayco::Plan.get "coursereact"
  assert(plan)
rescue Epayco::Error => e
  puts e
end
```

#### List

```
begin
  plan = Epayco::Plan.list
  assert(plan)
rescue Epayco::Error => e
  puts e
end
```

#### Remove

```
begin
  plan = Epayco::Plan.delete "coursereact"
  assert(plan)
rescue Epayco::Error => e
  puts e
end
```
