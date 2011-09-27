Emailvision Gem
===============

Emailvision is a REST API wrapper interacting with Emailvision. It :

* Has a very comfortable syntax (ruby style);
* Uses the "lazy loading" pattern;
* Support further changes on Emailvision API (dynamic call);
* Is well integrated with Rails but can be used by other frameworks like Sinatra

Configuration
-----------

### #1
If you use Rails, you can set your config in the config/emailvision.yml file:

<b>development:</b><br />
&nbsp;&nbsp;&nbsp;<b>server_name:</b> emv_server_name<br />
&nbsp;&nbsp;&nbsp;<b>login:</b> my_login<br />
&nbsp;&nbsp;&nbsp;<b>password:</b> my_password<br />
&nbsp;&nbsp;&nbsp;<b>key:</b> my_key<br />
<b>production:</b><br />
&nbsp;&nbsp;&nbsp;<b>server_name:</b> emv_server_name<br />
&nbsp;&nbsp;&nbsp;<b>login:</b> my_login<br />
&nbsp;&nbsp;&nbsp;<b>password:</b> my_password<br />
&nbsp;&nbsp;&nbsp;<b>key:</b> my_key<br />

### #2a
It can also be set when you initialize your object:

> emv = Emailvision::Api.new :login => "my_login", :password => "password", :key => "key", :endpoint => "endpoint"

### #2b
Or if you wanna get fancy, you can use this syntax:

> emv = Emailvision::Api.new do |o|<br />
> &nbsp;&nbsp;&nbsp;o.login = "my_login"<br />
> &nbsp;&nbsp;&nbsp;o.password = "password"<br />
> &nbsp;&nbsp;&nbsp;o.key = "key"<br />
> &nbsp;&nbsp;&nbsp;o.endpoint = "endpoint"<br />
> end<br />

### #3
Of course these parameters can be changed after initialization:<br />
> &nbsp;&nbsp;&nbsp;emv.endpoint = "endpoint"

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
 
\# Set an endpoint<br />
emv = Emailvision::Api.new :endpoint => "apitransactional"
 
Shortcuts
---------

 * <b>emv.open_connection</b> Login to the given endpoint
 * <b>emv.close_connection</b> Logout from the given endpoint
 * <b>emv.connected?</b> Check connection status

How to call a method
--------------------

In this section you will see how to "convert" a method definition.

XML schema definition of endpoints are available @ http://{server_name}/{endpoint}/services/rest?_wadl&_type=xml

### Example #1 (get last campaigns)

<b>XML Schema</b>

> &lt;resource path="campaign/last/"&gt;<br />
> &nbsp;&lt;method name="GET"&gt;<br />
> &nbsp;&nbsp;&nbsp;&lt;request&gt;<br />
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;param name="token" style="query" type="xs:string"/&gt;<br />
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;param name="limit" style="query" type="xs:int"/&gt;<br />
> &nbsp;&nbsp;&nbsp;&lt;/request&gt;<br />
> &nbsp;&nbsp;&nbsp;&lt;response&gt;<br />
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&lt;representation mediaType="application/xml"/&gt;<br />
> &nbsp;&nbsp;&nbsp;&lt;/response&gt;<br />
> &nbsp;&lt;/method&gt;<br />
> &lt;/resource&gt;<br />

<b>Summary</b>

 * Endpoint : apiccmd
 * Name : campaign/last
 * Method : GET
 * Parameters : token, limit

<b>Method calling syntax</b>

> emv = Emailvision::Api.new do | o | <br />
> &nbsp;&nbsp;&nbsp;o.endpoint = "apiccmd" <br />
> end <br />
> 
> emv.open_connection \# Should return true
> 
> emv.get.campaign.last(:limit => 5).call

<b>Explanation</b>

 * <b>get</b> is the HTTP verb to use
 * <b>campaign.last</b> is the method name
 * <b>(:limit => 5)</b> is the parameters. (token is automatically given)
 * <b>call</b> is the keyword to perform the API call