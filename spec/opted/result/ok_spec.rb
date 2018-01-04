RSpec.describe Opted::Result::Ok do
  describe "#ok?" do
    it "is true" do
      expect(Opted::Result::Ok.new(1).ok?).to eql(true)
    end
  end

  describe "#unwrap!" do
    it "returns the value" do
      expect(Opted::Result::Ok.new(1).unwrap!).to eql(1)
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

      expect(result).to eql(2)
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
