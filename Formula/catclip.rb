class Catclip < Formula
  desc "Copy project files to clipboard with safe ignores"
  homepage "https://github.com/tigreau/catclip"
  url "https://github.com/tigreau/catclip/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "c06b07d5f3014e8fbca31bc2ea2542ee761a47092889ae122df1a62af9a8bf5d"
  license "MIT"

  def install
    bin.install "catclip"
    bin.install "VERSION"
    pkgshare.install "ignore.yaml"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath/"config"
    (testpath/"sample.txt").write("hi")
    output = shell_output("#{bin}/catclip --print sample.txt")
    assert_match "# File: sample.txt", output
    assert_match "hi", output
  end
end
