module Opted
  module Result
    # Value object that represents an error result
    class Err
      # @param error [Object] a non-nil error to wrap
      # @raise [ArgumentError] if provided error is nil
      def initialize(error)
        if error.nil?
          fail ArgumentError.new("can't wrap nil")
        else
          @error = error
        end
      end

      # If other object is also {Err} and wraps equivalent error
      # @param other [Object] any object
      # @return [Boolean]
      def ==(other)
        other.is_a?(Err) && unwrap_err! == other.unwrap_err!
      end
      alias_method :eql?, :==

      # (see AbstractResult#ok?)
      # @see Ok#ok?
      def ok?
        false
      end

      # (see AbstractResult#err?)
      # @see Ok#err?
      def err?
        true
      end

      # (see AbstractResult#unwrap!)
      # @see Ok#unwrap!
      def unwrap!
        fail UnwrapError.new(__method__, inspect)
      end

      # (see AbstractResult#unwrap_err!)
      # @see Ok#unwrap_err!
      def unwrap_err!
        @error
      end

      # (see AbstractResult#map)
      # @see Ok#map
      def map
        self
      end

      # (see AbstractResult#map_err)
      # @see Ok#map_err
      def map_err
        Err.new(yield unwrap_err!)
      end

      # (see AbstractResult#unwrap_or)
      # @see Ok#unwrap_or
      def unwrap_or(other_value)
        other_value
      end

      # (see AbstractResult#and)
      # @see Ok#and
      def and(_other)
        self
      end

      # (see AbstractResult#and_then)
      # @see Ok#and_then
      def and_then
        self
      end

      # (see AbstractResult#or)
      # @see Ok#or
      def or(other)
        other
      end

      # (see AbstractResult#or_else)
      # @see Ok#or_else
      def or_else
        yield unwrap_err!
      end

      # (see AbstractResult#match)
      # @see Ok#match
      def match(&block)
        Match.match_error(unwrap_err!, &block)
      end
    end
  end
end
