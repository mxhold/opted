require "opted/result/abstract_result"

RSpec.describe Opted::Result::Ok do
  it "implements exactly the methods defined in AbstractResult" do
    expect(Opted::Result::Ok.instance_methods).to match_array(Opted::Result::AbstractResult.instance_methods)
  end

  describe ".new" do
    it "cannot wrap nil" do
      expect do
        Opted::Result::Ok.new(nil)
      end.to raise_error(ArgumentError, /can't wrap nil/)
    end
  end

  describe "#==" do
    context "two Ok with same value" do
      it "is true" do
        ok1 = Opted::Result::Ok.new("foo")
        ok2 = Opted::Result::Ok.new("foo")
        expect(ok1 == ok2).to eq(true)
      end
    end

    context "two Ok with different values" do
      it "is false" do
        ok1 = Opted::Result::Ok.new("foo")
        ok2 = Opted::Result::Ok.new("bar")
        expect(ok1 == ok2).to eq(false)
      end
    end

    context "Ok and Err" do
      it "is false" do
        ok = Opted::Result::Ok.new(1)
        err = Opted::Result::Err.new(:whoops)
        expect(ok == err).to eq(false)
      end
    end
  end

  describe "#eql?" do
    it "is equivalent to #==" do
      ok1 = Opted::Result::Ok.new("foo")
      ok2 = Opted::Result::Ok.new("foo")
      expect(ok1).to eql(ok2)
    end
  end

  describe "#ok?" do
    it "is true" do
      expect(Opted::Result::Ok.new(1).ok?).to eq(true)
    end
  end

  describe "#err?" do
    it "is false" do
      expect(Opted::Result::Ok.new(1).err?).to eq(false)
    end
  end

  describe "#unwrap!" do
    it "returns the value" do
      expect(Opted::Result::Ok.new(1).unwrap!).to eq(1)
    end
  end

  describe "#unwrap_err!" do
    it "raises an error" do
      expect do
        Opted::Result::Ok.new("hello").unwrap_err!
      end.to raise_error(Opted::Result::UnwrapError, /Called #unwrap_err! on #<Opted::Result::Ok:.* @value="hello">/)
    end
  end

  describe "#map" do
    it "returns an Ok with a value of the result of running the provided block without mutating the original Ok" do
      ok = Opted::Result::Ok.new(1)
      result = ok.map { |value| value + 1 }
      expect(result.unwrap!).to eq(2)
      expect(ok.unwrap!).to eq(1)
    end
  end

  describe "#map_err" do
    it "returns itself with no changes" do
      ok = Opted::Result::Ok.new(1)
      result = ok.map_err { |error| fail "unreachable" }
      expect(result).to equal(ok)
    end
  end

  describe "#unwrap_or" do
    it "returns the wrapped value" do
      ok = Opted::Result::Ok.new(1)
      expect(ok.unwrap_or(2)).to eq(1)
    end
  end

  describe "#and" do
    it "returns the provided argument" do
      ok = Opted::Result::Ok.new(1)
      expect(ok.and(Opted::Result::Ok.new(2).unwrap!)).to eq(2)
    end
  end

  describe "#and_then" do
    it "returns the result of calling the provided block with the wrapped value" do
      ok = Opted::Result::Ok.new(1)
      result = ok.and_then { |value| value + 1 }
      expect(result).to eq(2)
    end
  end

  describe "#or" do
    it "returns self" do
      ok = Opted::Result::Ok.new(1)
      result = ok.or(Opted::Result::Ok.new(2))
      expect(result).to eq(ok)
    end
  end

  describe "#or_else" do
    it "returns self" do
      ok = Opted::Result::Ok.new(1)
      result = ok.or_else { |_error| fail "unreachable" }
      expect(result).to eq(ok)
    end
  end

  describe "#match" do
    it "runs the ok block" do
      result = Opted::Result::Ok.new(1).match do
        ok { |value| value + 1 }
        err { fail "unreachable" }
      end

      expect(result).to eq(2)
    end

    it "fails unless both ok and err block provided" do
      expect do
        Opted::Result::Ok.new(1).match do
          ok { |value| value + 1 }
        end
      end.to raise_error(RuntimeError, "Must match on both ok and err results")
    end
  end
end
