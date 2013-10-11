module Emailvision
  class Logger < ::Logger

    attr_accessor :debug

    def initializer(*args)
      debug = false
      super args
    end

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