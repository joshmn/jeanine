module Jeanine
  module Rescuing
    def rescue_from(*exceptions, with: nil, &block)
      exceptions.each do |exception|
        if with
          rescue_handlers[exception] = with
        else
          rescue_handlers[exception] = block
        end
      end
    end

    def rescue_handlers
      @rescue_handlers ||= {}
    end
  end
end
