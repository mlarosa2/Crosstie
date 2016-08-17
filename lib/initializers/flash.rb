require 'json'
require_relative './flash_store'

Module CrosstieInit
  class Flash
    attr_reader :now

    def initialize(req)
      cookie = req.cookies["_rails_lite_app_flash"]
      if cookie
        cookie_content = JSON.parse(cookie)
      else
        cookie_content = {}
      end

      @now = FlashStore.new(cookie_content)
      @flash = FlashStore.new
    end

    def [](key)
      @now[key] || @flash[key]
    end

    def []=(key, val)
      @flash[key] = val
    end

    def store_flash(res)
      flash = @flash.to_json
      res.set_cookie("_rails_lite_app_flash", { :path => "/", :value => flash })
    end
  end
end
