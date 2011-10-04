require 'crack/xml'
require 'httparty'
require 'active_support/inflector'
require 'logger'

# Emailvision API wrapper
#
module Emailvision
  autoload :Api, 'emailvision/api'
  autoload :Exception, 'emailvision/exception'
  autoload :Logger, 'emailvision/logger'
  autoload :Relation, 'emailvision/relation'
  autoload :Tools, 'emailvision/tools'
  
  if defined?(Rails)
	  require 'emailvision/railtie'
	  require 'generators/install'
	end
end