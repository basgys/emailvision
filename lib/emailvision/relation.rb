module Emailvision
  class Relation
    
    def initialize(instance, http_verb)
      @instance = instance
      @http_verb = http_verb
      @uri = []
      @options = {}
    end
    
    def call(*args)
      @options.merge! extract_args(args)
      @instance.call @http_verb, @uri.join('/'), @options
    end
  
    def method_missing(method, *args)
      @uri << method.to_s.camelize(:lower)
      @options.merge! extract_args(args)
      self            
    end    
    
    private
    
    def extract_args(args)
      (args[0] and args[0].kind_of? Hash) ? args[0] : {}
    end
  
  end
end