module Opted
  module Result
    class UnwrapError < RuntimeError
      def initialize(error)
        super("Called #unwrap! on Err: #{error}")
      end
    end

    class Ok
      def initialize(value)
        @value = value
      end

      def ok?
        true
      end

      def unwrap!
        @value
      end
    end

    class Err
      def initialize(error)
        @error = error
      end

      def ok?
        false
      end

      def unwrap!
        fail UnwrapError, @error
      end
    end
  end
end
