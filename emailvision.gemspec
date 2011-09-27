Gem::Specification.new do |s|
  s.name        = 'emailvision'
  s.version     = '1.1.0'
  s.date        = '2011-09-26'
  s.summary     = "Emailvision"
  s.description = "REST API wrapper interacting with Emailvision"
  s.authors     = ["Bastien Gysler"]
  s.email       = 'basgys@gmail.com'
  s.files       = Dir["lib/**/*"]
  s.homepage    = 'http://github.com/basgys/emailvision'
  
  s.add_dependency("httparty", "~> 0.8.0")
  s.add_dependency("crack", "~> 0.3.0")
  # TODO : Dependencies for inflector and logger
  # TODO : convert rdoc to markdown
  # TODO : Update README
end