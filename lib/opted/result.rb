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

      def match(&block)
        match = Match.new(self)
        match.instance_eval(&block)
        match.mapped_result
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

      def match(&block)
        match = Match.new(self)
        match.instance_eval(&block)
        match.mapped_result
      end
    end

    class Match
      def initialize(result)
        @result = result
      end

      def ok
        @ok_called = true
        if @result.ok?
          @mapped_result = yield @result.unwrap!
        end
      end

      def err
        @err_called = true
        if !@result.ok?
          @mapped_result = yield @result.unwrap_err!
        end
      end

      def mapped_result
        if @ok_called && @err_called
          @mapped_result
        else
          fail "Must match on both ok and err results"
        end
      end
    end
  end
end
