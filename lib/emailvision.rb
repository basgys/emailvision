require 'crack/xml'
require 'httparty'
require 'active_support/inflector'
require 'logger'
require 'builder'

# Emailvision API wrapper
#
module Emailvision
  autoload :Api, 'emailvision/api'
  autoload :Exception, 'emailvision/exception'
  autoload :Logger, 'emailvision/logger'
  autoload :MalformedResponse, 'emailvision/malformed_response'
  autoload :Relation, 'emailvision/relation'
  autoload :Request, 'emailvision/request'
  autoload :RequestError, 'emailvision/request_error'
  autoload :Response, 'emailvision/response'
  autoload :SessionError, 'emailvision/session_error'
  autoload :Tools, 'emailvision/tools'
  autoload :Notification, 'emailvision/notification'
  autoload :Version, 'emailvision/version'  

  if defined?(Rails)
    require 'emailvision/railtie'
    require 'generators/install'
  end
end