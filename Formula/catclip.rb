class Catclip < Formula
  desc "Copy project files to clipboard with safe ignores"
  homepage "https://github.com/tigreau/catclip"
  url "https://github.com/tigreau/catclip/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "6e057e913afc967681182253209e786dbd95778404bdfcba014d459d1beb4df5"
  license "MIT"

  depends_on "go" => :build
  depends_on "fzf"
  depends_on "ripgrep"

  def install
    system "go", "build", *std_go_args(output: libexec/"catclip"), "./cmd/catclip"
    system "go", "build", *std_go_args(output: libexec/"catclip-tree"), "./cmd/catclip-tree"

    pkgshare.install "VERSION"

    (bin/"catclip").write_env_script libexec/"catclip",
                                     CATCLIP_FZF:  Formula["fzf"].opt_bin/"fzf",
                                     CATCLIP_RG:   Formula["ripgrep"].opt_bin/"rg",
                                     CATCLIP_TREE: libexec/"catclip-tree"
  end

  test do
    (testpath/"sample").mkpath
    (testpath/"sample/sample.txt").write("hi")

    output = shell_output("#{bin}/catclip --quiet --print sample --only '*.txt'")
    assert_match "<file path=\"sample/sample.txt\">", output
    assert_match "hi", output
  end
end
