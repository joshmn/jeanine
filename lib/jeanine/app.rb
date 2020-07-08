require 'jeanine/callbacks'
require 'jeanine/mimes'
require 'jeanine/request'
require 'jeanine/rescuing'
require 'jeanine/response'
require 'jeanine/renderer'
require 'jeanine/routing'
require 'jeanine/session'
require 'jeanine/view_paths'

module Jeanine
  class App
    include Session
    include Rescuing
    include Routing::Evaluation

    attr_reader :request, :response

    class << self
      include Callbacks
      include Routing::DSL
      include Rescuing
      include ViewPaths

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
      begin
        @env = env
        @request = Jeanine::Request.new(env)
        @response = Jeanine::Response.new
        catch(:halt) { route_eval }
      rescue => error
        handler = self.class.rescue_handlers[error.class]
        raise error unless handler
        if handler.is_a?(Symbol)
          @response.write(send(handler, error))
        else
          @response.write(instance_exec(error, &handler))
        end
        @response.complete!
      end
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
