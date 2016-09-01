#Crosstie

Crosstie is a micro-MVC framework written in Ruby. It features much of the same functionality
as found in Ruby on Rails, such as CSRF protection and static asset serving.

##Getting Started With Crosstie

1. Clone the Crosstie repository and cd into it.
2. Run bundle install
3. Start the server by running ruby bin/server.rb
4. You can view available routes in bin/server.rb or make your own!
5. To view the results of already created routes, checkout http://localhost:3000/dogs to view the dogs index, or check out http://localhost:3000/dogs/new to create a new dog!  
6. Follow along with the examples of features below to add your own Models, Views, and Controllers!

##Features

* Features are saved in lib/initializers

###Flash

The flash will store information for either one (flash.now) or two (flash) request/response cycles.
Flash information is stored in your controllers, by using flash(.now)[:errors], and flash(.now)[:notice].
Flash information is rendered in the views

Example of storing information in the Flash in a controller (see controllers/dogs_controller.rb for more):
```ruby
if @dog.save
  flash[:notice] = "Saved dog successfully"
  redirect_to "/dogs"
else
  flash.now[:errors] = @dog.errors
  render :new
end
```

Example of the Flash being rendered in a view (see views/dogs_controller/new.html.erb for more):
```
<% if flash[:errors] %>
  <% flash[:errors].each do |error| %>
    <%= error %>
  <% end %>
<% end %>
```

###Router

The router makes it all happen! Create your routes with router.draw inside of bin/server.rb

Example Routes:
```ruby
router.draw do
  get Regexp.new("^/dogs$"), DogsController, :index
  get Regexp.new("^/dogs/new$"), DogsController, :new
  post Regexp.new("^/dogs$"), DogsController, :create
end
```

###Sessions

Client information is stored in the session cookie. Sessions are set by calling
session['any_key'] = 'any_value' in your controller.

###Stack Traces

Errors are rendered in browser! No more ugly error pages!

###Static Assets

Static assets are served from the lib/public directory. .jpeg, .jpg, .png, .gif,
.zip, .txt, .css, .js, and .json file extensions are currently supported. Simply add
lib/public/name-of-file.* to the root url for the file to be served.

###CSRF Protection

Simply add the ControllerName.protect_from_forgery to the first line of your create method in the controller to protect your app from CSRF attacks. See this in action inside of bin/controllers/dogs_controller.rb
