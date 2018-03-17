module Opted
  module Result
    class Ok
      def initialize(value)
        if value.nil?
          fail ArgumentError.new("can't wrap nil")
        else
          @value = value
        end
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

      def unwrap_or(_other_value)
        unwrap!
      end

      def and(other)
        other
      end

      def and_then
        yield unwrap!
      end

      def or(_other)
        self
      end

      def or_else
        self
      end

      def match(&block)
        Matcher.from_value(unwrap!).match(&block)
      end
    end
  end
end
