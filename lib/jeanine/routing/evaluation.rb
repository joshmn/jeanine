module Jeanine
  module Routing
    module Evaluation
      IGNORED_INSTANCE_VARIABLES = [:@env]
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

      def find_route
        matches = nil
        route = Jeanine.router[@request.request_method.to_sym].detect do |r|
          matches = r[:compiled_path].match(@request.path_info)
          !matches.nil?
        end

        return nil if route.nil?
        return route if route && route[:params].empty?

        index = 0
        while index < matches.captures.size
          param = route[:params][index]
          @request.params[param] = matches.captures[index]
          if index == matches.captures.size
            @request.params[param].gsub!(@request.format)
          end
          index += 1
        end

        route
      end

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
