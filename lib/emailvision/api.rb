module Emailvision
  class Api    
    include HTTParty
    default_timeout 30
    format :plain
    
    # HTTP verbs allowed to trigger a call-chain
    HTTP_VERBS = [:get, :post].freeze  

    # Attributes
    class << self
      attr_accessor :token, :server_name, :endpoint, :login, :password, :key
    end
    attr_accessor :token, :server_name, :endpoint, :login, :password, :key

    def initialize(params = {})
      @default_params = {}
      
      yield(self) if block_given?      
      
      self.server_name ||= params[:server_name]  || self.class.server_name
      self.endpoint    ||= params[:endpoint]     || self.class.endpoint
      self.login       ||= params[:login]        || self.class.login
      self.password    ||= params[:password]     || self.class.password
      self.key         ||= params[:key]          || self.class.key
      self.token       ||= params[:token]        || self.class.token      
    end
    
    # Generate call-chain triggers
    HTTP_VERBS.each do |http_verb|
      define_method(http_verb) do
        Emailvision::Relation.new(self, http_verb)
      end
    end

    # Perform the API call
    # http_verb = (get, post, ...)
    # method = Method to call
    # params = Extra parameters (optionnal)
    def call(http_verb, method, params = {})
      params ||= {}      

      # Check presence of these essential attributes
      unless server_name and endpoint
        raise Emailvision::Exception.new "Cannot make an API call without a server name and an endpoint !"
      end

      # Build uri and parameters
      uri = base_uri + method
      params = @default_params.merge params
      
      # Send request
      logger.send "#{uri} with params : #{params}"
      raw_result = self.class.send http_verb, uri, :query => params
      
      # Parse response
      http_code = raw_result.header.code
      parsed_result = Crack::XML.parse raw_result.body
      logger.receive parsed_result.inspect

      # Return response or raise an exception if request failed
      if (http_code == "200") and (parsed_result and parsed_result["response"])
        parsed_result["response"]["result"] || parsed_result["response"]
      else        
        raise Emailvision::Exception.new "#{http_code} - #{parsed_result}"
      end
    end

    # Connection token
    def token=(value)
      @token = value
      @default_params = @default_params.merge({:token => token})
    end

    # Base uri
    def base_uri
      "https://#{server_name}/#{endpoint}/services/rest/"
    end

    # ----------------- BEGIN Pre-configured methods -----------------

    # Login to Emailvision API
    # Return :
    # - True if the connection has been established
    # - False if the connection cannot be established or has already been established
    def open_connection
      return false if connected?
      self.token = get.connect.open.call :login => @login, :password => @password, :key => @key
      connected?
    end

    # Logout from Emailvision API
    # Return :
    # - True if the connection has been destroyed
    # - False if the connection cannot be destroyed or has already been destroyed    
    def close_connection
      return false unless connected?
      get.connect.close.call if connected?
      invalidate_token!
      not connected?
    end

    # Check whether the connection has been established or not
    def connected?
      !token.nil?
    end
    
    def invalidate_token!
      self.token = nil
    end
    # ----------------- END Pre-configured methods -----------------
    
	  private
	
	  def logger      
	    if @logger.nil?
	      @logger = Emailvision::Logger.new(STDOUT)
	      @logger.level = Logger::WARN
	    end
	    @logger
	  end    
    
  end    
end