module Jeanine
  class Mimes
    MimeTypeNotFound = Class.new(StandardError)
    MIME_TYPES_INVERTED = ::Rack::Mime::MIME_TYPES.invert

    def self.loaded?
      @loaded
    end

    def self.load!
      return if loaded?
      @loaded = true
      register(:json, Rack::Mime::MIME_TYPES[".json"])
      register(:html, Rack::Mime::MIME_TYPES[".html"])
      register(:text, Rack::Mime::MIME_TYPES[".text"])
      register(:plain, self.for(:text))
    end

    def self.register(type, header)
      mime_types[type] = header
    end

    def self.for(type)
      mime_types.fetch(type) do
        raise(MimeTypeNotFound, "Mime #{type} not registered")
      end
    end

    def self.mime_types
      @mime_types ||= {}
    end

    private_class_method :mime_types

    def initialize(*)
      raise "Should not be initialiazed"
    end
  end
end
