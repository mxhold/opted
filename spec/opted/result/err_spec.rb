RSpec.describe Opted::Result::Err do
  describe "#==" do
    context "two Err with same error" do
      it "is true" do
        err1 = Opted::Result::Err.new(:error1)
        err2 = Opted::Result::Err.new(:error1)
        expect(err1 == err2).to eq(true)
      end
    end

    context "two Err with different error" do
      it "is false" do
        err1 = Opted::Result::Err.new(:error1)
        err2 = Opted::Result::Err.new(:error2)
        expect(err1 == err2).to eq(false)
      end
    end

    context "Err and Ok" do
      it "is false" do
        err = Opted::Result::Err.new(:error1)
        ok = Opted::Result::Ok.new(1)
        expect(err == ok).to eq(false)
      end
    end
  end

  describe "#eql?" do
    it "is equivalent to #==" do
      err1 = Opted::Result::Err.new(:error1)
      err2 = Opted::Result::Err.new(:error1)
      expect(err1).to eql(err2)
    end
  end

  describe "#ok?" do
    it "is false" do
      expect(Opted::Result::Err.new(:error).ok?).to eq(false)
    end
  end

  describe "#err?" do
    it "is true" do
      expect(Opted::Result::Err.new(:error).err?).to eq(true)
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
      expect(Opted::Result::Err.new(:whoops).unwrap_err!).to eq(:whoops)
    end
  end

  describe "#map" do
    it "returns itself with no changes" do
      err = Opted::Result::Err.new(:whoops)
      result = err.map { |value| fail "unreachable" }
      expect(result).to equal(err)
    end
  end

  describe "#map_err" do
    it "returns an Err with an error of the result of running the provided block without mutating the original Err" do
      err = Opted::Result::Err.new(:whoops)
      result = err.map_err { |error| error.upcase }
      expect(result.unwrap_err!).to eq(:WHOOPS)
      expect(err.unwrap_err!).to eq(:whoops)
    end
  end

  describe "#unwrap_or" do
    it "returns the provided value" do
      err = Opted::Result::Err.new(:whoops)
      expect(err.unwrap_or(2)).to eq(2)
    end
  end

  describe "#match" do
    it "runs the err block" do
      result = Opted::Result::Err.new(:whoops).match do
        ok { fail "unreachable" }
        err { |error| "error is #{error}" }
      end

      expect(result).to eq("error is whoops")
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
