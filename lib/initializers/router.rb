require_relative './route'

Module CrosstieInit
  class Router
    attr_reader :routes

    def initialize
      @routes = []
    end

    # simply adds a new route to the list of routes
    def add_route(pattern, method, controller_class, action_name)
      route = Route.new(pattern, method, controller_class, action_name)
      @routes.push(route)
    end

    # evaluate the proc in the context of the instance
    # for syntactic sugar :)
    def draw(&proc)
      instance_eval(&proc)
    end

    # make each of these methods that
    # when called add route
    [:get, :post, :put, :delete].each do |http_method|
      define_method(http_method) do |pattern, controller, action|
        add_route(pattern, http_method, controller, action)
      end
    end

    # should return the route that matches this request
    def match(req)
      matching_route = nil

      @routes.each do |route|
        matching_route = route if route.matches?(req)
      end

      matching_route
    end

    # either throw 404 or call run on a matched route
    def run(req, res)
      route = match(req)
      if route.nil?
        res.status = 404
        res.body = ["No route matched"]
      else
        route.run(req, res)
      end
    end
  end
end
