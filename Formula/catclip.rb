class Catclip < Formula
  desc "Copy project files to clipboard with safe ignores"
  homepage "https://github.com/tigreau/catclip"
  url "https://github.com/tigreau/catclip/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "064bee5f6491787dfabd34ac771bb62a4cfd0cb42cc3dd8eef8e527f97dde32a"
  license "MIT"

  depends_on "fzf"
  depends_on "ripgrep"
  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: libexec/"catclip"), "./cmd/catclip"
    pkgshare.install "VERSION"
    (bin/"catclip").write_env_script libexec/"catclip",
                                     CATCLIP_FZF: Formula["fzf"].opt_bin/"fzf",
                                     CATCLIP_RG:  Formula["ripgrep"].opt_bin/"rg"
  end

  test do
    (testpath/"sample").mkpath
    (testpath/"sample/sample.txt").write("hi")

    output = shell_output("#{bin}/catclip --quiet --print sample --only '*.txt'")
    assert_match "<file path=\"sample/sample.txt\">", output
    assert_match "hi", output
  end
end
