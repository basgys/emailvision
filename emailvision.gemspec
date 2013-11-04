# encoding: utf-8
$:.push File.expand_path('../lib', __FILE__)
require 'emailvision/version'

Gem::Specification.new do |s|
  s.name        = 'emailvision'
  s.summary     = "Emailvision"
  s.description = "REST API wrapper interacting with Emailvision"    
  s.version     = Emailvision::Version
  s.date        = Time.now.strftime('%Y-%m-%d')

  s.files       = Dir["lib/**/*"]
  s.require_path = 'lib'

  s.authors     = ["Bastien Gysler"]
  s.email       = 'basgys@gmail.com'
  s.homepage    = 'http://github.com/basgys/emailvision'
  
  s.add_dependency("httparty", "~> 0.12.0")
  s.add_dependency("crack", "~> 0.4.0")
  s.add_dependency("builder", ">= 3.0")
  s.add_dependency("activesupport", ">= 3.0", "<= 4.0.1")
end