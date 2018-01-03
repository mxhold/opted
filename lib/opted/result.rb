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
        match = OkMatch.new(@value)
        yield match
        match.result
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
        match = ErrMatch.new(@error)
        yield match
        match.result
      end
    end

    class OkMatch
      def initialize(value)
        @value = value
      end

      def ok
        @ok_called = true
        @result = yield @value
      end

      def err
        @err_called = true
      end

      def result
        if @ok_called && @err_called
          @result
        else
          fail "Must match on both ok and err results"
        end
      end
    end

    class ErrMatch
      def initialize(error)
        @error = error
      end

      def ok
        @ok_called = true
      end

      def err
        @err_called = true
        @result = yield @error
      end

      def result
        if @ok_called && @err_called
          @result
        else
          fail "Must match on both ok and err results"
        end
      end
    end
  end
end
