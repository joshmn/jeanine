module Jeanine
  module Routing
    module Evaluation
      def route_eval
        route = find_route
        if route
          result = instance_eval(&route[:block])
          @response.write(result)
        else
          @response.status = 404
        end
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

    end
  end
end
