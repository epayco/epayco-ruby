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
  "card[number]" => "4575623182290326",
  "card[exp_year]" => "2017",
  "card[exp_month]" => "07",
  "card[cvc]" => "123"
}

begin
  token = Epayco::Token.create credit_info
  assert(token)
rescue Epayco::Error => e
  puts e
end
```
