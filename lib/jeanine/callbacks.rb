module Jeanine
  module Callbacks
    def _callbacks
      @_callbacks ||= {
          before: [],
          after: [],
          before_all: [],
          after_all: []
      }
    end

    def _register_callback(type, paths = [], &block)
      if paths == []
        _callbacks["#{type}_all".to_sym] << { block: block }
      else
        _callbacks[type] << { paths: paths, block: block }
      end
    end

    def before(*paths, &block)
      _register_callback(:before, paths, &block)
    end

    def after(*paths, &block)
      _register_callback(:after, paths, &block)
    end
  end
end
