module Emailvision
  
  # API default exception
  #
  class Exception < ::StandardError

    attr_accessor :http_status, :error

    # Initialize
    #
    # @param [Integer] HTTP status code
    # @param [String] Error message
    # 
    def initializer(http_status, error)
      self.http_status = http_status
      self.error = error

      super("EMV API returns #{http_status} status code")
    end

  end
end