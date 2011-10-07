module Emailvision  
  class Notification
    include HTTParty
    default_timeout 30
    format :xml
    headers 'Content-Type' => 'application/xml;charset=utf-8', 'encoding' => 'UTF-8', 'Accept' => '*/*'
    
    def send(body)      
      # == Processing body ==
      body_xml = Emailvision::Tools.to_xml_as_is body
      
      # == Send request ==
      logger.send "#{base_uri} with body : #{body_xml}"
      response = self.class.send :post, base_uri, :body => body_xml
      logger.receive "#{base_uri} with status : #{response.header.inspect}"
      
      # == Check result ==
      response.header.code == '200'      
    end    
    
    # Base uri
    def base_uri
      'http://api.notificationmessaging.com/NMSXML'
    end
    
	  private
	
	  def logger      
	    if @logger.nil?
	      @logger = Emailvision::Logger.new(STDOUT)
	      @logger.level = Logger::DEBUG
	    end
	    @logger
	  end    
     
  end    
end