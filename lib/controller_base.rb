require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require 'byebug'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, params = {})
    @req = req
    @res = res
    @params = params
    @session = session
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    if already_built_response? && @already_built_response.status == @res.status && @already_built_response.header["location"] == @res.header["location"]
      raise "DOUBLE RENDER"
    end

    @res.header["location"] = url
    @res.status = 302
    @session.store_session(@res)
    @already_built_response = @res
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    if already_built_response? && @already_built_response.body  == @res.body && @already_built_response.header["Content-Type"] == @res.header["Content-Type"]
      raise "DOUBLE RENDER"
    end
    @res.header["Content-Type"] = content_type
    @res.body = [content]
    @session.store_session(@res)
    @already_built_response = @res
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    path_name = "views/"
    controller_name = self.class.to_s
    controller_name = controller_name.underscore
    path_name += controller_name
    path_name += "/" + template_name.to_s + ".html.erb"
    content = File.read(path_name)
    erb_content = ERB.new(content)
    binding
    render_content(erb_content.result(binding), 'text/html')
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    self.send(name)
    if @already_built_response.nil?
      render(name)
    end
  end
end
