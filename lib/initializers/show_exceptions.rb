require 'erb'

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
    path = File.dirname(__FILE__)
    path += '/../templates/rescue.html.erb'
    template = File.read(path)
    errors = ERB.new(template).result(binding)

    ['500', { 'Content-type' => 'text/html' } , [errors]]
  end

  def get_backtrace(e)
    e.backtrace
  end

  def read_error(e)
    e.message
  end

  def show_source(e)
    top_error = e.backtrace.first
    file = top_error.split(':')[0]

    File.readlines(file)
  end
end
