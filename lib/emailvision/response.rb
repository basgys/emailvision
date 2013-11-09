module Emailvision

  # Response object
  # 
  # This class aims to extract the response from Emailvision
  #
  class Response

    attr_reader :response, :logger

    def initialize(response, logger)
      @response = response
      @logger = logger
    end

    def extract
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

  end
end