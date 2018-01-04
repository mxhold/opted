module Opted
  module Result
    class OkMatch
      attr_reader :mapped_result
      def initialize(value)
        @value = value
      end

      def ok
        @mapped_result = yield @value
      end

      def err
      end
    end

    class ErrMatch
      attr_reader :mapped_result
      def initialize(error)
        @error = error
      end

      def ok
      end

      def err
        @mapped_result = yield @error
      end
    end

    class MatchWithBranchChecking
      def initialize(match)
        @match = match
      end

      def ok(&block)
        @ok_called = true
        @match.ok(&block)
      end

      def err(&block)
        @err_called = true
        @match.err(&block)
      end

      def mapped_result
        if @ok_called && @err_called
          @match.mapped_result
        else
          fail "Must match on both ok and err results"
        end
      end
    end
  end
end
