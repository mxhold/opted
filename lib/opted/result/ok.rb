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
        fail UnwrapError.new("Called #unwrap_err! on #{inspect}")
      end

      def match(&block)
        match = OkMatch.new(@value)
        match = MatchWithBranchChecking.new(match)
        match.instance_eval(&block)
        match.mapped_result
      end
    end
  end
end
