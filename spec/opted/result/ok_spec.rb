RSpec.describe Opted::Result::Ok do
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
