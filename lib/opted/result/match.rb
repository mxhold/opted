module Opted
  module Result
    module Match
      def self.match_value(value, &block)
        Matcher.new(OkMatch.new(value)).match(&block)
      end

      def self.match_error(error, &block)
        Matcher.new(ErrMatch.new(error)).match(&block)
      end

      class Matcher
        def initialize(match)
          @match = match
        end

        def match(&block)
          match = MatchWithBranchChecking.new(@match)
          match.instance_eval(&block)
          match.mapped_value_or_error
        end
      end

      class OkMatch
        attr_reader :mapped_value_or_error
        def initialize(value)
          @value = value
        end

        def ok
          @mapped_value_or_error = yield @value
        end

        def err
        end
      end

      class ErrMatch
        attr_reader :mapped_value_or_error
        def initialize(error)
          @error = error
        end

        def ok
        end

        def err
          @mapped_value_or_error = yield @error
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

        def mapped_value_or_error
          if @ok_called && @err_called
            @match.mapped_value_or_error
          else
            fail "Must match on both ok and err results"
          end
        end
      end
    end
  end
end
