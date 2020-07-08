module Jeanine
  module Rescuable
    def self.included(base)
      base.extend ClassMethods
      base.prepend InstanceMethods
    end

    module InstanceMethods
      def call(env)
        begin
          super
        rescue => error
          handler = self.class.rescue_handlers[error.class.to_s]
          raise error unless handler
          if handler.is_a?(Symbol)
            @response.write(send(handler, error))
          else
            @response.write(instance_exec(error, &handler))
          end
          @response.complete!
        end
      end
    end

    module ClassMethods
      def rescue_from(*exceptions, with: nil, &block)
        exceptions.each do |exception|
          if with
            rescue_handlers[exception.to_s] = with
          else
            rescue_handlers[exception.to_s] = block
          end
        end
      end

      def rescue_handlers
        @rescue_handlers ||= {}
      end
    end
  end
end
