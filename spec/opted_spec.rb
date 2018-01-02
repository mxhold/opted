RSpec.describe Opted do
  it "has a version number" do
    expect(Opted::VERSION).not_to be nil
  end

  describe "README code sample" do
    it "evaluates without error" do
      readme_text = File.read(File.join(__dir__, "..", "README.md"))
      code_sample = readme_text.match(/#{Regexp.escape("# BEGIN")}(.*?)#{Regexp.escape("```")}/m)[1]
      eval(code_sample)
    end
  end
end
