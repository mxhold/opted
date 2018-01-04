RSpec.describe Opted::Result::Err do
  describe "#ok?" do
    it "is false" do
      expect(Opted::Result::Err.new(:error).ok?).to eql(false)
    end
  end

  describe "#unwrap!" do
    it "raises an error" do
      expect do
        Opted::Result::Err.new(:whoops).unwrap!
      end.to raise_error(Opted::Result::UnwrapError, /Called #unwrap! on #<Opted::Result::Err:.* @error=:whoops>/)
    end
  end

  describe "#unwrap_err!" do
    it "returns the error" do
      expect(Opted::Result::Err.new(:whoops).unwrap_err!).to eql(:whoops)
    end
  end

  describe "#match" do
    it "runs the err block" do
      result = Opted::Result::Err.new(:whoops).match do
        ok { fail "unreachable" }
        err { |error| "error is #{error}" }
      end

      expect(result).to eql("error is whoops")
    end

    it "fails unless both ok and err block provided" do
      expect do
        Opted::Result::Err.new(:whoops).match do
          err { |error| "error is #{error}" }
        end
      end.to raise_error(RuntimeError, "Must match on both ok and err results")
    end
  end
end
