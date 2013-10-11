module Emailvision
  class Api
    include HTTParty
    default_timeout 30
    format :xml
    headers 'Content-Type' => 'text/xml'
    
    # HTTP verbs allowed to trigger a call-chain
    HTTP_VERBS = [:get, :post].freeze
    ATTRIBUTES = [:token, :server_name, :endpoint, :login, :password, :key, :debug].freeze

    # Attributes
    class << self
      attr_accessor *ATTRIBUTES
    end
    attr_accessor *ATTRIBUTES

    def initialize(params = {})
      yield(self) if block_given?
      assign_attributes(params)
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
        uri = prepare_uri(method, parameters)
        body = prepare_body(parameters)

        logger.send "#{uri} with query : #{parameters} and body : #{body}"

        response = perform_request(http_verb, uri, parameters, body)

        extract_response(response)
      rescue Emailvision::Exception => e
        if e.message =~ /Your session has expired/ or e.message =~ /The maximum number of connection allowed per session has been reached/
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
      rescue Errno::ECONNRESET, Timeout::Error => e
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
      close_connection
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

      def prepare_uri(method, parameters)
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
        uri
      end

      def prepare_body(parameters)
        body = parameters[:body] || {}
        parameters.delete :body
        # 2. Camelize all keys
        body = Emailvision::Tools.r_camelize body
        # 3. Convert to xml
        Emailvision::Tools.to_xml_as_is body        
      end

      def perform_request(http_verb, uri, parameters, body)
        self.class.send http_verb, uri, :query => parameters, :body => body, :timeout => 30      
      end

      def extract_response(response)
        http_code = response.header.code
        content = {}
        begin
          content = Crack::XML.parse response.body
        rescue MultiXml::ParseError => e
          logger.send "#{uri} Error when parsing response body (#{e.to_s})"
        end
        logger.receive content.inspect

        if (http_code == "200") and (content and content["response"])
          response = content["response"]["result"] || content["response"] 
        else        
          raise Emailvision::Exception.new "#{http_code} - #{content}"
        end
      end

      def format_response()
      end

      def assign_attributes(parameters)
        parameters or return
        ATTRIBUTES.each do |attribute|
          public_send("#{attribute}=", (parameters[attribute] || self.class.public_send(attribute)))
        end
      end
    
      def logger
        if @logger.nil?
          @logger = Emailvision::Logger.new(STDOUT)
          @logger.level = (debug ? Logger::DEBUG : Logger::WARN)
        end
        @logger
      end
    
  end
end