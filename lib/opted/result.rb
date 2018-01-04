require "opted/result/ok"
require "opted/result/err"
require "opted/result/match"

module Opted
  module Result
    class UnwrapError < RuntimeError
    end
  end
end
