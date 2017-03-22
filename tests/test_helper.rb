
module Epayco
  @mock_rest_client = nil

  def self.mock_rest_client=(mock_client)
    @mock_rest_client = mock_client
  end
end

def credit_info
  {
    "card[number]" => "4575623182290326",
    "card[exp_year]" => "2017",
    "card[exp_month]" => "07",
    "card[cvc]" => "123"
  }
end

def customer_info
  {
    token_card: "eXj5Wdqgj7xzvC7AR",
    name: "Joe Doe",
    email: "joe@payco.co",
    phone: "3005234321",
    default: true
  }
end

def update_customer_info
  {
    name: "Juan"
  }
end

def plan_info
  {
    id_plan: "coursereact",
    name: "Course react js",
    description: "Course react and redux",
    amount: 30000,
    currency: "cop",
    interval: "month",
    interval_count: 1,
    trial_days: 30
  }
end

def subscription_info
  {
    id_plan: "coursereact",
    customer: "A6ZGiJ6rgxK5RB2WT",
    token_card: "eXj5Wdqgj7xzvC7AR",
    doc_type: "CC",
    doc_number: "5234567"
  }
end

def pse_info
  {
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
end

def cash_info
  {
      invoice: "1472050778",
      description: "Pago pruebas",
      value: "20000",
      tax: "0",
      tax_base: "0",
      currency: "COP",
      type_person: "0",
      doc_type: "CC",
      doc_number: "10358519",
      name: "PRUEBAS",
      last_name: "PAYCO",
      email: "test@mailinator.com",
      cell_phone: "3010000001",
      end_date: "2017-12-05",
      ip: "186.116.10.133",
      url_response: "https:/secure.payco.co/restpagos/testRest/endpagopse.php",
      url_confirmation: "https:/secure.payco.co/restpagos/testRest/endpagopse.php",
      method_confirmation: "GET",
  }
end

def payment_info
  {
    token_card: "eXj5Wdqgj7xzvC7AR",
    customer_id: "A6ZGiJ6rgxK5RB2WT",
    doc_type: "CC",
    doc_number: "1035851980",
    name: "John",
    last_name: "Doe",
    email: "example@email.com",
    ip: "192.198.2.114",
    bill: "OR-1234",
    description: "Test Payment",
    value: "116000",
    tax: "16000",
    tax_base: "100000",
    currency: "COP",
    dues: "12"
  }
end
