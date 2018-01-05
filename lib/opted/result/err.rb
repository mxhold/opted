module Opted
  module Result
    class Err
      def initialize(error)
        @error = error
      end

      def ==(other)
        other.is_a?(Err) && unwrap_err! == other.unwrap_err!
      end
      alias_method :eql?, :==

      def ok?
        false
      end

      def err?
        true
      end

      def unwrap!
        fail UnwrapError.new("Called #unwrap! on #{inspect}")
      end

      def unwrap_err!
        @error
      end

      def map
        self
      end

      def map_err
        Err.new(yield unwrap_err!)
      end

      def unwrap_or(other_value)
        other_value
      end

      def and(_other)
        self
      end

      def and_then
        self
      end

      def or(other)
        other
      end

      def or_else
        yield unwrap_err!
      end

      def match(&block)
        match = ErrMatch.new(unwrap_err!)
        match = MatchWithBranchChecking.new(match)
        match.instance_eval(&block)
        match.mapped_result
      end
    end
  end
end
