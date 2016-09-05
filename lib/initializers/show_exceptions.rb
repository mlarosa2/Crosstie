require 'erb'

module CrosstieInit
  class ShowExceptions
    attr_reader :app
    def initialize(app)
      @app = app
    end

    def call(env)
      begin
        app.call(env)
      rescue Exception => e
        render_exception(e)
      end
    end

    private

    def render_exception(e)
      res = []
      res << "500"
      res << {'Content-type' => 'text/html'}
      res << [e.message]
    end
  end
end
