require 'forwardable'

module Brody
  class Router
    extend Forwardable

    def_delegators :@routes, :[]

    attr_reader :routes
    def initialize
      @routes = {
          GET: [],
          POST: [],
          PATCH: [],
          PUT: [],
          DELETE: [],
          OPTIONS: [],
          HEAD: [],
      }
    end

    def add(verb, path, options = {}, &block)
      routes[verb] << build_route("#{path}", options, &block)
    end

    private

    def build_route(path, options = {}, &block)
      route = { path: "#{path}", compiled_path: nil, params: [], block: block }
      compiled_path = route[:path].gsub(/:\w+/) do |match|
        route[:params] << match.tr(':', '').to_sym
        '([^/?#]+)'
      end
      route[:compiled_path] = /^#{compiled_path}?$/
      route
    end
  end
end
