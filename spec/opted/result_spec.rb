RSpec.describe Opted::Result do
  ok = Opted::Result::Ok
  err = Opted::Result::Err

  describe "both result types" do
    it "have exactly the same interface" do
      object_methods = Object.instance_methods
      ok_methods = ok.instance_methods - object_methods
      err_methods = err.instance_methods - object_methods
      expect(ok_methods).to eql(err_methods)
    end
  end

  describe ok do
    describe "#ok?" do
      it "is true" do
        expect(ok.new(1).ok?).to eql(true)
      end
    end

    describe "#unwrap!" do
      it "returns the value" do
        expect(ok.new(1).unwrap!).to eql(1)
      end
    end

    describe "#unwrap_err!" do
      it "raises an error" do
        expect do
          ok.new("hello").unwrap_err!
        end.to raise_error(RuntimeError, "Called #unwrap_err! on Ok(\"hello\")")
      end
    end

    describe "#match" do
      it "runs the ok block" do
        result = ok.new(1).match do
          ok { |r| r + 1 }
          err { fail "unreachable" }
        end

        expect(result).to eql(2)
      end

      it "fails unless both ok and err block provided" do
        expect do
          ok.new(1).match do
            ok { |r| r + 1 }
          end
        end.to raise_error(RuntimeError, "Must match on both ok and err results")
      end
    end
  end

  describe err do
    describe "#ok?" do
      it "is false" do
        expect(err.new(:error).ok?).to eql(false)
      end
    end

    describe "#unwrap!" do
      it "raises an error" do
        expect do
          err.new(:whoops).unwrap!
        end.to raise_error(RuntimeError, "Called #unwrap! on Err(:whoops)")
      end
    end

    describe "#unwrap_err!" do
      it "returns the error" do
        expect(err.new(:whoops).unwrap_err!).to eql(:whoops)
      end
    end

    describe "#match" do
      it "runs the err block" do
        result = err.new(:whoops).match do
          ok { fail "unreachable" }
          err { |error| "error is #{error}" }
        end

        expect(result).to eql("error is whoops")
      end

      it "fails unless both ok and err block provided" do
        expect do
          err.new(:whoops).match do
            err { |error| "error is #{error}" }
          end
        end.to raise_error(RuntimeError, "Must match on both ok and err results")
      end
    end
  end
end
