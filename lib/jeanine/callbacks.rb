module Jeanine
  module Callbacks
    def self.included(klass)
      klass.extend InstanceMethods
      klass.prepend EvaluationMethods
    end

    module InstanceMethods
      def _callbacks
        @_callbacks ||= {
            before: [],
            after: [],
            before_all: [],
            after_all: []
        }
      end

      def before(*paths, &block)
        _register_callback(:before, paths, &block)
      end

      def after(*paths, &block)
        _register_callback(:after, paths, &block)
      end

      private

      def _register_callback(type, paths = [], &block)
        if paths == []
          _callbacks["#{type}_all".to_sym] << { block: block }
        else
          _callbacks[type] << { paths: paths, block: block }
        end
      end
    end

    module EvaluationMethods
      def route_eval
        before_find_route!
        route = find_route

        if route
          before_evaluate_route!
          result = instance_eval(&route[:block])
          @response.write(result)
          after_evaluate_route!
        else
          @response.status = 404
        end
        after_response!
        @response.complete!
      end

      private

      def before_find_route!
        run_before_callbacks!(:before_all)
      end

      def before_evaluate_route!
        run_before_callbacks!(:before)
      end

      def after_evaluate_route!
        run_after_callbacks!(:after)
      end

      def after_response!
        run_after_callbacks!(:after_all)
      end

      def run_before_callbacks!(type)
        if type == :before_all
          self.class._callbacks[type].each { |callback| eval_callback(&callback[:block]) }
        else
          matching_callbacks(type) do |callback|
            eval_callback(&callback[:block])
          end
        end
      end

      def run_after_callbacks!(type)
        if type == :after_all
          self.class._callbacks[type].each { |callback| eval_callback(&callback[:block]) }
        else
          matching_callbacks(type) do |callback|
            eval_callback(&callback[:block])
          end
        end
      end

      def matching_callbacks(type)
        self.class._callbacks[type].select do |callback|
          paths = callback[:paths]
          if paths.detect { |path| path.match?(@request.path_info) }
            yield callback
          end
        end
      end

      def eval_callback(*args, &callback)
        instance_exec(*args, &callback)
      end
    end
  end
end
