module Opted
  module Result
    # Value object that represents a successful result
    class Ok
      # @param value [Object] a non-nil value to wrap
      # @raise [ArgumentError] if provided value is nil
      def initialize(value)
        if value.nil?
          fail ArgumentError.new("can't wrap nil")
        else
          @value = value
        end
      end

      # If other object is also {Ok} and wraps equivalent value
      # @param other [Object] any object
      # @return [Boolean]
      def ==(other)
        other.is_a?(Ok) && unwrap! == other.unwrap!
      end
      alias_method :eql?, :==

      # (see AbstractResult#ok?)
      # @see Err#ok?
      def ok?
        true
      end

      # (see AbstractResult#err?)
      # @see Err#err?
      def err?
        false
      end

      # (see AbstractResult#unwrap!)
      # @see Err#unwrap!
      def unwrap!
        @value
      end

      # (see AbstractResult#unwrap_err!)
      # @see Err#unwrap_err!
      def unwrap_err!
        fail UnwrapError.new(__method__, inspect)
      end

      # (see AbstractResult#map)
      # @see Err#map
      def map
        Ok.new(yield unwrap!)
      end

      # (see AbstractResult#map_err)
      # @see Err#map_err
      def map_err
        self
      end

      # (see AbstractResult#unwrap_or)
      # @see Err#unwrap_or
      def unwrap_or(_other_value)
        unwrap!
      end

      # (see AbstractResult#and)
      # @see Err#and
      def and(other)
        other
      end

      # (see AbstractResult#and_then)
      # @see Err#and_then
      def and_then
        yield unwrap!
      end

      # (see AbstractResult#or)
      # @see Err#or
      def or(_other)
        self
      end

      # (see AbstractResult#or_else)
      # @see Err#or_else
      def or_else
        self
      end

      # (see AbstractResult#match)
      # @see Err#match
      def match(&block)
        Match.match_value(unwrap!, &block)
      end
    end
  end
end
