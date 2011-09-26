module Emailvision
  class Api    
    include HTTParty
    default_timeout 30
    format :plain

    attr_accessor :token
    
    HTTP_VERBS = [:get, :post]

    def initialize(login = nil, password = nil, key = nil, params = {})
      @login = login || EMV_LOGIN || ENV['EMV_LOGIN']
      @password = password || EMV_PASSWORD || ENV['EMV_PASSWORD']
      @key = key || EMV_KEY || ENV['EMV_KEY']

      @default_params = params
    end
    
    HTTP_VERBS.each do |http_verb|
      define_method(http_verb) do
        Emailvision::Relation.new(self, http_verb)
      end
    end

    # http_verb = (get, post, ...)
    # method = Method to call
    # params = Extra parameters (optionnal)
    def call(http_verb, method, params = {})
      params ||= {}

      # Build uri and parameters
      uri = endpoint + method
      params = @default_params.merge params
      
      # Send request
      raw_result = self.class.send http_verb, uri, :query => params      
      
      # Parse response
      http_code = raw_result.header.code
      parsed_result = Crack::XML.parse raw_result.body

      # Return response or raise an exception if request failed
      if (http_code == "200") and (parsed_result and parsed_result["response"])
        parsed_result["response"]["result"] || parsed_result["response"]
      else        
        raise Emailvision::Exception.new "#{http_code} - #{raw_result.body}"
      end
    end

    # Connection token
    def token=(value)
      @token = value
      @default_params = @default_params.merge({:token => token})
    end

    # Endpoint base uri
    def endpoint
      'https://emvapi.emv3.com/apiccmd/services/rest/'
    end

    # ----------------- BEGIN Pre-configured methods -----------------

    # Login to Emailvision API
    # Return :
    # - True if the connection has been established
    # - False if the connection cannot be established or has already been established
    def login
      return false if connected?
      self.token = get.connect.open.call :login => @login, :password => @password, :key => @key
      connected?
    end

    # Logout to Emailvision API
    # Return :
    # - True if the connection has been destroyed
    # - False if the connection cannot be destroyed or has already been destroyed    
    def logout
      return false unless connected?
      get.connect.close.call if connected?
      self.token = nil
      connected?
    end

    # Check whether the connection has been established or not
    def connected?
      !token.nil?
    end
    # ----------------- END Pre-configured methods -----------------
  end  
end