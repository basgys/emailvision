Changelog
=========

2.1.19
-----

### bug
 * Fix release 2.1.18

2.1.18
-----

### bug
 * Prevent errors on invalid date

### enhancement
 * Support Date strings

2.1.17
-----

### update
 * Update "builder" to 3.1.x

2.1.16
-----

### update
 * Update "crack" to 0.4.x

2.1.15
-----

### enhancement
 * Add support for different kind of date/time classes like ActiveSupport::TimeWithZone

2.1.7
-----

### bug fix
 * Remove time zone conversion for Time

2.1.6
-----

### bug fix
 * "undefined method map for…." error

2.1.5
-----

### enhancement
 * Catches parsing errors on response body
 * Sanitizes request parameters like Date or Time

2.1.4
-----

### bug fix
 * Adds builder to dependencies

2.1.3
-----

### bug fix
 * Decreases verbosity of Notification class

2.1.2
-----

### enhancement
 * Adds the notification messaging API

### bug fix
 * Fixes char escaping problem during xml conversion


2.1.1
-----

### bug fix
 * Token was not automatically given for requests with only a body

2.1.0
-----

### enhancement
 * Improves parameters flexibility (uri, body, query)

### bug fix

2.0.0
-----

### enhancements
 * Better integration with Rails
 * Can uses multiple endpoints
 * Can be used outside of Rails
 * A cleaner initializer
 * A changelog file !
 
### /!\ breaks backward compatibility /!\ 
	
1.1.0
-----

### bug fix