require 'rails/generators'

module Emailvision
  module Generators
    class Install < Rails::Generators::Base
      
      source_root File.expand_path('../templates', __FILE__)

      def generate_config        
        copy_file "emailvision.yml", "config/emailvision.yml" unless File.exist?("config/emailvision.yml")
      end

    end    
  end
end