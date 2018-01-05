module Opted
  module Result
    class Ok
      def initialize(value)
        @value = value
      end

      def ==(other)
        other.is_a?(Ok) && unwrap! == other.unwrap!
      end
      alias_method :eql?, :==

      def ok?
        true
      end

      def err?
        false
      end

      def unwrap!
        @value
      end

      def unwrap_err!
        fail UnwrapError.new("Called #unwrap_err! on #{inspect}")
      end

      def map
        Ok.new(yield unwrap!)
      end

      def map_err
        self
      end

      def match(&block)
        match = OkMatch.new(unwrap!)
        match = MatchWithBranchChecking.new(match)
        match.instance_eval(&block)
        match.mapped_result
      end
    end
  end
end
