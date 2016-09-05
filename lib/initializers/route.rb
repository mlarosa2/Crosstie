module CrosstieInit
  class Route
    attr_reader :pattern, :http_method, :controller_class, :action_name

    def initialize(pattern, http_method, controller_class, action_name)
      @pattern = pattern
      @http_method = http_method
      @controller_class = controller_class
      @action_name = action_name
    end

    # checks if pattern matches path and method matches request method
    def matches?(req)
      @pattern =~ req.path && @http_method.to_s.upcase == req.request_method
    end

    # use pattern to pull out route params (save for later?)
    # instantiate controller and call controller action
    def run(req, res)
      route_params = {}
      match_data = @pattern.match(req.path)
      match_data.names.each do |name|
        route_params[name] = match_data[name]
      end
      req.params.merge(route_params)
      controller = @controller_class.new(req, res, req.params)
      controller.invoke_action(@action_name)
    end
  end
end
