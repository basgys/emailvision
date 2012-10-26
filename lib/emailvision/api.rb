module Emailvision
  class Api    
    include HTTParty
    default_timeout 30
    format :xml
    headers 'Content-Type' => 'text/xml'
    
    # HTTP verbs allowed to trigger a call-chain
    HTTP_VERBS = [:get, :post].freeze  

    # Attributes
    class << self
      attr_accessor :token, :server_name, :endpoint, :login, :password, :key, :debug
    end
    attr_accessor :token, :server_name, :endpoint, :login, :password, :key, :debug

    def initialize(params = {})      
      yield(self) if block_given?      
      
      self.server_name ||= params[:server_name]  || self.class.server_name
      self.endpoint    ||= params[:endpoint]     || self.class.endpoint
      self.login       ||= params[:login]        || self.class.login
      self.password    ||= params[:password]     || self.class.password
      self.key         ||= params[:key]          || self.class.key
      self.token       ||= params[:token]        || self.class.token
      self.debug       ||= params[:debug]        || self.class.debug      
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
      if connected?
        get.connect.close.call
      else
        return false
      end
    rescue Emailvision::Exception => e
    ensure
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

    # Perform the API call
    # http_verb = (get, post, ...)
    # method = Method to call
    # parameters = Parameters to send (optionnal)
    def call(http_verb, method, parameters = {})
      params ||= {}      

      # == Check presence of these essential attributes ==
      unless server_name and endpoint
        raise Emailvision::Exception.new "Cannot make an API call without a server name and an endpoint !"
      end

      # == Sanitize parameters ==
      parameters = Emailvision::Tools.sanitize_parameters(parameters)

      retries = 2
      begin
        # == Build uri ==
        uri = base_uri + method
        if parameters[:uri]
          uri += token ? "/#{token}/" : '/'
          uri += (parameters[:uri].respond_to?(:join) ? parameters[:uri] : [parameters[:uri]]).compact.join '/'
          parameters.delete :uri
        elsif parameters[:body]
          uri += token ? "/#{token}/" : '/'
        else
          parameters[:token] = token
        end
        
        # == Build body ==
        # 1. Extract body from parameters
        body = parameters[:body] || {}
        parameters.delete :body
        # 2. Camelize all keys
        body = Emailvision::Tools.r_camelize body
        # 3. Convert to xml
        body_xml = Emailvision::Tools.to_xml_as_is body
      
        # == Send request ==      
        logger.send "#{uri} with query : #{parameters} and body : #{body}"
        response = self.class.send http_verb, uri, :query => parameters, :body => body_xml, :timeout => 30      
      
        # == Parse response ==
        http_code = response.header.code
        content = {}
        begin
          content = Crack::XML.parse response.body
        rescue MultiXml::ParseError => e
          logger.send "#{uri} Error when parsing response body (#{e.to_s})"
        end
        logger.receive content.inspect

        # Return response or raise an exception if request failed
        if (http_code == "200") and (content and content["response"])
          response = content["response"]["result"] || content["response"] 
        else        
          raise Emailvision::Exception.new "#{http_code} - #{content}"
        end

      return response

      rescue Emailvision::Exception => e
        if e.message =~ /Your session has expired/
          self.close_connection          
          self.open_connection
          if((retries -= 1) >= 0)
            retry
          else
            raise e
          end
        else
          raise e          
        end
      rescue Errno::ECONNRESET => e
        if((retries -= 1) >= 0)
          retry
        else
          raise e
        end
      rescue Timeout::Error => e
        if((retries -= 1) >= 0)
          retry
        else
          raise e
        end
      end
    end    

		# Set token
    # Override
    def token=(value)
      @token = value
    end
    
    # Set endpoint
    # Override
    def endpoint=(value)
	    invalidate_token!	    
	  	@endpoint = value	  	
	  end

    # Base uri
    def base_uri
      "http://#{server_name}/#{endpoint}/services/rest/"
    end
    
    # Generate call-chain triggers
    HTTP_VERBS.each do |http_verb|
      define_method(http_verb) do
        Emailvision::Relation.new(self, http_verb)
      end
    end    
    
	  private
	
	  def logger      
	    if @logger.nil?
	      @logger = Emailvision::Logger.new(STDOUT)
	      @logger.level = (debug ? Logger::DEBUG : Logger::WARN)
	    end
	    @logger
	  end    
    
  end    
end