require 'brody/path_proxy'

module Brody
  module Routing
    module DSL
      extend SingleForwardable

      RouteError = Class.new(StandardError)

      def_delegator :Brody, :router

      def get(path = nil, options = {}, &block)
        router.add(:GET, path, options, &block)
      end

      def post(path = nil, options = {}, &block)
        router.add(:POST, path, options, &block)
      end

      def put(path = nil, options = {}, &block)
        router.add(:PUT, path, options, &block)
      end

      def patch(path = nil, options = {}, &block)
        router.add(:PATCH, path, options, &block)
      end

      def head(path = nil, options = {}, &block)
        router.add(:HEAD, path, options, &block)
      end

      def options(path = nil, options = {}, &block)
        router.add(:OPTIONS, path, options, &block)
      end

      def delete(path = nil, options = {}, &block)
        router.add(:DELETE, path, options, &block)
      end

      def path(pathname, options = {}, &block)
        option_merger = Brody::PathProxy.new(self, pathname, options)
        option_merger.instance_eval(&block)
      end

      def root(path = "/", options = {}, &block)
        router.add(:GET, path, options, &block)
      end

      def match(path = nil, options = {}, &block)
        via = options.delete(:via)
        unless via.is_a?(Array)
          raise RouteError, "options[:via] must be an array of HTTP verbs"
        end
        via.each do |verb|
          router.add(verb.upcase, path, options, &block)
        end
      end
    end
  end
end
