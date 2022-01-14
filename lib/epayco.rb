require 'rest-client'
require 'json'
require 'openssl'
require 'base64'
require 'open-uri'
require 'socket'
require_relative 'epayco/resources'

module Epayco

  # Set custom error
  class Error < StandardError
    include Enumerable
    attr_accessor :errors

    # Get code, lang and show custom error
    def initialize code, lang
      file = open("https://multimedia.epayco.co/message-api/errors.json").read
      data_hash = JSON.parse(file)
      error = "Error"
      if(data_hash[code.to_s])
        error = [data_hash[code.to_s][lang]]
      else
        error = [code, lang]
      end
      super error
      @errors = error
    end

    def each
      @errors.each { |e| yield *e }
    end
  end

  # Endpoints
  @api_base = 'https://api.secure.payco.co'
  @api_base_secure = 'https://secure.payco.co'
  @api_base_apify = "https://apify.epayco.co"

  # Init sdk parameters
  class << self
     attr_accessor :apiKey, :privateKey, :lang, :test
  end

  # Eject request and show response or error
  def self.request(method, url, extra=nil, params={}, headers={}, switch, cashdata, dt, apify)
    method = method.to_sym

    auth = authent(apiKey, privateKey, apify, lang)
    bearer_token = 'Bearer '+ (auth[:bearer_token] || auth[:token])

    if !apiKey || !privateKey || !lang
      raise Error.new('100', lang)
    end

    payload = JSON.generate(params) if method == :post || method == :patch
    params = nil unless method == :get

    # Switch secure or api or apify
    if apify 
      @tags = JSON.parse(payload)
      seted = {}
      file = File.read(File.dirname(__FILE__) + '/keylang_apify.json')
      data_hash = JSON.parse(file)
      @tags.each {
        |key, value|
        if data_hash[key]
          seted[data_hash[key]] = value
        else
          seted[key] = value
        end
      }
      payload = seted.to_json
      url = @api_base_apify + url
    elsif  switch
      if method == :post || method == :patch
        if cashdata
        enc = encrypt_aes(payload, true)
        payload = enc.to_json
        else
        enc = encrypt_aes(payload, false)
        payload = enc.to_json
        end
      end
      url = @api_base_secure + url
    else
      if method == :post || method == :patch
        rb_hash = JSON.parse(payload)
        if dt
          payload = rb_hash.to_json
        else
          rb_hash["test"] = test ? "TRUE" : "FALSE"
          rb_hash["ip"] = local_ip
          payload = rb_hash.to_json
        end
      end
      url = @api_base + url
    end

   
    headers = {
    :params => params,
    :content_type => 'application/json',
    :type => 'sdk-jwt',
    :lang => 'RUBY',
    :Authorization => bearer_token,
    }.merge(headers)

    options = {
    :headers => headers,
    :user => apiKey,
    :method => method,
    :url => url,
    :payload => payload
    }

    # Open library rest client
    begin
      #puts options
      #abort("Message goes here 1")
      response = execute_request(options)
      #puts response.body
      return {} if response.code == 204 and method == :delete
      JSON.parse(response.body, :symbolize_names => true)
    rescue RestClient::Exception => e
      handle_errors e
    end
  end

  private

  # Get response successful
  def self.execute_request(options)
    RestClient::Request.execute(options)
  end

  # Get response with errors
  def self.handle_errors exception
    body = JSON.parse exception.http_body
    raise Error.new(exception.to_s, body['errors'])
  end

  def self.local_ip
      orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true
      UDPSocket.open do |s|
        s.connect '64.233.187.99', 1
        s.addr.last
      end
      ensure
        Socket.do_not_reverse_lookup = orig
   end

  def self.encrypt_aes(data, cashdata)
   
    sandbox = Epayco.test ? "TRUE" : "FALSE"
    @tags = JSON.parse(data)
    @seted = {}
    if cashdata
      @tags.each {
        |key, value|
        @seted[lang_key(key)] = value
      }
      @seted["ip"] = local_ip
      @seted["enpruebas"] = encrypt(sandbox, Epayco.privateKey)
    else
    @tags.each {
      |key, value|
      @seted[lang_key(key)] = encrypt(value, Epayco.privateKey)
    }
    @seted["ip"] = encrypt(local_ip, Epayco.privateKey)
    @seted["enpruebas"] = encrypt(sandbox, Epayco.privateKey)
    end

    
    
    
    @seted["public_key"] = Epayco.apiKey
    @seted["i"] = Base64.encode64("0000000000000000")
    @seted["lenguaje"] = "ruby"
    @seted["p"] = ""
    return @seted
  end

  def self.encrypt(str, key)
    cipher = OpenSSL::Cipher.new('AES-128-CBC')
    cipher.encrypt
    iv = "0000000000000000"
    cipher.iv = iv
    cipher.key = key.byteslice(0, cipher.key_len)
    str = iv + str
    data = cipher.update(str) + cipher.final
    Base64.urlsafe_encode64(data)
  end

  # Traslate secure petitions
  def self.lang_key key
    file = File.read(File.dirname(__FILE__) + '/keylang.json')
    data_hash = JSON.parse(file)
    data_hash[key]
  end

  def self.authent(apiKey, privateKey, apify, lang)
    @parmas = {}
    @parmas["public_key"] = apiKey
    @parmas["private_key"] = privateKey
    
    headers = {
      # :params => @parmas,
      :Accept => 'application/json',
      :content_type => 'application/json',
      :type => 'sdk'
    }
    url = 'https://api.secure.payco.co/v1/auth/login'
    if(apify)
      headers[:Authorization] = "Basic" + Base64.strict_encode64(apiKey + ":" + privateKey)
      url = 'https://apify.epayco.co/login'
    end
    payload = @parmas.to_json
    options = {
      :headers => headers,
      :user => apiKey,
      :method => 'post',
      :url => url,
      :payload => if apify then nil else payload end
     }
    begin
      response = execute_request(options)
      return {} if response.code == 204 and method == :delete
      body = JSON.parse(response.body, :symbolize_names => true)
      return body if body[:bearer_token] || body[:token]
      raise Error.new("104", lang)
    rescue RestClient::Exception => e
      handle_errors e
    end

  end

end
