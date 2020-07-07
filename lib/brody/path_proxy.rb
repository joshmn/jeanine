module Brody
  class PathProxy
    def initialize(context, pathname, options = {})
      @context = context
      @pathname = pathname
      @options = options
    end

    def get(path = nil, options = {}, &block)
      @options.reverse_merge!(options)
      @context.get(merged_path(path), options, &block)
    end

    def post(path = nil, options = {}, &block)
      @options.reverse_merge!(options)
      @context.post(merged_path(path), options, &block)
    end

    def patch(path = nil, options = {}, &block)
      @options.reverse_merge!(options)
      @context.patch(merged_path(path), options, &block)
    end

    def put(path = nil, options = {}, &block)
      @options.reverse_merge!(options)
      @context.put(merged_path(path), options, &block)
    end

    def options(path = nil, options = {}, &block)
      @options.reverse_merge!(options)
      @context.options(merged_path(path), options, &block)
    end

    def head(path = nil, options = {}, &block)
      @options.reverse_merge!(options)
      @context.head(merged_path(path), options, &block)
    end

    def delete(path = nil, options = {}, &block)
      @options.reverse_merge!(options)
      @context.delete(merged_path(path), options, &block)
    end

    def path(path = nil, options = {}, &block)
      @options.reverse_merge!(options)
      @context.path(merged_path(path), options, &block)
    end

    def match(path = nil, options = {}, &block)
      @options.reverse_merge!(options)
      @context.match(merged_path(path), options, &block)
    end

    def root(path = '/', options = {}, &block)
      @options.reverse_merge!(options)
      @context.root(merged_path(path), options, &block)
    end

    def before(*paths, &block)
      @context.before(*paths, &block)
    end

    def after(*paths, &block)
      @context.after(*paths, &block)
    end

    private

    def merged_path(path)
      [@pathname, path].join
    end
  end
end
