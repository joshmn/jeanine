require 'rack/request'
require 'jeanine/headers'

module Jeanine
  class Request < Rack::Request
    FORMAT_REGEX = %r{\.(\w+)\z}

    def initialize(env)
      env['PATH_INFO'] = '/' if env['PATH_INFO'].empty?
      if env['PATH_INFO'].include?(".")
        format = env['PATH_INFO'].match(FORMAT_REGEX)
        if format
          @format = format.captures[0]
          env['PATH_INFO'].gsub!(FORMAT_REGEX, '')
        end
      end
      super
    end

    def headers
      @headers ||= Jeanine::Headers.new(self)
    end

    def post?
      request_method == 'POST'
    end

    def get?
      request_method == 'GET'
    end

    def delete?
      request_method == 'DELETE'
    end

    def put?
      request_method == 'PUT'
    end

    def patch?
      request_method == 'PATCH'
    end

    def options?
      request_method == 'options'
    end

    def head?
      request_method == 'head'
    end

    def json?
      format == 'json'
    end

    def mime_type
      @mime_type ||= Mimes::MIME_TYPES_INVERTED[content_type]
    end

    def format
      @format || Rack::Mime::MIME_TYPES[content_type]
    end
  end
end
