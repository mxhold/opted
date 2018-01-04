module Opted
  module Result
    class Err
      def initialize(error)
        @error = error
      end

      def ok?
        false
      end

      def unwrap!
        fail UnwrapError.new("Called #unwrap! on #{inspect}")
      end

      def unwrap_err!
        @error
      end

      def match(&block)
        match = ErrMatch.new(@error)
        match = MatchWithBranchChecking.new(match)
        match.instance_eval(&block)
        match.mapped_result
      end
    end
  end
end
