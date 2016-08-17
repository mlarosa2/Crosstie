require 'json'

class Session
  def initialize(req)
    @cookie = req.cookies["_rails_lite_app"]
    if @cookie.nil?
      @cookie = {}
    else
      @cookie = JSON.parse(@cookie)
    end
  end

  def [](key)
    @cookie[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    cookie = JSON.generate(@cookie)
    res.set_cookie("_rails_lite_app", { :path => "/", :value => cookie })
  end
end
