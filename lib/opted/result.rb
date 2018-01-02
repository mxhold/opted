module Opted
  module Result
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
        fail RuntimeError, @error
      end
    end
  end
end
