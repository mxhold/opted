module Opted
  module Result
    # @abstract This class exists purely to document the interface of both {Ok}
    #   and {Err} result types.
    class AbstractResult
      # If +self+ is {Ok}
      # @example
      #   Ok.new(1).ok? # => true
      #   Err.new(:err).ok? # => false
      # @return [Boolean]
      def ok?
      end

      # If +self+ is {Err}
      # @example
      #   Ok.new(1).err? # => false
      #   Err.new(:err).err? # => true
      # @return [Boolean]
      def err?
      end

      # Returns the inner value if {Ok}
      # @example
      #   Ok.new(1).unwrap! # => 1
      #   Err.new(:err).unwrap! # => UnwrapError: Called #unwrap! on #<Opted::Result::Err:0x00007fbec7032798 @error=:err>
      # @raise [UnwrapError] if {Err}
      # @return [Object] value
      def unwrap!
      end

      # Returns the inner error if {Err}
      # @example
      #   Ok.new(1).unwrap_err! # => UnwrapError: Called #unwrap_err! on #<Opted::Result::Ok:0x00007fbec7901c20 @value=1>
      #   Err.new(:err).unwrap_err! # => :err
      # @raise [UnwrapError] if {Ok}
      # @return [Object] error
      def unwrap_err!
      end

      # Returns a result of the same type wrapping the result of applying the
      # block to the original inner value, leaving errors untouched
      # @example
      #   Ok.new(1)
      #     .map { |value| value + 1 }
      #     .unwrap! # => 2
      #   Err.new(:err)
      #     .map { |value| value + 1 }
      #     .unwrap_err! # => :err
      # @yieldparam [Object] value
      # @return [Ok, Err] mapped result
      def map(&block)
      end

      # Returns a result of the same type wrapping the result of applying the
      # block to the original inner error, leaving values untouched
      # @example
      #   Ok.new(1)
      #     .map_err { |error| error.upcase }
      #     .unwrap! # => 1
      #   Err.new(:err)
      #     .map_err { |error| error.upcase }
      #     .unwrap_err! # => :ERR
      # @yieldparam [Object] error
      # @return [Ok, Err] mapped result
      def map_err(&block)
      end

      # Returns inner value if {Ok}, other value if {Err}
      # @example
      #   Ok.new(1).unwrap_or(2) # => 1
      #   Err.new(:err).unwrap_or(2) # => 2
      # @return [Object] inner value or other value
      def unwrap_or(other_value)
      end

      # Returns other result if {Ok}, +self+ if {Err}
      # @example
      #   Ok.new(1).and(Ok.new(2)) # => Ok.new(2)
      #   Ok.new(1).and(Err.new(:err)) # => Err.new(:err)
      #   Err.new(:e1).and(Ok.new(1)) # => Err.new(:e1)
      #   Err.new(:e1).and(Err.new(:e2)) # => Err.new(:e1)
      # @param other [Ok, Err] other result
      # @return [Ok, Err] self or other result
      # @note Arguments provided will be eagerly evaluated. Use {#and_then} for
      #   lazy evaluation.
      def and(other)
      end

      # Returns the result of calling the block with the inner value if {Ok},
      # self if {Err}
      # @yieldparam value [Object] inner value
      # @yieldreturn [Ok, Err] mapped result
      # @return [Ok, Err] self or mapped result
      # @note This differs from {#map} in that it allows you to turn {Ok} into
      #   {Err}
      # @example
      #   Ok.new(:foo)
      #     .and_then { |value| Err.new(value.upcase) }
      #     # => Err.new(:FOO)
      #   Err.new(:err)
      #     .and_then { |value| Err.new(value.upcase) }
      #     # => Err.new(:err)
      def and_then(&block)
      end

      # Returns self if {Ok}, other result if {Err}
      # @example
      #   Ok.new(1).or(Ok.new(2)) # => Ok.new(1)
      #   Ok.new(1).or(Err.new(:err)) # => Ok.new(1)
      #   Err.new(:e1).or(Ok.new(1)) # => Ok.new(:1)
      #   Err.new(:e1).or(Err.new(:e2)) # => Err.new(:e2)
      # @param [Ok, Err] other result
      # @return [Ok, Err] self or other result
      # @note Arguments provided will be eagerly evaluated. Use {#or_else} for
      #   lazy evaluation.
      def or(other)
      end

      # Returns self if {Ok}, the result of calling the block with the inner
      # error if {Err}
      # @yieldparam value [Object] inner error
      # @yieldreturn [Ok, Err] mapped result
      # @return [Ok, Err] self or mapped result 
      # @note This differs from {#map_err} in that it allows you to turn {Err}
      #   into {Ok}
      # @example
      #   Ok.new(:foo)
      #     .or_else { |error| Ok.new(error.upcase) }
      #     # => Ok.new(:foo)
      #   Err.new(:err)
      #     .or_else { |error| Ok.new(error.upcase) }
      #     # => Ok.new(:ERR)
      def or_else(&block)
      end

      # Returns the result of running either the +ok+ or +err+ branch provided
      # to the block based on if the result is {Ok} or {Err}
      # @raise [RuntimeError] unless both +ok+ and +error+ branches are defined
      # @return [Object] mapped value
      # @yieldreturn [Object] mapped value
      # @example
      #   Ok.new(1).match do
      #     ok { |value| value + 1 }
      #     err { |error| fail "unreachable" }
      #   end # => 2
      #
      #   Err.new(:err).match do
      #     ok { |value| fail "unreachable" }
      #     err { |error| error.upcase }
      #   end # => :ERR
      #
      #   Ok.new(1).match do
      #     ok { |value| value + 1 }
      #   end # => RuntimeError: Must match on both ok and err results
      def match(&block)
      end
    end
  end
end
