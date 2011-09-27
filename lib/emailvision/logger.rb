module Emailvision
  class Logger < ::Logger
    
    # Log a message sent to emailvision
    def send(message)
      info("[Emailvision] Send -> #{message}")
    end
    
    # Log a message received from emailvision
    def receive(message)
      info("[Emailvision] Receive -> #{message}")
    end
    
  end
end