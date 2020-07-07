require 'jeanine/callbacks'
require 'jeanine/mimes'
require 'jeanine/request'
require 'jeanine/response'
require 'jeanine/renderer'
require 'jeanine/routing'

module Jeanine
  class App
    include Routing::Evaluation
    attr_reader :request, :response
    class << self
      include Routing::DSL
      include Callbacks

      alias :_new :new
      def new(*args, &block)
        initialize!
        stack.run _new(*args, &block)
        stack
      end

      def initialize!
        Mimes.load!
      end

      def stack
        @stack ||= Rack::Builder.new
      end

      def router
        Jeanine.router
      end

      def call(env)
        new.call env
      end
    end

    def call(env)
      @env = env
      @request = Jeanine::Request.new(env)
      @response = Jeanine::Response.new
      catch(:halt) { route_eval }
    end

    private

    def params
      @params ||= if @request.format
                    @request.params.merge({ format: @request.format })
                  else
                    @request.params
                  end
    end

    def render(*args)
      @response.action_variables = instance_variables_cache
      Renderer.new(@response).render(*args)
    end

    def instance_variables_cache
      instance_variables.each_with_object({}) do |var, obj|
        obj[var] = instance_variable_get(var)
      end
    end
  end
end
