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
  end

  describe err do
    describe "#ok?" do
      it "is false" do
        expect(err.new(:error).ok?).to eql(false)
      end
    end

    describe "#unwrap!" do
      it "raises an UnwrapError" do
        expect do
          err.new("error").unwrap!
        end.to raise_error(RuntimeError, "error")
      end
    end
  end
end
