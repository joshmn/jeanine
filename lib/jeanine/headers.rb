# frozen_string_literal: true

module Jeanine
  class Headers
    CGI_VARIABLES = Set.new(%W[
        AUTH_TYPE
        CONTENT_LENGTH
        CONTENT_TYPE
        GATEWAY_INTERFACE
        HTTPS
        PATH_INFO
        PATH_TRANSLATED
        QUERY_STRING
        REMOTE_ADDR
        REMOTE_HOST
        REMOTE_IDENT
        REMOTE_USER
        REQUEST_METHOD
        SCRIPT_NAME
        SERVER_NAME
        SERVER_PORT
        SERVER_PROTOCOL
        SERVER_SOFTWARE
      ]).freeze

    HTTP_HEADER = /\A[A-Za-z0-9-]+\z/

    include Enumerable

    def initialize(request)
      @req = request
    end

    def [](key)
      @req.get_header env_name(key)
    end

    def key?(key)
      @req.has_header? env_name(key)
    end
    alias :include? :key?

    DEFAULT = Object.new

    def fetch(key, default = DEFAULT)
      @req.fetch_header(env_name(key)) do
        return default unless default == DEFAULT
        return yield if block_given?
        raise KeyError, key
      end
    end

    def each(&block)
      @req.each_header(&block)
    end

    def to_h
      obj = {}
      each do |k,v|
        obj[k] = v
      end
      obj
    end

    private

    def env_name(key)
      key = key.to_s
      if HTTP_HEADER.match?(key)
        key = key.upcase.tr("-", "_")
        key = "HTTP_" + key unless CGI_VARIABLES.include?(key)
      end
      key
    end
  end
end
