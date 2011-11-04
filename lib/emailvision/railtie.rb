require 'rails'

module Emailvision
	class Railtie < Rails::Railtie
		
		generators do
		  require 'generators/install'
		end		
	
	  config.to_prepare do
	    file = "#{Rails.root}/config/emailvision.yml"
	    
	    if File.exist?(file)
	      config = YAML.load_file(file)[Rails.env] || {}
	      
  	    Emailvision::Api.server_name  = config['server_name']
  	    Emailvision::Api.endpoint     = config['endpoint']
  	    Emailvision::Api.login        = config['login']
  	    Emailvision::Api.password     = config['password']
  	    Emailvision::Api.key          = config['key']	      
  	    Emailvision::Api.debug        = config['debug']  	    
  	    
  	    Emailvision::Notification.debug = config['debug']
	    end	    
	  end		
	
	end
end