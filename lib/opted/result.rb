require "opted/result/ok"
require "opted/result/err"
require "opted/result/match"

module Opted
  module Result
    private_constant :Match
    class UnwrapError < RuntimeError
      def initialize(method, caller)
        super("Called ##{method} on #{caller}")
      end
    end
  end
end
