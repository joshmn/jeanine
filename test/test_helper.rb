$LOAD_PATH.unshift File.expand_path("../lib", __dir__)


require 'pry'
require 'jeanine'

require 'rack'
require 'rack/test'
require "minitest/autorun"
require "minitest/reporters"


Minitest::Reporters.use!


module Jeanine
  module Mock
    def mock_app(&block)
      app = Jeanine::App
      app.class_eval(&block)
      app.plugin :Rescuing
      app.plugin :Callbacks
      app.plugin :Session
      app.plugin :Rendering
      @app = app.new
    end
  end
end
