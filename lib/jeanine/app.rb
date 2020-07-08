require 'jeanine/mimes'
require 'jeanine/request'
require 'jeanine/response'
require 'jeanine/routing'

module Jeanine
  class App
    include Routing::Evaluation

    attr_reader :request, :response

    def self.plugin(name)
      unless Jeanine._installed_plugins.include?(name)
        unless const_defined?("Jeanine::#{name}")
          require "jeanine/#{name.to_s.underscore}"
        end
        include Kernel.const_get("Jeanine::#{name}")
        Jeanine._installed_plugins << name
      end
    end

    def self.installed_plugins
      Jeanine._installed_plugins
    end

    # plugin :Callbacks
    # plugin :Rendering
    # plugin :Rescuing
    # plugin :Session

    class << self
      include Routing::DSL

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

    def instance_variables_cache
      instance_variables.each_with_object({}) do |var, obj|
        obj[var] = instance_variable_get(var)
      end
    end
  end
end
