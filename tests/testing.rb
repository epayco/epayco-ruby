require File.expand_path("../lib/epayco", File.dirname(__FILE__))
require File.expand_path("test_helper", File.dirname(__FILE__))

require "cutest"
require "mocha/api"
include Mocha::API

prepare do
  Epayco.apiKey = '491d6a0b6e992cf924edd8d3d088aff1'
  Epayco.privateKey = '268c8e0162990cf2ce97fa7ade2eff5a'
  Epayco.lang = 'ES'
  Epayco.test = true
end

setup do
  Epayco.mock_rest_client = mock
end

test "create token" do |mock|
  begin
    token = Epayco::Token.create credit_info
    assert(token)
  rescue Epayco::Error => e
    puts e
  end
end

# Customers

test "create customer" do |mock|
  begin
    customer = Epayco::Customers.create customer_info
    assert(customer)
  rescue Epayco::Error => e
    puts e
  end
end

test "retrieve customer" do |mock|
  begin
    customer = Epayco::Customers.get "123"
    assert(customer)
  rescue Epayco::Error => e
    puts e
  end
end

test "list customers" do |mock|
  begin
    customer = Epayco::Customers.list
    assert(customer)
  rescue Epayco::Error => e
    puts e
  end
end

test "update customer" do |mock|
  begin
    customer = Epayco::Customers.update "123", update_customer_info
    assert(customer)
  rescue Epayco::Error => e
    puts e
  end
end

# Plan

test "create plan" do |mock|
  begin
    plan = Epayco::Plan.create plan_info
    assert(plan)
  rescue Epayco::Error => e
    puts e
  end
end

test "retrieve plan" do |mock|
  begin
    plan = Epayco::Plan.get "coursereact"
    assert(plan)
  rescue Epayco::Error => e
    puts e
  end
end

test "list plan" do |mock|
  begin
    plan = Epayco::Plan.list
    assert(plan)
  rescue Epayco::Error => e
    puts e
  end
end

test "remove plan" do |mock|
  begin
    plan = Epayco::Plan.delete "coursereact"
    assert(plan)
  rescue Epayco::Error => e
    puts e
  end
end

# Subscriptions

test "create subscription" do |mock|
  begin
    sub = Epayco::Subscriptions.create subscription_info
    assert(sub)
  rescue Epayco::Error => e
    puts e
  end
end

test "charge subscription" do |mock|
  begin
    sub = Epayco::Subscriptions.charge subscription_info
    assert(sub)
  rescue Epayco::Error => e
    puts e
  end
end

test "retrieve subscriptions" do |mock|
  begin
    sub = Epayco::Subscriptions.get "123"
    assert(sub)
  rescue Epayco::Error => e
    puts e
  end
end

test "list subscriptions" do |mock|
  begin
    sub = Epayco::Subscriptions.list
    assert(sub)
  rescue Epayco::Error => e
    puts e
  end
end

test "cancel subscriptions" do |mock|
  begin
    sub = Epayco::Subscriptions.cancel "123"
    assert(sub)
  rescue Epayco::Error => e
    puts e
  end
end

# PSE

test "create pse" do |mock|
  begin
    pse = Epayco::Bank.create pse_info
    assert(pse)
  rescue Epayco::Error => e
    puts e
  end
end

test "retrieve pse" do |mock|
  begin
    pse = Epayco::Bank.get "123"
    assert(pse)
  rescue Epayco::Error => e
    puts e
  end
end

# Cash

test "create cash" do |mock|
  begin
    cash = Epayco::Cash.create cash_info, "efecty"
    assert(cash)
  rescue Epayco::Error => e
    puts e
  end
end

test "retrieve cash" do |mock|
  begin
    cash = Epayco::Cash.get "123"
    assert(cash)
  rescue Epayco::Error => e
    puts e
  end
end

# Payment

test "create payment" do |mock|
  begin
    pay = Epayco::Charge.create payment_info
    assert(pay)
  rescue Epayco::Error => e
    puts e
  end
end

test "retrieve payment" do |mock|
  begin
    pay = Epayco::Charge.get "123"
    assert(pay)
  rescue Epayco::Error => e
    puts e
  end
end
