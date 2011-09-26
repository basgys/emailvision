require 'crack/xml'
require 'httparty'

# Emailvision API wrapper
# 
# More infos @ http://emvapi.emv3.com/apiccmd/services/rest?_wadl&_type=xml
#
# Call example :
# resource path="url/createUnsubscribeUrl/" --> url.create_unsubscribe_url.call :params => value1
#
module Emailvision
  autoload :Api, 'emailvision/api'
  autoload :Exception, 'emailvision/exception'
  autoload :Logger, 'emailvision/logger'
  autoload :Relation, 'emailvision/relation'
end