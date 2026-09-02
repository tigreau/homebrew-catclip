class Catclip < Formula
  desc "Copy project files to clipboard with safe ignores"
  homepage "https://github.com/tigreau/catclip"
  url "https://github.com/tigreau/catclip/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "bfb6c11fa55d5e27998bf71b05c421627a0ecd14b0a32f098ceffa7ab4004012"
  license "MIT"

  depends_on "go" => :build
  depends_on "fzf"
  depends_on "ripgrep"

  def install
    system "go", "build", *std_go_args(output: libexec/"catclip"), "./cmd/catclip"


    (bin/"catclip").write_env_script libexec/"catclip",
                                     CATCLIP_FZF:  Formula["fzf"].opt_bin/"fzf",
                                     CATCLIP_RG:   Formula["ripgrep"].opt_bin/"rg"
  end

  def caveats
    <<~EOS
      Important: run catclip from inside the project you want to inspect.

        cd /path/to/project
        catclip --help
    EOS
  end

  test do
    (testpath/"sample").mkpath
    (testpath/"sample/sample.txt").write("hi")

    output = shell_output("#{bin}/catclip --quiet --print sample --only '*.txt'")
    assert_match "<file path=\"sample/sample.txt\">", output
    assert_match "hi", output
    assert_match "catclip #{version}", shell_output("#{bin}/catclip --version")
  end
end
