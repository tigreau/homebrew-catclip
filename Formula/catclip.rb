class Catclip < Formula
  desc "Copy project files to clipboard with safe ignores"
  homepage "https://github.com/tigreau/catclip"
  url "https://github.com/tigreau/catclip/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "0ce0356cd3d4eeac4b83db5720aa8713d79bc2223830372cfeb8e0503b08d183"
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
