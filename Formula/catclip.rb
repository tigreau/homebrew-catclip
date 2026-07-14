class Catclip < Formula
  desc "Copy project files to clipboard with safe ignores"
  homepage "https://github.com/tigreau/catclip"
  url "https://github.com/tigreau/catclip/archive/refs/tags/v0.6.7.tar.gz"
  sha256 "1e2c0f4d387b13b109e0b8067a51564c8b91d6c7870755caf01099b1197251a9"
  license "MIT"

  depends_on "go" => :build
  depends_on "fzf"
  depends_on "ripgrep"

  def install
    system "go", "build", *std_go_args(output: libexec/"catclip"), "./cmd/catclip"

    pkgshare.install "VERSION"

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
  end
end
