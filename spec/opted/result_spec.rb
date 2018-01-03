RSpec.describe Opted::Result do
  describe "both result types" do
    it "have exactly the same interface" do
      object_methods = Object.instance_methods
      ok_methods = Opted::Result::Ok.instance_methods - object_methods
      err_methods = Opted::Result::Err.instance_methods - object_methods
      expect(ok_methods).to eql(err_methods)
    end
  end

  describe Opted::Result::Ok do
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

  describe Opted::Result::Err do
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
end
