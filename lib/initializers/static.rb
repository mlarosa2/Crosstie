class Static
  attr_reader :app
  MIME = {
    ".jpg" => "image/jpeg",
    ".jpeg" => "image/jpeg",
    ".png" => "image/png",
    ".gif" => "image/gif",
    ".css" => "text/css",
    ".js" => "application/javascript",
    ".json" => "application/json",
    ".txt" => "text/plain",
    ".zip" => "application/zip"
  }
  def initialize(app)
    @app = app
    @res = Rack::Response.new
  end

  def call(env)
    req = Rack::Request.new(env)
    if req.path =~ (/^\/lib\/public/)
      begin
        file = File.new(__dir__ + '/../..' + req.path)
        res = ["200", { "Content-type" => MIME[File.extname(file)] }, [file.read]]
      rescue
        res = ["404", { "Content-type" => "text/html" }, ['Could not find file, sorry.']]
      end
    else
      app.call(env)
    end
  end
end
