Gem::Specification.new do |s|
  s.name        = 'emailvision'
  s.version     = '2.1.13'
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.summary     = "Emailvision"
  s.description = "REST API wrapper interacting with Emailvision"
  s.authors     = ["Bastien Gysler"]
  s.email       = 'basgys@gmail.com'
  s.files       = Dir["lib/**/*"]
  s.homepage    = 'http://github.com/basgys/emailvision'
  
  s.add_dependency("httparty", "~> 0.9.0")
  s.add_dependency("crack", "~> 0.3.0")
  s.add_dependency("builder", "~> 3.0.0")  
end