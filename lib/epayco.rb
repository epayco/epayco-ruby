require 'rest-client'
require 'json'
require 'openssl'
require 'base64'
require 'open-uri'
require 'socket'
require 'dotenv/load'
require_relative 'epayco/resources'

module Epayco

  # Set custom error
  class Error < StandardError
    include Enumerable
    attr_accessor :errors

    # Get code, lang and show custom error
    def initialize(code, lang)
      # Usar solo errores por defecto
      data_hash = {
        "100" => {"ES" => "[100] Error inicializando el sdk, compruebe que los parametros son correctos", "EN" => "[100] SDK initialization error, please check the parameters are correct"},
        "101" => {"ES" => "[101] Error de comunicación con el servicio", "EN" => "[101] Communication error with the service"},
        "102" => {"ES" => "[102] Error desconocido, verifique con soporte", "EN" => "[102] Unknown error, please verify with support"},
        "103" => {"ES" => "[103] La información suministrada es erronea, verifique con la documentación", "EN" => "[103] The information provided is incorrect, please check the documentation"},
        "104" => {"ES" => "[104] El servicio no se puede autenticar, verifique su llave pública o llave privada", "EN" => "[104] The service cannot authenticate, please verify your public key or private key"},
        "105" => {"ES" => "[105] No de puede obtener comunicación con el servicio", "EN" => "[105] Cannot establish communication with the service"},
        "106" => {"ES" => "[106] Llave pública o Llave privada inválida, compruebela", "EN" => "[106] Public key or Private key invalid, please check"},
        "107" => {"ES" => "[107] Método no válido, compruebe la petición", "EN" => "[107] Invalid method, please check the request"},
        "108" => {"ES" => "[108] Error al encriptar los datos, re intente la operación", "EN" => "[108] Error encrypting data, please retry the operation"},
        "109" => {"ES" => "[109] Método de pago en efectivo no válido, unicamnete soportados: efecty, baloto, gana, redservi, puntored, sured, apostar, susuerte", "EN" => "[109] Invalid cash payment method, only supported: efecty, baloto, gana, redservi, puntored, sured, apostar, susuerte"},
        
        "default" => {"ES" => "Error desconocido", "EN" => "Unknown error"}
      }
    
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

  @api_base = (ENV['BASE_URL_SDK'] && !ENV['BASE_URL_SDK'].empty?) ? ENV['BASE_URL_SDK'] : 'https://api.secure.payco.co'
  @api_base_secure = (ENV['BASE_URL_SECURE_SDK'] && !ENV['BASE_URL_SECURE_SDK'].empty?) ? ENV['BASE_URL_SECURE_SDK'] : 'https://secure.payco.co'
    @api_entorno = (ENV['BASE_URL_ENTORNO_SDK'] && !ENV['BASE_URL_ENTORNO_SDK'].empty?) ?  ENV['BASE_URL_ENTORNO_SDK'] : '/restpagos'
  @api_base_apify = (ENV['BASE_APIFY_SDK'] && !ENV['BASE_APIFY_SDK'].empty?) ? ENV['BASE_APIFY_SDK'] : 'https://apify.epayco.co'


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
    
    if method == :post && params && params.is_a?(Hash) && !params.key?("extras_epayco")
      params["extras_epayco"] = {extra5:"P45"}
    end
    payload = JSON.generate(params) if method == :post || method == :patch
    params = nil unless method == :get

    # Switch secure or api or apify
    if apify 
      if  method == :post
        begin
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
        rescue JSON::ParserError => e
          raise Error.new('103', lang)  # Error en formato de datos
        rescue Errno::ENOENT => e
          raise Error.new('101', lang)  # Error de comunicación
        end
      end
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
      url = @api_base_secure + @api_entorno + url
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
      response = execute_request(options)
      return {} if response.code == 204 and method == :delete
      JSON.parse(response.body, :symbolize_names => true)
    rescue RestClient::Exception => e
      #handle_errors e
      return e.response
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
    begin
      @tags = JSON.parse(data)
      @seted = {}
    rescue JSON::ParserError => e
      raise Error.new('103', Epayco.lang)  # Error en formato de datos
    end
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
        if lang_key(key) != "extras_epayco"
          @seted[lang_key(key)] = encrypt(value, Epayco.privateKey)
        else
          @seted[lang_key(key)] = {extra5:encrypt(value["extra5"], Epayco.privateKey)}
        end  
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
    begin
      cipher = OpenSSL::Cipher.new('AES-128-CBC')
      cipher.encrypt
      iv = "0000000000000000"
      cipher.iv = iv
      cipher.key = key.byteslice(0, cipher.key_len)
      str = iv + str
      data = cipher.update(str) + cipher.final
      Base64.urlsafe_encode64(data)
    rescue OpenSSL::CipherError => e
      raise Error.new('108', Epayco.lang)  # Error al encriptar los datos
    rescue ArgumentError => e
      raise Error.new('103', Epayco.lang)  # Error en parámetros de encriptación
    end
  end

  # Traslate secure petitions
  def self.lang_key key
    begin
      file = File.read(File.dirname(__FILE__) + '/keylang.json')
      data_hash = JSON.parse(file)
      data_hash[key]
    rescue Errno::ENOENT => e
      raise Error.new('101', Epayco.lang)  # Error de comunicación
    rescue JSON::ParserError => e
      raise Error.new('103', Epayco.lang)  # Error en formato de datos
    end
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

    url = @api_base+'/v1/auth/login'
    if(apify)
      headers[:Authorization] = "Basic " + Base64.strict_encode64(apiKey + ":" + privateKey)
      url = @api_base_apify+'/login'
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
      return e.response
      #handle_errors e
    end

  end

end
