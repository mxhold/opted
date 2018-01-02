RSpec.describe Opted do
  it "has a version number" do
    expect(Opted::VERSION).not_to be nil
  end

  describe "README code sample" do
    it "evaluates without error" do
      readme_text = File.read(File.join(__dir__, "..", "README.md"))
      code_sample = readme_text.match(/#{Regexp.escape("<!-- BEGIN CODE SAMPLE -->\n```ruby")}(.*?)#{Regexp.escape("```")}/m)[1]
      class ReadmeExample
        def get_binding
          binding
        end
      end
      eval(code_sample, ReadmeExample.new.get_binding)

      # ensure this test doesn't leave any lingering constants
      expect(Kernel.const_defined?("Ok")).to be_falsey
    end
  end
end
