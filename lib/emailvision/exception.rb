module Emailvision
  class Exception < ::Exception 
    
    attr_accessor :http_status, :error
    
    def initializer(http_status, error)
      self.http_status = http_status
      self.error = error
      
      super("EMV API returns #{http_status} status code")
    end
       
  end
end