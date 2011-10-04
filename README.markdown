Emailvision Gem
===============

Emailvision is a REST API wrapper interacting with Emailvision. It :

* Has a very comfortable syntax
* Will support method addition on Emailvision API (dynamic call)
* Has a clear documentation
* Is well integrated with Rails, but can be used alone though
* Is actively developed

Configuration
-------------

### Settable parameters
 * server_name
 * login
 * password
 * key
 * endpoint
 * token
 * debug (true/false)

### #1 (Rails configuration file)
If you use Rails, you can set your config in the config/emailvision.yml file

Generate the config file:

```
rails generate emailvision:install
```

### #2a (on loading)
It can also be set when you initialize your object:

```ruby
emv = Emailvision::Api.new :login => "my_login", :password => "password", :key => "key", :endpoint => "endpoint"
```

### #2b (on loading)
Or if you wanna get fancy, you can use this syntax:

```ruby
emv = Emailvision::Api.new do |o|
	o.login = "my_login"
	o.password = "password"
	o.key = "key"
	o.endpoint = "endpoint"
end
```

### #3 (afterward)
Of course these parameters can be changed after initialization:

```ruby
emv.endpoint = "endpoint"
```

### Notice
 * Parameters set in the config/emailvision.yml will be automaticaly added to your object.
   But if you want to override some of them, you just have to set them again at initialization or later.
 * Beware that if you change your endpoint, you will have to recall the open_connection method.


Endpoints
---------

Endpoints available :

 * <b>apiccmd</b> (segment, campaign, message, ...)
 * <b>apitransactional</b> (transactional message)
 * <b>apimember</b> (member list)

```ruby
# Set an endpoint
emv = Emailvision::Api.new :endpoint => "apitransactional"
```
 
Shortcuts
---------

```ruby
emv.open_connection # Login to the given endpoint
emv.close_connection # Logout from the given endpoint
emv.connected? # Check connection status
```

Method calling syntax
---------------------

```ruby
emv.get.campaign.last(:limit => 5).call
```

<b>Explanation</b>

 * <b>emv</b> instance of Emailvision::Api
 * <b>get</b> is the HTTP verb to use
 * <b>campaign.last</b> is the method name
 * <b>(:limit => 5)</b> is the parameter
 * <b>call</b> is the keyword to perform the API call
 
### Notice

 * You cannot change the following order : http verbe / method name / call
 * You can set your API call and perform it later (lazy loading),
   so you won't have to add your business logic in the view

Parameters
----------

Data can be sent through URI, Query parameters and body. Here is an example of each :

### URI

Method to call : member/getMemberByEmail/{token}/{email}

```ruby
emv.get.member.get_member_by_email(:uri =>{:email => "my@mail.com"}).call
```

### Query parameters

Method to call : member/getMemberById/

```ruby
emv.get.member.get_member_by_id(:id => 10).call
```

### Body

Method to call : member/updateMember/

```ruby
body = {
  :synchro_member=>{
    :dyn_content=>{
      :entry=>[
        {:key=>"FIRSTNAME", :value=>"Bastien"},
        {:key=>"LASTNAME", :value=>"Gysler"}
      ]
    }, 
    :email=>"my@mail.com"
  }
}

emv.post.member.update_member(:body => body).call
```

### Notice

You can also combine these ways to send data

```ruby
id => 10, :uri => {:email => "my@email.com"}, :body => {:foo => "bar"}
```
   
DEBUG   
-----

Debug mode show request sent/received in the console

It's also possible to monitor the traffic by using a proxy like this : 

```ruby
Emailvision::Api.http_proxy 'localhost', 8888
```

Then all requests will be redirected through the given proxy
   
TODO
----

 * Write some specs
 * Improves exception system
 * Improves logger (log file, ..)
 * Capacity to automatically renew token when it's no longer valid
 * Write some example in wiki pages
