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
      @app = app.new
    end
  end
end
