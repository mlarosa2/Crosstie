require 'rack'
require_relative '../lib/initializers/show_exceptions'
require_relative '../lib/initializers/static'
require_relative '../lib/initializers/router'

require_relative '../lib/controller_base'

#require_relative necessary controllers here
require_relative './controllers/dogs_controller'

router = CrosstieInit::Router.new
router.draw do
#Create Routes Here
#Crosstie currently supports: :create, :index, and :new actions
#Dogs Controller Routes
get Regexp.new("^/dogs$"), DogsController, :index
get Regexp.new("^/dogs/new$"), DogsController, :new
post Regexp.new("^/dogs$"), DogsController, :create

end

app = Rack::Builder.app do
  use Static
  use CrosstieInit::ShowExceptions
  run lambda { |env|
    req = Rack::Request.new(env)
    res = Rack::Response.new
    router.run(req, res)
    res.finish
  }
end

Rack::Server.start(
  app: app,
  Port: 3000
)
