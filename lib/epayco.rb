require 'rest-client'
require 'json'
# require 'aes'
require 'openssl'
require 'base64'
require 'open-uri'
require_relative 'epayco/resources'

module Epayco

  class Error < StandardError
    include Enumerable
    attr_accessor :errors

    def initialize code, lang
      file = open("https://s3-us-west-2.amazonaws.com/epayco/message_api/errors.json").read
      data_hash = JSON.parse(file)
      super data_hash[code][lang]
      @errors = errors
    end

    def each
      @errors.each { |e| yield *e.first }
    end
  end

  @api_base = 'http://localhost:3000'
  @api_base_secure = 'https://secure.payco.co'

  class << self
     attr_accessor :apiKey, :privateKey, :lang, :test
  end

  def self.request(method, url, apiKey=nil, params={}, headers={}, switch)
    method = method.to_sym

    lang = Epayco.lang.upcase

    unless apiKey ||= @apiKey
      raise Error.new('100', lang)
    end

    unless privateKey ||= @privateKey
      raise Error.new('100', lang)
    end

    payload = JSON.generate(params) if method == :post || method == :patch
    params = nil unless method == :get

    if switch
      url = @api_base_secure + url
      enc = encrypt_aes(payload)
      payload = enc.to_json
    else
      url = @api_base + url
    end

    headers = {
      :params => params,
      :content_type => 'application/json',
      :type => 'sdk'
    }.merge(headers)

    options = {
      :headers => headers,
      :user => apiKey,
      :method => method,
      :url => url,
      :payload => payload
    }

    @iv = "0000000000000000";

    begin
      response = execute_request(options)
      return {} if response.code == 204 and method == :delete
      JSON.parse(response.body, :symbolize_names => true)
    rescue RestClient::Exception => e
      handle_errors e
    end
  end

  private

  def self.execute_request(options)
    RestClient::Request.execute(options)
  end

  def self.handle_errors exception
    body = JSON.parse exception.http_body
    raise Error.new(exception.to_s, body['errors'])
  end

  def self.encrypt_aes data
    sandbox = Epayco.test ? "TRUE" : "FALSE"
    @tags = JSON.parse(data)
    @seted = {}
    @tags.each {
      |key, value|
      @seted[lang_key(key)] = encrypt(value, Epayco.privateKey)
    }
    @seted["public_key"] = Epayco.apiKey
    @seted["i"] = Base64.encode64("0000000000000000")
    @seted["enpruebas"] = encrypt(sandbox, Epayco.privateKey)
    @seted["lenguaje"] = "ruby"
    @seted["p"] = ""
    return @seted
  end

  def self.enc_value value, key
    AES.encrypt(value, key, {:iv => key})
  end

  def self.encrypt(str, key)
    cipher = OpenSSL::Cipher.new('AES-128-CBC')
    cipher.encrypt
    # iv = OpenSSL::Random.random_bytes(cipher.iv_len)
    iv = "0000000000000000"
    cipher.iv = iv
    cipher.key = key
    str = iv + str
    data = cipher.update(str) + cipher.final
    Base64.urlsafe_encode64(data)
  end

  def self.lang_key key
    file = File.read('../utils/key_lang.json')
    data_hash = JSON.parse(file)
    data_hash[key]
  end

end
