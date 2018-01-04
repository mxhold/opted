RSpec.describe Opted::Result do
  describe "both result types" do
    specify "have exactly the same interface" do
      object_methods = Object.instance_methods
      ok_methods = Opted::Result::Ok.instance_methods - object_methods
      err_methods = Opted::Result::Err.instance_methods - object_methods
      expect(ok_methods).to eql(err_methods)
    end
  end
end
