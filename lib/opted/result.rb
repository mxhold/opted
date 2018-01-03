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

      def unwrap_err!
        fail "Called #unwrap_err! on Ok(#{@value.inspect})"
      end

      def match
        yield OkMatch.new(@value)
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
        fail "Called #unwrap! on Err(#{@error.inspect})"
      end

      def unwrap_err!
        @error
      end

      def match
        yield ErrMatch.new(@error)
      end
    end

    class OkMatch
      def initialize(value)
        @value = value
        @mapped_value = nil
      end

      def ok
        @mapped_value = yield @value
      end

      def err
        @mapped_value
      end
    end

    class ErrMatch
      def initialize(error)
        @error = error
        @mapped_error = nil
      end

      def ok
      end

      def err
        @mapped_error = yield @error
      end
    end
  end
end
