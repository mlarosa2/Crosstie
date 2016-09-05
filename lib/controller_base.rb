require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require 'SecureRandom'
require 'json'
require_relative './initializers/session'
require_relative './initializers/flash'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = route_params.merge(req.params)
    @session = session
    @flash = flash
    @already_built_response = false
    @@protect_from_forgery ||= false
  end

  def self.protect_from_forgery
    @@protect_from_forgery = true
  end

  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    if already_built_response?
      raise "Cannot redirect twice"
    end

    @res.status = 302
    @res["location"] = url
    @already_built_response = true
    session.store_session(@res)
    flash.store_flash(@res)

    nil
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    if already_built_response?
      raise "Cannot render content twice."
    end
    @res.body = [content]
    @res.header["Content-Type"] = content_type
    @already_built_response = true
    session.store_session(@res)
    flash.store_flash(@res)

    nil
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

  def session
    @session ||= CrosstieInit::Session.new(req)
  end

  def flash
    @flash ||= CrosstieInit::Flash.new(req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    if @@protect_from_forgery && req.request_method != "GET"
      check_authenticity_token
    end
    self.send(name)
    render(name) unless already_built_response?
  end

  def form_authenticity_token
    @form_authenticity_token ||= generate_authenticity_token
    res.set_cookie('authenticity_token', value: @form_authenticity_token, path: '/')
    @form_authenticity_token
  end

  private

  def check_authenticity_token
    cookie = req.cookies["authenticity_token"]
    unless cookie && cookie == params["authenticity_token"]
      raise "Invalid authenticity token"
    end
  end

  def generate_authenticity_token
    SecureRandom.urlsafe_base64(16)
  end
end
